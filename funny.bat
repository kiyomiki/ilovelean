@echo off

echo ==========================================================
echo                 kiyo's IP Locator :3
echo ==========================================================

where curl >nul 2>nul
if errorlevel 1 (
    echo curl is not installed. Please install curl to use this script.
    pause
    exit /b
)

echo ==========================================================
echo Your IP and ISP Information:
echo ==========================================================
curl -s ipinfo.io

:input
echo ==========================================================
set /p hostname=Enter the hostname to look up the IP address: 
echo ==========================================================

if "%hostname%"=="" (
    echo No hostname entered. Exiting...
    goto :end
)

echo Looking up IP address for %hostname%...
for /f "tokens=2 delims=: " %%A in ('nslookup %hostname% ^| find "Address"') do set ip=%%A

set ip=%ip: =%

if "%ip%"=="" (
    echo Failed to resolve IP address for %hostname%. Exiting...
    goto :end
)

echo Fetching detailed information for IP address %ip%...
curl -s ipinfo.io/%ip%

set /p another=Do you want to look up another hostname? (yes/no): 
if /i "%another%"=="yes" (
    goto :input
) else (
    echo Exiting...
)

:end
pause
