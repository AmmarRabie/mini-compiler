#include "SymbolTableTree.h"

class SymanticAnalyzer{
    private:
    SymbolTableTree * sym;
    int * lineNumber;
    public : 
    SymanticAnalyzer(SymbolTableTree * sym,int * lineNumber);
    nodeType * varNotDec(char* index ,nodeType* value);
    nodeType * varReDec(char* index,nodeType* value,int type);



};