:: This is script to apply acl

@echo off

setlocal enabledelayedexpansion

set "username=vanduan"
set file_exepath=%1
set "file_acl=win_process\acl\%username%.acl"

:: Logging it all
FOR /F "TOKENS=1* DELIMS= " %%A IN ('DATE/T') DO SET DATE=%%B
FOR /F "TOKENS=1* DELIMS= " %%A IN ('TIME/T') DO SET TIME=%%A
ECHO %DATE% %TIME% %0 >> "..\active-responses.log"

::
if not exist %file_acl% (
	echo %DATE% %TIME% %0: ACL for user %username% doesn't exist!!! >> ..\active-responses.log
	call :Exit
)

:: file acl to array
set /A i=0
for /F "usebackq delims=" %%a in (%file_acl%) do (
	set s=%%a
	call set array[%%i%%]=!s: =!
	set /A i+=1
)
set /A na=%i%-1

:: file executable path to array
set /A j=0
for /F "usebackq delims=" %%c in (%file_exepath%) do (
	set s=%%c
	call set brray[%%j%%]=!s: =!
	set /A j+=1
)
set /A nb=%j%-1

:: do compare
for /L %%j in (0,1,%nb%) do (
	set /A iskill=1
	call :inner !brray[%%j]!
	if !iskill!==1 (
		:: do kill process
		process_kill.cmd !brray[%%j]!
	)
)
call :Exit

:inner
for /L %%i in (0,1,%na%) do (
	if /I "%1" EQU "!array[%%i]!" (
		set /A iskill=0
		goto :break
	)
)

:break
goto :eof


:Exit