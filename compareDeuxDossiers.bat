@echo off
SETLOCAL enabledelayedexpansion

:: Compte le nombre d'argument passer en paramètre de la fonction ::
FOR %%i IN (%*) DO SET /a nbArgument+=1
IF %nbArgument% LSS 2 SET /a "nbArgument=2"
echo %nbArgument%

FOR %%i IN (%*) DO (
    SET /a "nbArgument+=1"
    SET "pathDossier!count!=%%i"
    echo %%i
)
echo %pathDossier!count!%
echo %pathDossier2%
echo %pathDossier3%

::SET "pathDossier1=%~1"
::SET "pathDossier2=%~2"
SET "sRet="

::======================::
:: Code éxecuter (main) ::
::======================::
FOR /l %%i IN (1, 1, %nbArgument%) DO call :choixDossierSource %%i
FOR /l %%i IN (1, 1, %nbArgument%) DO call :nomFichierTemp %%i
FOR /l %%i IN (1, 1, %nbArgument%) DO call :nbDossierInSource %%i

FOR /l %%a IN (1, 1, %nbArgument%) DO (
    FOR /l %%b IN (1, 1, %nbArgument%) DO (
        IF %%b GTR %%a (
            IF !nbDossierInSource%%a! EQU !nbDossierInSource%%b! (
                echo "Le nombre de dossier dans le dossier !pathDossier%%a! est identique au nombre de dossier dans le dossier !pathDossier%%b!"
            ) else (
                echo "Le nombre de dossier dans le dossier !pathDossier%%a! est différent du nombre de dossier dans le dossier !pathDossier%%b!"
            )
        )
    )
)



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