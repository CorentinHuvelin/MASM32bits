@echo off
c:\masm32\bin\ml /c /Zd /coff fibonacci.asm
c:\\masm32\bin\Link /SUBSYSTEM:CONSOLE fibonacci.obj
pause