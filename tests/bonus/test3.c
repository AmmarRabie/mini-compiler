// test case  for ( nested if)
// symbol Table ----> tree of  symbol tables to handle differenct scopes
// in the example :::::::
///  y is accessed correctly in the second if because it is defined the parent scope 

int z=3;

while (z!=9)
{
    int z=1;
    int xv=3+2;
    z=z+xv;
    xv=-1;
}

char afterWhile[]="While";