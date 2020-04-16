#include "SymbolTable.h"

using namespace std;

SymbolTable::SymbolTable(string index)
{
  this->index=index;
}

Entry* SymbolTable::find_symbol(string index) {

  if  (   table.find(index) != table.end()  )
  {
      return table[index];
  }
  else
  {
      return NULL;
  }
  
}

bool SymbolTable::add_symbol(string index,nodeType* value,int type,int cons_flag) {

  Entry*  en=new Entry(value,type,cons_flag);
  this->table[index]=en;
  return true;
}

string SymbolTable::get_table_index()
{
  return this->index;
}

SymbolTable::~SymbolTable()
{
  for (auto& it: this->table) {
      delete it.second;
  }
}

void SymbolTable::printTable()
{
     for (auto& it: this->table) {
      cout<< "index = "<<it.first<<" : value = "<<it.second->value<<" : type = "<<it.second->type<<endl;
  } 
}


