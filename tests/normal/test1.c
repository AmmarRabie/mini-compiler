// supported data types (int ,float ,char,bool,char[])
// in this example we can do any operation containing any of this three types (int, float) casting will happen.
// to handle complex expression result are stored in temps numiable (T0, T1, T2 .....).

////////////////////// definitions 
int num1=7;
char char2='a';
float num3=3.422;
bool bo4=true;

////////////////////// declarations
float num5;
int num6;
float num7;

//////////////////// simple assignments
num6=3;
num5=9.9;
/////
num6=num6-num1;  
num7=num5+num3;
//////
num6 = 3+num1;
num7= num5+6.3;
/////
num6=7+8;
/////
bo4=false || true;
bo4=bo4 && true;
bo4= num3<num7;
////



