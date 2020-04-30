%{
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <typeinfo>
#include <fstream>
#include <iostream>

#include "ast/ast.h"
#include "execute.h"

#include "semantic/SymanticAnalyzer.h"
using namespace std;


string get_string(char * s);
nodeType* unaryExpression(int operation, nodeType* ex1);
nodeType* binaryExpression(int operation, nodeType* ex1, nodeType* ex2);
nodeType* execute_expression(int operation,nodeType* ex1,nodeType* ex2);

string get_type_name(int type);
int label_count=0;
string createLabel();
int scopes_count=0;
string last_label;
string createScope();
bool syntax_error=false;

extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern int yylineno, yychar;

SymbolTableTree * sym=new SymbolTableTree(NULL,"Global");
SymanticAnalyzer sem(sym,&yylineno);

int yylex(void);
void yyerror(char *s);

char * outputFile;
char * debugFile;

string label;

%}


%union {
    int iValue;                 /* integer value */
    float fValue;                 /* float value */
    nodeType* nPtr;
    char* sValue;
    char cValue;       /* character value*/
    bool bValue;
};

%error-verbose

%token  <sValue> IDENTIFIER "identifier"
%token  <iValue> V_INTEGER "integer"
%token  <fValue> V_FLOAT "float"
%token  <cValue> V_CHR "character value"
%token  <bValue> V_BOOL "boolean value"
%token  <sValue> STRINGS "string value"

%token <iValue> INVALID_IDENTIFIER "invalid identifier"

%token  <iValue> ARRAY "Array value"

%token <iValue> BREAK "break"

%token SEMICOLON ";" FUNCTION "function" 
%token <iValue> PRINT "print built in function" // built-in functions
%token <iValue> IF "if statement" SWITCH "switch statement" CASE "case statement" WHILE "while statement "
%token <iValue> FOR " for statement"  DEFAULT "defualt statement"// flow controls
%token <iValue> CONST "const keyword" 
%token <iValue> T_INT "integer" T_FLOAT "float"  T_CHR "char"  T_BOOL "Boolean" // types
%token <iValue> TEMP DO "do statement"


%token <iValue>  INVALID "invalid c words or syymbols"
%type <nPtr>      SMALL_PROGRAM _stmt  ITERATION_STATEMENT SELECTION_STATEMENT COMPUND_STATEMNET EXPRESSION_STATEMENT ASSIGNMENT_STATEMENT DECLARATION_STATEMENT VARIABLE_EXPRESSION IF_STATEMENT type  WHILE_LOOP_STATEMENT  


%left <iValue> EQQ NEQ 
%left <iValue> '>' '<'
%left <iValue> LEQ  GEQ 
%right <iValue> '='
%left <iValue> '+' '-' AND OR 
%left <iValue> '*' '/'
%nonassoc <iValue> UMINUS
%nonassoc IFX
%nonassoc ELSE



// %type <nPtr> stmt expr stmt_list
%start program

%%

program:
                        program _stmt                                                          { printf("[line %d Success ]\n",yylineno);
                                                                                                 ex($2,outputFile);
                                                                                                 freeNode($2);
                                                                                                  }

                        | /* NULL */                                                          { //   printf("[epsilon prog]\n");
                                                                                                }
                                ;


_stmt:                                                                               
                        COMPUND_STATEMNET                                                       {//   printf("Matched COMPUND_STATEMNET \n");
                                                                                                } 
                        |EXPRESSION_STATEMENT SEMICOLON                                
                        |SELECTION_STATEMENT 
                        |ITERATION_STATEMENT 
                        |error SEMICOLON                                                      {   yyerrok; yyclearin; $$=opr(-1,0);syntax_error=true; }
        ;

SMALL_PROGRAM :
                        SMALL_PROGRAM _stmt                                                          {  printf("[line %d Success ]\n",yylineno);
                                                                                                     $$=opr(60*100,2,$1,$2);
                                                                                                  }

                        | /* NULL */                                                          { $$=opr(-1,0);
                                                                                                }
                                ;
                

COMPUND_STATEMNET:
                        '{' 
                        { 
                                //   printf("enter block \n"); 
                                string scope = createScope();
                                sym=sym->enter_scope(scope);
                                sem.setSym(sym);
                        }
                                SMALL_PROGRAM 
                        { 
                                sym=sym->exit_scope();
                                sem.setSym(sym);
                        }
                        '}'
                        { //   printf("stmt list (block structure)\n");
                        string label=   createLabel();
                        char * s= mystrdup((char*)(label.c_str()));
                         $$ = opr (52*100,2,$3,id(s));
                        }
                        ;


EXPRESSION_STATEMENT:

                        /* NULL */                                                             {  //   printf("parser1:empty statement\n");
                                                                                                $$ = opr(';', 2, NULL, NULL); }
                        |ASSIGNMENT_STATEMENT
                        |DECLARATION_STATEMENT
                        |VARIABLE_EXPRESSION                                                  {   // printf("parserW2: expression stmt\n");
                                                                                                $$ = $1; }
                        ;

SELECTION_STATEMENT:
                        IF_STATEMENT
                        ;
ITERATION_STATEMENT:
                        WHILE_LOOP_STATEMENT
                        ;

ASSIGNMENT_STATEMENT:
                        IDENTIFIER '=' VARIABLE_EXPRESSION                                   {  
                                                                                                //   printf("parser3: Assignmet stmt\n");
                                                                                                $$ = sem.varAss($1,$3,syntax_error);
                                                                                              }
                        ;

DECLARATION_STATEMENT:
                        type  IDENTIFIER ARRAY                                      {
                                                                                                //   printf("parser: Array Declaration\n");
                                                                                                $$=sem.varDec($2,NULL,$1->ty.t*100,syntax_error);
                                                                                       }
                        |type  IDENTIFIER ARRAY '=' STRINGS                                     {
                                                                                                //   printf("parser: Array Declaration with inilization\n");
                                                                                                nodeType * val=strr($5);
                                                                                                $$=sem.varDec($2,val,$1->ty.t*100,syntax_error);
                                                                                        }

                        |type IDENTIFIER                                                 {  
                                                                                                //   printf("parser5: declaration statement\n");
                                                                                                $$=sem.varDec($2,NULL,$1->ty.t,syntax_error);
                                                                                        }
                        |type IDENTIFIER '=' VARIABLE_EXPRESSION                        { 
                                                                                                //   printf("parser: declaration statement with init value\n");
                                                                                                $$=sem.varDec($2,$4,$1->ty.t,syntax_error);
                                                                                        }

                        
                        //|INVALID_IDENTIFIER '=' VARIABLE_EXPRESSION                                           {   printf("[Line: %d]Invalid Variable Name ",yylineno); syntax_error=true;}

        
                        //|type INVALID_IDENTIFIER                                               {   printf("[Line: %d]Invalid Variable Name ",yylineno);syntax_error=true;}
        
                        //|type INVALID_IDENTIFIER '=' VARIABLE_EXPRESSION                                      {   printf("[Line: %d]Invalid Variable Name ",yylineno);syntax_error=true;}

                
                        
                        
                        ;


VARIABLE_EXPRESSION:
                        V_INTEGER                               { //   printf("parser.VARIABLE_EXPRESSION: INTEGER\n");
                                                                  $$=intt($1); }
                        | V_FLOAT                               { //   printf("parser.VARIABLE_EXPRESSION: FLOAT\n");
                                                                  $$=floatt($1);}
                        | V_CHR                                 { //   printf("parser.VARIABLE_EXPRESSION: CHR value \n");
                                                                  $$=charr($1);}
                        | V_BOOL                                 { //   printf("parser.VARIABLE_EXPRESSION: CHR value \n");
                                                                  $$=bo($1);}
                        | IDENTIFIER                            { //   printf("parser.VARIABLE_EXPRESSION: VAR\n"); 
                                                                 $$=sem.varInEx($1);}
                        | '-' VARIABLE_EXPRESSION %prec UMINUS                                  { //   printf("parser.VARIABLE_EXPRESSION: UMIN\n"); 
                                                                                                $$=  unaryExpression(UMINUS, $2); }
                        | VARIABLE_EXPRESSION '+' VARIABLE_EXPRESSION                         {//   printf("parser.VARIABLE_EXPRESSION: ADD\n");
                                                                                                 $$=binaryExpression('+', $1, $3);
                                                                                                 }
                        | VARIABLE_EXPRESSION '-' VARIABLE_EXPRESSION                         { //   printf("parser.VARIABLE_EXPRESSION: SUB\n");
                                                                                                $$=binaryExpression('-', $1, $3);}
                        | VARIABLE_EXPRESSION '*' VARIABLE_EXPRESSION                         { //   printf("parser.VARIABLE_EXPRESSION: MUL\n"); 
                                                                                                $$=binaryExpression('*', $1, $3);}
                        | VARIABLE_EXPRESSION '/' VARIABLE_EXPRESSION                         { //   printf("parser.VARIABLE_EXPRESSION: DIV\n");
                                                                                                 $$=binaryExpression('/', $1, $3);}
                        | VARIABLE_EXPRESSION '<' VARIABLE_EXPRESSION                         { //   printf("parser.VARIABLE_EXPRESSION: <\n");
                                                                                                $$=binaryExpression('<', $1, $3);}
                        | VARIABLE_EXPRESSION '>' VARIABLE_EXPRESSION                         { //   printf("parser.VARIABLE_EXPRESSION: >\n");
                                                                                                  $$=binaryExpression('>', $1, $3);}
                        | VARIABLE_EXPRESSION LEQ VARIABLE_EXPRESSION                         { //   printf("parser.VARIABLE_EXPRESSION: LE\n");
                                                                                                $$=binaryExpression(LEQ, $1, $3);}
                        | VARIABLE_EXPRESSION GEQ VARIABLE_EXPRESSION                         { //   printf("parser.VARIABLE_EXPRESSION: GEQ\n");
                                                                                                  $$=binaryExpression(GEQ, $1, $3);}
                        | VARIABLE_EXPRESSION NEQ VARIABLE_EXPRESSION                         { //   printf("parser.VARIABLE_EXPRESSION: NE\n");
                                                                                                  $$=binaryExpression(NEQ, $1, $3);}
                        | VARIABLE_EXPRESSION EQQ VARIABLE_EXPRESSION                         { //   printf("parser.VARIABLE_EXPRESSION: EQ\n");
                                                                                                 $$=binaryExpression(EQQ, $1, $3);}
                        | VARIABLE_EXPRESSION AND VARIABLE_EXPRESSION                         { //   printf("parser.VARIABLE_EXPRESSION: EQ\n");
                                                                                                 $$=binaryExpression(AND, $1, $3);}
                        | VARIABLE_EXPRESSION OR VARIABLE_EXPRESSION                         { //   printf("parser.VARIABLE_EXPRESSION: EQ\n");
                                                                                                 $$=binaryExpression(OR, $1, $3);}
                        | '(' VARIABLE_EXPRESSION ')'                                            { //   printf("parser.VARIABLE_EXPRESSION: '(' VARIABLE_EXPRESSION ')'\n"); 
                                                                                                 $$ = $2; }
                        ;

IF_STATEMENT:
         IF '(' VARIABLE_EXPRESSION ')' _stmt %prec IFX                                                {  // printf("Matched IF condition");
                                                                                                        string newLabel=createLabel();
                                                                                                        // cout<<"ll  " <<newLabel<<endl;
                                                                                                        char * ss= mystrdup((char*)newLabel.c_str());
                                                                                                         $$ = opr(IF,3,$3,$5,id(ss));
                                                                                                        }
        ;



WHILE_LOOP_STATEMENT:
        WHILE '(' VARIABLE_EXPRESSION ')' _stmt                                                       {   // printf("while stmt\n");
                                                                                                        string newLabel=createLabel();
                                                                                                        // cout<<"ll  " <<newLabel<<endl;
                                                                                                        char * ss= mystrdup((char*)newLabel.c_str());
                                                                                                         $$ = opr(WHILE,3,$3,$5,id(ss)); }
        |DO _stmt  WHILE '(' VARIABLE_EXPRESSION ')' SEMICOLON                                         {   // printf("do while statement stmt\n");
                                                                                                        string newLabel=createLabel();
                                                                                                        // cout<<"ll  " <<newLabel<<endl;
                                                                                                        char * ss= mystrdup((char*)newLabel.c_str());
                                                                                                        // cout<<"here"<<endl;
                                                                                                         $$ = opr(DO,3,$5,$2,id(ss)); }
                                ;



type:
    T_INT { // printf("parser: type int\n"); 
            $$=ty($1);}
    | T_FLOAT {// printf("parser: type float\n");
                $$=ty($1); }
    | T_CHR {// printf("parser: type char\n");
                $$=ty($1); }
    | T_BOOL {// printf("parser: type char\n");
                $$=ty($1); }
    ;


%%




nodeType* binaryExpression(int operation, nodeType* ex1, nodeType* ex2)
{
        int type=sem.typeCheck(operation,ex1,ex2);
        if (type!=-1 && !(ex1->type==typeOpr && ex1->opr.oper==-1 ) && !(ex2->type==typeOpr && ex2->opr.oper==-1 ))
        {
                nodeType *operr = opr(operation, 2, ex1, ex2);
                nodeType* value=execute_expression(operation,ex1,ex2);
                string index= sym->createTemp(value,type);
                nodeType* ptr=opr(TEMP,2,id(  mystrdup(  (char *)index.c_str() )  ),operr);

                ptr->opr.iValue=value->opr.iValue;
                ptr->opr.cValue=value->opr.cValue;
                ptr->opr.fValue=value->opr.fValue;
                ptr->opr.bValue=value->opr.bValue;

                ptr->opr.expression_type=type;
                return ptr;
        }
        else if ((ex1->type==typeOpr && ex1->opr.oper==-1 ) || (ex2->type==typeOpr && ex2->opr.oper==-1 ))
        {
                return opr(-1,0);

        }
        else{
                cout<<" line : "<<yylineno<<" : "<< "type mismatch "<< get_type_name(sem.get_Type(ex1));
                cout<<" conflicts with "<<get_type_name(sem.get_Type(ex2))<<endl;
                return opr(-1,0);
        }
}

nodeType* execute_expression(int operation,nodeType* ex1,nodeType* ex2)
{
    int type1=sem.get_Type(ex1);
    int type2=sem.get_Type(ex2);
    
    nodeType * p;
    //// int expressions
    if (type1==type2 && type1==T_INT)
    {
      int result=excute_int(operation,ex1,ex2,sym);
      p = opr(-1,0);
      p->opr.iValue=result;
    }
    //// int expressions
    if (type1==type2 && type1==T_FLOAT)
    {
      float result=excute_float(operation,ex1,ex2,sym);
      p = opr(-1,0);
      p->opr.fValue=result;
    }

    //// char expressions
    if (type1==type2 && type1==T_CHR)
    {
      char result=excute_char(operation,ex1,ex2,sym);
      p = opr(-1,0);
      p->opr.cValue=result;
    }

    //// bool expressions
    if ((type1==type2 && type1==T_BOOL))
    {
      bool result=excute_bool(operation,ex1,ex2,sym);
      p = opr(-1,0);
      p->opr.bValue=result;
    }

    bool boolOp= (operation == '<') || (operation == '>') || (operation == LEQ) ;
    boolOp = boolOp ||  (operation == GEQ) ||  (operation == EQQ) || (operation == NEQ);

    if ((  (type1==T_INT || type1==T_FLOAT)&&(type2==T_INT || type2==T_FLOAT)  )&&(boolOp))
    {
      bool result=excute_comparesion(operation,ex1,ex2,sym);
      p = opr(-1,0);
      p->opr.bValue=result;
   }
    
    return p;
    
  
}
nodeType* unaryExpression(int operation, nodeType* ex1)
{
        int type =sem.get_Type(ex1);
        if (type == T_INT || type == T_FLOAT)
        {
        nodeType *operr = opr(operation, 1, ex1);
        string index= sym->createTemp(operr,type);
        return opr(TEMP,2,id(mystrdup((char *)index.c_str())),operr);
        }
        else{
        cout<<" line : "<<yylineno<<" : "<< "type mismatch "<< get_type_name(sem.get_Type(ex1))<<endl;
        return opr(-1,0);
        }
  
}

void yyerror(char *s) {
    cout<<"line : "<<yylineno<<" : "<<s<<endl;
    //exit(1);
}


int main(int argc, char *argv[]) {

	
	if (argc !=4 )
	{
		cout <<" error in number of command line parameters"<<endl;
		return -1;
	}
	// open a file handle to a particular file:
	FILE *myfile = fopen(argv[1], "r");
	// make sure it's valid:
	if (!myfile) {
		cout << "Compiler can't open file " << endl;
		return -1;
	}
	// set lex to read from it instead of defaulting to STDIN:
        
	yyin = myfile;

        outputFile = argv[2];
        debugFile  = argv[3];


        ofstream output;
        output.open(outputFile);
        output.close();
        // freopen(outputFile, "w", stdout);
        // cout<<"";
        freopen(debugFile, "w", stdout); 



	yyparse();

    return 0;
}

string createLabel(){

    string index= "Label"+to_string(label_count++);
    last_label=index;
    return index;
}

string createScope(){

    string index= "scope"+to_string(scopes_count++);
    return index;
}


