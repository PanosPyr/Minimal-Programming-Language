//****************************************************************************
//*         This is a part of the Mini-(C)ompiler Source Code. 
//*         All rights reserved. 
//****************************************************************************
#include <stdio.h>
#include <malloc.h>
#include "sym_tab.h"
#include "fin_code.h"
#include "defs.h"

typedef struct stroffsetinfo
{
	int offset;
	char global;
}*offsetinfo;


int GetFormParamSize(entry func)
{
	if (func->kind.Proc.LastParam!=NULL){
		if (func->kind.Proc.LastParam->kind.ValueParam.typeDesc->type_specif==CHAR_TYPE)
			return -func->kind.Proc.LastParam->kind.ValueParam.offset+CHAR_SIZE-1;
		if (func->kind.Proc.LastParam->kind.ValueParam.typeDesc->type_specif==INT_SIZE)
			return -func->kind.Proc.LastParam->kind.ValueParam.offset+INT_SIZE-1;
		if (func->kind.Proc.LastParam->kind.ValueParam.typeDesc->type_specif==PTR_SIZE)
			return -func->kind.Proc.LastParam->kind.ValueParam.offset+PTR_SIZE-1;
	}
	else return 0;
}


offsetinfo GetOffset(entry argX)
{
	switch(argX->IDclass){
	case TEMP	  :	return NULL;
	case CONSTANT :	return NULL;
	case VARIABLE :	
					{
						offsetinfo offinfo=(offsetinfo)malloc(sizeof(struct stroffsetinfo));
						offinfo->global=argX->kind.Variable.global;
						offinfo->offset=argX->kind.Variable.offset;
						return offinfo;
					}
	case VALUEPARAM :
					{
						offsetinfo offinfo=(offsetinfo)malloc(sizeof(struct stroffsetinfo));
						offinfo->global=NOGLOBAL;
						offinfo->offset=argX->kind.ValueParam.offset;
						return offinfo;
					}
	case PROC		:	return NULL;
	}
}


void MakeFinalCode(char *fname,Quadruples intcode)
{

}

