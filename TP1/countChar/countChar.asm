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
Phrase     db    "Nombre de caracteres : %d",10,0
question	db	"Entrez votre mot : ", 0
formatText db "%s",0

.DATA?
; variables non-initialisees (bss)
toCount db ?

.CODE

COUNTCHAR PROC
		;création pile
		push ebp;
		mov ebp, esp;

		;récupération adresse de chaine de caractère et stockage dans esi
		mov esi, [esp+8];
        xor eax, eax; on passe eax à 0, il nous servira pour compter

        mov edi, esi ; on passe edi à la valeur de esi

        repne scasb ; itération sur la chaine de edi via al, tant que ZF = 1 ou jusqu'à CX = 0

        sub edi, esi ; on soustrait les deux adresse ce qui nous permet d'avoir le nombre de caractère
        sub edi, 1; on enlève 1 pour ne pas prendre en compte \n ou le 0

        mov eax, edi; on met le nombre de caractère dans eax

		return:
			; supprime la pile actuelle et retour sur la pile du programme précédent
			mov esp, ebp;
			pop ebp ;
			ret;

COUNTCHAR ENDP

start:
		push offset question;
        call crt_printf ; Demande d'entrée utilisateur

        push offset toCount;
        push offset formatText; format a récupérer
        call crt_scanf ; récupère l'entrée utilisateur et la stocke dans toCount
		
		push offset toCount; on place la chaine de caractère à compter
		call COUNTCHAR; on appelle la fonction COUNTCHAR

        push eax ; on place le second argument de la fonction appelée sur la pile
        push offset Phrase; On place le premier argument de la fonction appelée sur la pile
        call crt_printf; on affiche le résultat

		invoke  crt__getch; utiliser pour faire une pause dans le programme et afficher les résultats au dessus, la fonction lit un caractère
		mov eax, 0;
	    invoke	ExitProcess,eax;

end start

