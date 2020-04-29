#include "ast/ast.h"
#include "symbolTable/SymbolTableTree.h"
int excute_int(int operation,nodeType* ex1,nodeType* ex2,SymbolTableTree * sym);
float excute_float(int operation,nodeType* ex1,nodeType* ex2,SymbolTableTree * sym);
char excute_char(int operation,nodeType* ex1,nodeType* ex2,SymbolTableTree * sym);
bool excute_bool(int operation,nodeType* ex1,nodeType* ex2,SymbolTableTree * sym);
bool excute_comparesion(int operation,nodeType* ex1,nodeType* ex2,SymbolTableTree * sym);



