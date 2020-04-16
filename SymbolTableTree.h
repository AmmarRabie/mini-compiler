#include "SymbolTable.h"

using namespace std;

#ifndef SYMBOL_TABLE_TREE
#define SYMBOL_TABLE_TREE
class SymbolTableTree
{
 private:
 SymbolTableTree * parent;
 vector<SymbolTableTree *> childrens;
 SymbolTable table;
 
 public:
 string get_table_index();
 SymbolTableTree(SymbolTableTree * parent,string index);
 SymbolTableTree* enter_scope(string scopeindex);
 Entry* find_symbol(string index);
 void add_symbol(string index,nodeType * value,int type,int cons_flag=0);
 bool check_scope(string index);
 SymbolTableTree* exit_scope();
 void printTable();
 ~SymbolTableTree();


};



#endif