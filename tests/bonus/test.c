/// if staements + handling of scope information in symbol table
/// xyz is redefined in the if statements but there is no error it was in different scope
// y is used inside if statements because it was already defined in the parent scope (global)
int xyz=3;
xyz=3*7;
float y=2;
if (1<3) 
{
    float xyz=y*200;
}

int x=3;



