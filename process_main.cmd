:: This is main script for process
@echo off
echo.

:: Logging it all
FOR /F "TOKENS=1* DELIMS= " %%A IN ('DATE/T') DO SET DATE=%%B
FOR /F "TOKENS=1* DELIMS= " %%A IN ('TIME/T') DO SET TIME=%%A

ECHO %DATE% %TIME% %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 >> "active-response\active-responses.log"

IF "%1"=="add" GOTO ADD

IF "%1"=="delete" GOTO DEL

:ERROR
ECHO "Invalid argument. %1"
GOTO Exit;

:ADD
:: Get list process running by user & save to file
cd active-response\bin\
set "file_pr=win_process\data\process_running.txt"
call process_get_process_running.cmd %2 > %file_pr%

:: Get list executable path of process running by user & save to file
set "file_tempexepath=win_process\data\temp_process_executablepath.txt"
set "file_exepath=win_process\data\process_executablepath.txt"

call process_get_executablepath.cmd %file_pr% > %file_tempexepath%

if exist %file_exepath% del %file_exepath%

setlocal enabledelayedexpansion
set str_old=""
for /F "usebackq delims=" %%a in (%file_tempexepath%) do (
	set str_new=%%a
	if /I !str_new! NEQ !str_old! echo !str_new! >> %file_exepath%
	set str_old=%%a
)
del %file_tempexepath%

:: Compare Executable path with ACL
set "file_pid=win_process\data\process_id_tokill.txt"
call process_apply_acl.cmd %file_exepath% >> ..\active-responses.log
goto Exit;

:DEL

:Exit
