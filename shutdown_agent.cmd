:: Script to send mail alert and shutdown computer
@ECHO OFF
ECHO.
set "username=%2"

:: Logging it all
FOR /F "TOKENS=1* DELIMS= " %%A IN ('DATE/T') DO SET DATE=%%B
FOR /F "TOKENS=1* DELIMS= " %%A IN ('TIME/T') DO SET TIME=%%A

ECHO %DATE% %TIME% %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 >> "..\active-responses.log"

IF "%1"=="add" GOTO ADD

IF "%1"=="delete" GOTO DEL

:ERROR
ECHO "Invalid argument. %1"
GOTO Exit;


:ADD
:: Send mail alert
:: read mail configure from file

cd active-response\bin
sendmail.cmd "Mail alert from active response: %computername%: %username%" "Detail: Rule id 100620: A new process has been created not_in_work_time: %DATE% %TIME%" >> "..\active-responses.log"

rem Shutdown PC in 10 seconds
call SHUTDOWN -s -t 10 -c "Vi pham chinh sach cua cong ty. Lien he Administrator de biet them chi tiet"
GOTO Exit;

:DEL

:Exit