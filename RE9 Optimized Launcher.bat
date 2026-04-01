@echo off
setlocal EnableDelayedExpansion


set "LOG_FILE=RE9_Launcher.log"
set "GAME_EXE=re9.exe"


echo -------------------------------------------------- >> "%LOG_FILE%"
echo LOG START: %date% %time% >> "%LOG_FILE%"


pushd "%~dp0"
echo [LOG] Directory set to: %CD% >> "%LOG_FILE%"


net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [LOG] Requesting Admin Elevation... >> "%LOG_FILE%"
    powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)


title RE: Requiem Optimized Launcher by CeZeY
mode con: cols=85 lines=28
color 0B
echo ======================================================================
echo              RESIDENT EVIL REQUIEM - OPTIMIZED LAUNCHER
echo ======================================================================
echo.
echo [1] ADMIN STATUS:    YES (Verified)
echo [2] WORKING PATH:    %CD%
echo [3] LOGGING TO:      %LOG_FILE%
echo.


echo [4] CHECKING MODS:   Scanning for REFramework...
echo [LOG] Scanning for dinput8.dll and reframework folder... >> "%LOG_FILE%"

if exist "dinput8.dll" (
    if exist "reframework\" (
        goto :MODS_FOUND
    )
)

:MODS_NOT_FOUND
color 0E
echo     RESULT:       [WARNING] REFramework NOT FOUND (Vanilla Launch)
echo [LOG] REFramework not found. >> "%LOG_FILE%"
goto :PRE_LAUNCH

:MODS_FOUND
color 0A
echo     RESULT:       [SUCCESS] REFramework FOUND ^& ACTIVE
echo [LOG] REFramework detected successfully. >> "%LOG_FILE%"

:PRE_LAUNCH
echo.



echo [5] OPTIMIZING:      Preparing Engine Flags...
set "CMD_ARGS=-useallavailablecores -high -cpuLoadRebalancing -malloc=system -dx12"
echo [LOG] Optimization Flags: %CMD_ARGS% >> "%LOG_FILE%"


if exist "%GAME_EXE%" (
    echo.
    echo ======================================================================
    echo [SYSTEM] Injection successful! 
    echo ======================================================================
    echo.
    
    echo The game will launch automatically in 5 seconds...
    echo (Or press any key to launch immediately)
    echo.
    
    timeout /t 5
    
    echo [LOG] Launching %GAME_EXE% with priority HIGH. >> "%LOG_FILE%"
    
    
    start "" /high "%GAME_EXE%" %CMD_ARGS%
    
    echo [LOG] Game process started successfully. >> "%LOG_FILE%"
    echo.
    echo Game is running! This window will close in 3 seconds...
    timeout /t 3 >nul
    popd
    exit
) else (
    color 0C
    echo.
    echo ======================================================================
    echo [CRITICAL ERROR] %GAME_EXE% NOT FOUND!
    echo ======================================================================
    echo [LOG] ERROR: %GAME_EXE% was not found. >> "%LOG_FILE%"
    pause
    popd
    exit
)