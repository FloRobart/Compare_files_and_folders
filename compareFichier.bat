@echo off

SET "pathFichier1=%~1"
SET "pathFichier2=%~2"

:choixFichier1
IF NOT EXIST "%pathFichier1%" (
    :: Demande à l'utilisateur de choisir un fichier 1 valide
    echo Veuillez choisir le premier fichier à comparer
    SET /P pathFichier1="Chemin et/ou nom du fichier : "
    goto :choixFichier1
)

:choixFichier2
IF NOT EXIST "%pathFichier2%" (
    :: Demande à l'utilisateur de choisir un fichier 1 valide
    echo Veuillez choisir le deuxième fichier à comparer
    SET /P pathFichier2="Chemin et/ou nom du fichier : "
    goto :choixFichier2
)


:: Compte le nombre de fichier présent dans le dossier ::
FOR /f %%i IN ('dir "%cd%" /a:-d ^| find "fichier"') DO SET "nbFichier=%%i"


:: Vérifie si le nom du fichier temporaires existe déjà ::
FOR /l %%C IN (1, 1, %nbFichier%) DO (
    IF NOT EXIST temp%%C.txt (
        SET "nomFichierTemp=temp%%C.txt"
        goto :passerBoucle
    ) else (
        echo le fichier existe deja
    )
)
:passerBoucle

goto :eof
:: Permet de connaitre le nombre de lignes dans fichier ::
FIND /v /c "" < %pathFichier% > %nomFichierTemp%
FOR /f "tokens=1 delims=" %%A IN (%nomFichierTemp%) DO SET /a nbLigne=%%A-1
del %nomFichierTemp%


:: Boucle pour lire les deux fichiers ligne par ligne ::
call :verifLigne1
FOR /l %%C IN (1, 1, %nbLigne%) DO (
    call :verifFichier %%C
    echo.
)
goto :eof


:: Permet de vérifier si les deux fichiers sont identiques et dans le même ordre ::
:verifFichier
echo %~1
FOR /f "delims= skip=%~1" %%A IN ('type .\donnees\coordonnees.txt') DO (
    FOR /f "delims= skip=%~1" %%B IN ('type .\donnees\coordonnees.txt') DO (
        if %%A EQU %%B (
            echo %%A == %%B
        ) else (
            echo %%A != %%B
        )
        goto :eof
    )
)
goto :eof


:: Permet de vérifier la première ligne du fichier ::
:verifLigne1
FOR /f "delims=" %%A IN ('type .\donnees\coordonnees.txt') DO (
    FOR /f "delims=" %%B IN ('type .\donnees\coordonnees.txt') DO (
        if %%A EQU %%B (
            echo %%A == %%B
        ) else (
            echo %%A != %%B
        )
        goto :eof
    )
)
goto :eof