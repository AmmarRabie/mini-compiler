#include "SymanticAnalyzer.h"


SymanticAnalyzer::SymanticAnalyzer(SymbolTableTree * sym,int * lineNumber)
{
    this->sym=sym;
    this->lineNumber=lineNumber;
}
nodeType * SymanticAnalyzer::varAss(char* index,nodeType* value)
{
    Entry* en = sym->find_symbol(index);
    nodeType * r;
    if (en==NULL)
    { 
        // semantics error
        cout <<" line :"<< *lineNumber<<" : semntic error, variable "<<index<<" not defined" <<endl;
        // we need stop here code generation and only
        // complete the anaysic
        // on the value stack i have but no operation node;
        r= opr(-1, 0);
    }
    else
    {
        en->value=value;
        sym->printTable();
        r= opr('=', 2, id(index), value); 
    }
    return r;
}


nodeType * SymanticAnalyzer::varDec(char* index,nodeType* value,int type)
{
    Entry* en = sym->find_symbol(index);
    nodeType * r;
    if (en==NULL)
    { 
        sym->add_symbol(index,value,type);
        sym->printTable();
        if (value!=NULL)
        {
            r= opr(type, 2, id(index),value);
        }
        else
        {
            r= opr(type, 1, id(index));
        }    
    }
    else
    {
        // semantics error
        cout <<" line :"<< *lineNumber<<" : semntic error, variable "<<index<<" Redeclared" <<endl;
        // we need stop here code generation and only
        // complete the anaysic
        // on the value stack i have but no operation node;
        r= opr(-1, 0); 
    }
    return r;
}



nodeType * SymanticAnalyzer::varInEx(char* index)
{
    Entry* en = sym->find_symbol(index);
    nodeType * r;
    if (en==NULL)
    { 
        // semantics error
        cout <<" line :"<< *lineNumber<<" : semntic error, variable "<<index<<" not defined" <<endl;
        r= opr(-1, 0);
    }
    else
    {
        if (en->value==NULL)
        {
        // semantics error
        cout <<" line :"<< *lineNumber<<" : semntic error, variable "<<index<<" not initilized " <<endl;
        r= opr(-1, 0);
        }
        else
        {
          r = id(index); 
        }
    }
    return r;
}





