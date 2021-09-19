%{
#include "lexico.h"
#include <math.h>
int numeroLineas;
int numeroErrores;
%}
digito              [0-9]
letra               [a-zA-Z]
entero              [0-9]
identificador       ({letra}|_)({letra}|_|digito)*
erroModoPanico      [^ \n\t/a-zA-Z0-9;,+\-*/(){}]+

%x comentario
%option yylineno

%%
[ \n\t]+                                    ;
"//"(.*)[\n]                                ;
"/*"                                        {yymore(); numeroLineas = yylineno; BEGIN(comentario);}
<comentario>[*]+"/"                         {BEGIN(INITIAL); printf("COMENTARIO: \n-------\n%s\n-------\n" ,yytext);}
<comentario>([^*]|[*]+[^*/])*               yymore();
<comentario><<EOF>>                        { printf("ERRO COMENTARIO SIN CERRAR linea : %d\n" ,numeroLineas);
                                          //Tengo que decirle a yylex() que he llegado al final                                                
                                            return 0;}
"main"                                      return START;
"func"                                      return FUNC;
"var"                                       return VAR;
"const"                                     return CONST;
"if"                                        return IF;
"else"                                      return ELSE;
"while"                                     return WHILE;
"print"                                     return PRINT;
"read"                                      return READ;
{entero}+                                   { long int aux = atol(yytext);
                                                if( aux > pow(2,32)){
                                                    printf("ERROR %s > 2³² long %d\n" ,yytext,yyleng);
                                                    numeroErrores++;
                                                 ;}
                                                return INTLITERAL;}
{identificador}                             {
                                                if (yyleng > 16){
                                                    printf("ERROR %s > 16 long %d\n" ,yytext,yyleng);
                                                }
                                                 return ID;}
                           
    
\"[^"]+\"                                   return CADENA;
"("                                         return LPAREN;		
")"                                         return RPAREN;
"{"                                         return LBRACE;		
"}"                                         return RBRACE;
";"                                         return SEMICOLON;
","                                         return COMMA;
"="                                         return ASSIGNOP;
"+"                                         return PLUSOP;
"-"                                         return MINUSOP;
"*"                                         return MULTSOP;
"/"                                         return DIVTSOP;
{erroModoPanico}                            {printf("TOKEN CRAP");
                                            printf(" LEXEMA %s  LONGITUD %d\n",yytext,yyleng); 
                                            return CRAP;}
%%
