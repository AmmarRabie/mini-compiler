// test case  while statement
// symbol Table ----> tree of  symbol tables to handle differenct scopes
// z is used in the while statements because it was defined in the parent scope

float z=3.0;

while (z!=9)
{
    int xv=3+2;
    z=9.0;
}

char afterWhile[]="While";