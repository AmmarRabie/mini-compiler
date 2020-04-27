#include <cstdlib>
#include <string>
#include<stdarg.h>
#include <stdio.h>
#include <string.h>
#include <iostream>
using namespace std;

#ifndef AST
#define AST

using namespace std;
                //constant  //identifier // operation //TypeDefinition //string value
typedef enum { typeInt,typeFloat,typeChar, typeId, typeOpr ,typeType, typeString,typeBool} nodeEnum;
/* constants */
 struct intNodeType {
    int value; /* value of constant */
} ;

struct boolNodeType {
    bool value; /* value of constant */
} ;

 struct floatNodeType {
    float value; /* value of constant */
} ;

 struct charNodeType {
    char value; /* value of constant */
} ;


 struct strNodeType {
    char * value; /* value of string */
} ;
/* identifiers */
 struct idNodeType {
 char * i; 
} ;

/* type */
typedef struct {
 int t; /* subscript to sym array */
} typeNodeType;
/* operators */
typedef struct {
 int oper; /* operator */
 int nops; /* number of operands */
 int expression_type;
 struct nodeType *op[1]; /* operands, extended at runtime */
} oprNodeType;

 struct nodeType {
 nodeEnum type; /* type of node */
 union {
 intNodeType intt;
 floatNodeType floatt;
 charNodeType charr;
 idNodeType id; /* identifiers */
 oprNodeType opr; /* operators */
 typeNodeType ty ; /*type*/
 strNodeType str; /*string value*/
 boolNodeType bo; /* boolean value */
 };
};



/* prototypes */

nodeType *opr(int oper, int nops, ...);
nodeType *id(char* i);
nodeType *floatt(float value);
nodeType *intt(int value);
nodeType *charr(char value);

nodeType *strr(char * value);
nodeType *ty(int t);
nodeType *bo(bool value);


void freeNode(nodeType *p);
string ex(nodeType *p,char * file);

string get_type_name(int type);

#endif
char *mystrdup( char *c);