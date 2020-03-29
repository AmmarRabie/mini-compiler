# auto detect for output extension
RES_EXT = exe
ifneq ($(OS), Windows_NT)
	RES_EXT = out
endif
# utils used
YACC = bison
LEX = flex
CC = gcc
CLINKER = $(CC) -o 
# args for utils
YACCARGS = --yacc -d -t -Wall -v -ginfo/Graph.dot
FLEXARGS = 
CFLAGS = 
CLINKFLAGS = 
# objs needed to link the final result
OBJS = y.tab.o lex.yy.o

# high level commands
## default command => generate result file
all: result.$(RES_EXT)

## generates the result file and run it
run: result.$(RES_EXT)
	result.$(RES_EXT)

test debug: result.$(RES_EXT)
	result.$(RES_EXT)

# linking the objs files
result.$(RES_EXT): $(OBJS)
	$(CLINKER) result.$(RES_EXT) $(CLINKFLAGS) $(OBJS)

# bison
y.tab.c y.tab.h: grammer.y
	$(YACC) grammer.y $(YACCARGS)

# flex
lex.yy.c: lex.l y.tab.h
	$(LEX) lex.l $(FLEXARGS)

# remove everything
remove:
	make clean
	rm *.$(RES_EXT)

# clean the project => remove everything except .$(RES_EXT)
clean:
	rm *.o y.output ./info/* y.tab.c y.tab.h lex.yy.c

# target-specific variable value
test: CFLAGS += -DTEST
debug: CFLAGS += -DDEBUG # this will not work unless you force cmake or remove before run
.PHONY: clean