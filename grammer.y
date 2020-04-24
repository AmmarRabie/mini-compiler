%{
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <typeinfo>

#include <iostream>
#include "ast.h"
#include "SymanticAnalyzer.h"
using namespace std;
string get_string(char * s);
nodeType* expression(char operation, nodeType* ex1, nodeType* ex2);




// begining the symbol Table

extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern int yylineno, yychar;

SymbolTableTree * sym=new SymbolTableTree(NULL,"Global");

SymanticAnalyzer sem(sym,&yylineno);

#ifdef TEST // run test cases
cout<<"test defined"<<endl;
#endif

#ifdef DEBUG
#define REDUCE cout<<"reduce at line "<<__LINE__<<endl;
#else
#define REDUCE
#endif

int yylex(void);
void yyerror(char *s);

%}


%union {
    int iValue;                 /* integer value */
    float fValue;                 /* float value */
    nodeType* nPtr;
    char* sValue;
    char cValue;       /* character value*/
};

%error-verbose

%token  <sValue> IDENTIFIER "identifier"
%token  <iValue> V_INTEGER "integer"
%token  <fValue> V_FLOAT "float"
%token  <cValue> V_CHR "character value"
%token <iValue> BREAK "break"

%token SEMICOLON ";" FUNCTION "function"
%token <iValue> PRINT "print built in function" // built-in functions
%token <iValue> IF "if statement" SWITCH "switch statement" CASE "case statement" WHILE "while statement "
%token <iValue> FOR " for statement"  DEFAULT "defualt statement"// flow controls
%token <iValue> CONST "const keyword" 
%token <iValue> T_INT "integer" T_FLOAT "float"  T_CHR "char" // types
%token <iValue> TEMP


%token <sValue>  UNMATCHED "unmatched"
%token <sValue> INVALID_IDENTIFIER "invalid identifier"
%type <nPtr>     _stmt SWITCH_STATEMENT  FUNCTION_CALL_STATEMENT ITERATION_STATEMENT SELECTION_STATEMENT COMPUND_STATEMNET EXPRESSION_STATEMENT ASSIGNMENT_STATEMENT DECLARATION_STATEMENT PRINT_STATEMENT VARIABLE_EXPRESSION IF_STATEMENT FOR_LOOP_STATEMENT    type for_init_stmt for_cond_stmt for_inc_stmt WHILE_LOOP_STATEMENT  



%left <iValue> EQQ NEQ 
%left <iValue> '>' '<'
%left <iValue> LEQ  GEQ 
%right <iValue> '='
%left <iValue> '+' '-'
%left <iValue> '*' '/'
%nonassoc <iValue> UMINUS
%nonassoc IFX
%nonassoc ELSE





// %type <nPtr> stmt expr stmt_list
%start program

%%

program:
                        program _stmt                                                          {REDUCE printf("[Success]\n"); ex($2);}

                        | /* NULL */                                                          { REDUCE printf("[epsilon prog]\n");}
                                ;


_stmt:                                                                               
                        COMPUND_STATEMNET                                                       {REDUCE printf("Matched COMPUND_STATEMNET \n");} 
                        |EXPRESSION_STATEMENT SEMICOLON         
                        //|EXPRESSION_STATEMENT                                              {REDUCE  printf("[Line Number: %d] SEMICOLON Misssing \n",yylineno);}
                        |SELECTION_STATEMENT 
                        |ITERATION_STATEMENT 
                        //|UNMATCHED SEMICOLON                                                  { REDUCE yyerrok; yyclearin; printf("[Grammer] unmatched token \n") ;}
                        |error SEMICOLON                                                      { REDUCE yyerrok; yyclearin; }
        ;

COMPUND_STATEMNET:
                        '{' 
                        
                        { 
                                REDUCE printf("enter block \n"); 
                                string label=sym->createLabel();
                                sym=sym->enter_scope(label);
                                sym->printTable();
                        }
                                _stmt 
                        { 
                                REDUCE printf(" exit block \n"); 
                                sym=sym->exit_scope();
                                sym->printTable();
                        }
                        '}'
                        { REDUCE printf("stmt list (block structure)\n");}
                        ;




EXPRESSION_STATEMENT:

                        /* NULL */                                                             {  REDUCE printf("parser1:empty statement\n");$$ = opr(';', 2, NULL, NULL); }
                        |ASSIGNMENT_STATEMENT
                        |FUNCTION_CALL_STATEMENT
                        |DECLARATION_STATEMENT
                        |PRINT_STATEMENT
                        |VARIABLE_EXPRESSION                                                  {  REDUCE printf("parserW2: expression stmt\n");$$ = $1; }
                        ;

SELECTION_STATEMENT:
                        IF_STATEMENT
                        |SWITCH_STATEMENT
                        ;
ITERATION_STATEMENT:
                        FOR_LOOP_STATEMENT
                        |WHILE_LOOP_STATEMENT
                        ;

ASSIGNMENT_STATEMENT:
                        IDENTIFIER '=' VARIABLE_EXPRESSION                                   {  
                                                                                                REDUCE printf("parser3: Assignmet stmt\n");
                                                                                                $$ = sem.varAss($1,$3);
                                                                                              }
                        ;

FUNCTION_CALL_STATEMENT:
                        '('args_list ')'                                       { REDUCE printf("function prototype statement\n"); }
                        ;
DECLARATION_STATEMENT:
                        type IDENTIFIER                                                 {  
                                                                                                REDUCE printf("parser5: declaration statement\n");
                                                                                                $$=sem.varDec($2,NULL,$1->ty.t);
                                                                                        }
                        |type IDENTIFIER '=' VARIABLE_EXPRESSION                        { 
                                                                                                REDUCE printf("parser: declaration statement with init value\n");
                                                                                                $$=sem.varDec($2,$4,$1->ty.t);
                                                                                        }
                        |CONST type IDENTIFIER '=' VARIABLE_EXPRESSION                  {  
                                                                                                REDUCE printf("parser: declaration statement with init value\n"); 
                                                                                                sym->add_symbol($3,$5,$2->ty.t,$1);
                                                                                                sym->printTable();
                                                                                                $$ = opr($2->ty.t, 3,$1,id($3),$5);
                                                                                        }
                        | type IDENTIFIER '('args_list')'                               { REDUCE printf("function prototype statement\n"); }
                        | type IDENTIFIER '('args_list')' '{'_stmt'}'                   { REDUCE printf("function definition stmt\n"); }        
                        
                        //|INVALID_IDENTIFIER '=' VARIABLE_EXPRESSION                                           {REDUCE  printf("[Line: %d]Invalid Variable Name ",yylineno);}

        
                        //|type INVALID_IDENTIFIER                                               {REDUCE  printf("[Line: %d]Invalid Variable Name ",yylineno);}
        
                        //|type INVALID_IDENTIFIER '=' VARIABLE_EXPRESSION                                      {REDUCE  printf("[Line: %d]Invalid Variable Name ",yylineno);}

        
        
                        //|CONST type INVALID_IDENTIFIER '=' VARIABLE_EXPRESSION                            {REDUCE  printf("[Line: %d]Invalid Variable Name ",yylineno);}
        
                        
                        
                        ;
PRINT_STATEMENT:
                        PRINT '(' VARIABLE_EXPRESSION ')'                                         { 
                                                                                                REDUCE printf("parser4: PRINT expr stmt';'\n");
                                                                                                $$ = opr(PRINT, 2, $1, NULL);
                                                                                        }
                        ;

VARIABLE_EXPRESSION:
                        V_INTEGER                             { REDUCE printf("parser.VARIABLE_EXPRESSION: INTEGER\n");  $$=con($1); }
                        | V_FLOAT                               { REDUCE printf("parser.VARIABLE_EXPRESSION: FLOAT\n");  $$=con($1);}
                        | V_CHR                                 { REDUCE printf("parser.VARIABLE_EXPRESSION: CHR value \n");  $$=con($1);}
                        | IDENTIFIER                            { REDUCE printf("parser.VARIABLE_EXPRESSION: VAR\n");  $$=sem.varInEx($1);}
                        | '-' VARIABLE_EXPRESSION %prec UMINUS                 { REDUCE printf("parser.VARIABLE_EXPRESSION: UMIN\n"); $$=  opr(UMINUS, 1, $2); }
                        | VARIABLE_EXPRESSION '+' VARIABLE_EXPRESSION                         { REDUCE printf("parser.VARIABLE_EXPRESSION: ADD\n");
                                                                                                 $$=expression('+', $1, $3);
                                                                                                 }
                        | VARIABLE_EXPRESSION '-' VARIABLE_EXPRESSION                         { REDUCE printf("parser.VARIABLE_EXPRESSION: SUB\n");
                                                                                                $$=expression('-', $1, $3);}
                        | VARIABLE_EXPRESSION '*' VARIABLE_EXPRESSION                         { REDUCE printf("parser.VARIABLE_EXPRESSION: MUL\n"); 
                                                                                                $$=expression('*', $1, $3);}
                        | VARIABLE_EXPRESSION '/' VARIABLE_EXPRESSION                         { REDUCE printf("parser.VARIABLE_EXPRESSION: DIV\n");
                                                                                                 $$=expression('/', $1, $3);}
                        | VARIABLE_EXPRESSION '<' VARIABLE_EXPRESSION                         { REDUCE printf("parser.VARIABLE_EXPRESSION: <\n");
                                                                                                $$=expression('<', $1, $3);}
                        | VARIABLE_EXPRESSION '>' VARIABLE_EXPRESSION                         { REDUCE printf("parser.VARIABLE_EXPRESSION: >\n");
                                                                                                  $$=expression('>', $1, $3);}
                        | VARIABLE_EXPRESSION LEQ VARIABLE_EXPRESSION                         { REDUCE printf("parser.VARIABLE_EXPRESSION: LE\n");
                                                                                                $$=expression((char)LEQ, $1, $3);}
                        | VARIABLE_EXPRESSION GEQ VARIABLE_EXPRESSION                         { REDUCE printf("parser.VARIABLE_EXPRESSION: GEQ\n");
                                                                                                  $$=expression((char)GEQ, $1, $3);}
                        | VARIABLE_EXPRESSION NEQ VARIABLE_EXPRESSION                         { REDUCE printf("parser.VARIABLE_EXPRESSION: NE\n");
                                                                                                  $$=expression((char)NEQ, $1, $3);}
                        | VARIABLE_EXPRESSION EQQ VARIABLE_EXPRESSION                         { REDUCE printf("parser.VARIABLE_EXPRESSION: EQ\n");
                                                                                                 $$=expression((char)EQQ, $1, $3);}
                        | '(' VARIABLE_EXPRESSION ')'                          { REDUCE printf("parser.VARIABLE_EXPRESSION: '(' VARIABLE_EXPRESSION ')'\n");  $$ = $2; }
                        ;


CONSTANT_EXPRESSION:
                        V_INTEGER                                     { REDUCE printf("parser.CONSTANT_EXPRESSION: INTEGER\n"); }
                        |IDENTIFIER                                    {REDUCE printf("parser.CONSTANT_EXPRESSION: IDENTIFIER\n");}
                        | V_FLOAT                                     { REDUCE printf("parser.CONSTANT_EXPRESSION: FLOAT\n"); }
                        | '-' CONSTANT_EXPRESSION %prec UMINUS                 { REDUCE printf("parser.CONSTANT_EXPRESSION: UMIN\n"); }
                        | CONSTANT_EXPRESSION '+' CONSTANT_EXPRESSION                   { REDUCE printf("parser.CONSTANT_EXPRESSION: ADD\n"); }
                        | CONSTANT_EXPRESSION '-' CONSTANT_EXPRESSION                   { REDUCE printf("parser.CONSTANT_EXPRESSION: SUB\n"); }
                        | CONSTANT_EXPRESSION '*' CONSTANT_EXPRESSION                   { REDUCE printf("parser.CONSTANT_EXPRESSION: MUL\n"); }
                        | CONSTANT_EXPRESSION '/' CONSTANT_EXPRESSION                   { REDUCE printf("parser.CONSTANT_EXPRESSION: DIV\n"); }
                        | CONSTANT_EXPRESSION '<' CONSTANT_EXPRESSION                   { REDUCE printf("parser.CONSTANT_EXPRESSION: <\n"); }
                        | CONSTANT_EXPRESSION '>' CONSTANT_EXPRESSION                   { REDUCE printf("parser.CONSTANT_EXPRESSION: >\n"); }
                        | CONSTANT_EXPRESSION LEQ CONSTANT_EXPRESSION                   { REDUCE printf("parser.CONSTANT_EXPRESSION: LE\n"); }
                        | CONSTANT_EXPRESSION GEQ CONSTANT_EXPRESSION                   { REDUCE printf("parser.CONSTANT_EXPRESSION: GEQ\n"); }
                        | CONSTANT_EXPRESSION NEQ CONSTANT_EXPRESSION                   { REDUCE printf("parser.CONSTANT_EXPRESSION: NE\n"); }
                        | CONSTANT_EXPRESSION EQQ CONSTANT_EXPRESSION                   { REDUCE printf("parser.CONSTANT_EXPRESSION: EQ\n"); }
                        | '(' CONSTANT_EXPRESSION ')'                          { REDUCE printf("parser.CONSTANT_EXPRESSION: '(' CONSTANT_EXPRESSION ')'\n"); }
                        ;



IF_STATEMENT:
         IF '(' VARIABLE_EXPRESSION ')' _stmt %prec IFX                                                { REDUCE printf("Matched IF condition"); REDUCE $$ = opr(IF,2,$3,$5);}
        | IF '(' VARIABLE_EXPRESSION ')' _stmt ELSE _stmt                                                { REDUCE printf("if else stmt\n");$$ = opr(IF,3,$3,$5,$7); }
        //| IF '(' UNMATCHED ')' _stmt %prec IFX                                           {REDUCE yyerrok; yyclearin; printf("[Line: %d]The IF condition must contain boolean expression ",yylineno);}
        //| IF '(' UNMATCHED ')' _stmt ELSE _stmt                                           {REDUCE yyerrok; yyclearin; printf("[Line: %d]The IF condition must contain boolean expression ",yylineno);}

SWITCH_STATEMENT:
                        SWITCH '(' CONSTANT_EXPRESSION ')'  SWITCH_CASES                               { REDUCE printf("switch cases\n"); }
                        ;
SWITCH_CASES:
         '{'  _SWITCH_CASES  '}'
         |/*NULL*/
        ;
_SWITCH_CASES:
        _SWITCH_CASES  DEFAULT ':' _stmt
        |_SWITCH_CASES CASE CONSTANT_EXPRESSION ':' _stmt
        | _SWITCH_CASES BREAK SEMICOLON 
        |
        ;

FOR_LOOP_STATEMENT:
        FOR'('for_init_stmt SEMICOLON for_cond_stmt SEMICOLON for_inc_stmt')'_stmt     { REDUCE printf("for stmt\n"); $$ = opr(FOR,4,$3,$5,$7,$9);}
        ;
for_init_stmt:
        IDENTIFIER '=' VARIABLE_EXPRESSION                                                             { REDUCE;
                                                                                         $$ = opr('=', 2, $1, $3); }
        | type IDENTIFIER '=' VARIABLE_EXPRESSION                                                     { REDUCE;
                                                                                        $$ = opr($1->ty.t, 2, id($2),$4); }
        | CONST type IDENTIFIER '=' VARIABLE_EXPRESSION                                               { REDUCE 
                                                                                        $$ = opr($2->ty.t, 3,$1,id($3),$5);}
        | /* epsiolon */                                                               { REDUCE
                                                                                        $$ = opr(-1, 0); }
        ;
for_cond_stmt: 
        VARIABLE_EXPRESSION                                                                           { REDUCE; $$=$1; }
        | /*epsiolon*/                                                                 { REDUCE; $$ = opr(-1, 0);}
        ;
for_inc_stmt: 
        IDENTIFIER '=' VARIABLE_EXPRESSION                                                            { REDUCE;$$ = opr('=',2,$1,$3); }
        | /*epsiolon*/                                                                 { REDUCE;$$ = opr(-1, 0); }
        ;



WHILE_LOOP_STATEMENT:
        WHILE '(' VARIABLE_EXPRESSION ')' _stmt                                                       { REDUCE printf("while stmt\n");$$ = opr(WHILE, 2, $3,$5);  }

var_declaration:
        type IDENTIFIER                                                 { REDUCE printf("parser.declaration: type IDENTIFIER\n"); }
        | CONST type IDENTIFIER                                         { REDUCE printf("parser.declaration: CONST type IDENTIFIER\n"); }
        ;

_args_list:
        var_declaration
        | var_declaration ',' _args_list
        ;


args_list:
        _args_list
        |
        ;



type:
    T_INT { printf("parser: type int\n");  $$=ty($1);}
    | T_FLOAT {printf("parser: type float\n");$$=ty($1); }
    | T_CHR {printf("parser: type char\n");$$=ty($1); }
    ;


%%


nodeType* expression(char operation, nodeType* ex1, nodeType* ex2)
{
        nodeType *operr = opr(operation, 2, ex1, ex2);
        string index= sym->createTemp(operr);
        return opr(TEMP,2,id((char *)index.c_str()),operr);
}

void yyerror(char *s) {
    cout<<"line : "<<yylineno<<" : "<<s<<endl;
    //exit(1);
}


int main(int argc, char *argv[]) {

	
	if (argc !=3 )
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

        freopen(argv[2], "w", stdout); 

	yyparse();

    return 0;
}

