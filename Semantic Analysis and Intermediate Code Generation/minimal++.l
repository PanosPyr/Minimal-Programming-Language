%{
#include <stdio.h>
#include <stdlib.h> 
#include <malloc.h> 
#include <string.h>
#include "gener.h"
#include "sym_tab.h"
#include "int_code.h"
#include "y.tab.h"
FILE *new_file;
int column=0;
int line=1;
void count();
void multi_line_comment();
void one_line_comment();

%}

L						[A-Za-z]
D 						[0-9]
N						[1-9]
C						|"!"|"@"|"#"|"$"|"%"|"^"|"&"|"_"|"-"

identifier				{L}({L}|{D})*      
dec_const				0|{N}{D}*                                 
other					[ \t\r]+

%%

"program"				{count(); return(PROGRAM);}

"declare"				{count(); return(DECLARE);}

"if"					{count(); return(IF);}

"else"					{count(); return(ELSE);}

"while"					{count(); return(WHILE);}

"doublewhile"				{count(); return(DOUBLEWHILE);}

"loop"					{count(); return(LOOP);}

"exit"					{count(); return(EXIT);}

"forcase"				{count(); return(FORCASE);}

"incase"				{count(); return(INCASE);}

"when"					{count(); return(WHEN);}

"default"				{count(); return(DEFAULT);}

"not"					{count(); return(NOT);}

"and"					{count(); return(AND);}

"or"					{count(); return(OR);}

"function"				{count(); return(FUNCTION);}

"procedure"				{count(); return(PROCEDURE);}

"call"					{count(); return(CALL);}

"return"				{count(); return(RETURN);}

"in"					{count(); return(IN);}

"inout"					{count();  return(INOUT);}

"input"					{count(); return(INPUT);}

"print"					{count(); return(PRINT);}


"+"						{count(); return(PLUS);}

"-"						{count(); return(MINUS);}

"*"						{count(); return(STAR);}

"/"						{count(); return(DIV);}

"<"						{count(); return(LT);}

">"						{count(); return(GT);}

"="	                    {count(); return(EQUAL);}

"<="					{count(); return(L_EQ_THAN);}

">="					{count(); return(G_EQ_THAN);}

"<>"					{count(); return(NEQUAL);}

":="					{count(); return(ASSIGN);}

"("						{count(); return(LPAREN);}

")"						{count(); return(RPAREN);}

"["						{count(); return(LSQUARE_BRACK);}

"]"						{count(); return(RSQUARE_BRACK);}

"{"						{count(); return(LBRACK);}

"}"						{count(); return(RBRACK);}

";"						{count(); return(SEMICOLON);}

","						{count(); return(COMMA);}

":"						{count(); return(COLON);}

"//"					{one_line_comment();}

"/*"					{multi_line_comment();}


{other}					{count();}



{identifier}            { count(); char *yycopy=strdup(yytext);
                            if(strlen(yycopy)>30){
						        printf("identifier %s in line %d not valid(longer than 30 characters)\n",yycopy,line);
						    } else {
								printf("found identifier %s in line %d\n",yycopy,line);
                                return(IDENTIFIER);
                            }
                        }

{dec_const}             { count(); char *yycopy=strdup(yytext);   
							int yyparsed = atoi(yycopy);
                            if ((yyparsed < -65535) || (yyparsed > 65535)) {
                                printf("Found %d which cant be accepted as a number\n", yyparsed);
                                return;
                            } else {
								printf("found dec_const %s in line %d\n",yycopy,line);
                                return(DEC_CONST);
                            }
                        }


%%

 

int yywrap()
{
	return 1;
}

void count()
{
        int i;
        for(i=0;yytext[i]!='\0';i++)
        if(yytext[i]=='\n')
        {
                line++;
                column=0;
        }
        else if(yytext[i]=='\t')
                column += 8-(column % 8);
                else column++;
}

void multi_line_comment()
{
	char c, c1;
loop:
	while ((c = input()) != '*' && c != 0);
	if (c != 0 && (c1 = input()) != '/')
	{
		unput(c1);
		goto loop;
	}
	if (c==0) unput(c);
}


void one_line_comment()
{
  int c;
  while(c=input()!='\n')
  {
     
  }
  line++;
}