@echo off
SETLOCAL enabledelayedexpansion

SET "pathDossier1=%~1"
SET "pathDossier2=%~2"

::======================::
:: Code éxecuter (main) ::
::======================::
FOR /l %%i IN (1, 1, 2) DO call :choixDossierSource %%i
FOR /l %%i IN (1, 1, 2) DO call :nomFichierTemp %%i
FOR /l %%i IN (1, 1, 2) DO call :nbDossierInSource %%i



::call :compareDossiers

ENDLOCAL
:: Met fin au programme ::
goto :eof



::----------------------------------::
:: Vérifie si l'argument est valide ::
::----------------------------------::
:choixDossierSource
    IF NOT EXIST "!pathDossier%~1!" (
        :: Demande à l'utilisateur de choisir un dossier 1 valide ::
        IF %~1==1 (
            SET /P "pathDossier%~1=Veuillez choisir le chemin et/ou le nom du 1er dossier à comparer : "
        ) ELSE (
            SET /P "pathDossier%~1=Veuillez choisir le chemin et/ou le nom du %~1ème dossier à comparer : "
        )
        call :choixDossierSource %~1
    )
goto :eof



::------------------------------------------------------::
:: Vérifie si le nom du fichier temporaires existe déjà ::
::------------------------------------------------------::
:: Vérifie si le nom du fichier temporaires existe déjà ::
:nomFichierTemp
    :: Compte le nombre de fichier présent dans le dossier ::
    FOR /f %%i IN ('dir "%cd%" /b /a-d') DO SET /a "nbFichier+=1"

    :: Vérifie si le fichier existe déjà ::
    FOR /l %%C IN (1, 1, %nbFichier%) DO (
        IF NOT EXIST "temp%%C.txt" (
            SET "nomFichierTemp%~1=temp%%C.txt"
            goto :eof
        )
    )
goto :eof



::---------------------------------------------------------------::
:: Compte le nombre de dossiers qu'il y a dans le dossier source ::
::---------------------------------------------------------------::
:nbDossierInSource
    SET /a "nbDossierInSource%~1=0"
    FOR /f %%i IN ('dir "!pathDossier%~1!" /b /ad') DO SET /a "nbDossierInSource%~1+=1"
goto :eof




::---------------------------::
:: Compare les deux dossiers ::
::---------------------------::
:compareDossiers
    :: Selectionne les deux fichiers à comparer ::
    FOR /f %%A IN ('dir "!pathDossier1!" /a /b /o:GEN') DO & SET "nbFichier=%%A"
    (
        FOR /f %%B IN ('dir "!pathDossier2!" /a /b /o:GEN') DO & SET "nbFichier=%%B" (

        )
    )
goto :eof