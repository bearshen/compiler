#ifndef FUNCTION_H__
#define FUNCTION_H__

#include "variable.h"
#include <stdlib.h>
#include <list>
#include <string>
#include <vector>
#include <stdio.h>

using namespace std;

const int MAGIC_OFFSET = -4;
int g_jmp_label;
extern int n_label;

struct FuncRecord {
	string name;
	int nvars;
	vector<string> var;
	_ast *stmts;
	bool isdefined;
	int label;
	char type;
	FuncRecord(string name, int nvars) : name(name), nvars(nvars){
		label = n_label++;
		type = 'i';
	}
};

list<FuncRecord> func_record;
list <FuncRecord>::iterator it;

int identifyfunction (string name, int nvars, char& type) {	
	for (it = func_record.begin(); it != func_record.end(); ++it) {
		if ((*it).name == name && (*it).nvars == nvars) {
			type = it->type;
			return (*it).label;
		}
	}
	func_record.push_back (FuncRecord(name, nvars));
	for (it = func_record.begin(); it != func_record.end(); ++it) {
		if ((*it).name == name && (*it).nvars == nvars) {
			type = it->type;
			return (*it).label;
		}
	}
}

void beginfunction(string name, int nvars, string s1, string s2, string s3, string s4, char t) {
	char dummy;
	int label = identifyfunction(name, nvars, dummy);
	(*it).isdefined = true;
	it->type = t;
	enterFunction();	
	if (nvars >= 1) {
		((*it).var).push_back(s1);
	} 
	if (nvars >= 2) {
		((*it).var).push_back(s2);
	} 
	if (nvars >= 3) {
		((*it).var).push_back(s3);
	} 
	if (nvars >= 4) {
		((*it).var).push_back(s4);
	} 
	for (int i = 0; i < nvars; ++i) {
		declare((*it).var[i], MAGIC_OFFSET-i);
	}
	g_jmp_label = n_label++;
	printf ("jmp L%03d\n",g_jmp_label);
	printf ("L%03d:\t", label);
}

void endfunction() {
	printf ("push 0\nret\n");
	printf ("L%03d:\t", g_jmp_label);
	exitFunction();
}

int checkfunction() {
	for (it = func_record.begin(); it != func_record.end(); ++it) {
		if (!(*it).isdefined) {
            reporterrorline = false;
            char msg[160];
			sprintf (msg, "Function not defined: %s, %d parameters", (*it).name.c_str() , (*it).nvars);
            yyerror (msg);
		}
	}
	return 0;
}

#endif	
