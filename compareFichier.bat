@echo off

SET "pathFichier=donnees\coordonnees.txt"
IF NOT EXIST "%pathFichier%" goto :eof

:: Vérifie si le nom du fichier temporaires existe ::
for /f %%i in ('dir "%pathFichier%" /a:-d ^| find "*.txt"') do echo %%i

goto :eof
::FOR /l %%C IN (1, 1, ) DO (
::IF EXIST temp.txt (
::    
::)

:: Permet de connaitre le nombre de lignes dans fichier ::
FIND /v /c "" < %pathFichier% > temp.txt
FOR /f "tokens=1 delims=" %%A IN (temp.txt) DO SET /a nbLigne=%%A-1
del temp.txt


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