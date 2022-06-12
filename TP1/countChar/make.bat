@echo off
c:\masm32\bin\ml /c /Zd /coff countChar.asm
c:\\masm32\bin\Link /SUBSYSTEM:CONSOLE countChar.obj
pause