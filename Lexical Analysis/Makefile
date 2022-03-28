CC = gcc
CCFLAGS = -I.
LEX = flex

#Target File

build: minimal++

minimal++: lex.yy.c
	$(CC) -o output lex.yy.c $(CCFLAGS)
	
lex.yy.c: minimal++.l
	$(LEX) minimal++.l
	

clean:
	rm output lex.yy.c defines.h sym_hashing.h