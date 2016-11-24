:: This is script get list process running by user & and echo it

@echo off

:: Logging it all
FOR /F "TOKENS=1* DELIMS= " %%A IN ('DATE/T') DO SET DATE=%%B
FOR /F "TOKENS=1* DELIMS= " %%A IN ('TIME/T') DO SET TIME=%%A
ECHO %DATE% %TIME% %0 >> "..\active-responses.log"

setlocal enabledelayedexpansion
set fileP=list_process.data
set username=%1

:: List process running by user to file
TASKLIST /FI "USERNAME qe %username%" /FI "STATUS eq running" /FO:list > %fileP%

:: Read data from file to array (process)
set /A i=0
set /A k=1
for /F "usebackq delims=" %%a in (%fileP%) do (
    set /A sum=!i! * 5 + 1
    if !k!==!sum! (
        set s=%%a
        call set array[%%i%%]=!s:~14!
        set /A i+=1
    )
    set /A k+=1
)
set /A n=%i%-1

:: Print array process
for /L %%i in (0,1,%n%) do call echo %%array[%%i]%%

del %fileP%

