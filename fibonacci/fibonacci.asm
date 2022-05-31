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
question	db	"Entrez votre texte : ", 0
formatText db "%s",0

.DATA?
; variables non-initialisees (bss)
result db ?

.CODE

FIBONACCI PROC

		;création pile
		push ebp;
		mov ebp, esp;

        sub esp, 16 ; ajout à la pile de 4 entiers de 32 bits (DWORD)

        mov ebx, 3
        mov [ebp-4], ebx   ; allocation de i
        mov ebx, 1
        mov [ebp-8], ebx   ; allocation de j
        mov ebx, 1
        mov [ebp-12], ebx  ; allocation de k
        xor ebx, ebx ; on passe ebx à 0
        mov [ebp-16], ebx  ; allocation de l

        mov ecx, [ebp-4]   ; on met i dans ecx
		loop_fibo:
			; l = j + k
            mov ebx, [ebp-8]
            add ebx, [ebp-12]
            mov [ebp-16], ebx

            ; j = k
            mov ebx, [ebp-12]
            mov [ebp-8], ebx

            ; k = l
            mov ebx, [ebp-16]
            mov [ebp-12], ebx

            ; i++
            ; mov ebx, [ebp-4]
            ; inc ebx
            ; mov [ebp-4], ebx
            inc ecx

            ; compare i à n et fait un branchement vers la boucle si i > n
            mov eax, [ebp+8] ; recupère n
            cmp ecx, eax ; compare i à n
            jle loop_fibo

		next_one:
			; on ajoute un à esi pour aller au caractère suivant
			add esi, 1;
			test al,al; test si dernier caractère
			jnz loop_fibo ; jump pour retourner dans la boucle principale

		return:
            mov eax, [ebp-12]; on met k dans eax pour le retour de la fonction 
			; supprime la pile actuelle et retour sur la pile du programme précédent
			mov esp, ebp;
			pop ebp ;
			ret;

FIBONACCI ENDP

start:
    	push offset question;
        call crt_printf ; Demande d'entrée utilisateur

        push offset toCount;
        push offset formatText; format a récupérer
        call crt_scanf ; récupère l'entrée utilisateur et la stocke dans toCount

        call FIBONACCI; appelle à la fonction

		invoke  crt__getch; utiliser pour faire une pause dans le programme et afficher les résultats au dessus, la fonction lit un caractère
		mov eax, 0;
	    invoke	ExitProcess,eax;

end start

