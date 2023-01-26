@echo Off
title Ping Servers
color 17
cls
echo **************************
echo * Paul's Batch Ping Test *
echo **************************
echo.

echo Getting Server List...
Set "ServerList=servers.csv"
echo Done
echo.

echo Setting Results Location...
set dt=%DATE:~6,4%_%DATE:~3,2%_%DATE:~0,2%__%TIME:~0,2%_%TIME:~3,2%_%TIME:~6,2%
set dt=%dt: =0%
set LogFile=Results\Results-%dt%.csv
echo Done
echo.

echo Killing OneDrive to prevent sync issues
start "OneDrive" /D "C:\Program Files\Microsoft OneDrive\" OneDrive.exe /shutdown
timeout 3 > NUL
echo Done
echo.

echo Adding Current Connection Details
echo My Current IP Details > %LogFile%
ipconfig|Find "IPv4">>%LogFile%
echo. >> %LogFile%
echo. >> %LogFile%
echo. >> %LogFile%
echo Name                                                                              NetConnectionID               NetConnectionStatus  NetEnabled>> %LogFile%
wmic NIC get Name,NetConnectionID,NetConnectionStatus,NetEnabled | Find "TRUE" >> %LogFile%
echo. >> %LogFile%
echo. >> %LogFile%
echo. >> %LogFile%
echo Done
echo.

echo Running Tests...
echo The first ping test always fails >> %LogFile%
echo Recommend a blank firstline in %ServerList% >> %LogFile%
echo. >> %LogFile%
echo. >> %LogFile%
echo. >> %LogFile%
echo Pass or Fail,IP Address or URL,Description >> %LogFile%
>>"%LogFile%" (For /F "tokens=1-2 delims=," %%A In (%ServerList%) Do Ping -n 1 %%A|Find "TTL=">Nul&&(Echo Pass,%%A,%%B )||Echo FAIL,%%A,%%B )
color 27
echo Done
echo.

echo Starting OneDrive to sync new files
start "OneDrive" /D "C:\Program Files\Microsoft OneDrive\" OneDrive.exe /background
echo Done
echo.

color 20
echo Finished
timeout 3 > NUL
color
