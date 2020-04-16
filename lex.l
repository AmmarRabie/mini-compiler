%{
#include <stdlib.h>
#include <string.h>
#include <iostream>
#include "ast.h"
#include "SymbolTableTree.h"
#include "y.tab.h"
using namespace std;
void yyerror(char *);
void onError(char *);
extern int yylex();





#if defined LEX_DEBUG || defined DEBUG
#define MATCH cout<<"match at line "<<__LINE__<<": "<<yytext<<endl;
#define RETURN(x) cout<<"returning "<<#x<<endl; return x;
#else
#define MATCH
#define RETURN(x) return x;
#endif
%}
%option yylineno
letter [a-zA-Z]
validChar [0-9a-zA-Z_]
number [0-9]+
cChar  '.'

%%

[ \t]+        ;       /* ignore whitespace */
\n            ;



"print" {yylval.iValue =PRINT; MATCH RETURN (PRINT);}
">=" { MATCH RETURN (GEQ);}
"<=" { MATCH RETURN (LEQ);}
"!=" { MATCH RETURN (NEQ);}
"==" { MATCH RETURN (EQQ);}
"const" {yylval.iValue =CONST; MATCH RETURN (CONST);}
"int"   {yylval.iValue =T_INT; MATCH RETURN (T_INT);}
"char"  {yylval.iValue =T_CHR; MATCH RETURN (T_CHR);}
"float" {yylval.iValue =T_FLOAT; MATCH RETURN (T_FLOAT);}
"if" { yylval.iValue =IF;MATCH RETURN (IF);}
"else" { yylval.iValue =ELSE; MATCH RETURN (ELSE);}
"switch" { yylval.iValue =SWITCH; MATCH RETURN (SWITCH);}
"case" { yylval.iValue =CASE; MATCH RETURN (CASE);}
"default" {yylval.iValue =DEFAULT; MATCH RETURN (DEFAULT);}
"while" { yylval.iValue =WHILE; MATCH RETURN (WHILE);}
"until" { yylval.iValue =UNTIL; MATCH RETURN (UNTIL);}
"for" { yylval.iValue =FOR; MATCH RETURN (FOR);}

(function|#) {MATCH RETURN(FUNCTION); };

[-()<>=+*/{},:] { MATCH
    return *yytext;
}

{cChar} {
     yylval.cValue =yytext[1]; 
     //cout<<endl<<yylval.cValue<<endl;
    MATCH RETURN (V_CHR);
}

{letter}{validChar}* { 
        yylval.sValue =mystrdup(yytext);
        MATCH RETURN(IDENTIFIER);
}

{number} { MATCH
    //cout<<"lex -- INTEGER" << yytext<<endl;
    yylval.iValue=atoi(yytext);
    RETURN(V_INTEGER);
}

{number}\.{number} { MATCH
    //cout<<"lex -- Float" << yytext<<endl;
    yylval.fValue=strtof(yytext,NULL);
    RETURN(V_FLOAT);
}

^[ \t\n]+$ // before this line, we match a empty lines as empty statement

[;] { MATCH
    //printf("end of statement\n");
    RETURN(SEMICOLON);
}



%%
int yywrap(void) {
    printf("warping\n");
    return 1;
}

void onError(char * message){
    cout<<"Error"<<endl;
    cout<<"''"<<yytext<<"''"<<endl;
    yyerror(message);
}


char *mystrdup( char *c)
{
    char *dup =(char*) malloc(strlen(c) + 1);

    if (dup != NULL)
       strcpy(dup, c);

    return dup;
}