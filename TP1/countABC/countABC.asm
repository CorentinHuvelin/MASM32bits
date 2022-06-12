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
Phrase     db    "Nombre de a : %d, Nombre de b : %d, Nombre de c : %d", 10, 0
question	db	"Entrez une phrase : ", 0
formatText db "%s",0

.DATA?
; variables non-initialisees (bss)
countABC db ?

.CODE

COUNTABC PROC
        push ebp;création pile
	    mov ebp, esp;

        sub esp, 12; ajout à la pile de 3 entiers de 32 bits

        xor ebx, ebx; on passe ebx à 0
        mov [ebp-4], ebx; allocation du nombre de a
        mov [ebp-8], ebx; allocation du nombre de b
        mov [ebp-12], ebx; allocation du nombre de c

        mov esi, [ebp+8]; On met la chaine à traiter dans esi
        mov ebx, 1; on passe 1 à ebx, il servira pour faire l'incrémentation

        loop_abc:
            mov al, [esi] ; On prend un caractère depuis esi et on le met dans al

            test_a:
                cmp al, 97; si al est égale à 97 alors il s'agit de a
                jne test_b; on saute si on est pas égale
                add [ebp-4], ebx; sinon on incrémente le nombre de a
                jmp next_one; on passe au suivant

            test_b:
                cmp al, 98; même chose pour b avec 98
                jne test_c
                add [ebp-8], ebx
                jmp next_one

            test_c:
                cmp al, 99; même chose pour c avec 99
                jne next_one
                add [ebp-12], ebx
                jmp next_one

        next_one:
			add esi, 1; on ajoute un à esi pour aller au caractère suivant
			test al,al; test si dernier caractère
			jnz loop_abc ; jump pour retourner dans la boucle principale

        return:
            mov eax, [ebp-4]; on prépare le retour des compteurs
            mov ebx, [ebp-8]
            mov ecx, [ebp-12]

		mov esp, ebp; supprime la pile actuelle et retour sur la pile du programme précédent
		pop ebp;
		ret;

COUNTABC ENDP

start:
    	push offset question;
        call crt_printf ; Demande d'entrée utilisateur

        push offset countABC
        push offset formatText; format a récupérer
        call crt_scanf ; récupère l'entrée utilisateur et la stocke dans countABC

        push offset countABC; on envoie l'entrée user en tant que paramètre
        call COUNTABC; appelle à la fonction

        push ecx; On met le nombre de c
        push ebx; On met le nombre de b
        push eax; On met le nombre de a
        push offset Phrase; on met la phrase à afficher
        call crt_printf; on affiche le résultat 

		invoke  crt__getch; utiliser pour faire une pause dans le programme et afficher les résultats au dessus, la fonction lit un caractère
		mov eax, 0;
	    invoke	ExitProcess,eax;

end start

