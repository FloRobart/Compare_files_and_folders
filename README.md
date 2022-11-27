# Script permettant de comparer deux fichiers ou plusieurs dossiers

1. Comparer deux fichiers
    * Lancement du script
        * Interface graphique Windows
        * Terminal Windows
2. Comparer plusieurs dossiers
    * Lancement du script
        * Interface graphique Windows
        * Terminal Windows


## 1. Comparer deux fichiers
Ce script permet de comparer le contenu de deux fichiers en ignorant le nom de ces derniers.


### Lancement du script
Pour lancer le script, il existe deux solutions, la première via l'interface graphique de Windows et la deuxième via un terminal (invite de commande/CMD). Il n'y a aucune réelle différence entre les deux méthodes si ce n'est que c'est plus rapide de passer par l'interface graphique Windows.


#### Interface graphique Windows
Après l'avoir téléchargé double-cliquer sur le script puis suivez les instructions qui vous seront données par le script.


#### Terminal Windows
Après avoir téléchargé le script, ouvrez le gestionnaire de fichier dans le répertoire où se trouve ce dernier puis écrivez dans la barre en haut CMD ou PowerShell. Il est conseillé d'ouvrir un CMD.

Illustration pour ouvrir un CMD ou un PowerShell
![](./img/cmd.png "Illustration pour ouvrir un CMD ou un PowerShell")

Si vous ouvrez PowerShell écrivez `./compareDeuxFichiers.bat [argument]` dans ce dernier. Si vous ouvrez un CMD écrivez `compareDeuxFichiers.bat [argument]`

Pour lancer le script avec et des arguments, il faut écrire `compareDeuxFichiers.bat "cheminFichier1/nomFichier1.extention" "cheminFichier2/nomFichier2.extention"`.
Tous les arguments après le deuxième seront ignorés.
Pour le lancer sans argument, il faut simplement écrire `compareDeuxFichiers.bat`, puis suivre les instructions données par le script


## 2. Comparer des dossiers
Ce script permet de comparer le contenu des fichiers et le nombre de sous-dossiers présents dans les dossiers qui sont passés en argument du script.

### Lancement du script
Pour lancer le script, il existe deux solutions, la première via l'interface graphique de Windows et la deuxième via un terminal (invite de commande/CMD). Il n'y a aucune réelle différence entre les deux méthodes si ce n'est que c'est plus rapide de passer par l'interface graphique Windows.


#### Interface graphique Windows
Après l'avoir téléchargé double-cliquer sur le script puis suivez les instructions qui vous seront données par le script.


#### Terminal Windows
Après avoir téléchargé le script, ouvrez le gestionnaire de fichier dans le répertoire où se trouve ce dernier puis écrivez dans la barre en haut CMD ou PowerShell. Il est conseillé d'ouvrir un CMD.

Illustration pour ouvrir un CMD ou un PowerShell
![](./img/cmd.png "Illustration pour ouvrir un CMD ou un PowerShell")

Si vous ouvrez PowerShell écrivez `./compareDossiers.bat [argument]` dans ce dernier. Si vous ouvrez un CMD écrivez `compareDossiers.bat [argument]`

Pour lancer le script avec et des arguments, il faut écrire `compareDossiers.bat "cheminDossier1" "cheminDossier2" "cheminDossier3"`. Il est bon de noter que vous pouvez comparer autant de dossiers que vous voulez mai plus il y en aura plus le traitement prendra de temps.
Pour le lancer sans argument, il faut simplement écrire `compareDossiers.bat`, puis suivre les instructions données par le script.
