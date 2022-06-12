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
print_dossier db "<DOSSIER> %s%s", 10,0
print_fichier db "<FICHIER> %s%s", 10,0
print_erreur db "Il y a eu une erreur verifier le chemin d'entree.", 10,0
question db "Chemin du dossier a afficher (sans le slash final) #>",0
print_dossier_initial db "<CHEMIN CHOISI> %s", 10,0
scanFormat db "%s"

; variable pour comprendre ce qu'il se passe
; print_E12 db "<EBP-12> %s", 10,0
; print_E16 db "<EBP-16> %s", 10,0
; print_E8 db "<EBP-8> %s", 10,0
; print_dossier_actuel db "<CHEMIN DOSSIER ACTUEL> %s", 10,0
; print_dossier_esi db "<CHEMIN DOSSIER ESI> %s", 10,0

; Pour construire les chemins
slash dd "/" ;
star dd "*" ;

.DATA?
; variables non-initialisees (bss)
file_folder_find      WIN32_FIND_DATA <?> 
dossier_to_dir db 260 dup(?) ; 260 car taille en caractère maximale pour un chemin sous windows

.CODE

DIR_REC PROC
		;création pile
		push ebp;
		mov ebp, esp;
        sub esp,16 ; Alloue 4 entrée dans la pile, les variables locales

        ; %%%%%%%%%%%%%%%%%%%%%
        ; Création de deux mallocs pour le chemin avec slash et slash étoile
        invoke GlobalAlloc, GMEM_ZEROINIT, 260 ; chemin avec /*
        mov [ebp-12], eax

        invoke GlobalAlloc, GMEM_ZEROINIT, 260 ; chemin avec /
        mov [ebp-16], eax

        ; [ebp-4] sera utilisé poursauvegarder l'handler et ebp-8 sera allouer plus tard, il servira pour créer les chemins pour l'appel récursif

        ; On récupère le chemin fournit par l'utilisateur et on le met dans le malloc /*
        push [ebp-12]
        push [ebp+8] ; recupere entrée user
        call duplicate_string
        add esp,8

        ; On ajoute au premier malloc le /
        push offset slash ; /
        push [ebp-12]
        call crt_strcat 
        add esp,8
        mov [ebp-12], eax

        ; On copie notre premier malloc (/*) dans le deuxième malloc (/), ici on a "chemin/"
        push [ebp-16]
        push [ebp-12]
        call duplicate_string
        add esp,8

        ; On ajoute a notre premier malloc (/*) une etoile, ici on a "chemin/*
        push offset star
        push [ebp-12]
        call crt_strcat ; addr chaîne concat->eax , le résultat est à la fois dans eax et dans ebp-12
        add esp,8

        ;Afficher contenu de la MALLOC chemin avec /* pour test
        ; push [ebp-12] ; 
        ; push offset print_E12
        ; call crt_printf 
        ; add esp,8

        ; Afficher contenu de la MALLOC chemin avec / pour test
        ; push [ebp-16]
        ; push offset print_E16
        ; call crt_printf  
        ; add esp,8
        
        ; Appel de FindFirstFile
        invoke FindFirstFile, [ebp-12], ADDR file_folder_find ; On invoque la fonction Windows qui liste les info du dossier pointé
  
        .IF eax!=INVALID_HANDLE_VALUE ; Si on a pas d'erreur, on procède à l'affichage des fichier/dossier
            mov [ebp-4], eax ; ebp-4 est le handler

            jmp apres_handler_verif; on jump dans la suite du code si le handler n'a pas de problème
        .ELSE
            push offset print_erreur
            call crt_printf; on affiche qu'il y a eu erreur
            add esp,4
            jmp return ; et on quitte la fonction
        .ENDIF


        boucle:
            invoke FindNextFile, [ebp-4], ADDR file_folder_find
            cmp eax, 0 ; si eax = 0, alors plus de fichier dans le dossier
            je return ; si eax=0 on ferme ce FindNextFile

            apres_handler_verif:
                lea edi,file_folder_find
                mov eax,[edi]	; file attributes
                .if ax & FILE_ATTRIBUTE_DIRECTORY
                    cmp file_folder_find.cFileName, "." ;
                    jz boucle ; si . ou .. on skip le dossier

                        push offset file_folder_find.cFileName
                        push [ebp-16]
                        push offset print_dossier ; on appelle l'affichage du dossier
                        call crt_printf
                        add esp,12
                        ; %%%%%%%%%%%%%%%%%%%%%%%%%%
                        ; APPEL RECURSIF SUR LE SOUS-DOSSIER
                        ; %%%%%%%%%%%%%%%%%%%%%%%%%%

                            invoke GlobalAlloc, GMEM_ZEROINIT, 260 ; variable local utilisé pour futur recursion, on la recréer à chaque appel car si on le créer au tout début on a un soucis au niveau de la duplication non identifié
                            mov [ebp-8], eax

                            push [ebp-8]
                            push [ebp-16]
                            call duplicate_string; on dupplique le chemin actuel
                            add esp,8 ; suppression des push au dessus

                            ; on concatene le dossier_actuel avec le nom du sous dossier
                            push offset file_folder_find.cFileName
                            push [ebp-8]; on met le chemin /
                            call crt_strcat ; addr chaîne concat->eax
                            add esp,8

                            push [ebp-8]; on appelle la fonction recursivement
                            call DIR_REC
                            add esp,4

                        jmp boucle
                .else
                    push offset file_folder_find.cFileName; on affiche le fichier
                    push [ebp-16]; on affiche le chemin
                    push offset print_fichier
                    call crt_printf
                    add esp,12
                    jmp boucle ; on revient au début
                .endif  


		return:
			; supprime la pile actuelle et retour sur la pile du programme précédent
			mov esp, ebp;
			pop ebp ;
			ret;
        
    ; Fonction pour dupliquer un string
    duplicate_string:
        push ebp
        mov ebp,esp

        mov eax,[ebp+8] ; addr string
        mov ebx,[ebp+12] ; addr
        begin_dup:
            cmp byte ptr [eax],0
            je end_dup

            mov cl, byte ptr [eax]
            mov byte ptr [ebx],cl

            add eax,1
            add ebx,1
            jmp begin_dup
        end_dup:
        mov esp,ebp
        pop ebp
        ret

DIR_REC ENDP


start:
    push offset question
    call crt_printf

    push offset dossier_to_dir
    push offset scanFormat
    call crt_scanf

    push offset dossier_to_dir
    push offset print_dossier_initial
    call crt_printf

    push offset dossier_to_dir
    call DIR_REC

    invoke  crt__getch; utiliser pour faire une pause dans le programme et afficher les résultats au dessus, la fonction lit un caractère
	mov eax, 0;
	invoke ExitProcess,eax;

end start