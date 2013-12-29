#ifndef AST_H__
#define AST_H__

#include "errorconfig.h"
#include <stdlib.h>
#include <string.h>

int n_label;
extern bool fatal;
enum {
    _add,
    _sub,
    _mul,
    _div,
    _mod,
    _not,
    _lessThan,
    _greaterThan,
    _greaterEqual,
    _lessEqual,
    _notEqual,
    _equal,
    _and,
    _or,
    _varAssign,
    _num,
    _char,
    _str,
    _addr,
    _array,
    _dummy,
    _call,
    _possgn,
    _negsgn,
    _contentOf,
    _addrOf,
};

typedef int _action;

typedef union {
	char s[MAXSTRING];
	int i;
} _value;

struct _ast
{
    _value v;
    _action a;
    _ast *l;
    _ast *r;
};



_ast* _newast (_action a, _value v, _ast *l, _ast *r) {
	_ast* ret_ast = (_ast *) malloc (sizeof (_ast));
	if (ret_ast == NULL) { fatal = true; yyerror("Internal Failure: malloc failure"); }
	ret_ast->a = a;
	ret_ast->v = v;
	ret_ast->l = l;
	ret_ast->r = r;
	return ret_ast;
}

_ast* newast (_action a, char* v, _ast *l, _ast *r) {
	_value _v;
	strcpy (_v.s, v);
	return _newast (a, _v, l, r);
}

_ast* newast (_action a, int v, _ast *l, _ast *r) {
	_value _v;
	_v.i = v;
	return _newast (a, _v, l, r);
}

_ast* newast (_action a, _value v, _ast *l, _ast *r) {
	return _newast (a, v, l, r);
}

void freeast(_ast * ast) {
	if (ast == NULL) return;
	else {
		free(ast);
		ast = NULL;
	}
}


#endif //AST_H__
