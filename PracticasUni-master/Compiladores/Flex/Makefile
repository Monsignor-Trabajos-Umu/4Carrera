all: lexAnalizer

lex.yy.c: lexico.l lexico.h
	flex lexico.l

lexAnalizer: lex.yy.c main.c lexico.h
	gcc -lfl -o lexAnalizer main.c lex.yy.c

run : lexAnalizer prueba
	./lexAnalizer prueba

clean:
	rm lex.yy.c lexAnalizer
