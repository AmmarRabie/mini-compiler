#include "SymbolTableTree.h"
#include "y.tab.h"

class SymanticAnalyzer{
    private:
    SymbolTableTree * sym;
    int * lineNumber;
    int  compareTwoTypes(int operation ,int  type1,int type2);
    

    public : 
    SymanticAnalyzer(SymbolTableTree * sym,int * lineNumber);
    void setSym(SymbolTableTree* sym);
    nodeType * varAss(char* index ,nodeType* value,bool syntax_error = false);
    nodeType * varDec(char* index,nodeType* value,int type,bool syntax_error = false);
    nodeType * varInEx(char* index); // variable used in expression
    int  typeCheck(int operation,nodeType* v1,nodeType * v2);

    int  get_Type(nodeType* v1);



};