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
Phrase     db    "Chaine en minuscule : %s",10,0
Phrase2     db    "Chaine en majuscule : %s",10,0
question	db	"Entrez votre texte : ", 0
formatText db "%s",0

.DATA?
; variables non-initialisees (bss)
toUpper db ?

.CODE

TOUPPERCASE PROC
		;création pile
		push ebp;
		mov ebp, esp;

		;récupération adresse de chaine de caractère
		mov esi, [esp+8];

		loop_upper:
			mov al, [esi]; On prend le caractère correspondant à l'adresse d'esi
			
			; ascii de a = 97 donc on doit être plus grand que 97 
			cmp al, 97;
			; Si plus petit que 97 alors pas une lettre en minuscule donc on passe au suivant
			jb next_one;

			;ascii de z = 122 donc on doit être plus petit que 122
			cmp al, 122;
			jg next_one;

			; pour passer en màj, on soustrait 32 à la valeur car a = 97 et A = 65 donc 97 - 32 = 65
			sub al, 32;
			; On met dans la valeur à l'adresse esi la nouvelle valeur de al
			mov [esi], al;

		next_one:
			; on ajoute un à esi pour aller au caractère suivant
			add esi, 1;
			test al,al; test si dernier caractère
			jnz loop_upper ; jump pour retourner dans la boucle principale

		return:
			; supprime la pile actuelle et retour sur la pile du programme précédent
			mov esp, ebp;
			pop ebp ;
			ret;

TOUPPERCASE ENDP

start:
		push offset question;
        call crt_printf ; Demande d'entrée utilisateur

        push offset toUpper;
        push offset formatText; format a récupérer
        call crt_scanf ; récupère l'entrée utilisateur et la stocke dans toUpper

		push offset toUpper ; on place le second argument de la fonction appelée sur la pile
        push offset Phrase; On place le premier argument de la fonction appelée sur la pile
        call crt_printf; on affiche l'entrée user
		
		push offset toUpper; on place la chaine de caractère à mettre en majuscule
		call TOUPPERCASE; on appelle la fonction TOUPPERCASE

		push offset toUpper; on place le second argument de la fonction appelée sur la pile
        push offset Phrase2; On place le premier argument de la fonction appelée sur la pile
        call crt_printf; on affiche la phrase en majuscule

		invoke  crt__getch; utiliser pour faire une pause dans le programme et afficher les résultats au dessus, la fonction lit un caractère
		mov eax, 0;
	    invoke	ExitProcess,eax;

end start

