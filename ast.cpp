#include "ast.h"
#include "y.tab.h"
#include <fstream>
#include <sstream>
#include <iterator>
#include <iomanip>
#include <algorithm>




using namespace std;

#define SIZEOF_NODETYPE ((char *)&p->con - (char *)p)
nodeType *floatt(float value) {
    nodeType *p;
    /* allocate node */
    if ((p =( nodeType *) malloc(sizeof(nodeType))) == NULL)
    cout<<"out of memory"<<endl;
    /* copy information */
    p->type = typeFloat;
    p->floatt.value = value;
    return p;
}
nodeType *intt(int value) {
    nodeType *p;
    /* allocate node */
    if ((p =( nodeType *) malloc(sizeof(nodeType))) == NULL)
    cout<<"out of memory"<<endl;
    /* copy information */
    p->type = typeInt;
    p->intt.value = value;
    return p;
}
nodeType *bo(bool value) {
    nodeType *p;
    /* allocate node */
    if ((p =( nodeType *) malloc(sizeof(nodeType))) == NULL)
    cout<<"out of memory"<<endl;
    /* copy information */
    p->type = typeBool;
    p->bo.value = value;
    return p;
}

nodeType *charr(char value) {
    nodeType *p;
    /* allocate node */
    if ((p =( nodeType *) malloc(sizeof(nodeType))) == NULL)
    cout<<"out of memory"<<endl;
    /* copy information */
    p->type = typeChar;
    p->charr.value = value;
    return p;
}


nodeType *strr(char * value)
{
    nodeType *p;
    /* allocate node */
    if ((p =( nodeType *) malloc(sizeof(nodeType))) == NULL)
        cout<<"out of memory"<<endl;
    /* copy information */
    p->type = typeString;
    p->str.value = value;
    return p;
}

nodeType *id(char* i) {
 nodeType *p;
 /* allocate node */
 if ((p = ( nodeType *)malloc(sizeof(nodeType))) == NULL)
 cout<<"out of memory"<<endl;

 /* copy information */
 p->type = typeId;

 p->id.i = i;


 return p;
}

nodeType *ty(int t) {
 nodeType *p;
 /* allocate node */
 if ((p = ( nodeType *)malloc(sizeof(nodeType))) == NULL)
 cout<<"out of memory"<<endl;
 /* copy information */
 p->type = typeType;
 p->ty.t = t;
 return p;
}

nodeType *opr(int oper, int nops, ...) {
 va_list ap;
 nodeType *p;
 int i;
 /* allocate node, extending op array */
 if ((p = ( nodeType *)malloc(sizeof(nodeType) +
 (nops-1) * sizeof(nodeType *))) == NULL)
 cout<<"out of memory"<<endl;
 /* copy information */
 p->type = typeOpr;
 p->opr.oper = oper;
 p->opr.nops = nops;
 va_start(ap, nops);
 for (i = 0; i < nops; i++)
 p->opr.op[i] = va_arg(ap, nodeType*);
 va_end(ap);
 

 return p;
}
void freeNode(nodeType *p) {
 int i;
 if (!p) return;
 if (p->type == typeOpr) {
 for (i = 0; i < p->opr.nops; i++)
 freeNode(p->opr.op[i]);
 }
 free (p);
}

string get_type_name(int type)
{
  switch(type)
  {
    case T_INT : return "integer";
    case T_FLOAT : return "float";
    case T_CHR : return "char";
    case T_CHR*100 : return "char[]";
    case T_BOOL: return "bool";
    default :
    return "NOT definded";
  }
}


string nameToOper(int num)
{
    switch(num)
    {
        case '=' :
        case T_INT: 
        case T_FLOAT: 
        case T_CHR*100:
        case T_BOOL:
        case T_CHR : return "MOV";
        case '+' : return "ADD";
        case '*' : return "MUL";
        case '/' : return "DIV";
        case '<' : return "LT";
        case '>' : return "GT";
        case '-' : return "SUB";
        case LEQ : return "LEQ";
        case GEQ : return "GEQ";
        case NEQ : return "NEQ";
        case EQQ : return "EQQ";
        case OR : return "OR";
        case AND : return "AND";
        case UMINUS: return "NEG";


        default :
        return "Not implemented";
    }
}

void printQuad(int op,string src1, string src2,string des,ofstream& output)
{
    output <<nameToOper(op)<<"  "<<src1<<"  "<<src2<<"  " <<des<<endl;
}

string ex(nodeType *p,char * outputFile) {
 string v;
 ofstream output;
 output.open(outputFile,ios::out | ios::app);
 
 if (!p) return v;
 switch(p->type)
  {
    case typeFloat: 
        return to_string(p->floatt.value);
   case typeInt: 
        return to_string(p->intt.value);
   case typeChar: 
        return to_string(p->charr.value);
   case typeBool: 
        return to_string(p->bo.value); 
    case typeString: 
        {
        ostringstream result;
        string value=p->str.value;

        result << std::setw(2) << std::setfill('0') << std::hex << std::uppercase;
        std::copy(value.begin(), value.end(), std::ostream_iterator<unsigned int>(result, ""));
        return "0x"+result.str();
        }  
    case typeId: 
        {
        string s=p->id.i;
        return s;
        }
    case typeOpr :
        switch (p->opr.oper)
        {
            case 60*100:
            {
                ex(p->opr.op[0],outputFile);
                ex(p->opr.op[1],outputFile);
            }
            break;
            case 52*100:
            {
            
            string lable=ex(p->opr.op[1],outputFile);
            output<<lable<<" :"<<endl;
            ex(p->opr.op[0],outputFile);
            return lable;
            break;
            }
            case IF :
            {
                string labelFalse=ex(p->opr.op[2],outputFile);
                string temp=ex(p->opr.op[0],outputFile);

                output << "IF NOT  "<<temp << " GOTO " << labelFalse<<endl;
                ex(p->opr.op[1],outputFile);
                output<<labelFalse<<" :"<<endl;
            }
                break;
            case WHILE :
            {
                string labelFalse=ex(p->opr.op[2],outputFile);
                string temp=ex(p->opr.op[0],outputFile);

                output << "IF NOT  "<<temp << " GOTO " << labelFalse<<endl;
                string labelTrue=ex(p->opr.op[1],outputFile);
                temp=ex(p->opr.op[0],outputFile);
                output << "IF  " << temp << " GOTO  "<<labelTrue<<endl;
                output<<labelFalse<<" :"<<endl;
            }
                break;
            
            case T_CHR*100:
                if(p->opr.nops == 2)
                {
                string result= ex(p->opr.op[1],outputFile);
                printQuad(p->opr.oper,result,"",p->opr.op[0]->id.i,output);
                }
                break;
            case T_FLOAT:
            case T_CHR:
            case T_BOOL:
            case T_INT : 
                if(p->opr.nops == 2)
                {
                string result= ex(p->opr.op[1],outputFile);
                printQuad(p->opr.oper,result,"",p->opr.op[0]->id.i,output);
                }
                else
                {
                //string result="0";
                //printQuad(p->opr.oper,result,"",p->opr.op[0]->id.i,output);
                }
                break;

            case '=':
                {
                string result= ex(p->opr.op[1],outputFile);
                printQuad(p->opr.oper,result,"",p->opr.op[0]->id.i,output);
                break;
                }
           
            case TEMP :  
                if(p->opr.nops == 2)
                {
                string result= ex(p->opr.op[1],outputFile);
                output<<result<<"  "<<p->opr.op[0]->id.i<<endl;
                }
                v=p->opr.op[0]->id.i;
                return v;
                break;
            case LEQ :
            case GEQ :
            case NEQ :
            case EQQ :
            case OR  :
            case AND :
            case '+' :
            case '*' :
            case '/' :
            case '<' :
            case '-' :
            case '>' :
                {        
                string v1=ex(p->opr.op[0],outputFile);
                string v2=ex(p->opr.op[1],outputFile);
                string s;
                s=nameToOper(p->opr.oper);
                return  s+"  "+v1+"  "+v2;
                }
            case UMINUS:
                {
                   
                    {                    
                    string v1=ex(p->opr.op[0],outputFile);
                    string s;
                    s=nameToOper(p->opr.oper);
                    return s+"  "+v1;
                    }
                                      
                }
  
        }

  }
      
 return v;
}



char *mystrdup( char *c)
{
    char *dup =(char*) malloc(strlen(c) + 1);

    if (dup != NULL)
       strcpy(dup, c);

    return dup;
}