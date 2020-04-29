/// if staements + handling of scope information in symbol table
/// xyz is redefined in the if statements but there is no error  because it was in a different scope
// y is used inside if statements because it was already defined in the parent scope (global)
int xyz=3;
xyz=3*7;
float y=2.3;
if (1<3) 
{
    float xyz=y*200.0;
}

int x=3;



