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
                //constant  //identifier // operation //TypeDefinition
typedef enum { typeCon, typeId, typeOpr ,typeType} nodeEnum;
/* constants */
 struct conNodeType {
    double value; /* value of constant */
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
 struct nodeType *op[1]; /* operands, extended at runtime */
} oprNodeType;

 struct nodeType {
 nodeEnum type; /* type of node */
 union {
 conNodeType con; /* constants */
 idNodeType id; /* identifiers */
 oprNodeType opr; /* operators */
 typeNodeType ty ; /*type*/
 };
};



/* prototypes */

nodeType *opr(int oper, int nops, ...);
nodeType *id(char* i);
nodeType *con(int value);
nodeType *ty(int t);
void freeNode(nodeType *p);
string ex(nodeType *p);



#endif
char *mystrdup( char *c);