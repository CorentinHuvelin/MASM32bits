# Assembleur x86
## TP n°1

### A. Appel de fonctions

Fonctionnement du débogueur :
1 : Fonctions
2 : Valeurs des registres
3 : Drapeaux utilisés pour les opérations de comparaison
4 : Pile avec les adresses à gauche et valeurs à droite
5 : Tas avec les adresses à gauche et valeurs à droite

Parler du printf !!

Pour message box : on crée deux variables, une pour le texte du message et l'autre pour le titre de la fenêtre dans la partie .DATA du fichier. Ensuite, on invoque la fonction MessageBox préexistante dans le logiciel ASM avec comme paramètre : le premier repésente la fenêtre nous avons mis NULL, le second le texte à afficher dans cette fenêtre puis en troisième son titre et enfin le type de message box utilisé nous avons choisi MB_OK afin de n'avoir qu'un bouton OK à cliquer pour fermer la fenêtre.
Puis on réinitialise le registre eax à 0 avec la commande ```mov eax, 0```
Et enfin on invoque la fonction ExitProcess avec en paramètre eax qui vaut 0, nous aurions pu mettre NULL à la place ça revient au même.

### UpperCase

En variable on a : Un message pour afficher la chaine en minuscule, Un message pour présenter la phrase en majuscule, Un message pour demander à l'utilisateur d'entrer son texte et une variable pour préciser le type de données attendu : "%s" soit une chaine de caractères.

Nous créons aussi une variable non initialisée : toUpper de taille et de type inconnu ??

Dans le début du code, on initialise la procédure de passage en majuscule.
Tout d'abord création de la pile : push ebp suivi de mov ebp, esp
Ensuite on récupère l'adresse de la chaine de caractère mov

### E. Un peu de lecture

Plongeon dans les appels systèmes Windows

Cet article explique, en détaillant toutes les étapes du processus, comment un programme utilisateur peut réaliser un appel à une fonction s'exécutant en mode noyau.

Avant de débuter cette étude, l'auteur rappelle les niveaux de privilège d'un processeur x86. Ces privilèges sont répartis sur 4 niveaux appelés ring ou anneau, de 0 à 4 : 0 équivalant aux privilèges les plus élevés soit le mode superviseur et 3 aux privilèges les plus restreints soit le mode utilisateur.

Le niveau courant du processeur, CPL, est stocké dans les deux premiers bits de registre CS et SS et suit une règle : il n'est pas possible d'exécuter des instructions nécessitant un niveau de privilège inférieur au CPL et il n'est pas non plus directement possible de changer le CPL vers un niveau inférieur.

**A finir**

