%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parser.tab.h" /* Important: Inclusion des tokens définis par Bison */

int ligne_num = 1;
%}

%option noyywrap

%%

"@"             { return SYM_AT; }
"#"             { return SYM_HASH; }
"$"             { return SYM_DOLLAR; }

[-./:;]         { return SEP; }

[!?]            { return END; }

[a-zA-Z]+       { 
    yylval.str = strdup(yytext); 
    return MOT; 
}

[ \t]+          { /* Ignorer espaces */ }

\n              { ligne_num++; }

.               { printf("Caractère inconnu ligne %d: %s\n", ligne_num, yytext); }

%%