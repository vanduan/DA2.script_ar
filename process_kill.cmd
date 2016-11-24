:: This is script to kill process

@echo off

set "exepath=%1"
setlocal enabledelayedexpansion

:: Logging it all
FOR /F "TOKENS=1* DELIMS= " %%A IN ('DATE/T') DO SET DATE=%%B
FOR /F "TOKENS=1* DELIMS= " %%A IN ('TIME/T') DO SET TIME=%%A
ECHO %DATE% %TIME% %0 %1>> "win_process\log"

:: input: C:\Users\abc\app.exe
:: output: app.exe
set exepath=%exepath:\= %
set "username=vanduan"
for %%a in (%exepath%) do set name=%%a
wmic process where name="%name%" get ProcessId | more | findstr "[0-9]" > %temp%\temp.txt

set /A i=0
for /F "usebackq delims=" %%c in (%temp%\temp.txt) do (
	set a=%%c
	set /A a=!a: =!
	call set brray[%%i%%]=!a!
	set /A i+=1
)
del %temp%\temp.txt
set /A n=%i%-1
for /L %%i in (0,1,%n%) do (
	echo                   kill process ID: !brray[%%i]%! >> "win_process\log"
	call taskkill /PID %%brray[%%i]%% /f >> "win_process\log"
)

