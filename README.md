# mini-compiler
mini compiler for c-like language using flex and bison
# C Compiler
I found an [old grammer](https://www.lysator.liu.se/c/ANSI-C-grammar-y.html) and [lexer](https://www.lysator.liu.se/c/ANSI-C-grammar-l.html) of c. :)
# Run
## dependencies
- [flex and bison](https://sourceforge.net/projects/winflexbison/)
- [gcc](https://sourceforge.net/projects/tdm-gcc/), you may use other compilers but don't forget to change it in the make file
<br>All dependencies is also on drive where project documet located
## install and run
run `make` or `make all` from root directory, you will find result.exe file that is your compiler. you can compile and run quickly with `make run`

# Debug
To run in the debug mode, you have to recompile. so run
```
> make remove
> make debug
```
after you have done. don't forget to run remove again
```
> make remove
```
