@echo off
REM Batch script to look up and locate IP addresses with detailed information

REM Display the initial screen
echo ==========================================================
echo                 kiyo's IP Locator :3
echo ==========================================================

REM Check if curl is installed
where curl >nul 2>nul
if errorlevel 1 (
    echo curl is not installed. Please install curl to use this script.
    pause
    exit /b
)

REM Fetch and display user's IP and ISP information
echo ==========================================================
echo Your IP and ISP Information:
echo ==========================================================
curl -s ipinfo.io

:input
echo ==========================================================
set /p hostname=Enter the hostname to look up the IP address: 
echo ==========================================================

REM Check if the user has entered a hostname
if "%hostname%"=="" (
    echo No hostname entered. Exiting...
    goto :end
)

REM Perform the nslookup
echo Looking up IP address for %hostname%...
for /f "tokens=2 delims=: " %%A in ('nslookup %hostname% ^| find "Address"') do set ip=%%A

REM Trim whitespace from IP address
set ip=%ip: =%

REM Check if the IP address is empty
if "%ip%"=="" (
    echo Failed to resolve IP address for %hostname%. Exiting...
    goto :end
)

REM Fetch detailed information using ipinfo.io
echo Fetching detailed information for IP address %ip%...
curl -s ipinfo.io/%ip%

REM Check if the user wants to look up another hostname
set /p another=Do you want to look up another hostname? (yes/no): 
if /i "%another%"=="yes" (
    goto :input
) else (
    echo Exiting...
)

:end
pause
