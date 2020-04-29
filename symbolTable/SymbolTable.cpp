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
       if (it.first[0]=='T') continue;
       switch(it.second->type)
       {
         case T_INT: 
          if (it.second->value == NULL)
          {
              cout<< "index = "<<it.first<<" : value = "<<" Not initialized "<<" : type = "<<type<<endl;
          }
          else
          {
              cout<< "index = "<<it.first<<" : value = "<<it.second->iValue<<" : type = "<<type<<endl;
          }        
          break;
         case T_FLOAT: 
          if (it.second->value == NULL)
          {
              cout<< "index = "<<it.first<<" : value = "<<" Not initialized "<<" : type = "<<type<<endl;
          }
          else
          {
              cout<< "index = "<<it.first<<" : value = "<<it.second->fValue<<" : type = "<<type<<endl;
          }        
          break;
         case T_BOOL: 
          if (it.second->value == NULL)
          {
              cout<< "index = "<<it.first<<" : value = "<<" Not initialized "<<" : type = "<<type<<endl;
          }
          else
          {
              cout<< "index = "<<it.first<<" : value = "<<it.second->bValue<<" : type = "<<type<<endl;
          }        
          break;
         case T_CHR: 
          if (it.second->value == NULL)
          {
              cout<< "index = "<<it.first<<" : value = "<<" Not initialized "<<" : type = "<<type<<endl;
          }
          else
          {
              cout<< "index = "<<it.first<<" : value = "<<it.second->cValue<<" : type = "<<type<<endl;
          }        
          break;
         case T_CHR*100: 
          if (it.second->value == NULL)
          {
              cout<< "index = "<<it.first<<" : value = "<<" Not initialized "<<" : type = "<<type<<endl;
          }
          else
          {
              cout<< "index = "<<it.first<<" : value = "<<it.second->sValue<<" : type = "<<type<<endl;
          }        
          break;
          }
  } 
}


