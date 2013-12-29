%{
#include <stdlib.h>
void yyerror(const char *);
int nlines = 0;
struct _ast;

#include "h100.tab.h"
%}

%%
">="            return GE;
"<="            return LE;
"=="            return EQ;
"!="            return NE;
"for"           return FOR;
"while"         return WHILE;
"if"            return IF;
"else"          return ELSE;
"print"         return PRINT;
"println"       return PRINTLN;
"get"           return GET;
"getline"       return GETLINE;
"getchar"       return GETCHAR;
"&&"            return AND;
"||"            return OR;
"var"           return VAR;
"function"      return FUNC;
"charfunc"      return CFUNC;
"return"        return RET;
"break"         return BREAK;
"continue"      return CONT;
"exit"          return EXIT;
"..."           return ETC;

\"([^"]|\\\")*\" {
                strcpy (yylval.s, yytext+1);
	        	yylval.s[yyleng-2] = 0;
                for (int i = 0; yylval.s[i] != 0; ++i) {
                    if (yylval.s[i] == '\n') nlines++;
                }
                return STRING;
}

[_a-zA-Z]+[a-zA-Z0-9_]* { 
                strcpy (yylval.s, yytext) ;
                return IDENTIFIER;
}

0 {
                yylval.v = atoi(yytext);
                return INTEGER;
}

[1-9][0-9]* {
                yylval.v = atoi(yytext);
                return INTEGER;
}

'[^\'\\]' {
                yylval.v = yytext[1];
                return CHAR;
}

'\\.' {
                switch (yytext[2]) {
                        case 'n':       yylval.v = '\n'; break;
                        case 't':       yylval.v = '\t'; break;
                        case '\\':      yylval.v = '\\'; break;
                        case '\'':      yylval.v = '\''; break;
                        case '\"':      yylval.v = '\"'; break;
                        default:        yylval.v = yytext[2]; break;
                }
                return CHAR;
}



[-()<>=+*/;{}\[\]%!,&$] {
                return *yytext;
}

\/\/.*\n        {nlines++;}        /* skip comments */

[ \t\r]+        ;       /* ignore whitespace */

\n              {nlines++;}

. {
                char error_text[80];
                sprintf(error_text, "line %d: Unrecognized character: %c \n", nlines, yytext[0]);
                yyerror(error_text);
}

%%

int yywrap(void) {
    return 1;
}
