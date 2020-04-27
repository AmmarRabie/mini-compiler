#include <iostream>
#include "../ast/ast.h"
using namespace std;
class Entry{
    public:
    nodeType* value;
    int type;
    int cons_flag;
    Entry(nodeType* value,int type,int cons_flag=0);
};