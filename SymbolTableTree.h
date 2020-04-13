#include "SymbolTable.h"

using namespace std;


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
 void add_symbol(string index,float numeric_value,int type);
 bool check_scope(string index);
 SymbolTableTree* exit_scope();
 void printTable();
 ~SymbolTableTree();


};