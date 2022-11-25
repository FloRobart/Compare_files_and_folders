@echo off

::======================::
:: Code éxecuter (main) ::
::======================::
SETLOCAL enabledelayedexpansion
    :: Variable ::
    SET "sRet=msgbox"


    :: Compte le nombre d'argument passer en paramètre de la fonction ::
    FOR %%i IN (%*) DO SET /a nbArgument+=1

    :: Si le nombre d'argument est inférieur à 2, on demande à l'utilisateur combien de dossier il veut comparer ::
    IF "%nbArgument%" LSS "2" SET /p "nbArgument=Combien de dossier voulez-vous comparer ? : "

    :: Définition des variables %%pathDossier%% ::
    FOR %%i IN (%*) DO (
        SET /a "count+=1"
        SET "pathDossier!count!=%%i"
    )

    :: Vérifie que les dossiers existe et sont valides ::
    FOR /l %%i IN (1, 1, %nbArgument%) DO call :choixDossierSource %%i
    :: Nomme les fichiers temporaires ::
    ::FOR /l %%i IN (1, 1, %nbArgument%) DO call :nomFichierTemp %%i
    :: Compte le nombre de dossier présent dans les dossiers sources ::
    FOR /l %%i IN (1, 1, %nbArgument%) DO call :nbDossierInSource %%i

    :: Compare le nombre de dossier présent dans les dossiers sources ::
    FOR /l %%a IN (1, 1, %nbArgument%) DO (
        FOR /l %%b IN (1, 1, %nbArgument%) DO (
            IF %%b GTR %%a (
                IF !nbDossierInSource%%a! EQU !nbDossierInSource%%b! (
                    SET sRet=%sRet% "Il y a %nbDossierInSource%%%a dans le dossier ""!pathDossier%%a!"" et dans le dossier ""!pathDossier%%b!"" ^& vbCRLF ^& "
                ) else (
                    SET sRet=%sRet% "Il y a %nbDossierInSource%%%a dans le dossier ""!pathDossier%%a!"" et %nbDossierInSource%%%b dans le dossier ""!pathDossier%%b!"" ^& vbCRLF ^& "
                )
            )
        )
    )

    :: Afficher le résultat du nombre de dossier dans les dossiers sources ::
    call :afficherResultat 1


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
        IF NOT EXIST "temp%%C.%~2" (
            SET "nomFichierTemp%~1=temp%%C.%~2"
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



::--------------------------------------------------------------------::
:: Affiche le résultat du nombre de dossier dans les dossiers sources ::
::--------------------------------------------------------------------::
:afficherResultat
    call :nomFichierTemp %~1 "vbs"
    echo %sRet% > "!nomFichierTemp%~1!"
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