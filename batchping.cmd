@echo off
setlocal EnableDelayedExpansion
title Ping Servers
cls
echo **************************
echo * Paul's Batch Ping Test *
echo **************************
echo.
echo Running...

:: Killing OneDrive to prevent sync issues
start "OneDrive" /D "C:\Program Files\Microsoft OneDrive\" OneDrive.exe /shutdown
timeout 3 > NUL

:: Get the current date and time in the format YYYYMMDD-HHMM
set "year=%date:~6,4%"
set "month=%date:~3,2%"
set "day=%date:~0,2%"
set "hour=%time:~0,2%"
set "minute=%time:~3,2%"
if not exist Results mkdir Results
set "filename=Results\Results-%year%%month%%day%-%hour%%minute%.csv"

:: Set the input and output file names
set "input_file=addresses.csv"
set "output_file=%filename%"

:: Count the number of lines in the input file
set "line_count=0"
for /f "tokens=1" %%a in ('type "%input_file%" ^| find /v /c ""') do set "line_count=%%a"
echo Number of lines in %input_file%: %line_count%

:: Adding current IPv4s for this device
echo IPv4 Addresses>>%output_file%
for /f "tokens=2 delims=:" %%a in ('ipconfig^|find "IPv4 Address"') do (
    set "ip=%%a"
    echo !ip:~1!>>%output_file%
)
echo.>>%output_file%
echo.>>%output_file%

:: Adding currently used network devices
echo Network Devices in use>>%output_file%
for /f "tokens=1 delims=" %%a in ('wmic NIC get Name^,NetEnabled ^| find "TRUE"') do (
    set "device=%%a"
    set "device=!device:TRUE=!"
    set "device=!device:  =!"
    echo !device!>>%output_file%
)
echo.>>%output_file%
echo.>>%output_file%

:: Write the header to the output file
echo Status,Address,Description >> "%output_file%"

:: Loop through each line in the input file
set "counter=0"
set "pass_count=0"
set "fail_count=0"
for /f "tokens=1,2 delims=," %%a in (%input_file%) do (
    set /a "counter+=1"
    set "address=%%a"
    set "description=%%b"

    :: Ping the address and write the result to the output file
    ping -n 1 !address! >nul
    if errorlevel 1 (
        echo FAIL,!address!,!description! >> "%output_file%"
        set /a "fail_count+=1"
    ) else (
        echo Pass,!address!,!description! >> "%output_file%"
        set /a "pass_count+=1"
    )

    :: Print a message to the console indicating the progress
    echo Processed !counter! of %line_count% lines. Pass-!pass_count! Fail-!fail_count!
)

:: Restarting OneDrive
start "OneDrive" /D "C:\Program Files\Microsoft OneDrive\" OneDrive.exe /background

:: Print a message to the console indicating where the results were saved
echo Results saved in %output_file%
timeout 3 > NUL
