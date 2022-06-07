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
Phrase     db    "Resultat de factoriel de %d : %d",10,0
question	db	"Entrez un chiffre : ", 0
formatText db "%d",0

.DATA?
; variables non-initialisees (bss)
result dword ?

.CODE

FACTORIEL PROC
		push ebp;création pile
		mov ebp, esp;

        mov ebx, [esp+8]; on prend l'entrée user ou la valeur du programme précédent
        cmp ebx, 1; on compare ebx et 1
        jne factoriel_mult; si on est différent de 1, on jump dans la partie en dessous
        mov eax, 1; sinon on met 1 dans eax et on sort de la fonction, on est arriver tout en bas de la récursivité
        jmp return

        factoriel_mult:
            sub ebx, 1; on soustrait 1 à ebx qui est l'entrée user ou l'entrée du programme précédent
            push ebx; on push la valeur sur la pile
            call FACTORIEL; on appelle la fonction récursivement
            xor edx, edx; on passe edx à 0
            mov ebx, [ebp+8]; On reprend le paramètre de notre fonction
            mul ebx; on multiplie eax avec ebx, le résultat sera dans eax

		return:
			mov esp, ebp; supprime la pile actuelle et retour sur la pile du programme précédent
			pop ebp;
			ret;

FACTORIEL ENDP

start:
    	push offset question;
        call crt_printf ; Demande d'entrée utilisateur

        push offset result;
        push offset formatText; format a récupérer
        call crt_scanf ; récupère l'entrée utilisateur et la stocke dans result

        push dword ptr result; on envoie l'entére user en tant que paramètre, dword ptr sert à indiquer la taille de l'opérande
        call FACTORIEL; appelle à la fonction

        push eax; on met le résultat de la fonction
        push dword ptr result; on met l'entrée user
        push offset Phrase; on met la phrase à afficher
        call crt_printf; on affiche le résultat 

		invoke  crt__getch; utiliser pour faire une pause dans le programme et afficher les résultats au dessus, la fonction lit un caractère
		mov eax, 0;
	    invoke	ExitProcess,eax;

end start

