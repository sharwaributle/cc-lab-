%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
int yyerror(const char *s);
%}

%union {
    double num;
}

%token <num> NUMBER
%type <num> expr

%left '+' '-'
%left '*' '/'
%right UMINUS

%%
input:
      /* empty */
    | input line
    ;

line:
      '\n'
    | expr '\n' {
          printf("Result = %g\n", $1);
      }
    | error '\n' {
          printf("Invalid expression. Try again.\n");
          yyerrok;
      }
    ;

expr:
      NUMBER              { $$ = $1; }
    | expr '+' expr       { $$ = $1 + $3; }
    | expr '-' expr       { $$ = $1 - $3; }
    | expr '*' expr       { $$ = $1 * $3; }
    | expr '/' expr       {
          if ($3 == 0) {
              yyerror("Division by zero");
              $$ = 0;
          } else {
              $$ = $1 / $3;
          }
      }
    | '-' expr %prec UMINUS { $$ = -$2; }
    | '(' expr ')'        { $$ = $2; }
    ;
%%

int yyerror(const char *s)
{
    printf("Error: %s\n", s);
    return 0;
}

int main()
{
    printf("Desk Calculator (Ctrl+D to exit)\n");
    yyparse();
    return 0;
}
