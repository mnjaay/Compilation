%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Déclarations externes (définies dans main.c) */
extern int ligne_num;
extern int yylex();
extern FILE *rapport_file; // Pour écrire le rapport au fur et à mesure
void yyerror(const char *s);

/* Variable globale pour stocker le message (accessible via main.c) */
char message_cache[10000] = ""; 

void ajouter_mot(char *s) {
    strcat(message_cache, s);
    strcat(message_cache, " ");
}
%}

%union {
    char *str;
}

%token <str> MOT
%token SYM_AT SYM_HASH SYM_DOLLAR SEP END

%%

programme:
    phrases
    ;

phrases:
    phrases phrase
    | phrase
    ;

phrase:
    SYM_AT MOT SEP MOT SEP MOT END {
        fprintf(rapport_file, "Ligne %d: [VALIDE] Symbole @ -> Ajout 1er et 3ème mot.\n", ligne_num);
        ajouter_mot($2); 
        ajouter_mot($6);
    }
    | SYM_HASH MOT SEP MOT SEP MOT END {
        fprintf(rapport_file, "Ligne %d: [VALIDE] Symbole # -> Ajout 1er et 2ème mot.\n", ligne_num);
        ajouter_mot($2); 
        ajouter_mot($4);
    }
    | SYM_DOLLAR MOT SEP MOT SEP MOT END {
        fprintf(rapport_file, "Ligne %d: [VALIDE] Symbole $ -> Ajout du mot concaténé.\n", ligne_num);
        /* Concatène les trois mots en une seule chaîne puis l'ajoute */
        size_t len = strlen($2) + strlen($4) + strlen($6) + 1;
        char *concat = (char*)malloc(len);
        if (concat) {
            concat[0] = '\0';
            strcat(concat, $2);
            strcat(concat, $4);
            strcat(concat, $6);
            ajouter_mot(concat);
            free(concat);
        } else {
            fprintf(rapport_file, "Ligne %d: [WARN] allocation échouée, ajout séparé.\n", ligne_num);
            ajouter_mot($2);
            ajouter_mot($4);
            ajouter_mot($6);
        }
    }
    | error END {
        yyerrok; 
    }
    ;

%%

void yyerror(const char *s) {
    fprintf(rapport_file, "Ligne %d: [ERREUR] %s - Phrase ignorée.\n", ligne_num, s);
    fprintf(stderr, "Erreur syntaxique ligne %d\n", ligne_num);
}