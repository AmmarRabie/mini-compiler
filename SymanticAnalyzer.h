#include "SymbolTableTree.h"

class SymanticAnalyzer{
    private:
    SymbolTableTree * sym;
    int * lineNumber;
    public : 
    SymanticAnalyzer(SymbolTableTree * sym,int * lineNumber);
    nodeType * varAss(char* index ,nodeType* value);
    nodeType * varDec(char* index,nodeType* value,int type);
    nodeType * varInEx(char* index); // variable used in expression




};