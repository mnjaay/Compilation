#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h> // Pour mkdir
#include <sys/types.h>

/* Déclarations provenant du parser et lexer */
extern int yyparse();
extern FILE *yyin;
extern char message_cache[]; // Le message reconstruit dans parser.y

/* Fichiers de sortie globaux */
FILE *rapport_file;

int main(int argc, char **argv) {
    if (argc < 2) {
        printf("Usage: %s <fichier_test>\n", argv[0]);
        return 1;
    }

    // 1. Ouvrir le fichier d'entrée (Test)
    yyin = fopen(argv[1], "r");
    if (!yyin) {
        perror("Erreur ouverture fichier test");
        return 1;
    }

    // 2. Création du dossier output (si n'existe pas)
    #ifdef _WIN32
        mkdir("output");
    #else
        mkdir("output", 0777);
    #endif

    // 3. Ouvrir les fichiers de sortie
    rapport_file = fopen("output/rapport.txt", "w");
    FILE *msg_file = fopen("output/message.txt", "w");
    FILE *xml_file = fopen("output/message.xml", "w");

    if (!rapport_file || !msg_file || !xml_file) {
        perror("Erreur création fichiers de sortie");
        return 1;
    }

    // En-tête du rapport
    fprintf(rapport_file, "RAPPORT D'ANALYSE SYNTAXIQUE\n");
    fprintf(rapport_file, "================================\n");

    // 4. Lancer l'analyse (Lex + Yacc)
    printf("Analyse en cours...\n");
    yyparse();

    // 5. Écriture des résultats finaux
    // Fichier TXT
    fprintf(msg_file, "%s", message_cache);
    
    // Fichier XML (Optionnel selon le sujet, mais bon point !)
    fprintf(xml_file, "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
    fprintf(xml_file, "<resultats>\n");
    fprintf(xml_file, "  <message_cache>%s</message_cache>\n", message_cache);
    fprintf(xml_file, "</resultats>\n");

    printf("Terminé ! Vérifiez le dossier 'output/'.\n");

    // 6. Nettoyage
    fclose(yyin);
    fclose(rapport_file);
    fclose(msg_file);
    fclose(xml_file);

    return 0;
}