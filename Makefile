h100: h100.l h100.y ast.h errorconfig.h function.h generate.h init.h variable.h
	flex h100.l
	bison -vd h100.y
	g++ h100.tab.c lex.yy.c -o h100
