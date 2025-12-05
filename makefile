# Nom de l'exécutable
EXEC = analyseur

# Fichiers sources
SRC = main.c parser.tab.c lex.yy.c

# Compilateur et options
CC = gcc
CFLAGS = -Wall

# Règle par défaut
all: $(EXEC)

# Création de l'exécutable
$(EXEC): parser.tab.c lex.yy.c main.c
	$(CC) $(CFLAGS) -o $(EXEC) $(SRC)

# Génération du code C par Bison (Parser)
parser.tab.c parser.tab.h: parser.y
	bison -d parser.y

# Génération du code C par Flex (Lexer)
lex.yy.c: lexer.l parser.tab.h
	flex lexer.l

# Nettoyage des fichiers générés
clean:
	rm -f $(EXEC) lex.yy.c parser.tab.c parser.tab.h
	rm -rf output/

# Pour lancer un test rapidement
run: all
	./$(EXEC) tests/test1.txt