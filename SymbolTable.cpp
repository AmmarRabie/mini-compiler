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
     for (auto& it: this->table)
      {
       string type =get_type_name(it.second->type);
       string initialized;
       if (it.second->value==NULL)
       {
         initialized=" Not Initialized";
       }
       else
       {
         initialized=" Initialized";
       }
       if (it.first[0]!='T')
      cout<< "index = "<<it.first<<" : value = "<<initialized<<" : type = "<<type<<endl;
  } 
}


