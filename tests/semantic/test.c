// Test cases : to show semantics checks
// semantics checks implemented :
// 1- using of variable not defined 
// 2- redecleration of variables
// 3- variable used without not initialized
// 4- type checking (assign numeric value to string variable or expression contain string variable with numeric variables 


// after sematinc check occur we have stopped code compilation (generating of quadrables)

int var2=7;
char ch='a';
float f=3.422;
char ramy[]="hello";


float var;
float result;

// using of var not initialized
result = var*3;

// using of var not defined
result = notDefined *9;

// variable redeclaration
int result ;

// type mismatch (string with numeuc value)
result = 5 * ramy;
// type mismatch (char with numeric values)
result = 5*ch;
// type mismatch (boolean with numeric values)
result = 9/false;
// type mismtac whe trying to declare variable;
int mis = false;







