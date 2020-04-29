#include "SymanticAnalyzer.h"

void SymanticAnalyzer::setSym(SymbolTableTree* sym)
{
    this->sym=sym;
}

SymanticAnalyzer::SymanticAnalyzer(SymbolTableTree * sym,int * lineNumber)
{
    this->sym=sym;
    this->lineNumber=lineNumber;
}
nodeType * SymanticAnalyzer::varAss(char* index,nodeType* value,bool syntax_error)
{
    if (syntax_error)
    {
        return opr(-1,0);
    }
    
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
        if (!(value->type==typeOpr && value->opr.oper==-1 ))
        {
            if (compareTwoTypes('=',en->type,get_Type(value))!=-1)
            {
            en->setValue(value);
            sym->printTable();
            r= opr('=', 2, id(index), value); 
            }
            else
            {
               cout <<" line :"<< *lineNumber<<" Type mismatch "<<get_type_name(en->type);
               cout<<" conflitcs with "<<get_type_name(get_Type(value))<<endl;
                r=opr(-1,0);
            }
        }
        else
        {
            r=opr(-1,0);
        }
        
    }
    return r;
}


nodeType * SymanticAnalyzer::varDec(char* index,nodeType* value,int type,bool syntax_error)
{
    if (syntax_error)
    {
        return opr(-1,0);
    }
    nodeType * r;
    if (!sym->check_scope(index))
    { 
        if (value==NULL)
        {
            r= opr(type, 1, id(index));
            sym->add_symbol(index,value,type);
            sym->printTable();
        }
        else if (!(value->type==typeOpr && value->opr.oper==-1 ))
        {
            if (compareTwoTypes('=',type,get_Type(value))!=-1)
            {
                r= opr(type, 2, id(index),value);
                sym->add_symbol(index,value,type);
                sym->printTable();
            }
            else
            {
                cout <<" line :"<< *lineNumber<<" Type mismatch "<<get_type_name(type);
                cout<<" conflitcs with "<<get_type_name(get_Type(value))<<endl;
                r=opr(-1,0);
            }
            
        }
        else
        {
            r= opr(-1, 0); 
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

int  SymanticAnalyzer::get_Type(nodeType* v1)
{
    int type1;
    if (v1->type==typeFloat)
    {
        type1=T_FLOAT;
    }
    else if (v1->type==typeInt)
    {
        type1=T_INT;
    }
   else if (v1->type==typeBool)
    {
        type1=T_BOOL;
    }
    else if (v1->type==typeChar)
    {
        type1=T_CHR;
    }
    else if (v1->type==typeId)
    {
        Entry* e =sym->find_symbol(v1->id.i);
        type1=e->type;
    
    }
    else if (v1->type==typeOpr)
    {
        type1=v1->opr.expression_type;
    }
    else if (v1->type==typeString)
    {
        type1=T_CHR * 100;
    }
    return type1;

}

int  SymanticAnalyzer::compareTwoTypes(int operation ,int  type1,int type2)
{
    bool boolOp= (operation == '<') || (operation == '>') || (operation == LEQ) ;
    boolOp = boolOp ||  (operation == GEQ) ||  (operation == EQQ) || (operation == NEQ);

    if ((  (type1==T_INT || type1==T_FLOAT)&&(type2==T_INT || type2==T_FLOAT)  )&&(boolOp))
    {
        return T_BOOL;
    }
    
    if  (type1==type2)
    {
        return type1;
    }
    return -1;

}


 
int  SymanticAnalyzer::typeCheck(int operation,nodeType* v1,nodeType * v2)
{
    int type1=get_Type(v1);
    int type2=get_Type(v2);
   return compareTwoTypes(operation,type1,type2);
}




