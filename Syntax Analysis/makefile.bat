@echo off
color 0b
title Makefile

cls
bison -dy gram.y
flex minimal++.l
gcc -o parser.exe lex.yy.c y.tab.c sym_tab.c
pause