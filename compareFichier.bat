@echo off

SET "pathFichier1=%~1"
SET "pathFichier2=%~2"

:: Code éxecuter (main) ::
call :choixFichier1
call :choixFichier2

call :selectNbLigneFichiers 1
call :selectNbLigneFichiers 2

call :compareFichiers

:: Met fin au programme
goto :eof



:: Vérifie si l'argument 1 est valide ::
:choixFichier1
    IF NOT EXIST "%pathFichier1%" (
        :: Demande à l'utilisateur de choisir un fichier 1 valide ::
        echo Veuillez choisir le premier fichier à comparer
        SET /P pathFichier1="Chemin et/ou nom du fichier : "
        goto :choixFichier1
    )
goto :eof


:: Vérifie si l'argument 2 est valide ::
:choixFichier2
    IF NOT EXIST "%pathFichier2%" (
        :: Demande à l'utilisateur de choisir un fichier 1 valide ::
        echo Veuillez choisir le deuxième fichier à comparer
        SET /P pathFichier2="Chemin et/ou nom du fichier : "
        goto :choixFichier2
    )
goto :eof


:: Vérifie si le nom du fichier temporaires existe déjà ::
:selectNbLigneFichiers
    :: Compte le nombre de fichier présent dans le dossier ::
    FOR /f %%i IN ('dir "%cd%" /a:-d ^| find "fichier"') DO SET "nbFichier=%%i"

    :: Vérifie si le fichier existe déjà ::
    FOR /l %%C IN (1, 1, %nbFichier%) DO (
        IF NOT EXIST temp%%C.txt (
            SET "nomFichierTemp=temp%%C.txt"
            goto :nbLigneFichier%~1 %nomFichierTemp%
        )
    )
goto :eof


:: Permet de connaitre le nombre de lignes dans fichier 1 ::
:nbLigneFichier1
    SET "nomFichierTemp1=%~1"
    FIND /v /c "" < %pathFichier1% > %nomFichierTemp1%
    FOR /f "tokens=1 delims=" %%A IN (%nomFichierTemp%) DO SET /a nbLigne=%%A-1
goto :eof

:: Permet de connaitre le nombre de lignes dans fichier 2 ::
:nbLigneFichier2
    SET "nomFichierTemp2=%~1"
    FIND /v /c "" < %pathFichier2% > %nomFichierTemp2%
    FOR /f "tokens=1 delims=" %%A IN (%nomFichierTemp%) DO SET /a nbLigne=%%A-1
goto :eof


:: Boucle pour lire les deux fichiers ligne par ligne ::
:compareFichiers
    call :verifLigne1
    FOR /l %%C IN (1, 1, %nbLigne%) DO (
        call :verifFichier %%C
        echo.
    )
goto :eof


:: Permet de vérifier si les deux fichiers sont identiques et dans le même ordre ::
:verifFichier
    FOR /f "delims= skip=%~1" %%A IN ('type %pathFichier1%') DO (
        FOR /f "delims= skip=%~1" %%B IN ('type %pathFichier2%') DO (
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
    FOR /f "delims=" %%A IN ('type %pathFichier1%') DO (
        FOR /f "delims=" %%B IN ('type %pathFichier2%') DO (
            if %%A EQU %%B (
                echo %%A == %%B
            ) else (
                echo %%A != %%B
            )
            goto :eof
        )
    )
goto :eof


:: Suppressions des fichiers temporaires ::
:suppressionFichierTemp
    del %nomFichierTemp1%
    del %nomFichierTemp2%
goto :eof