// test case  for ( nested if)
// symbol Table ----> tree of  symbol tables to handle differenct scopes
// in the example :::::::
///  y is accessed correctly in the second if because it is defined the parent scope 

int z=3;

if (z<5)
{
    int y=3;
    if (z<2.5)
    {
        y=100;
    }

    bool endIf2=true;
}
bool endIf1=true;