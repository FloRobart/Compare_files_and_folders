@echo off
SETLOCAL enabledelayedexpansion

:: Code éxecuter (main) ::
FOR /f %%i IN ('dir "%cd%" /a:-d ^| find "fichier"') DO SET "nbFichier=%%i"

ENDLOCAL
:: Met fin au programme ::
goto :eof