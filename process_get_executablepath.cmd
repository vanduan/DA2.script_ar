:: This is script get list executable path of process running by user & save to file

@echo off
echo.

:: Logging it all
FOR /F "TOKENS=1* DELIMS= " %%A IN ('DATE/T') DO SET DATE=%%B
FOR /F "TOKENS=1* DELIMS= " %%A IN ('TIME/T') DO SET TIME=%%A
ECHO %DATE% %TIME% %0 >> "..\active-responses.log"

:: check file process running is exist?
setlocal enabledelayedexpansion
set fileP=%1
if not exist %fileP% (
	echo "%DATE% %TIME% %0: File data '%fileP%' doesn't exist" >> "..\active-responses.log"
	goto Exit;
)

:: file to array
set /A i=0
for /F "usebackq delims=" %%a in (%fileP%) do (
    call set array[%%i%%]=%%a
    set /A i+=1
)
set /A n=%i%-1

:: use wmic get executable path
for /L %%i in (0,1,%n%) do (
	call wmic process where name="%%array[%%i]%%" get ExecutablePath /format:list | more >> temp_path.txt
)
for /F "usebackq delims=" %%a in (temp_path.txt) do (
    set s=%%a
	set s=!s:~15!
	if "!s!" NEQ "" (
		call echo !s:~0,-1! >> temp_path_new.txt
	)
)
del temp_path.txt
set /A i=0
for /F "usebackq delims=" %%a in (temp_path_new.txt) do (
    call set brray[%%i%%]=%%a
    set /A i+=1
)
set /A n=%i%-1
for /L %%i in (0,1,%n%) do call echo %%brray[%%i]:~0,-1%%

del temp_path_new.txt
call :Exit
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:Exit