#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h> // Pour mkdir
#include <sys/types.h>

/* Déclarations provenant du parser et lexer */
extern int yyparse();
extern FILE *yyin;
extern char message_cache[]; 

FILE *rapport_file;

int main(int argc, char **argv) {
    if (argc < 2) {
        printf("Usage: %s <fichier_test>\n", argv[0]);
        return 1;
    }

    yyin = fopen(argv[1], "r");
    if (!yyin) {
        perror("Erreur ouverture fichier test");
        return 1;
    }

    #ifdef _WIN32
        mkdir("output");
    #else
        mkdir("output", 0777);
    #endif

    rapport_file = fopen("output/rapport.txt", "w");
    FILE *msg_file = fopen("output/message.txt", "w");
    FILE *xml_file = fopen("output/message.xml", "w");

    if (!rapport_file || !msg_file || !xml_file) {
        perror("Erreur création fichiers de sortie");
        return 1;
    }

    fprintf(rapport_file, "RAPPORT D'ANALYSE SYNTAXIQUE\n");
    fprintf(rapport_file, "================================\n");

    printf("Analyse en cours...\n");
    yyparse();

   
    fprintf(msg_file, "%s", message_cache);
    
    fprintf(xml_file, "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
    fprintf(xml_file, "<resultats>\n");
    fprintf(xml_file, "  <message_cache>%s</message_cache>\n", message_cache);
    fprintf(xml_file, "</resultats>\n");

    printf("Terminé ! Vérifiez le dossier 'output/'.\n");

    fclose(yyin);
    fclose(rapport_file);
    fclose(msg_file);
    fclose(xml_file);

    return 0;
}