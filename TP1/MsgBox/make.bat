@echo off
c:\masm32\bin\ml /c /Zd /coff MsgBox.asm
c:\\masm32\bin\Link /SUBSYSTEM:CONSOLE MsgBox.obj
pause