:: This script to send mail
@echo off

set subject=%1
set body=%2

:: Logging it all
FOR /F "TOKENS=1* DELIMS= " %%A IN ('DATE/T') DO SET DATE=%%B
FOR /F "TOKENS=1* DELIMS= " %%A IN ('TIME/T') DO SET TIME=%%A
ECHO %DATE% %TIME% %0 :%1 :%2>> "win_process\log"

:: Config default for mail
SET "mserver=smtp.gmail.com:587"
SET "msender=ossec.iuh@gmail.com"
SET "mpasswd=123@123@123"
SET "mto=ossec.iuh@gmail.com"

rem Send mail
CALL SENDEMAIL -o tls=yes -f %msender% -t %mto% -s %mserver% -xu %msender% -xp %mpasswd% -u "%subject%" -m "%body%" >> "..\active-responses.log"
