@echo off
c:\masm32\bin\ml /c /Zd /coff dir_recursif.asm
c:\\masm32\bin\Link /SUBSYSTEM:CONSOLE dir_recursif.obj
pause