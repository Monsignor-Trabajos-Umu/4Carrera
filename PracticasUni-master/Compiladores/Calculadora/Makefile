all: calc

calc: cal.tab.c cal.tab.h lex.yy.c
	gcc -lfl -o calc cal.tab.c lex.yy.c

lex.yy.c: cal.l cal.tab.h
	flex cal.l

cal.tab.c cal.tab.h: cal.y
	bison -d cal.y
	

