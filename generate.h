#ifndef GENERATE_H__
#define GENERATE_H__
#include "ast.h"
#include "function.h"
#define STACKSIZE 64
extern int n_label;

struct stack {
	int top;
	int container[STACKSIZE];
};

stack mgt_break, mgt_cont;

int pop(stack &s) {
	if (s.top == 0) {
		return ERROR_STACK_EMPTY;
	}
	else {
		return s.container[--s.top];
	}
}

int top(stack s) {
	if (s.top == 0) {
		return ERROR_STACK_EMPTY;
	}
	else {
		return s.container[s.top-1];
	}
}

void push (stack &s, int i) {
	s.container[s.top++] = i;
}

char generate (_ast *ast) {
	if (ast == NULL) 
		// Reserved state. if NULL, nothing need to be generated.
		return 'x';
	char type = 'x';

	char ltype = 'x';
	char rtype = 'x';
	switch (ast->a) {
		case _add: case _sub: case _mul: case _div: case _mod: case _possgn: case _negsgn:
		case _and: case _or: case _not: 
		case _lessThan: case _greaterThan: case _greaterEqual: case _lessEqual: case _notEqual: case _equal:
			if(ast->l != NULL) ltype = generate(ast->l);
			if(ast->r != NULL) rtype = generate(ast->r);
	}

	switch (ast->a) {
		// Terminals
		case _num:
			printf("push %d\n", (ast->v).i ); type = 'i'; break;
		case _char:
			printf("push '%c'\n", (char) (ast->v).i ); type = 'c'; break;
		case _str:
			printf("push \"%s\"\n", (ast->v).s ); type = 's'; break;
		case _addr: {
			VarRecord* var = lookup((ast->v).s);
			if(var->offset == ERROR_ID_NOT_FOUND){
				char msg[MAXSTRING];
				sprintf(msg, "Variable '%s' is not defined.", (ast->v).s);
				yyerror(msg); break;
			}
			type = var->type;
			if(type >= 'a') { // scalar
				if (var->local) printf("push fp[%d]\n", var->offset);
				else printf("push sb[%d]\n", var->offset);
			}
			else { // array pointer
				if (var->local) printf("push fp\npush sb\nsub\npush %d\nadd\n", var->offset);
				else printf("push %d\n", var->offset);
				type = 'p';
			}
			break;
			}
		case _contentOf: {
			char addresstype = generate(ast->l);
			if(addresstype != 'i' && addresstype != 'p') yyerror("Pointer address is not a number.");
			printf("pop ac\npush sb[ac]\n");
			type = 'i';
			break;
			}
		case _addrOf: {
			VarRecord* var = lookup((ast->v).s);
			if(var->offset == ERROR_ID_NOT_FOUND){
				char msg[MAXSTRING];
				sprintf(msg, "Variable '%s' is not defined.", (ast->v).s);
				yyerror(msg); break;
			}
			if (var->local) printf("push fp\npush sb\nsub\npush %d\nadd\n", var->offset);
			else printf("push %d\n", var->offset);
			type = 'p';
			break;
			}
		case _array: {
			char indextype = generate(ast->l);
			if(indextype != 'i') { yyerror("Array index is not a number."); break;}
			VarRecord* var = lookup((ast->v).s);
			if(var->offset == ERROR_ID_NOT_FOUND){
				char msg[MAXSTRING];
				sprintf(msg, "Array '%s' is not defined.", (ast->v).s);
				yyerror(msg);
				break;
			}
			printf("push %d\n", var->offset); // assume offset>=0 for now
			printf("add\npop ac\n");
			if (var->local) printf("push fp[ac]\n");
			else printf("push sb[ac]\n");
			type = var->type + 'a' - 'A';
			break;
			}
		case _call: {
			int argc = 0;
			if(ast->r){
				if(ast->r->r) { generate(ast->r->r); argc++; }
				if(ast->r->l) { generate(ast->r->l); argc++; }
			}
			if(ast->l){
				if(ast->l->r) { generate(ast->l->r); argc++; }
				if(ast->l->l) { generate(ast->l->l); argc++; }
			}
			int lbFuncEntry = identifyfunction((ast->v).s, argc, type);
			printf("call L%03d, %d\n", lbFuncEntry, argc);
			break;
			}

		// Arithmetics
		case _add: 
			if(ltype=='i' && rtype=='i') { printf("add\n"); type = 'i'; }
			else if(ltype=='c' && rtype=='i') { printf("add\n"); type = 'c'; }
			else if(ltype=='p' && rtype=='i') { printf("add\n"); type = 'p'; }
			else yyerror("Type mismatch: adding non-numbers.");
			break;
		case _sub: 
			if(ltype=='i' && rtype=='i') { printf("sub\n"); type = 'i'; }
			else if(ltype=='c' && rtype=='i') { printf("sub\n"); type = 'c'; }
			else if(ltype=='c' && rtype=='c') { printf("sub\n"); type = 'i'; }
			else if(ltype=='p' && rtype=='i') { printf("sub\n"); type = 'p'; }
			else yyerror("Type mismatch: subtracting non-numbers.");
			break;
		case _mul:
			if(ltype=='i' && rtype=='i') { printf("mul\n"); type = 'i'; }
			else yyerror("Type mismatch: multiplying non-numbers.");
			break;
		case _div:
			if(ltype=='i' && rtype=='i') { printf("div\n"); type = 'i'; }
			else yyerror("Type mismatch: dividing non-numbers.");
			break;
		case _mod:
			if(ltype=='i' && rtype=='i') { printf("mod\n"); type = 'i'; }
			else yyerror("Type mismatch: taking modulo of non-numbers.");
			break;
        case _possgn:
            if(rtype=='i') { printf("push 0\nadd\n"); type = 'i'; }
			else yyerror("Type mismatch: positive sign used before non-numbers.");
            break;
        case _negsgn:
            if(rtype=='i') { printf("push 0\nsub\n"); type = 'i'; }
			else yyerror("Type mismatch: negating non-numbers.");
            break;

		// Logic operations
		case _and:
			if(ltype=='i' && rtype=='i') { printf("and\n"); type = 'i'; }
			else yyerror("Type mismatch: conjunction on non-boolean values.");
			break;
		case _or:
			if(ltype=='i' && rtype=='i') { printf("or\n"); type = 'i'; }
			else yyerror("Type mismatch: disjunction on non-boolean values.");
			break;
		case _not:
			if(ltype=='i') { printf("neg\n"); type = 'i'; }
			else yyerror("Type mismatch: negation on non-boolean values.");
			break;

		// Comparisons
		case _lessThan:
			if((ltype=='i' && rtype=='i') || (ltype=='c' && rtype=='c')) { printf("complt\n"); type = 'i'; }
			else yyerror("Type mismatch: comparing non-numbers.");
			break;
		case _greaterThan:
			if((ltype=='i' && rtype=='i') || (ltype=='c' && rtype=='c')) { printf("compgt\n"); type = 'i'; }
			else yyerror("Type mismatch: comparing non-numbers.");
			break;
		case _greaterEqual:
			if((ltype=='i' && rtype=='i') || (ltype=='c' && rtype=='c')) { printf("compge\n"); type = 'i'; }
			else yyerror("Type mismatch: comparing non-numbers.");
			break;
		case _lessEqual:
			if((ltype=='i' && rtype=='i') || (ltype=='c' && rtype=='c')) { printf("comple\n"); type = 'i'; }
			else yyerror("Type mismatch: comparing non-numbers.");
			break;
		case _notEqual:
			if((ltype=='i' && rtype=='i') || (ltype=='c' && rtype=='c')) { printf("compne\n"); type = 'i'; }
			else yyerror("Type mismatch: comparing non-numbers.");
			break;
		case _equal:
			if((ltype=='i' && rtype=='i') || (ltype=='c' && rtype=='c')) { printf("compeq\n"); type = 'i'; }
			else yyerror("Type mismatch: comparing non-numbers.");
			break;

		// Assignment
		case _varAssign: {
			char newtype = generate(ast->r);
			printf("push sp[-1]\n"); // leave a copy on the stack
			if(ast->l->a == _array){
				char indextype = generate(ast->l->l);
				if(indextype != 'i') yyerror("Array index is not a number.");
				VarRecord* var = lookup((ast->l->v).s);
				if(var->offset == ERROR_ID_NOT_FOUND){
					char msg[MAXSTRING];
					sprintf(msg, "Array '%s' is not defined.", (ast->l->v).s);
					yyerror(msg);
                    break;
				}
				var->type = newtype + 'A' - 'a';
				printf("push %d\n", var->offset); // assume no arrays in parameters
				printf("add\npop ac\n");
				if(var->local) printf("pop fp[ac]\n");
				else printf("pop sb[ac]\n");
			} 
			else if(ast->l->a == _contentOf){
				char addresstype = generate(ast->l->l);
				if(addresstype != 'i' && addresstype != 'p') yyerror("Pointer address is not a number.");
				printf("pop ac\npop sb[ac]\n");
			}
			else{
				VarRecord* var = lookup((ast->l->v).s);
				if(var->offset == ERROR_ID_NOT_FOUND){
					char msg[MAXSTRING];
					sprintf(msg, "Variable '%s' is not defined.", (ast->l->v).s);
					yyerror(msg);
                    break;
				}
				var->type = newtype;
				if(var->local) printf("pop fp[%d]\n", var->offset);
				else printf("pop sb[%d]\n", var->offset);
			}
			break;
		}
		default:
            fatal = true;
            yyerror ("internal error");
			break;
	}
	freeast(ast);
	return type;
}

void genStmt(_ast *expr){
	generate(expr);
	printf("pop ac\n");
}

int genForBegin(_ast *e2){
	int lbCondition = n_label++;
	int lbContinue = n_label++;
	int lbEndFor = n_label++;
	push(mgt_break, lbEndFor);
	push(mgt_cont, lbContinue);
	printf("L%03d:", lbCondition);
	generate(e2);
	printf("j0 L%03d\n", lbEndFor);
	return lbCondition;
}

void genForEnd(_ast *e3, int lbCondition){
	printf("L%03d: ", pop(mgt_cont));
	genStmt(e3);
	printf("jmp L%03d\n", lbCondition);
	printf("L%03d: ", pop(mgt_break));
}

void genWhileBegin(_ast *condition){
	int lbCondition = n_label++;
	int lbEndWhile = n_label++;
	push(mgt_break, lbEndWhile);
	push(mgt_cont, lbCondition);
	printf("L%03d: ", lbCondition);
	generate(condition);
	printf("j0 L%03d\n", lbEndWhile);
}

void genWhileEnd(){
	printf("jmp L%03d\n", pop(mgt_cont));
	printf("L%03d: ", pop(mgt_break) );
}

int genIfBegin(_ast *condition){
	generate(condition);
	int lbSkipThen = n_label++;
	printf("j0 L%03d\n", lbSkipThen);
	return lbSkipThen;
}

int genIfElse(int lbSkipThen){
	int lbSkipElse = n_label++;
	printf("jmp L%03d\n", lbSkipElse);
	printf("L%03d: ", lbSkipThen);
	return lbSkipElse;
}

void genIfEnd(int lbEndIf){
	printf("L%03d: ", lbEndIf);
}

void genBreak(){
	int lbBreak = top(mgt_break);
	if(lbBreak == ERROR_STACK_EMPTY){
		char msg[MAXSTRING];
		sprintf(msg, "Break statement used outside a loop.");
		yyerror(msg);
	}
	else printf("jmp L%03d\n", lbBreak);
}

void genContinue(){
	int lbContinue = top(mgt_cont);
	if(lbContinue == ERROR_STACK_EMPTY){
		char msg[MAXSTRING];
		sprintf(msg, "Contiune statement used outside a loop.");
		yyerror(msg);
	}
	else printf("jmp L%03d\n", lbContinue);
}

void genReturn(_ast *value){
	if(value) generate(value);
	else printf("push 0\n");
	printf("ret\n");
}

void genPrint(_ast *expr, bool println){
	char arrayName[MAXSTRING];
	if((expr->v).s) strcpy(arrayName, (expr->v).s);
	char type = generate(expr);
	switch (type){
		case 'i': case 's': case 'c':
			if(println) printf("put%c\n", type);
			else printf("put%c_\n", type);
			break;
		case 'p':
			printf("pop ac\n");
			VarRecord* var = lookup(arrayName);
			int length = var->dim[0];
			if(var->dim[1] > 0) length *= var->dim[1];
			if(var->dim[2] > 0) length *= var->dim[2];
			if(length > 1){
				printf("push 0\npop ac\n");
				int lbCondition = n_label++;
				int lbEndLoop = n_label++;
				printf("L%03d: push ac\npush %d\ncomplt\n", lbCondition, length);
				printf("j0 L%03d\n", lbEndLoop);
				if (var->local) printf("push fp[ac]\n");
				else printf("push sb[ac]\n");
				switch (var->type){
					case 'I': printf("puti_\n"); printf("push '\t'\nputc_\n"); break;
					case 'C': printf("putc_\n"); break;
					case 'S': printf("puts_\n"); printf("push ' '\nputc_\n"); break;
				}
				printf("push ac\npush 1\nadd\npop ac\njmp L%03d\n", lbCondition);
				if(println) printf("L%03d: push ''\nputc\n", lbEndLoop);
				else printf("L%03d: ", lbEndLoop);
			}
			break;
	}
}

void genGet(_ast *variable, char type){
	printf("get%c\n", type);
	VarRecord* var = lookup((variable->v).s);
	if(var->offset == ERROR_ID_NOT_FOUND){
		char msg[MAXSTRING];
		sprintf(msg, "Variable '%s' is not defined.", (variable->v).s);
		yyerror(msg);
        return;
	}
	var->type = type;
	if(var->local) printf("pop fp[%d]\n", var->offset);
	else printf("pop sb[%d]\n", var->offset);
}

void genExit(){
	printf("end\n");
}

void genModifyCharArray(string name, _ast* position, string content){
	char indextype = generate(position);
	if(indextype != 'i') { yyerror("Char array index is not a number."); return; }
	VarRecord* var = lookup(name);
	if(var->offset == ERROR_ID_NOT_FOUND){
		char msg[MAXSTRING];
		sprintf(msg, "Char array '%s' is not defined.", name.c_str());
		yyerror(msg);
        return;
	}
	var->type = 'C';
	printf("push %d\n", var->offset);
	printf("add\npop ac\n");
	for(int i=0; i<content.length(); i++){
		printf("push '%c'\n", content[i]);
		if (var->local) printf("pop fp[ac]\n");
		else printf("pop sb[ac]\n");
		printf("push ac\npush 1\nadd\npop ac\n");
	}
}

void genDeclareCharArray(string name, string content){
	if(content.length()==0){
		declare(name, newast(_char, 0, NULL, NULL));
		return;
	}
	if(content.length()==1){
		declare(name, newast(_char, name[0], NULL, NULL));
		return;
	}
	declare(name, NULL, content.length(), 0, 0, 0);
	genModifyCharArray(name, newast(_num, 0, NULL, NULL), content);
}

#endif //GENERATE_H__
