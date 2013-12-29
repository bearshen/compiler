%{

int yylex(void);
void yyerror(const char *s);
bool fatal = false;
bool reporterrorline = true;
int error_count = 0;
extern int nlines;

#include <stdio.h>

#include "ast.h"
#include "variable.h"
#include "generate.h"
#include "function.h"
#include "init.h"
%}

// token definition
%union{
        _ast* a;
        int v;
        char s[80];
        int label;
};

%type <a> expr;
%type <a> variable;
%type <label> if_prefix;
%token <s> IDENTIFIER
%token <s> STRING
%token <v> INTEGER
%token <v> CHAR
%token FUNC VAR CFUNC
%token PRINT PRINTLN GET GETCHAR GETLINE
%token FOR WHILE IF RET BREAK CONT EXIT ETC

%nonassoc IFX
%nonassoc ELSE
%nonassoc VARDECLARE

%left ','
%right '='
%left OR
%left AND
%left NE EQ
%left GE LE '<' '>'
%left '+' '-'
%left '*' '/' '%'
%right NEG POS '!' '&' '$'
%left '(' ')' '[' ']'

// grammar
%%
routines:
        | routines routine
        ;

routine:
        function
        | stmt
        ;
        
stmts:
        | stmts stmt
        ;

function_header:
        FUNC IDENTIFIER '(' ')' { beginfunction($2, 0, "", "", "", "", 'i'); }
        | FUNC IDENTIFIER '(' IDENTIFIER ')' { beginfunction($2, 1, $4, "", "", "", 'i'); }
        | FUNC IDENTIFIER '(' IDENTIFIER ',' IDENTIFIER ')' { beginfunction($2, 2, $4, $6, "", "", 'i'); }
        | FUNC IDENTIFIER '(' IDENTIFIER ',' IDENTIFIER ',' IDENTIFIER ')' { beginfunction($2, 3, $4, $6, $8, "", 'i'); }
        | FUNC IDENTIFIER '(' IDENTIFIER ',' IDENTIFIER ',' IDENTIFIER ',' IDENTIFIER ')' { beginfunction($2, 4, $4, $6, $8, $10, 'i'); }
        | CFUNC IDENTIFIER '(' ')' { beginfunction($2, 0, "", "", "", "", 'c'); }
        | CFUNC IDENTIFIER '(' IDENTIFIER ')' { beginfunction($2, 1, $4, "", "", "", 'c'); }
        | CFUNC IDENTIFIER '(' IDENTIFIER ',' IDENTIFIER ')' { beginfunction($2, 2, $4, $6, "", "", 'c'); }
        | CFUNC IDENTIFIER '(' IDENTIFIER ',' IDENTIFIER ',' IDENTIFIER ')' { beginfunction($2, 3, $4, $6, $8, "", 'c'); }
        | CFUNC IDENTIFIER '(' IDENTIFIER ',' IDENTIFIER ',' IDENTIFIER ',' IDENTIFIER ')' { beginfunction($2, 4, $4, $6, $8, $10, 'c'); }
        ;

function:
        function_header '{' stmts '}' { endfunction(); }
        ;

expr:
        INTEGER { $$ = newast(_num, $1, NULL, NULL ); }
        | CHAR { $$ = newast(_char, $1, NULL, NULL); }
        | STRING { $$ = newast(_str, $1, NULL, NULL); }
        | variable %prec VARDECLARE { $$ = $1;}
        | IDENTIFIER '(' ')' { $$ = newast(_call, $1, NULL, NULL); }
        | IDENTIFIER '(' expr ')' { $$ = newast(_call, $1, newast(_dummy, NULL, $3, NULL), NULL); }
        | IDENTIFIER '(' expr ',' expr ')' { $$ = newast(_call, $1, newast(_dummy, NULL, $3, $5), NULL); }
        | IDENTIFIER '(' expr ',' expr ',' expr ')' { $$ = newast(_call, $1, newast(_dummy, NULL, $3, $5), newast(_dummy, NULL, $7, NULL)); }
        | IDENTIFIER '(' expr ',' expr ',' expr ',' expr ')' { $$ = newast(_call, $1, newast(_dummy, NULL, $3, $5), newast(_dummy, NULL, $7, $9)); }
        | expr '+' expr { $$ = newast(_add, NULL, $1, $3); }
        | expr '-' expr { $$ = newast(_sub, NULL, $1, $3); }
        | expr '*' expr { $$ = newast(_mul, NULL, $1, $3); }
        | expr '/' expr { $$ = newast(_div, NULL, $1, $3); }
        | expr '%' expr { $$ = newast(_mod, NULL, $1, $3); }
        | expr '<' expr { $$ = newast(_lessThan, NULL, $1, $3); }
        | expr '>' expr { $$ = newast(_greaterThan, NULL, $1, $3); }
        | expr EQ expr  { $$ = newast(_equal, NULL, $1, $3); }
        | expr NE expr  { $$ = newast(_notEqual, NULL, $1, $3); }
        | expr GE expr  { $$ = newast(_greaterEqual, NULL, $1, $3); }
        | expr LE expr  { $$ = newast(_lessEqual, NULL, $1, $3); }
        | '!' expr      { $$ = newast(_not, NULL, $2, NULL); }
        | '+' expr %prec POS { $$ = newast (_possgn, NULL, NULL, $2); }
        | '-' expr %prec NEG { $$ = newast (_negsgn, NULL, NULL, $2); }
        | expr AND expr { $$ = newast(_and, NULL, $1, $3); }
        | expr OR expr  { $$ = newast(_or, NULL, $1, $3); }
        | variable '=' expr { $$ = newast(_varAssign, NULL, $1, $3); }
        | '(' expr ')' { $$ = $2; }
        | '&' IDENTIFIER { $$ = newast(_addrOf, $2, NULL, NULL); }
        ;

variable:
        IDENTIFIER { $$ = newast(_addr, $1, NULL, NULL); }
        | IDENTIFIER '[' expr ']' { $$ = newast(_array, $1, $3, NULL); }
        | IDENTIFIER '[' expr ']' '[' expr ']' { 
                int dim2 = lookup($1)->dim[1];
                _ast* mulast = newast (_mul, NULL, newast(_num, dim2, NULL, NULL), $3);
                _ast* addast = newast (_add, NULL, mulast, $6);
                $$ = newast(_array, $1, addast, NULL); }
        | IDENTIFIER '[' expr ']' '[' expr ']' '[' expr ']' {
                int dim2 = lookup($1)->dim[1];
                int dim3 = lookup($1)->dim[2];
                _ast* mulast1 = newast (_mul, NULL, newast(_num, dim2*dim3, NULL, NULL), $3);
                _ast* mulast2 = newast (_mul, NULL, newast(_num, dim3, NULL, NULL), $6);
                _ast* addast1 = newast (_add, NULL, mulast1, mulast2);
                _ast* addast2 = newast (_add, NULL, addast1, $9);
                $$ = newast(_array, $1, addast2, NULL); }
        | '$' expr { $$ = newast(_contentOf, NULL, $2, NULL); }
        ;

if_prefix:
        IF '(' expr ')' { $$ = genIfBegin($3); }
        ;

stmt:
        ';'
        | expr ';' { genStmt($1); }
        | error ';' { if (fatal) exit(-1); else { yyerrok; yyerror("Statement not valid"); yyclearin; }}
        | '{' stmts '}' 
        | VAR IDENTIFIER ';' { declare($2, NULL); }
        | VAR IDENTIFIER '=' expr ';' { declare($2, $4); }
        | VAR IDENTIFIER '[' ']' '=' STRING ';' { genDeclareCharArray($2, $6); }
        | VAR IDENTIFIER '[' INTEGER ']' ';' { declare($2, NULL, $4, 0, 0, 0); }
        | VAR IDENTIFIER '[' INTEGER ']' '[' INTEGER ']' ';' { declare($2, NULL, $4, $7, 0, 0); }
        | VAR IDENTIFIER '[' INTEGER ']' '[' INTEGER ']' '[' INTEGER ']' ';' { declare($2, NULL, $4, $7, $10, 0); }
        | IDENTIFIER '[' expr ETC ']' '=' STRING ';' { genModifyCharArray($1, $3, $7); }
        | FOR '(' expr ';' expr ';' expr ')' { genStmt($3); $<label>$ = genForBegin($5); } stmt { genForEnd($7, $<label>9); }	
        | WHILE '(' expr ')' { genWhileBegin($3); } stmt { genWhileEnd(); }
        | if_prefix stmt %prec IFX { genIfEnd($1); }
        | if_prefix stmt ELSE { $<label>$ = genIfElse($1); } stmt { genIfEnd($<label>4); }
        | RET expr ';' { genReturn($2); }
        | RET ';' { genReturn(NULL); }
        | PRINT expr ';' { genPrint($2, false); }
        | PRINTLN expr ';' { genPrint($2, true); }
        | GET variable ';' { genGet($2, 'i'); }
        | GETCHAR variable ';' { genGet($2, 'c'); }
        | GETLINE variable ';' { genGet($2, 's'); }
        | CONT ';' { genContinue(); }
        | BREAK ';' { genBreak(); }
    	| EXIT ';' { genExit(); }
        ;

%%

int main(int argc, char **argv) {
        init ();
        yyparse();
        if (checkfunction() == ERROR_FUNCTION_NOT_DEFINED) {
                reporterrorline = false;
                fatal = true;
                yyerror ("There are calls to undefined functions.");
        }
        if (error_count != 0) 
            fprintf(stderr, "Build Failed: %d errors\n", error_count);
        return 0;
}

void yyerror(const char *s) {
        if (fatal) {
            fprintf(stderr, "Fatal Error ");
        }
        else {
            fprintf(stderr, "Error ");
        }
        if (reporterrorline)
            fprintf(stderr, "Line %d: %s\n", nlines + 1, s );
        else {
            fprintf(stderr, "%s\n", s );
        }
        error_count++;
        if (fatal) exit(-1);
}

