@echo off

SETLOCAL enabledelayedexpansion

SET "pathFichier1=%~1"
SET "pathFichier2=%~2"
SET /a "nbLigne=0"


:: Code éxecuter (main) ::
call :choixFichier 1
call :choixFichier 2

call :nomFichierTemp 1
goto :eof
call :nomFichierTemp 2


call :compareFichiers

ENDLOCAL
:: Met fin au programme
goto :eof



:: Vérifie si l'argument est valide ::
:choixFichier
    IF NOT EXIST "!pathFichier%~1!" (
        :: Demande à l'utilisateur de choisir un fichier 1 valide ::
        IF %~1==1 (
            SET /P "pathFichier%~1=Veuillez choisir le chemin et/ou le nom du premier fichier à comparer : "
        ) ELSE (
            SET /P "pathFichier%~1=Veuillez choisir le chemin et/ou le nom du deuxième fichier à comparer : "
        )
        goto :choixFichier %~1
    )
goto :eof


:: Vérifie si le nom du fichier temporaires existe déjà ::
:nomFichierTemp
    :: Compte le nombre de fichier présent dans le dossier ::
    FOR /f %%i IN ('dir "%cd%" /a:-d ^| find "fichier"') DO SET "nbFichier=%%i"

    :: Vérifie si le fichier existe déjà ::
    FOR /l %%C IN (1, 1, %nbFichier%) DO (
        IF NOT EXIST temp%%C.txt (
            SET "nomFichierTemp%~1=temp%%C.txt"
            call :nbLigneFichier %~1
            goto :eof
        )
    )
goto :eof


:: Permet de connaitre le nombre de lignes dans les fichiers ::
:nbLigneFichier
    echo %~1
    echo !nomFichierTemp%~1!
    echo !pathFichier%~1!
    FIND /v /c "" < "!pathFichier%~1!" > "!nomFichierTemp%~1!"
    FOR /f "tokens=1 delims=" %%A IN (!nomFichierTemp%~1!) DO SET /a !nbLigne!=%%A-1
goto :eof


:: Boucle pour lire les deux fichiers ligne par ligne ::
:compareFichiers
    call :verifLigne1
    FOR /l %%C IN (1, 1, !nbLigne!) DO (
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