@echo off

::======================::
:: Code éxecuter (main) ::
::======================::
SETLOCAL enabledelayedexpansion
    :: Variable ::
    SET "sRetNbSousDossier=msgbox"

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

    :: Compte le nombre de dossier présent dans les dossiers sources ::
    FOR /l %%i IN (1, 1, %nbArgument%) DO call :nbDossierInSource %%i


    ::fonction nbSousDossier potentiellement inutile
    call :nbSousDossier


    :: Affiche le nombre de dossier présent dans les dossiers sources ::
    call :nomFichierTemp 1 "vbs"
    echo !sRetNbSousDossier! > !nomFichierTemp1!
    call !nomFichierTemp1!


    :: Compare le contenue des fichiers dans les dossiers sources ::
    call :compareDossier


    call :suppressionFichierTemp
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
        goto :choixDossierSource %~1
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



::---------------------------------------------------------------::
:: Compte le nombre de fichiers qu'il y a dans le dossier source ::
::---------------------------------------------------------------::
:: Inutiliser
:nbFichierInSource
    SET /a "nbFichierInSource%~1=0"
    FOR /f %%i IN ('dir "!pathDossier%~1!" /b /a-d') DO SET /a "nbFichierInSource%~1+=1"
goto :eof



::---------------------------------------------------------------::
:: Détermine le nombre de sous dossier dans les dossiers sources ::
::---------------------------------------------------------------::
:nbSousDossier
    FOR /l %%i IN (1, 1, !nbArgument!) DO (
        SET "sRetNbSousDossier=!sRetNbSousDossier! """!pathDossier%%i!"" contient !nbDossierInSource%%i! sous dossiers""
        IF %%i LSS !nbArgument! SET "sRetNbSousDossier=!sRetNbSousDossier! ^& vbCRLF ^&"
    )
goto :eof



::---------------------------::
:: Compare les deux dossiers ::
::---------------------------::
:compareDossier
    :: Selectionne les deux fichiers à comparer ::
    FOR /f %%A IN ('dir "!pathDossier1!" /a-d /b /o:GEN') DO (
        FOR /f %%B IN ('dir "!pathDossier2!" /a-d /b /o:GEN') DO (
            call :compareDeuxFichiers "!pathDossier1!\%%A" "!pathDossier2!\%%B"
        )
    )
goto :eof







::==============================================::
:: Fonction qui compare deux fichiers entre eux ::
::==============================================::
:compareDeuxFichiers
    SET "pathFichier1=%~1"
    SET "pathFichier2=%~2"
    SET "nbLigneFichier1="
    SET "nbLigneFichier2="

    SET /a "nbDifferenceFichiers=0"


    call :choixFichierSource 1
    call :choixFichierSource 2

    :: Compte le nombre de ligne dans le fichier 1 ::
    call :nomFichierTemp 2 "txt"
    call :nbLigneFichier 1 2

    :: compte le nombre de ligne dans le fichier 2 ::
    call :nomFichierTemp 3 "txt"
    call :nbLigneFichier 2 3



    :: Compare le nombre de ligne des deux fichiers ::
    SET "msgFichierDiff=msgbox "
    if "%nbLigneFichier1%" EQU "%nbLigneFichier2%" (
        :: Compare le contenue des deux fichiers ::
        call :compareFichiers
    ) else (
        SET msgFichierDiff=%msgFichierDiff%"Le nombre de ligne des deux fichiers sont différentes ""%pathFichier1%"" = %nbLigneFichier1% Lignes ""%pathFichier2%"" = %nbLigneFichier2% Lignes"
    )

    :: Affiche le résultat de la comparaison ::
    if "%nbDifferenceFichiers%" EQU "0" (
        ECHO "le contenue des fichiers ""%pathFichier1%"" et ""%pathFichier2%"" sont IDENTIQUES"
    ) else (
        echo %msgFichierDiff%"il y a %nbDifferenceFichiers% lignes DIFFERENTES entre les fichiers ""%pathFichier1%"" et ""%pathFichier2%"
    )

    call :suppressionFichierTemp
:: Met fin à la comparaison des fichiers passé en paramètre ::
goto :eof



:: Vérifie si l'argument est valide ::
:choixFichierSource
    IF NOT EXIST "!pathFichier%~1!" (
        call :nomFichierTemp 4 "vbs"
        echo msgbox "Un problème est survenue, ""!pathFichier%~1!"" n'existe pas", vbOkOnly+vbCritical, "Erreur" > !nomFichierTemp4!
        call !nomFichierTemp4!
        call :suppressionFichierTemp
        exit /b 1
    )
goto :eof



:: Permet de connaitre le nombre de lignes dans les fichiers ::
:nbLigneFichier
    FIND /v /c "" < "!pathFichier%~1!" > "!nomFichierTemp%~2!" 
    FOR /f "tokens=1 delims=" %%A IN (!nomFichierTemp%~2!) DO SET /a "nbLigneFichier%~1=%%A"
goto :eof


:: Boucle pour lire les deux fichiers ligne par ligne ::
:compareFichiers
    call :verifFichier "delims=" 0
    FOR /l %%C IN (1, 1, !nbLigneFichier1!) DO (
        call :verifFichier "delims= skip=%%C" %%C
        SET "rien="
    )
goto :eof


:: Permet de vérifier si les deux fichiers sont identiques et dans le même ordre ::
:verifFichier
    FOR /f "%~1" %%A IN ('type "!pathFichier1!"') DO (
        FOR /f "%~1" %%B IN ('type "!pathFichier2!"') DO (
            if NOT "%%A" EQU "%%B" (
                SET /a "nbDifferenceFichiers+=1"
            )
            goto :eof
        )
    )
goto :eof


:: Suppressions des fichiers temporaires ::
:suppressionFichierTemp
    IF EXIST "!nomFichierTemp1!" del "!nomFichierTemp1!"
    IF EXIST "!nomFichierTemp2!" del "!nomFichierTemp2!"
    IF EXIST "!nomFichierTemp3!" del "!nomFichierTemp3!"
    IF EXIST "!nomFichierTemp4!" del "!nomFichierTemp4!"
goto :eof