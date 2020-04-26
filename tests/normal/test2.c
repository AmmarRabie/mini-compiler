// in this example we can do any operation containing any of this three types (int, float ,char)
// for temporary variables i didn't make them using a instructions that make variable because they will be removed in 
// when the real assembly code is  generated  (registers will be used ) so i only used them

// bonus -----> handling of complex expression

int var2=7;
char ch='a';
float f=3.422;

int test3=3431;
float result;

/// mixed expression contain  (int ,float ) casting will happen and will succed
result = (3+7)+ var2*3.3/f + test3 ; 




