%{
#include <stdlib.h>
#include <iostream>
#include "grammer.tab.h"
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

letter [a-zA-Z]
validChar [0-9a-zA-Z_]
number [0-9]+

%%
"print" { MATCH RETURN (PRINT);}
">=" { MATCH RETURN (GEQ);}
"<=" { MATCH RETURN (LEQ);}
"!=" { MATCH RETURN (NEQ);}
"==" { MATCH RETURN (EQQ);}
"const" { MATCH RETURN (CONST);}
"int" { MATCH RETURN (T_INT);}
"float" { MATCH RETURN (T_FLOAT);}
"if" { MATCH RETURN (IF);}
"else" { MATCH RETURN (ELSE);}
"switch" { MATCH RETURN (SWITCH);}
"case" { MATCH RETURN (CASE);}
"default" { MATCH RETURN (DEFAULT);}
"while" { MATCH RETURN (WHILE);}
"until" { MATCH RETURN (UNTIL);}
"for" { MATCH RETURN (FOR);}

(function|#) {MATCH RETURN(FUNCTION); };

[-()<>=+*/{},:] { MATCH
    return *yytext;
}

{letter}{validChar}* { 
    cout<<"lex -- identifier" << yytext<<endl;
    yylval.sValue=yytext;
    MATCH RETURN(IDENTIFIER);
}

{number} { MATCH
    cout<<"lex -- INTEGER" << yytext<<endl;
    yylval.iValue=atoi(yytext);
    RETURN(V_INTEGER);
}

{number}\.{number} { MATCH
    cout<<"lex -- Float" << yytext<<endl;
    yylval.fValue=strtof(yytext,NULL);
    RETURN(V_FLOAT);
}

^[ \t\n]+$ // before this line, we match a empty lines as empty statement

[;] { MATCH
    // printf("end of statement\n");
    RETURN(SEMICOLON);
}



[ \t]+        ;       /* ignore whitespace */
\n            ;

.               onError("Unknown char");
%%
int yywrap(void) {
    printf("warping\n");
    return 1;
}

void onError(char * message){
    printf("ERROR\n", yytext);
    yyerror(message);
}
