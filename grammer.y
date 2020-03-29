%{
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#ifdef TEST // run test cases
printf("test defined");
#endif

#ifdef DEBUG
#define REDUCE printf("reduce at line %d\n", __LINE__);
#else
#define REDUCE
#endif

int yylex(void);
void yyerror(char *s);
%}

// %union {
//     int iValue;                 /* integer value */
//     char sIndex;                /* symbol table index */
//     // nodeType *nPtr;             /* node pointer */
// };
// %token <iValue> INTEGER
%token IDENTIFIER V_INTEGER V_FLOAT SEMICOLON FUNCTION
// %token <sIndex> VARIABLE
%token PRINT // built-in functions
%token IF SWITCH CASE WHILE FOR UNTIL DEFAULT// flow controls
%token CONST T_INT T_FLOAT // types

%left EQQ NEQ '>' '<'
%left LEQ GEQ
%right '='
%left '+' '-'
%left '*' '/'
%nonassoc UMINUS
%nonassoc IFX
%nonassoc ELSE

// %type <nPtr> stmt expr stmt_list

%%

program:
          program stmt                                                                 { REDUCE printf("[Success]\n"); }
        | /* NULL */                                                                   { REDUCE printf("[epsilon prog]\n"); }
        ;

stmt:
          SEMICOLON                                                                    { REDUCE printf("parser1:empty statement\n"); }
        | expr SEMICOLON                                                               { REDUCE printf("parser2: expression stmt\n"); }
        | PRINT expr SEMICOLON                                                         { REDUCE printf("parser4: PRINT expr stmt';'\n"); }
        | IDENTIFIER '=' expr SEMICOLON                                                { REDUCE printf("parser3: Assignmet stmt\n"); }
        | type IDENTIFIER SEMICOLON                                                    { REDUCE printf("parser5: declaration statement\n"); }
        | type IDENTIFIER '=' expr SEMICOLON                                           { REDUCE printf("parser: declaration statement with init value\n"); }
        | CONST type IDENTIFIER '=' expr SEMICOLON                                     { REDUCE printf("parser2: const declaration statement\n"); }
        /* functions */
        | type IDENTIFIER '('args_list')' SEMICOLON                                    { REDUCE printf("function prototype statement\n"); }
        | type IDENTIFIER '('args_list')' '{'stmt_list'}'                              { REDUCE printf("function definition stmt\n"); }
        /* flow controls */
        | WHILE '(' expr ')' stmt                                                      { REDUCE printf("while stmt\n"); }
        | FOR'('for_init_stmt SEMICOLON for_cond_stmt SEMICOLON for_inc_stmt')'stmt    { REDUCE printf("for stmt\n"); }
        | IF '(' expr ')' stmt %prec IFX                                               { REDUCE printf("if stmt\n"); }
        | IF '(' expr ')' stmt ELSE stmt                                               { REDUCE printf("if else stmt\n"); }
        | SWITCH'('expr')' switch_cases                                                { REDUCE printf("switch cases\n"); }
        /* recursions and others */
        | '{' stmt_list '}'                                                            { REDUCE printf("stmt list (block structure)\n"); }
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
        IDENTIFIER '=' expr                                                            { REDUCE }
        | type IDENTIFIER '=' expr                                                     { REDUCE }
        | CONST type IDENTIFIER '=' expr                                               { REDUCE }
        | /* epsiolon */                                                               { REDUCE }
        ;
for_cond_stmt: 
        expr                                                                           { REDUCE }
        | /*epsiolon*/                                                                 { REDUCE }
        ;
for_inc_stmt: 
        IDENTIFIER '=' expr                                                            { REDUCE }
        | /*epsiolon*/                                                                 { REDUCE }
        ;


var_declaration:
        type IDENTIFIER                                                 { REDUCE printf("parser.declaration: type IDENTIFIER\n"); }
        | CONST type IDENTIFIER                                         { REDUCE printf("parser.declaration: CONST type IDENTIFIER\n"); }
        ;

args_list:
        _args_list
        |
        ;

_args_list:
        var_declaration
        | var_declaration ',' _args_list
        ;

        
type:
    T_INT { /*printf("parser2: type int\n")*/; }
    | T_FLOAT { /*printf("parser2: type float\n")*/; }
    ;
  

stmt_list:
          _stmt_list                  { /*$$ = $1*/; }
        |        { /*$$ = opr(';', 2, $1, $2)*/; }
        ;
_stmt_list:
          stmt                  { /*$$ = $1*/; }
        | stmt _stmt_list        { /*$$ = opr(';', 2, $1, $2)*/; }
        ;

expr:
          V_INTEGER                             { REDUCE printf("parser.expr: INTEGER\n"); }
        | V_FLOAT                               { REDUCE printf("parser.expr: FLOAT\n"); }
        | IDENTIFIER                            { REDUCE printf("parser.expr: VAR\n"); }
        | '-' expr %prec UMINUS                 { REDUCE printf("parser.expr: UMIN\n"); }
        | expr '+' expr                         { REDUCE printf("parser.expr: ADD\n"); }
        | expr '-' expr                         { REDUCE printf("parser.expr: SUB\n"); }
        | expr '*' expr                         { REDUCE printf("parser.expr: MUL\n"); }
        | expr '/' expr                         { REDUCE printf("parser.expr: DIV\n"); }
        | expr '<' expr                         { REDUCE printf("parser.expr: <\n"); }
        | expr '>' expr                         { REDUCE printf("parser.expr: >\n"); }
        | expr LEQ expr                         { REDUCE printf("parser.expr: LE\n"); }
        | expr GEQ expr                         { REDUCE printf("parser.expr: GEQ\n"); }
        | expr NEQ expr                         { REDUCE printf("parser.expr: NE\n"); }
        | expr EQQ expr                         { REDUCE printf("parser.expr: EQ\n"); }
        | '(' expr ')'                          { REDUCE printf("parser.expr: '(' expr ')'\n"); }
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
    fprintf(stdout, "%s\n", s);
    exit(1);
}

int main(void) {
    while(1) yyparse();
    return 0;
}