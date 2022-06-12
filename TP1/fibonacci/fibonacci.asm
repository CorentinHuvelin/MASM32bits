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
Phrase     db    "Resultat de fibonacci : %d",10,0
question	db	"Entrez un chiffre : ", 0
formatText db "%d",0

.DATA?
; variables non-initialisees (bss)
result dword ?

.CODE

FIBONACCI PROC
		push ebp;création pile
		mov ebp, esp;

        sub esp, 16 ; ajout à la pile de 4 entiers de 32 bits

        mov ebx, 3
        mov [ebp-4], ebx; allocation de i
        mov ebx, 1
        mov [ebp-8], ebx; allocation de j
        mov ebx, 1
        mov [ebp-12], ebx; allocation de k
        xor ebx, ebx ; on passe ebx à 0
        mov [ebp-16], ebx; allocation de l

        mov ecx, [ebp-4]; on met i dans ecx
        mov eax, [ebp+8] ; recupère n, l'entrée l'user, dans eax
        
        cmp ecx, eax ; compare i à n
        jg return ; on jump à la fin si n est plus petit que 3

		loop_fibo:
			
            mov ebx, [ebp-8]; on met j dans ebx
            add ebx, [ebp-12]; on ajoute j a k
            mov [ebp-16], ebx; on place le résultat dans l

            mov ebx, [ebp-12]; on met k dans ebx
            mov [ebp-8], ebx; on met ebx à la place de j

            mov ebx, [ebp-16]; on met l dans ebx
            mov [ebp-12], ebx; on met ebx à la place de k

            add ecx, 1; on incrémente ecx qui correspond à i

            ; compare i à n et fait un branchement vers la boucle si i > n
            cmp ecx, eax ; compare i à n
            jle loop_fibo ; on jump au début de la fonction

		return:
            mov eax, [ebp-12]; on met k dans eax pour le retour de la fonction 
			mov esp, ebp; supprime la pile actuelle et retour sur la pile du programme précédent
			pop ebp ;
			ret;

FIBONACCI ENDP

start:
    	push offset question;
        call crt_printf ; Demande d'entrée utilisateur

        push offset result;
        push offset formatText; format a récupérer
        call crt_scanf ; récupère l'entrée utilisateur et la stocke dans result

        push dword ptr result; on envoie l'entére user en tant que paramètre, dword (un mot de 32 bits) ptr sert à indiquer la taille de l'opérande
        call FIBONACCI; appelle à la fonction

        push eax; on met le résultat de la fonction
        push offset Phrase; on met la phrase à afficher
        call crt_printf; on affiche le résultat 

		invoke  crt__getch; utiliser pour faire une pause dans le programme et afficher les résultats au dessus, la fonction lit un caractère
		mov eax, 0;
	    invoke	ExitProcess,eax;

end start

