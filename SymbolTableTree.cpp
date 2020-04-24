#include "SymbolTableTree.h"
using namespace std;


SymbolTableTree::SymbolTableTree(SymbolTableTree * parent,string index):table(index)
{
    this->parent=parent;
    this->temp_count=0;
    this->label_count=0;
}

SymbolTableTree* SymbolTableTree::enter_scope(string index)
{

    SymbolTableTree * nScope = new SymbolTableTree(this,index);
    this->childrens.push_back(nScope);

    cout<<"Symbol Table created with index '"<<nScope->table.get_table_index()<<"'"<<endl;

    return nScope;
    
}
Entry*  SymbolTableTree::find_symbol(string index)
{
  SymbolTableTree * c=this;
  while(c!=NULL)
  {
      Entry* en=c->table.find_symbol(index);
      if (en!=NULL)
      {
          return en;
      }
      c=c->parent;
  }
  return NULL;
}
void SymbolTableTree::add_symbol(string index,nodeType* value,int type,int cons_flag)
{
    this->table.add_symbol(index,value,type,cons_flag);
}
bool SymbolTableTree::check_scope(string index)
{
    if ( this->table.find_symbol(index)!=NULL)
    {
          return true;
    }
    return false;
}
SymbolTableTree* SymbolTableTree::exit_scope()
{

    return this->parent;
}


string SymbolTableTree::get_table_index()
{
    return this->table.get_table_index();
}


 SymbolTableTree::~SymbolTableTree()
{

    for (int i=0;i<this->childrens.size();i++)
    {
        delete this->childrens[i];
    }
}


void SymbolTableTree::printTable()
{
    cout<<"##################"<<endl;
    if (this->parent !=NULL)
    {
        cout << "parent scope is "<<this->parent->get_table_index()<<endl;
    }
    cout <<"current scope is "<< this->get_table_index()<<endl;

    cout<<"children scopes  are :"<<endl;

    for (int i=0;i<this->childrens.size();i++)
    {
        cout<< this->childrens[i]->get_table_index()<<endl;
    }
    cout<<"Table :"<<endl;
    this->table.printTable();
    cout<<"##################"<<endl;
}


string SymbolTableTree::createTemp(nodeType *value)
{
    string index= "T"+to_string(this->temp_count++);

    this->add_symbol(index,value,-1,0);
    return index;
}

string SymbolTableTree::createLabel(){

    string index= "Label"+to_string(this->label_count++);
    return index;
}


