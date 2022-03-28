//****************************************************************************
//*         This is a part of the Mini-(C)ompiler Source Code. 
//*         All rights reserved. 
//****************************************************************************
#ifndef   __CHECK_H
#define   __CHECK_H
#include "gener.h"
#include "int_code.h"
#include "err_code.h"
#include "error_str.h"

express TypeChecking(express leftoper,int op,express rigthoper);

char *CheckFunctionParam(express func,expression_list exprlist);

errconbr CheckContinueBreak(statem stat);
errconbr CheckReturn(entry fun,statem stat);

#endif