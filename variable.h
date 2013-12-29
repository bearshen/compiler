#ifndef VARIABLE_H__
#define VARIABLE_H__
#include "errorconfig.h"
#include <map>
#include <string>
using namespace std;
char generate (_ast *ast);

bool _local = false;
int _offset = 0;
int _global_offset = 0;

class VarRecord{
public:
	bool local;
	string name;
	char type; // [i] integer, [c] char, [s] string pointer, [x] unknown, capital letters for array
	int offset;
	int dim[3];
	VarRecord(){
		offset = ERROR_ID_NOT_FOUND;
		type = 'x';
		dim[0] = dim[1] = dim[2] = 0;
	}
};

map<string,VarRecord> _globalVars = *(new map<string,VarRecord>());
map<string,VarRecord> _localVars = *(new map<string,VarRecord>());

void enterFunction(){
	_local = true;
	_localVars.clear();
	_global_offset = _offset;
	_offset = 0;
}

void exitFunction(){
	_local = false;
	_offset = _global_offset;
}

VarRecord* lookup(string name) {
	if(_local){
		if(_localVars.find(name) != _localVars.end()) return &(_localVars[name]);
	}
	if(_globalVars.find(name) != _globalVars.end()) return &(_globalVars[name]);
	return new VarRecord;
}


VarRecord* local_lookup(string name) {
	if(_local){
		if(_localVars.find(name) != _localVars.end()) return &(_localVars[name]);
	}
	return new VarRecord();
}

int declare(string name, _ast* a, int dim1, int dim2, int dim3, int offset) {
	char newtype = 'x';
	if(dim1 < 0 || dim2 < 0 || dim3 < 0) { yyerror ("bad array dimension"); return ERROR_BAD_ARRAY_DIMENSION; } 
	if (a == NULL && offset == 0) printf ("push 0\n");
	else if(a != NULL) newtype = generate(a);
	VarRecord* existingRecord;
	if (offset == 0) existingRecord = lookup(name);
	else existingRecord = local_lookup(name);
	if(existingRecord->offset == ERROR_ID_NOT_FOUND){
		VarRecord* newRecord = new VarRecord;
		newRecord->local = _local;
		newRecord->name = name;
		newRecord->type = newtype;
		if(offset==0){
			newRecord->offset = _offset;
			int length = 1;
			if(dim1>0) { (newRecord->dim)[0] = dim1; length *= dim1; }
			if(dim1>0 && dim2>0) { (newRecord->dim)[1] = dim2; length *= dim2; }
			if(dim1>0 && dim2>0 && dim3>0) { (newRecord->dim)[2] = dim3; length *= dim3; }
			if(length > 1){ // allocate more space
				printf("push sp\n");
				printf("push %d\n", length-1);
				printf("add\npop sp\n");
				_offset += length-1;
				newRecord->type = 'X';
			}
			_offset++;
		}
		else{
			newRecord->offset = offset;
			newRecord->type = 'i'; // parameter must be integer
		}
		if(_local) _localVars[name] = *newRecord;
		else _globalVars[name] = *newRecord;
		return 0;
	}
    char msg[180];
    sprintf (msg, "the identifier \'%s\' already exists.", name.c_str());
    yyerror(msg);
	return ERROR_ID_ALREADY_EXISTS;
}

int declare(string name, _ast* a) {
	return declare(name, a, 0, 0, 0, 0);
}

int declare(string name, int offset){
	return declare(name, NULL, 0, 0, 0, offset);
}

#endif
