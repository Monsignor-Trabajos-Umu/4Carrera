#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "lexico.h"

extern char *yytext;
extern int yyleng;
extern FILE *yyin;
extern int yylex();
extern int numeroErrores;
FILE *fich;


const char * ERRORDIC [] = {
    "nada",
    "START",
    "FUNC",
    "VAR",
    "CONST",
    "IF",
    "ELSE",
    "WHILE",
    "PRINT",
    "READ",
    "ID",
    "INTLITERAL",
    "CADENA",
    "LPAREN",
    "RPAREN",
    "LBRACE",
    "RBRACE",
    "SEMICOLON",
    "COMMA",
    "ASSIGNOP",
    "PLUSOP",
    "MINUSOP",
    "MULTSOP",
    "DIVTSOP",
    "CRAP"
};




int main(int argc, char *argv[])
{
    if (argc != 2)
    {
        printf("Uso %s fichero.txt", argv[0]);
        char nombre[80];
        printf("INTRODUCE NOMBRE DE FICHERO FUENTE:");
        fgets(nombre, 80, stdin);
        nombre[strlen(nombre) - 1] = 0;
        printf("Nombre fichero: %s\n", nombre);
        if ((fich = fopen(nombre, "r")) == NULL)
        {
            printf("***ERROR, no puedo abrir el fichero\n");
            perror("Error leyendo:");
            exit(1);
        }
    }

    if (argc == 2)
    {
        char *nombre = argv[1];
        printf("Nombre fichero: %s\n", nombre);
        if ((fich = fopen(nombre, "r")) == NULL)
        {
            printf("***ERROR, no puedo abrir el fichero\n");
            perror("Error leyendo:");
            exit(1);
        }
    }
    int i;
    yyin = fich;
    while (i = yylex())
    {
        if (i != CRAP)
        {
            printf("TOKEN %d" , i);
            printf(" IS %s " , ERRORDIC[i]);
            printf(" LEXEMA %s  LONGITUD %d\n", yytext, yyleng);
            //if(i==ID) printf(" LEXEMA %s  LONGITUD %d\n",yytext,yyleng);
            //else printf("\n");
        }
    }
    fclose(fich);
    printf("Numero de errores  %d", numeroErrores);
    return 0;
}
