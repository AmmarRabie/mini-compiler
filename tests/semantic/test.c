// Test cases : to show semantics checks
// semantics checks implemented :
// 1- using of variable not defined 
// 2- redecleration of variables
// 3- variable used without not initialized
// 4- type checking (assign numeric value to string variable or expression contain string variable with numeric variables )

int var2=7;
char ch='a';
float f=3.422;
char ramy[]="hello";


float var;
float result;

// type mismatch (string with numeuc value)
result = 5 * ramy;
// type mismatch (char with numeric values)
result = 5*ch;
// type mismatch (boolean with numeric values)
result = 9/false;
// type mismtac whe trying to declare variable;
float mis = false;


// using of var not initialized
result = var*3;

// using of var not defined
result = notDefined *9;

// variable redeclaration
int result ;









