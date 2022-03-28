%{
#include <stdio.h>
#include <string.h>
#include <malloc.h>
#include "sym_tab.h"
extern char *yytext;
#define YYPRINT(file, type, value)   yyprint (file, type, value)
#define YYERROR_VERBOSE
%}


%union
{
char *name;
}

%token IDENTIFIER
%token DEC_CONST

%token PLUS MINUS STAR DIV
%token EQUAL NEQUAL L_EQ_THAN G_EQ_THAN LT GT
%token PROGRAM DECLARE IF ELSE WHILE DOUBLEWHILE LOOP EXIT
%token FORCASE INCASE WHEN DEFAULT NOT END OR FUNCTION
%token PROCEDURE CALL RETURN IN INOUT INPUT PRINT
%token LPAREN RPAREN LSQUARE_BRACK RSQUARE_BRACK LBRACK RBRACK
%token SEMICOLON COMMA COLON
%token AND ASSIGN 

%start program
%%

program
		: PROGRAM identifier block
		;

identifier
		: IDENTIFIER
		;

block
        : LBRACK declarations subprograms sequence RBRACK
		;



declarations
        : DECLARE varlist SEMICOLON declerations_loop
		;
	
      

declerations_loop
		: declarations declerations_loop
		| // empty
        ;


varlist 
		: identifier varlist_loop
		;


varlist_loop
		: COMMA identifier varlist_loop
		| //empty
		;
	
subprograms
		: subprograms_loop
		;

subprograms_loop
		: func subprograms_loop
		| //empty
		;

func
 		: PROCEDURE identifier funcbody
		| FUNCTION identifier funcbody
		;

funcbody 
		: formalpars block
		;

formalpars
		: LPAREN RPAREN
		| LPAREN formalparlist RPAREN  
		;

formalparlist
		: formalparitem formalparlist_loop
		;

formalparlist_loop
		: COMMA formalparitem formalparlist_loop
		| //empty
		;

formalparitem
		: IN identifier
		| INOUT identifier
		;

brack_or_stat
		: brackets_seq 
		| statement
		;

brackets_seq 
		: LBRACK sequence RBRACK        
		;

sequence 
		: statement sequence_loop
		;

sequence_loop
		: SEMICOLON statement sequence_loop
		| //empty
		;

statement
        : assignment_stat 
		| if_stat
		| while_stat
		| double_while_stat
		| loop_stat
		| forcase_stat
		| incase_stat
		| exit_stat
		| return_stat
		| print_stat
		| input_stat
		| call_stat 
		| //empty
		;

assignment_stat
		: identifier ASSIGN expression
		;
	
if_stat		
		: IF LPAREN condition RPAREN brack_or_stat elsepart	 
		;
		

elsepart
		: ELSE brack_or_stat
		| //empty
		;

while_stat
         : WHILE LPAREN condition RPAREN brack_or_stat
         ;

double_while_stat
		 : DOUBLEWHILE LPAREN condition RPAREN brack_or_stat ELSE brack_or_stat
         ;

loop_stat
		 : LOOP brack_or_stat
         ;

forcase_stat
		 : FORCASE when_loop DEFAULT COLON brack_or_stat
         ;

incase_stat
         : INCASE  when_loop 
         ;
  
when_loop
		: when_stat when_loop
		| //empty
        ;

when_stat 		
		: WHEN COLON LPAREN condition RPAREN COLON brack_or_stat
		;

exit_stat
		: EXIT
		;

return_stat
		: RETURN LPAREN expression RPAREN
		;

print_stat
		: PRINT LPAREN expression RPAREN
		;

input_stat		
        : INPUT LPAREN identifier RPAREN
		;

call_stat
		: CALL identifier actualpars
		;

actualpars 
		: LPAREN  RPAREN
		| LPAREN actualparlist RPAREN 
		;

actualparlist
		: actualparitem actualparlist_loop
		;

actualparlist_loop	
		: COMMA actualparitem actualparlist_loop
		| //empty
		;

actualparitem		
		: IN expression
		| INOUT identifier
		;

condition
		: boolterm condition_loop
		;

condition_loop		
		: OR boolterm 
		| //empty
		;    

boolterm		
		: boolfactor  boolterm_loop
		;

boolterm_loop	
		: AND boolfactor boolterm_loop
		| //empty
		;   

boolfactor		
		: NOT LSQUARE_BRACK condition RSQUARE_BRACK
		| LSQUARE_BRACK condition RSQUARE_BRACK
		| expression relational_oper expression
		;

expression 		
		: optional_sign term expression_loop		
		;

expression_loop	
		: add_oper term expression_loop		
		| //empty
		;

term		
		: factor term_loop
		;
				
term_loop	
		: mul_oper factor term_loop
		| //empty
		;	

factor		
		: DEC_CONST
		| LPAREN expression RPAREN		
		| identifier idtail
		;
		
idtail
		: actualpars
		| //empty
		;

relational_oper
        : EQUAL
        | LT
        | L_EQ_THAN
        | NEQUAL
        | G_EQ_THAN
        | GT
        ;

add_oper
        : PLUS
        | MINUS
        ;

mul_oper
        : STAR
        | DIV
        ;

optional_sign 
        : add_oper
		| //empty
		;

%%

extern int column;
extern void yyrestart( FILE *input_file );
extern FILE *new_file;
int yydebug;

int main(int argc, char *argv[]){
	if (argc!=2) printf("\nUsage: ph_2 <input file name> \n");
	else
		if ((new_file=fopen(argv[1],"r"))==NULL) 
			printf("\n<%s> not found.\n",argv[1]);
		else 
			{
				yyrestart(new_file); 
				return yyparse();
				fclose(new_file);
			}

symbol_table newst;
newst=create_st();
yydebug=1;
return yyparse();

}


int yyerror(s)
char *s;
{
        fflush(stdout);
        printf("\n%*s\n%*s\n", column, "^", column, s);
		return 1;
}

static int
yyprint (file, type, value)
     FILE *file;
     int type;
     YYSTYPE value;
{
  if (type == IDENTIFIER)
    fprintf (stderr," = %s", value.name);
  return 1;
}

