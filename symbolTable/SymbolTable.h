#include <vector>
#include <unordered_map> 
#include "Entry.h"
#include "../y.tab.h"


using namespace std;


class SymbolTable
{

    private:
    std::unordered_map< string, Entry*> table; 
    string index;
    public:
    string get_table_index();
    SymbolTable(string index);
    Entry* find_symbol(string index);
    bool add_symbol(string index,nodeType* value,int type,int cons_flag=0);
    void printTable();
    ~SymbolTable();
};