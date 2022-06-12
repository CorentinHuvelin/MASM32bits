@echo off
c:\masm32\bin\ml /c /Zd /coff countABC.asm
c:\\masm32\bin\Link /SUBSYSTEM:CONSOLE countABC.obj
pause