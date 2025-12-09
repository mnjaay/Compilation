# Compilation - Analyseur Lexical et Syntaxique

## 📋 Description du Projet

Ce projet implémente un **analyseur lexical et syntaxique** (basé sur **Flex** et **Bison**) capable de décoder un message caché dans un texte suivant une grammaire artificielle stricte.

## 🎯 Objectif

Le programme analyse des phrases structurées selon des patterns spécifiques et extrait des mots pour reconstituer un message caché. Chaque phrase suit une grammaire définie avec des symboles spéciaux (@, #, $) qui détermine quels mots extraire.

## 📁 Structure du Projet

```
analyseur/
├── lexer.l              # Définition des tokens (Flex)
├── parser.y             # Grammaire et actions syntaxiques (Bison)
├── main.c               # Point d'entrée du programme
├── makefile             # Compilation
├── lex.yy.c             # Code généré par Flex
├── parser.tab.c         # Code généré par Bison
├── parser.tab.h         # Déclarations de tokens
├── output/              # Fichiers de résultats
│   ├── rapport.txt      # Rapport d'analyse détaillé
│   ├── message.txt      # Message décodé
│   └── message.xml      # Message au format XML
└── tests/               # Fichiers de test
    ├── test1.txt
    └── test2.txt
```

## 🔧 Compilation

```bash
make clean
make
```

## ▶️ Exécution

```bash
./analyseur tests/test1.txt
```

## 📝 Grammaire Acceptée

### Patterns de phrases valides :

- **`@ MOT SEP MOT SEP MOT END`** → Extraction du 1er et 3ème mot
- **`# MOT SEP MOT SEP MOT END`** → Extraction du 1er et 2ème mot  
- **`$ MOT SEP MOT SEP MOT END`** → Extraction des 3 mots

### Symboles spéciaux :

| Symbole | Rôle |
|---------|------|
| `@` | Marqueur de pattern 1 |
| `#` | Marqueur de pattern 2 |
| `$` | Marqueur de pattern 3 |
| SEP | Séparateur : `-` `.` `/` `:` `;` |
| END | Fin de phrase : `!` ou `?` |
| MOT | Mot : caractères alphabétiques |

### Exemple d'entrée :

```
@ Validation / du / systeme !
# Test / de / reprise ?
@ Fin / du / test !
```

### Message décodé :

```
Validation systeme Test de Fin test
```

## 📊 Fichiers de Sortie

### output/rapport.txt
Analyse détaillée de chaque ligne avec validation/erreurs :
```
RAPPORT D'ANALYSE SYNTAXIQUE
================================
Ligne 1: [VALIDE] Symbole @ -> Ajout 1er et 3ème mot.
Ligne 2: [VALIDE] Symbole # -> Ajout 1er et 2ème mot.
```

### output/message.txt
Le message décodé extrait

### output/message.xml
Résultats au format XML

## 🏗️ Architecture

### lexer.l
- Reconnaissance des tokens (symboles spéciaux, mots, séparateurs)
- Gestion des numéros de ligne

### parser.y
- Définition de la grammaire LALR(1)
- Actions syntaxiques pour extraire les mots
- Gestion des erreurs

### main.c
- Orchestration du processus d'analyse
- Création du dossier output
- Écriture des fichiers résultats

## 🛠️ Technologie

- **Lexer** : Flex 2.6.4
- **Parser** : Bison 2.3
- **Langage** : C (ANSI/ISO C)
- **Compilateur** : GCC

## ✅ Fonctionnalités

- ✓ Analyse lexicale complète
- ✓ Analyse syntaxique LALR(1)
- ✓ Extraction conditionnelle de mots
- ✓ Rapport détaillé d'analyse
- ✓ Gestion des erreurs avec récupération
- ✓ Support multi-lignes
- ✓ Sortie XML

## 📝 Notes

- Les espaces entre tokens sont ignorés
- Les caractères inconnus génèrent un message d'avertissement
- Les erreurs syntaxiques sont catchées et la phrase est ignorée
- Le message est reconstruit progressivement lors de l'analyse



