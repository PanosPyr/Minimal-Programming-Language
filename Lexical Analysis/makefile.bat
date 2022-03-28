@echo off
color 0b
title Makefile

cls
flex minimal++.l
gcc lex.yy.c -o minimal++.exe
pause