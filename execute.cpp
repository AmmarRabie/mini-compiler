#include "execute.h"
int excute_int(int operation,nodeType* ex1,nodeType* ex2,SymbolTableTree * sym)
{
        int value1;
        int value2;
        if (ex1->type==typeInt)
        {
                value1=ex1->intt.value;
        } 
        if (ex2->type==typeInt)
        {
                value2=ex2->intt.value;
        } 
        if (ex1->type==typeId)
        {
                Entry* e =sym->find_symbol(ex1->id.i);
                value1=e->iValue;
        } 
        if (ex2->type==typeId)
        {
                Entry* e =sym->find_symbol(ex2->id.i);
                value2=e->iValue;
        } 
       if (ex1->type==typeOpr)
        {
          char* identifier=ex1->opr.op[0]->id.i;
          Entry* e=sym->find_symbol(identifier);
          value1=e->iValue;
        }
        if (ex2->type==typeOpr)
        {
          char* identifier=ex2->opr.op[0]->id.i;
          Entry* e=sym->find_symbol(identifier);
          value2=e->iValue;
        }

        switch (operation)
        {
                case '+' : return value1 + value2;
                case '-' : return value1 - value2;
                case '*' : return value1 * value2;
                case '/' : return value1 / value2;
        }

        return 0;

}

float excute_float(int operation,nodeType* ex1,nodeType* ex2,SymbolTableTree * sym)
{
        float value1;
        float value2;
        if (ex1->type==typeFloat)
        {
                value1=ex1->floatt.value;
        } 
        if (ex2->type==typeFloat)
        {
                value2=ex2->floatt.value;
        } 
        if (ex1->type==typeId)
        {
                Entry* e =sym->find_symbol(ex1->id.i);
                value1=e->fValue;
        } 
        if (ex2->type==typeId)
        {
                Entry* e =sym->find_symbol(ex2->id.i);
                value2=e->fValue;
        } 
       if (ex1->type==typeOpr)
        {
          char* identifier=ex1->opr.op[0]->id.i;
          Entry* e=sym->find_symbol(identifier);
          value1=e->fValue;
        }
        if (ex2->type==typeOpr)
        {
          char* identifier=ex2->opr.op[0]->id.i;
          Entry* e=sym->find_symbol(identifier);
          value2=e->fValue;
        }

        switch (operation)
        {
                case '+' : return value1 + value2;
                case '-' : return value1 - value2;
                case '*' : return value1 * value2;
                case '/' : return value1 / value2;
        }

        return 0;

}

char excute_char(int operation,nodeType* ex1,nodeType* ex2,SymbolTableTree * sym)
{
        char value1;
        char value2;
        if (ex1->type==typeChar)
        {
                value1=ex1->charr.value;
        } 
        if (ex2->type==typeChar)
        {
                value2=ex2->charr.value;
        } 
        if (ex1->type==typeId)
        {
                Entry* e =sym->find_symbol(ex1->id.i);
                value1=e->cValue;
        } 
        if (ex2->type==typeId)
        {
                Entry* e =sym->find_symbol(ex2->id.i);
                value2=e->cValue;
        } 
       if (ex1->type==typeOpr)
        {
          char* identifier=ex1->opr.op[0]->id.i;
          Entry* e=sym->find_symbol(identifier);
          value1=e->cValue;
        }
        if (ex2->type==typeOpr)
        {
          char* identifier=ex2->opr.op[0]->id.i;
          Entry* e=sym->find_symbol(identifier);
          value2=e->cValue;
        }

        switch (operation)
        {
                case '+' : return value1 + value2;
                case '-' : return value1 - value2;
                case '*' : return value1 * value2;
                case '/' : return value1 / value2;
        }

        return 0;

}


bool excute_bool(int operation,nodeType* ex1,nodeType* ex2,SymbolTableTree * sym)
{
        bool value1;
        bool value2;
        if (ex1->type==typeBool)
        {
                value1=ex1->bo.value;
        } 
        if (ex2->type==typeBool)
        {
                value2=ex2->bo.value;
        } 
        if (ex1->type==typeId)
        {
                Entry* e =sym->find_symbol(ex1->id.i);
                value1=e->bValue;
        } 
        if (ex2->type==typeId)
        {
                Entry* e =sym->find_symbol(ex2->id.i);
                value2=e->bValue;
        } 
       if (ex1->type==typeOpr)
        {
          char* identifier=ex1->opr.op[0]->id.i;
          Entry* e=sym->find_symbol(identifier);
          value1=e->bValue;
        }
        if (ex2->type==typeOpr)
        {
          char* identifier=ex2->opr.op[0]->id.i;
          Entry* e=sym->find_symbol(identifier);
          value2=e->bValue;
        }

        switch (operation)
        {
                case AND : return value1 && value2;
                case OR : return value1 || value2;
                case EQQ : return value1 == value2;
                case NEQ : return value1 != value2;


        }

        return 0;

}

bool excute_comparesion(int operation,nodeType* ex1,nodeType* ex2,SymbolTableTree * sym)
{
        float value1;
        float value2;
        if (ex1->type==typeFloat)
        {
                value1=ex1->floatt.value;
        } 
        if (ex2->type==typeFloat)
        {
                value2=ex2->floatt.value;
        } 

        if (ex1->type==typeInt)
        {
                value1=ex1->intt.value;
        } 
        if (ex2->type==typeInt)
        {
                value2=ex2->intt.value;
        } 

        if (ex1->type==typeId)
        {
                Entry* e =sym->find_symbol(ex1->id.i);
                if (e->type==T_INT)
                {
                        value1=e->iValue;
                }    
                else
                {
                        value1=e->fValue;
                }
        } 
        if (ex2->type==typeId)
        {
                Entry* e =sym->find_symbol(ex2->id.i);
                if (e->type==T_INT)
                {
                        value2=e->iValue;
                }    
                else
                {
                        value2=e->fValue;
                }

        } 
       if (ex1->type==typeOpr)
        {
          char* identifier=ex1->opr.op[0]->id.i;
          Entry* e=sym->find_symbol(identifier);
          if (e->type==T_INT)
                {
                        value1=e->iValue;
                }    
                else
                {
                        value1=e->fValue;
                }
        }
        if (ex2->type==typeOpr)
        {
          char* identifier=ex2->opr.op[0]->id.i;
          Entry* e=sym->find_symbol(identifier);
          if (e->type==T_INT)
                {
                        value2=e->iValue;
                }    
                else
                {
                        value2=e->fValue;
                }
        }

        switch (operation)
        {
                case '<' : return value1 < value2;
                case '>' : return value1 > value2;
                case EQQ : return value1 == value2;
                case NEQ : return value1 != value2;
                case GEQ : return value1 >= value2;
                case LEQ : return value1 <= value2;
        }

        return 0;
}