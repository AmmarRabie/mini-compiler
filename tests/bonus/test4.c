// test case   do statement
// symbol Table ----> tree of  symbol tables to handle differenct scopes
// z is used in the while statements because it was defined in the parent scope

int z=3;

do {
    int xv=3+2;
    z=z+xv;
} while(z<3);

char afterWhile[]="While";