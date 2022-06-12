@echo off
c:\masm32\bin\ml /c /Zd /coff upperCase.asm
c:\\masm32\bin\Link /SUBSYSTEM:CONSOLE upperCase.obj
pause