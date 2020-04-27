// test case  while statement
// symbol Table ----> tree of  symbol tables to handle differenct scopes
// z is used in the while statements because it was defined in the parent scope

float z=3;

while (z!=9)
{
    int xv=3+2;
    z=z+xv;
}

char afterWhile[]="While";