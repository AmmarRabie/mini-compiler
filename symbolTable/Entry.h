#include <iostream>
#include "../ast/ast.h"
#include <string>
using namespace std;

#ifndef ENTRY
#define ENTRY
class Entry{
    public:
    nodeType* value;
    int iValue;
    float fValue;
    bool bValue;
    string sValue;
    char cValue;
    int type;
    int cons_flag;
    Entry(nodeType* value,int type,int cons_flag=0);
    void setValue(nodeType* value);
};

#endif