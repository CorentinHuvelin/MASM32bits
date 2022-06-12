# Assembleur x86
## Projet
# Verdier Léa e2101110 et Huvelin Corentin e2103800

## Introduction 

Le but de ce projet était de produire l'équivalent de la commande DIR récursif de windows avec un affichage graphique.
Pour des raisons de manque de temps, nous n'avons pas pu réaliser l'affichage graphique. Cependant la fonction de DIR récursif est fonctionnel sous interface de commande.

## Variables Globales

Dans un premier temps nous allons avoir besoin de différentes variables :
```print_dossier db "<DOSSIER> %s%s", 10,0``` la chaine pour l'affichage d'un dossier, avec deux ```%s``` un pour le chemin et l'autre pour le dossier.
```print_fichier db "<FICHIER> %s%s", 10,0``` même chose pour un fichier.
```print_erreur db "Il y a eu une erreur verifier le chemin d'entree.", 10,0``` un message d'erreur si la fonction de lecture de l'arborescence rencontre une erreur.
```question db "Chemin du dossier a afficher (sans le slash final) #>",0``` un chaine pour demandé à l'user sur quel chemin il veut effectuer le DIR.
```print_dossier_initial db "<CHEMIN CHOISI> %s", 10,0``` un chaine pour retourner à l'user le chemin qu'il à demandé.
```scanFormat db "%s"``` le format de la chaine de caractère lu
```slash dd "/" ;``` une variable contenant le slash
```star dd "*" ;``` une variable contenant l'étoile
Et pour les variable global non connu à l'avance.
```file_folder_find      WIN32_FIND_DATA <?>``` la structure qui recevra le retour de la fonction findfirstfile et findnextfile.
```dossier_to_dir db 260 dup(?) ;``` l'entrée utilisateur sur 260 caractère car windows ne peut pas aller au délà d'un chemoin de 260 caractère.

## La fonction principale

Le corps de la fonction main est simple, on demande juste à l'user de rentrée un chemin sans slash à la fin et menant vers un dossier dont il souhaite afficher le contenu récursivement.

## La fonction DIR_REC

Dans la fonction DIR_REC, nous allons effectuer plusieurs choses. Tout d'abord, nous allons allouer 4 espace dans la pile. C'est 4 espaces comprendront pour ```[ebp-16]``` le chemin donné par l'user ou la fonction précédante mais en rajoutant un "/", pour ```[ebp-12]``` le même principe mais avec un "/*" de rajouter, pour ```[ebp-8]``` il sera utiliser plus tard pour allouer un espace mémoire suffisant pour créer le chemin nécessaire pour appeler récursivement la fonction et ```[ebp-4]``` sera utilisé pour contenir une variable local, le handler qui servira à parcourirs les dossiers et fichiers contenus dans le chemin lu par la fonction.

Dans un premier temps la fonction va donc allouer de l'espace mémoire de la taille 260 caractère , la taille maximum d'un chemin sur windows, sur nos deux premières variables locales et va copier l'entrée user dans ces deux espaces. Ensuite nous allons rajouter à chacunes des variables un "/" ou "/*". Le premier servira à la fois à l'affichage mais aussi à construire les futur chemin de récursion, tandis que le second sera utilisé pour parcourir le contenu du dossier donné par l'user.
Une fois ces actiosn effectué nous allons appelé FindFirstFile, avec le chemin possédant "/*". Nous appliquerons une vérification pour vérifier si le handler renvoyé par la fonction est correcte puis nous le déplacerons dans ```[ebp-4]``` puis nous effecturons un jump conditionnel directement dans la boucle utilisé pour parcourir le dossier actuel mais sans commencer par le début de cette boucle, car au début ce trouve la fonction ```FindNextFile``` qui passe au dossier suivant.
Si il ya eu une erreur avec le handler nous afficherons un message d'erreur puis nous quitterons le programme.

La suite du code va alord boucler sur le parcours du dossier actuel. Dans un premier temps, allons vérifier si ce que nous observons est un dossier ou un fichier. S'il s'agit d'un fichier nous allons simplement afficher le chemin contenu dans ```[ebp-16]``` suivi du nom du fichier actuel avec ```file_folder_find.cFileName```.
Cependant, s'il s'agit d'un dossier, nous allons d'abord vérifier s'il s'agit de . ou .. que nous n'afficheront pas en utilisant un jump conditionnel. Puis après cette vérification nous irons tout d'abord appeler l'affichage du dossier actuellement avec son chemin avant de nous préparer à l'appel récursif. Pour l'appel récursif nous allons construire le chemin à passé à la fonction avec ```[ebp-16]``` et en le copiant dans ```[ebp-8]``` que nous auront allouer sur le moment avec ```invoke GlobalAlloc```. Nous allons ensuite concaténer ```[ebp-8]``` avec ```file_folder_find.cFileName``` pour créer le nouveau chemin et l'utiliser pour appeler récursivement la fonction avec ```push [ebp-8]``` puis ```call DIR_REC```. Après ceci, nous aurons juste a reboucler au début de la boucle qui vérifiera après avoir fait un ```FindNextFile``` s'il reste encore des dossier ou fichier à parcourir et si non quittera la fonction.

De plus, nous avons utiliser ```add esp, X*4``` X étant le nombre de paramètre que nous avons push sur la pile, afin de nettoyer la pile des toutes informations plus nécessaire. Nous n'avions pas fait ceci lors du TP car nos fonction était relativement courte et n'appellais pas beaucoup d'autre fonction mais ici nous avons beaucoup d'appel, et nous avons jugé important de nettoyer la pile. 

## Conclusion

    Ce projet a été mené en collaboration avec le groupe de Laisné Clément et Sevaux Jean pour des raisons de manque de temps. Malgré cette coopération nous n'avons quand même pas eu assez de temps pour réaliser la totalité du projet demandé, à savoir qu'il nous manque la partie graphique de l'affichage. Cependant nous sommes quand même content d'avoir réussi à implémenter un DIR récursif en MASM32. Nous aurions aussi peut rajouter dans l'affichage en ligne de commande des tirets pour mieux faire comprendre l'arborescence des fichiers. Ceci pourrait être réalisé en rajoutant une nouvelle variable à la fonction qui serait le niveau de récursivité et servirais à ajouter x fois des tirets devant l'affichage.

