%{
#include <stdlib.h>
#include "y.tab.h"
void yyerror(char *);
void onError(char *);

#if defined LEX_DEBUG || defined DEBUG
#define MATCH printf("match at line %d: %s\n", __LINE__, yytext);
#define RETURN(x) printf("returning %s\n", #x); return x;
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
    // printf(yytext);
    // printf("\n");
    return *yytext;
}

{letter}{validChar}* { MATCH
    // printf("IDENTIFIER %s\n", yytext);
    RETURN(IDENTIFIER);
}

{number} { MATCH
    // printf("INTEGER %s\n", yytext);
    RETURN(V_INTEGER);
}

{number}\.{number} { MATCH
    // printf("FLOAT\n");
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
