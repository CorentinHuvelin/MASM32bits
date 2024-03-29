# Assembleur x86
## TP n°1
# Verdier Léa e2101110 et Huvelin Corentin e2103800

### A. Appel de fonctions

Fonctionnement du débogueur :
1 : Fonctions
2 : Valeurs des registres
3 : Drapeaux utilisés pour les opérations de comparaison
4 : Pile avec les adresses à gauche et valeurs à droite
5 : Tas avec les adresses à gauche et valeurs à droite

Pour afficher un texte sur l'interface de commande, nous allons utiliser la fonction crt_printf.
Pour l'utiliser, nous devons garder en mémoire que les paramètres passés en assembleur doivent être ajouté à la pile avec ```push``` dans l'ordre inverse.
Ici, nous allons donc d'abord pousser la chaîne "42" avant de pousser "Hello World : %d",10,0.
Ensuite, il suffira d'appeler la fonction avec ```call crt_printf```.
Cependant, nous pouvons nous interroger sur la capacité de ```crt_printf``` à récupérer sur la pile le bon nombre de paramètres. En effet, comment cette fonction comprend qu'elle doit chercher un élément supplémentaire sur la pile afin de reconstruire la chaîne de caractère.
En utilisant le déboggeur, nous pouvons vérifier comment ```crt_printf``` peut connaître son nombre d'arguments. Suite à l'étude de la fonction, il semblerait dans un premier temps, que la fonction scanne le premier paramètre pour compter le nombre de "%" présent dans la chaîne. Ensuite, elle ira chercher le nombre de paramètres correspondant dans la pile pour les assembler et les afficher.

Pour message box : on crée deux variables, une pour le texte du message et l'autre pour le titre de la fenêtre dans la partie .DATA du fichier. Ensuite, on invoque la fonction MessageBox préexistante dans le logiciel ASM avec comme paramètre : le premier repésente la fenêtre nous avons mis NULL, le second le texte à afficher dans cette fenêtre puis en troisième son titre et enfin le type de message box utilisé nous avons choisi MB_OK afin de n'avoir qu'un bouton OK à cliquer pour fermer la fenêtre.
Puis on réinitialise le registre eax à 0 avec la commande ```mov eax, 0```.
Enfin, on invoque la fonction ExitProcess avec en paramètre eax qui vaut 0, l'utilisation du mot clé ```NULL``` aurait été similaire.

### B. UpperCase

En variable, nous avons : Un message pour afficher la chaine en minuscule, Un message pour présenter la phrase en majuscule, Un message pour demander à l'utilisateur d'entrer son texte et une variable pour préciser le type de données attendu : "%s" soit une chaine de caractères.

Nous créons aussi une variable non initialisée : toUpper.

Dans le début du code, nous initialisons la procédure de passage en majuscule.
Tout d'abord création de la pile : push ebp suivi de mov ebp, esp.
Puis, nous récupérons l'adresse de la chaîne de caractère mov.
Dans loop_upper, nous allons définir le code correspondant aux actions à réaliser à chaque tour de boucle.
Ici, nous allons dans un premier temps chercher un caractère sur le registre esi qui nous sert à parcourir la chaîne de caractère, pour le stocker dans le registre al.
Grâce à ```cmp```, nous pouvons comparer la valeur du caractère à des nombres tel que 97 et 122, soit les codes de a et z en ASCII.
Si la valeur du caractère est comprise entre ces deux valeurs, alors nous restons dans la boucle, sinon nous passons dans la partie next_one du code. La suite du code de la boucle consiste à soustraire 32 à la valeur comprise dans ```al```, nous passerons ainsi du code de a à A (97 à 65) et de z à Z (122 à 90).
Dans next_one, nous retrouverons le code permettant de passer au caractère suivant. Nous allons d'abord ajouter 1 à la valeur comprise dans ```esi``` pour passer au caractère suivant. En utilisant ```test al,al```, nous vérifions si nous avons atteint le dernier caractère de notre mot et nous utiliserons le jump conditionnel ```jnz loo_upper``` pour retourner dans la boucle si le résultat de ```test``` n'est pas 0.
Pour finir, nous allons restaurer la pile du programme précédant, en déplaçant ```esp``` vers ```ebp``` puis en utilisant ```pop``` pour récupérer la valeur sauvegardée d'ebp au début de notre fonction.
```ret``` va alors récupérer l'adresse sur la pile pour indiquer au pointeur de programme que la prochaine instruction se trouve à cet endroit, ce qui ramènera le programme dans notre fonction principale.

### C. Variables locales

Cette exercice a pout but de reproduire un algorithme C en assembleur en utilisant des variables locales. 
    ```int myst( int n ){```
        ```int i, j, k, l;```
        ```j = 1;```
        ```k = 1;```
        ```for ( i = 3; i <= n; i++ ) {```
            ```l = j + k;```
            ```j = k;```
            ```k = l;```
        ```}```
        ```return k;```
    

Nous allons tout d'abord récupérer l'entrée utilisateur. Pour cela, nous utiliserons la même méthode que précedemment en changeant le format de la chaine lu pour %d, correspondant à un entier. 
Ensuite, nous allons allouer 4 places dans la pile correspondant aux 4 variables locales i, j, k et l.
Après avoir alloué les variables, nous commencerons par effectuer une comparaison pour savoir si l'entrée utilisateur est plus petite que i à son initialisation soit 3. Soit on quitte le programme directement, soit on passe dans la boucle que l'on parcourera assez de fois en incrémentant i pour qu'il soit égal à l'entrée utilisateur. Dans la boucle, nous effectuerons les calculs nécessaires sur l, j et k. Nous mettrons le resultat de la fonction dans eax avant de quitter le programme en restorant la stackframe.

Après avoir executé le programme, nous nous rendons compte qu'il permet de calculer la suite de fibonacci. En comparant avec cette suite sur internet, nous tombons bien sur les mêmes résultats, n=1 on a 1, n=2 on a 1, n=3 on a 2, n=4 on a 3 ...

Nous allons maintenant écrire une fonction qui compte le nombre de caractère a, b, c dans un mot donné. Nous utiliserons le même fonctionnement que pour la fonction toUpper. Nous allons comparer les valeurs des lettres que nous parcourons à 97, 98, 99 soit la valeur en ASCII de a,b,c. Nous utiliserons aussi des jumps conditionnels afin de sauter les tests qui ne sont pas concluant. Les compteurs que nous utilisons seront des variables locales ajouté à la pile de la fonction. De plus, nous utilisons la fonction XOR d'un registre avec lui-même pour l'initialiser à 0, ce qui represente une économie d'exécution par rapport à un ```mov registre, 0```. Nous mettons les résultats de la fonction dans eax, ebx et ecx.

### D. Un peu de calcul

Dans cet exercice, nous allons devoir produire deux programmes, un qui indique tous les diviseurs d'un entier positif et un autre qui, récursivement, calcule la factorielle d'un entier.

Nous commençons par le diviseur. Ce programme sera simple car il suivra le même principe que plusieurs programmes précedents. Nous commençons par ajouter une variable locale dans la pile du programme et nous l'initialisons à 1, ce sera le diviseur, puis à récupérer la saisi de l'utilisateur. Ensuite, nous allons effectuer une division sur l'entrée utilisateur par notre variable locale avec ```div ebx```. Le résultat de ce calcul sera dans edx, nous allons donc appeler ``` test edx, edx ``` qui nous permettra de passer le flag ZF (ZéroFlag) à 1, si edx est égale à 0, et nous empechera de prendre le jump conditionnel suivant, qui mène vers une incrémentation puis un retour au début de la boucle. Si nous ne prenons pas le jump, alors nous afficherons l'information que l'entier actuel divise le nombre saisi. La seule nouveauté était de vérifier au début du code si le nombre donné n'était pas négatif, donc inférieur à 0. Nous utilisons donc un ``` cmp eax, 0``` eax contenant la saisie de l'utilisateur, pour faire un jump conditionnel si le nombre saisi est plus grand ou égal à 0. Sinon nous afficherons une phrase pour indiquer que la saisie est un nombre négatif.

Pour le second programme, il faut calculer récursivement la factorielle d'un nombre. Comme d'habitude, nous allons récuperer l'entrée utilisateur et la comparer à 1. Si la valeur est différente de 1, nous allons jump dans la partie du code qui appelle récursivement la fonction. Sinon nous allons retourner 1 via eax.
La partie du code qui s'occupe de faire la récursion va d'abord soustraire 1 au nombre actuellement lu puis va appeler la fonction en lui passant le nombre en paramètre. Ensuite, nous récupérons via eax ce nombre que nous allons multiplier avec l'entrée utilisateur ou l'entrée du programme supérieur. Le résultat de ``` mul ``` sera mit dans eax et sera utilisé pour retourner la fonction.

### E. Un peu de lecture

Synthèse de l'article : Plongeon dans les appels systèmes Windows

Cet article explique, en détaillant toutes les étapes du processus, comment un programme utilisateur peut réaliser un appel à une fonction s'exécutant en mode noyau.

Avant de débuter cette étude, l'auteur rappelle les niveaux de privilège d'un processeur x86. Ces privilèges sont répartis sur 4 niveaux appelés ring ou anneau, de 0 à 4 : 0 équivalant aux privilèges les plus élevés soit le mode superviseur et 3 aux privilèges les plus restreints soit le mode utilisateur.

Le niveau courant du processeur, CPL, est stocké dans les deux premiers bits de registre CS et SS et suit une règle : il n'est pas possible d'exécuter des instructions nécessitant un niveau de privilège inférieur au CPL et il n'est pas non plus directement possible de changer le CPL vers un niveau inférieur.

Afin d'analyser le déroulé d'un appel système, l'article commence par nous présenter un programme d'exemple en C. Ce programme appelle l'API Windows FindFirstFile, une fonction qui prend en paramètre un nom de dossier et retourne un handle vers le premier fichier de ce dossier. 

Une fois le programme compilé, nous l'analysons à l'aide du débogeur OllyDbg.

Nous pouvons tout d'abord observer que le programme s'éxecute avec un niveau de privilège utilisateur donc 3. Nous allons donc étudier l'appel à la fonction FindFirstFile. Au fur et à mesure de l'exécution du programme, nous pouvons observer les différents jump entre les fonctions appelées. Tout d'abord, le programme appelle la fonction FindFirstFileA puis dans cette fonction, nous trouvons l'appel à la fonction FindForstFileExW. La première fonction se termine par A pour spécifier qu'elle gère l'ASCII et la seconde par W pour spécifier qu'elle gère l'Unicode. Cette dernière fonction est appelée car la plupart des fonctions internes Windows utilisent l'encodage Unicode et non ASCII. En suivant cette fonction, nous nous apercevons qu'elle-même appelle plusieurs autres fonctions dans ntdll.dll comme ZwOpenFile. C'est cette dernière qui réalise le passage en mode noyau (anneau 0) à l'aide de la fonction KiFastSystemCall. C'est plus précisément SYSENTER qui réalise ce passage. Cette instruction permet en effet d'effectuer des appels systèmes en modifiant temporairement la valeur de CS afin d'exécuter des commandes en mode noyau.

En investiguant plus, nous pouvons observer que la fonction ```KiFastCallEntry``` se trouve dans un des exécutable noyau. Cette fonction charge la table SSDT (Service System Dispatch Table) dans EDI qui permet de distribuer les appels systèmes vers la fonction correspondante.

Une fois le passage en mode noyau et la commande voulue effectuée, nous observons le retour en mode utilisateur. Pour cela, le programme appelle la fonction ```KiSystemCallExit2``` qui utilise la fonction ```SYSEXIT``` pour sortir du mode noyau et retourner à l'état initial du registre CS.

Ce schéma de fonctionnement peut être exploité afin d'accéder à un niveau de privilège plus élevé en dehors du cadre des fonctions prévues à cet effet.

