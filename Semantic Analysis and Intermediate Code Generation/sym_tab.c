//****************************************************************************
//*         This is a part of the Mini-(C)ompiler Source Code. 
//*         All rights reserved. 
//****************************************************************************
#include <stdio.h>
#include <string.h>
#include <malloc.h>
#include "sym_tab.h"

symbol_table create_st(void)
{
	symbol_table newst;
	newst=(symbol_table)malloc(sizeof(struct symtab));
	newst->st_entries=NULL;
	return newst;
}

void destroy_st(symbol_table table)
{
	entr_list list=table->st_entries;
	while (list!=NULL){
		free(list->id->name);
		free(list->id);
		list=list->next;
	}
}

char enter(symbol_table table,entry entryptr)
{
	if (table->st_entries==NULL){
		entr_list list;
		list=(entr_list)malloc(sizeof(struct strentlist));
		list->id=entryptr;
		list->next=NULL;
		table->st_entries=list;
		return 1;
	}
	else {
		entry fentry=lookup(table,entryptr->name);
		if (fentry==NULL){
			entr_list list;
			list=(entr_list)malloc(sizeof(struct strentlist));
			list->id=entryptr;
			list->next=table->st_entries;
			table->st_entries=list;
			return 1;
		}
		else return 0;
	}
}

entry lookup(symbol_table table,char *name)
{
	entr_list list;
	if (table==NULL) return NULL;
	list=table->st_entries;
	while ((list!=NULL)&&(strcmp(list->id->name,name)!=0)){
		list=list->next;
	}
	if (list!=NULL) return list->id;
	 else return NULL;
}


void FreeEntry(entry entr)
{
if ((entr!=NULL)&&(entr->name!=NULL))
	{
		switch(entr->IDclass){
			case CONSTANT	:	if (entr->kind.Constant.ConstType!=NULL) free(entr->kind.Constant.ConstType);break;
			case VARIABLE	:	free(entr->kind.Variable.typeDesc);break;
			case VALUEPARAM	:	free(entr->kind.ValueParam.typeDesc);break;
			case PROC		:	{
								entry lastParam;
								free(entr->kind.Proc.ReturnType);
								while (entr->kind.Proc.LastParam!=NULL){
									lastParam=entr->kind.Proc.LastParam->previous;
									FreeEntry(entr->kind.Proc.LastParam);
									entr->kind.Proc.LastParam=lastParam;
								}
								break;
								}
		}
		free(entr->name);
		free(entr);
		entr->name=NULL;
	}
}
