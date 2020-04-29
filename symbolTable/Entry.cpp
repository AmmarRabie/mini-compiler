#include "Entry.h"
#include "../y.tab.h"
Entry::Entry(nodeType* value,int type,int cons_flag)
{
    this->value=value;

    if (value != NULL)
    {
        switch (type)
        {
        case T_INT: this->iValue=value->opr.iValue; break;
        case T_FLOAT: this->fValue=value->opr.fValue; break;
        case T_CHR: this->cValue=value->opr.cValue; break;
        case T_BOOL: this->bValue=value->opr.bValue; break;
        case T_CHR*100: this->sValue=value->opr.sValue; break;
        }
    }



    this->type=type;
    this->cons_flag=cons_flag;
}


void Entry::setValue(nodeType* value)
{
    this->value=value;

    if (value != NULL)
    {
        switch (type)
        {
        case T_INT: this->iValue=value->opr.iValue; break;
        case T_FLOAT: this->fValue=value->opr.fValue; break;
        case T_CHR: this->cValue=value->opr.cValue; break;
        case T_BOOL: this->bValue=value->opr.bValue; break;
        case T_CHR*100: this->sValue=value->opr.sValue; break;
        }
    }


}
