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
Phrase     db    "%d est un diviseur de %d",10,0
Phrase2     db  "Le nombre %d n'est pas positif",10,0
question	db	"Entrez un chiffre positif : ", 0
formatText db "%d",0

.DATA?
; variables non-initialisees (bss)
result dword ?

.CODE

DIVISEUR PROC
		push ebp;création nouvelle pile
		mov ebp, esp;

        sub esp, 4; ajout à la pile d'un entiers de 32 bits
        mov ecx, 1; On initialise le premier diviseur à un

        mov eax, [ebp+8]; On met la valeur de l'user dans eax
        cmp eax, 0; on compare la valeur à 0
        jge loop_div; si on est plus grand ou égale à 0 on passe dans la boucle, sinon
        push [ebp+8] ; la valeur de l'user
        push offset Phrase2; on affiche une phrase si la saisie est négative
        call crt_printf; on affiche
        jmp return; on quitte le programme

        loop_div:

            mov ebx, ecx; On met la valeur du diviseur dans ebx

            mov eax, [ebp+8]; On met la valeur de l'user dans eax
            xor edx, edx; On vide le registre qui nous sert au calcule
            mov [ebp-4], ebx; sauvegarde ebx dans la pile
            div ebx; On divise eax par ebx et la valeur de sortie sera dans edx
            test edx, edx; si edx = 0 alors ZF sera à 1 donc on prendra pas le jump suivant
            jne next_one

        print_diviseur:
            push ecx ; le nombre actuel
            push [ebp+8] ; la valeur de l'user
            push offset Phrase; on push les différents paramètre pour l'affichage
            call crt_printf; on affiche

        next_one:
            mov ecx, [ebp-4]; On reprend la valeur sauvegarder précedemment
            add ecx, 1; On incrémente le diviseur ecx
            cmp ecx, [ebp+8]; on compare la saisie de l'user et notre diviseur
            jle loop_div; si on est plus petit ou égale à la valeur de l'user on retourne dans la boucle

		return:
			mov esp, ebp; supprime la pile actuelle et retour sur la pile du programme précédent
			pop ebp ;
			ret;

DIVISEUR ENDP

start:
    	push offset question;
        call crt_printf ; Demande d'entrée utilisateur

        push offset result;
        push offset formatText; format a récupérer
        call crt_scanf ; récupère l'entrée utilisateur et la stocke dans result

        push dword ptr result; on envoie l'entére user en tant que paramètre, dword ptr sert à indiquer la taille de l'opérande
        call DIVISEUR; appelle à la fonction

		invoke  crt__getch; utiliser pour faire une pause dans le programme et afficher les résultats au dessus, la fonction lit un caractère
		mov eax, 0;
	    invoke	ExitProcess,eax;

end start

