@echo Off
title Batch Ping
color 17
cls
echo *******************
echo * Batch Ping Test *
echo *******************
echo.

echo WARNING
echo This will overwrite the results file results.csv
pause

:: Added some echos for each step to help identify any issues

:: If error retrieving this file, check it's not open
:: Excel stops access
echo Getting Server List...
Set "ServerList=servers.csv"
echo Done

:: Same again, make sure it's not open in Excel
echo Setting Results Location...
Set "LogFile=results.csv"
echo Done

echo Running Tests...
If Not Exist "%ServerList%" Exit /B
>"%LogFile%" (For /F "tokens=1-2 delims=," %%A In (%ServerList%
) Do Ping -n 1 %%A|Find "TTL=">Nul&&(Echo %%A,%%B,Pass)||Echo %%A,%%B,FAILED)
color 27
echo Done
pause
