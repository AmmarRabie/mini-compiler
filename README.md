# mini-compiler
mini compiler for c-like language using flex and bison
# Features 
1. Support 11 different operations
1. Support any type of nested expression (complex expression)
1. Five types
    * Int 
    * Float
    * Bool
    * Char
    * Strings (char []).
1. 4 semantic checks:
    * Well-informative messages.
    * Using  a variable not defined
    * Variable redeclaration
    * Type checking 
    * Using a variable not initialized.
1. Support (declarations and definitions statements).
1. Support if statements ( if-else not supported)
1. Support of while statements. 
1. Support scopes (if statement and while statement is different scope from the global).
1. Syntax errors handling 
    * More informative messages (like missing semicolumn)
    * If an error happens compiler discard token till the nearest semicolumn and continues syntax checking

## Getting Started
To have a version of the project use the command 
```
git clone https://github.com/AmmarRabie/mini-compiler.git
```

### Prerequisites

You nedd to install 
1. Flex 
2. Bison
3. C++ compiler (g++)



### Installing
- [flex and bison](https://sourceforge.net/projects/winflexbison/)
- [g++](https://sourceforge.net/projects/tdm-g++/), you may use other compilers but don't forget to change it in the make file
<br>All dependencies is also on drive where project documet located

run `make` or `make all` from root directory, you will find result.exe file that is your compiler. you can compile and run quickly with `make run`
or if you don't have make you can get the commands to run from `commands.txt`


