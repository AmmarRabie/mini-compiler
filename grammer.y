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


%token SEMICOLON ";" FUNCTION "function"
%token <iValue> PRINT "print built in function" // built-in functions
%token <iValue> IF "if statement" SWITCH "switch statement" CASE "case statement" WHILE "while statement "
%token <iValue> FOR " for statement" UNTIL "until statement" DEFAULT "defualt statement"// flow controls
%token <iValue> CONST "const keyword" 
%token <iValue> T_INT "integer" T_FLOAT "float"  T_CHR "char" // types


%type <nPtr> stmt expr stmt_list _stmt_list type for_init_stmt for_cond_stmt for_inc_stmt 



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
          program stmt                                                                 { REDUCE printf("[Success]\n"); }
        | /* NULL */                                                                   { REDUCE printf("[epsilon prog]\n");}
		;

stmt:
          SEMICOLON                                                                    {  REDUCE printf("parser1:empty statement\n");$$ = opr(';', 2, NULL, NULL); }
        | expr SEMICOLON                                                               {  REDUCE printf("parserW2: expression stmt\n");$$ = $1; }
        | PRINT expr SEMICOLON                                                         { 
                                                                                         REDUCE printf("parser4: PRINT expr stmt';'\n");
                                                                                         $$ = opr(PRINT, 2, $1, NULL);}
        | IDENTIFIER '=' expr SEMICOLON                                                {  
                                                                                          REDUCE printf("parser3: Assignmet stmt\n");
                                                                                          $$ = sem.varAss($1,$3);
                                                                                        }
                                                                                          

        | type IDENTIFIER SEMICOLON                                                    {  
                                                                                        REDUCE printf("parser5: declaration statement\n");
                                                                                        $$=sem.varDec($2,NULL,$1->ty.t);
                                                                                         }
        | type IDENTIFIER '=' expr SEMICOLON                                           { 
                                                                                        REDUCE printf("parser: declaration statement with init value\n");
                                                                                        $$=sem.varDec($2,$4,$1->ty.t);
                                                                                       }
        | CONST type IDENTIFIER '=' expr SEMICOLON                                      {  
                                                                                        REDUCE printf("parser: declaration statement with init value\n"); 
                                                                                        sym->add_symbol($3,$5,$2->ty.t,$1);
                                                                                        sym->printTable();
                                                                                        $$ = opr($2->ty.t, 3,$1,id($3),$5);}
        /* functions */
        | type IDENTIFIER '('args_list')' SEMICOLON                                    { REDUCE printf("function prototype statement\n"); }
        | type IDENTIFIER '('args_list')' '{'stmt_list'}'                              { REDUCE printf("function definition stmt\n"); }
        /* flow controls */
        | WHILE '(' expr ')' stmt                                                      { REDUCE printf("while stmt\n");$$ = opr(WHILE, 2, $3,$5);  }
        | FOR'('for_init_stmt SEMICOLON for_cond_stmt SEMICOLON for_inc_stmt')'stmt    { REDUCE printf("for stmt\n"); $$ = opr(FOR,4,$3,$5,$7,$9);}
        | IF '(' expr ')' stmt %prec IFX                                               { REDUCE $$ = opr(IF,2,$3,$5);}
        | IF '(' expr ')' stmt ELSE stmt                                               { REDUCE printf("if else stmt\n");$$ = opr(IF,3,$3,$5,$7); }
        | SWITCH'('expr')' switch_cases                                                { REDUCE printf("switch cases\n"); }
        /* recursions and others */
        | '{'  { 
                REDUCE printf("enter block \n"); 
                sym=sym->enter_scope("New Scope");
                sym->printTable();}
            stmt_list 
            { 
                REDUCE printf(" exit block \n"); 
                sym=sym->exit_scope();
                sym->printTable();}
            '}'                                                            
            { REDUCE printf("stmt list (block structure)\n");}
	|  error SEMICOLON                                                             { REDUCE yyerrok; yyclearin; }
	;

switch_cases:
        _switch_cases DEFAULT ':' stmt
        | _switch_cases
        | SEMICOLON
        | '{' _switch_cases '}'
        ;

_switch_cases:
        cases_list stmt
        | switch_cases cases_list stmt
        ;

cases_list: CASE const_expr ':'
        | cases_list CASE const_expr ':' 
        ;

for_init_stmt: 
        IDENTIFIER '=' expr                                                            { REDUCE;
                                                                                         $$ = opr('=', 2, $1, $3); }
        | type IDENTIFIER '=' expr                                                     { REDUCE;
                                                                                        $$ = opr($1->ty.t, 2, id($2),$4); }
        | CONST type IDENTIFIER '=' expr                                               { REDUCE 
                                                                                        $$ = opr($2->ty.t, 3,$1,id($3),$5);}
        | /* epsiolon */                                                               { REDUCE
                                                                                        $$ = opr(-1, 0); }
        ;
for_cond_stmt: 
        expr                                                                           { REDUCE; $$=$1; }
        | /*epsiolon*/                                                                 { REDUCE; $$ = opr(-1, 0);}
        ;
for_inc_stmt: 
        IDENTIFIER '=' expr                                                            { REDUCE;$$ = opr('=',2,$1,$3); }
        | /*epsiolon*/                                                                 { REDUCE;$$ = opr(-1, 0); }
        ;


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
  

stmt_list:
          _stmt_list                  { $$ = $1; }
        |        { $$ = opr(-1, 0); }
        ;
_stmt_list:
          stmt                  { $$ = $1; }
        | stmt _stmt_list        { $$ = opr(';', 2, $1, $2); }
        ;

expr:
          V_INTEGER                             { REDUCE printf("parser.expr: INTEGER\n");  $$=con($1); }
        | V_FLOAT                               { REDUCE printf("parser.expr: FLOAT\n");  $$=con($1);}
        | V_CHR                                 { REDUCE printf("parser.expr: CHR value \n");  $$=con($1);}
        | IDENTIFIER                            { REDUCE printf("parser.expr: VAR\n");  $$=sem.varInEx($1);}
        | '-' expr %prec UMINUS                 { REDUCE printf("parser.expr: UMIN\n"); $$=  opr(UMINUS, 1, $2); }
        | expr '+' expr                         { REDUCE printf("parser.expr: ADD\n");  $$ = opr('+', 2, $1, $3);}
        | expr '-' expr                         { REDUCE printf("parser.expr: SUB\n");  $$ = opr('-', 2, $1, $3);}
        | expr '*' expr                         { REDUCE printf("parser.expr: MUL\n");  $$ = opr('*', 2, $1, $3);}
        | expr '/' expr                         { REDUCE printf("parser.expr: DIV\n");  $$ = opr('/', 2, $1, $3);}
        | expr '<' expr                         { REDUCE printf("parser.expr: <\n");    $$ = opr('<', 2, $1, $3);}
        | expr '>' expr                         { REDUCE printf("parser.expr: >\n");    $$ = opr('>', 2, $1, $3);}
        | expr LEQ expr                         { REDUCE printf("parser.expr: LE\n");   $$ = opr(LEQ, 2, $1, $3);}
        | expr GEQ expr                         { REDUCE printf("parser.expr: GEQ\n");  $$ = opr(GEQ, 2, $1, $3);}
        | expr NEQ expr                         { REDUCE printf("parser.expr: NE\n");   $$ = opr(NEQ, 2, $1, $3);}
        | expr EQQ expr                         { REDUCE printf("parser.expr: EQ\n");   $$ = opr(EQQ, 2, $1, $3);}
        | '(' expr ')'                          { REDUCE printf("parser.expr: '(' expr ')'\n");  $$ = $2; }
        ;

const_expr:
        V_INTEGER                                     { REDUCE printf("parser.const_expr: INTEGER\n"); }
        | V_FLOAT                                     { REDUCE printf("parser.const_expr: FLOAT\n"); }
        | '-' const_expr %prec UMINUS                 { REDUCE printf("parser.const_expr: UMIN\n"); }
        | const_expr '+' const_expr                   { REDUCE printf("parser.const_expr: ADD\n"); }
        | const_expr '-' const_expr                   { REDUCE printf("parser.const_expr: SUB\n"); }
        | const_expr '*' const_expr                   { REDUCE printf("parser.const_expr: MUL\n"); }
        | const_expr '/' const_expr                   { REDUCE printf("parser.const_expr: DIV\n"); }
        | const_expr '<' const_expr                   { REDUCE printf("parser.const_expr: <\n"); }
        | const_expr '>' const_expr                   { REDUCE printf("parser.const_expr: >\n"); }
        | const_expr LEQ const_expr                   { REDUCE printf("parser.const_expr: LE\n"); }
        | const_expr GEQ const_expr                   { REDUCE printf("parser.const_expr: GEQ\n"); }
        | const_expr NEQ const_expr                   { REDUCE printf("parser.const_expr: NE\n"); }
        | const_expr EQQ const_expr                   { REDUCE printf("parser.const_expr: EQ\n"); }
        | '(' const_expr ')'                          { REDUCE printf("parser.const_expr: '(' const_expr ')'\n"); }
        ;
%%



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

