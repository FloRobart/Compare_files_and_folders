@echo off
SETLOCAL enabledelayedexpansion

SET "pathDossier1=%~1"
SET "pathDossier2=%~2"


:: Code éxecuter (main) ::
FOR /f %%i IN ('dir "pathDossier1" /a:-d') DO echo %%i & SET "nbFichier=%%i"

ENDLOCAL
:: Met fin au programme ::
goto :eof