%{
#include <stdlib.h>
#include "y.tab.h"
%}

%%
[0-9]+(\.[0-9]+)? {
    yylval.num = atof(yytext);
    return NUMBER;
}
[ \t]+     { }
\n         { return '\n'; }
[+\-*/()]  { return yytext[0]; }
.          { return yytext[0]; }
%%

int yywrap()
{
    return 1;
}
