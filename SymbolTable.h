#include <vector>
#include <string>
#include <unordered_map> 
#include "Entry.h"

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
    bool add_symbol(string index,float numeric_value,int type);
    void printTable();
    ~SymbolTable();
};