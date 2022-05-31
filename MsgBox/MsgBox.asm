.386
.model flat,stdcall
option casemap:none

include c:\masm32\include\windows.inc
include c:\masm32\include\gdi32.inc
include c:\masm32\include\gdiplus.inc
include c:\masm32\include\user32.inc
include c:\masm32\include\kernel32.inc
include c:\masm32\include\msvcrt.inc

includelib c:\masm32\lib\gdi32.lib
includelib c:\masm32\lib\kernel32.lib
includelib c:\masm32\lib\user32.lib
includelib c:\masm32\lib\msvcrt.lib

.DATA
; variables initialisees
MsgBoxCaption  db "Test du TD1 exo1",0
MsgBoxText       db "Corentin est le meilleur !",0

.CODE
start:
    invoke MessageBox, NULL, addr MsgBoxText, addr MsgBoxCaption, MB_OK
    mov eax, 0
	invoke	ExitProcess,eax
end start 