// supported data types (int ,float ,char,bool,char[])
// in this example we can do any operation containing any of this three types (int, float) casting will happen.
// to handle complex expression result are stored in temps variable (T0, T1, T2 .....).

////////////////////// definitions 
int var2=7;
char ch='a';
float f=3.422;
bool b1=true;
char ramy[]="ramy";

////////////////////// declarations
float result2;
int result1;
float result3;

////////////////// complex expressions

/// expression contain only integers
result1=var2+var2-var2*7/3;
/// expression contain only floats
result2=(5.3+f*9.3)+7.8/3.9;
/// expression contain only characters
char result4=ch+'3';
/// expression boolean
bool b2 = ((4*4)<(5*7)) || (342<789);


