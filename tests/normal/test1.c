// supported data types (int ,float ,char,bool,char[])
// in this example we can do any operation containing any of this three types (int, float ,bool)
// for temporary variables i didn't make them using a instructions that make variable because they will be removed in 
// when the real assembly code is  generated  (registers will be used ) so i only used them

int var2=7;
char ch='a';
float f=3.422;
int result1;
bool b1=true;

float result2;
/// expression contain only integers
result1=5+var2+7/3;
/// expression contain only floats
result2=5.3+f*9.3+7.8/3.9;
/// expression contain only characters
char result3=ch+'3';

/// expression boolean
bool b2 = ((4*4)<(5*7)) || (342<789);


