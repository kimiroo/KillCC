@echo off

rem Adobe CC Junk Process Killer
rem ver. 20-07-14_v03

rem KillCC.bat

rem Initialize
setlocal EnableExtensions
setlocal EnableDelayedExpansion

set NoDB=False
set CustomDB=False
if not exist "%~dp0KillCC_AppList.txt" (
 set NoDB=True
)

set CustomDBLocation=%1

if not "%CustomDBLocation%" == "" (
    set CustomDB=True
    goto _setCustomDB
) else (goto _postSetCustomDB)
:_setCustomDB
if exist "%cd%\%CustomDBLocation%" (
    set CustomDBLocation=%cd%\%CustomDBLocation%
    set NoDB=False
) else if exist "%CustomDBLocation%" (
    set NoDB=False
) else (
    set NoDB=True
)
:_postSetCustomDB

set AppListSource=%~dp0KillCC_AppList.txt
set SessionID=%random%
set AppName=Adobe CC Junk Process Killer
set AppVer=20-07-14_v03
set AppAuther=kimiroo
title %AppName% (%AppVer%)
set ExpectedDBName=KillCC_ProcessDB
if "%CustomDB%"=="True" (
    set AppListSource=%CustomDBLocation%
)
if "%NoDB%"=="True" (
    set DBName=N/A
    set DBVer=N/A
    goto _postDBMetaRead
) else (
    goto _readDBMeta
)

:_readDBMeta
for /f "delims== tokens=1,2" %%G in (%AppListSource%) do (
    if "%%G"=="DBName" (
        set %%G=%%H
    )
    if "%%G"=="DBVer" (
        set %%G=%%H
    )
)
:_postDBMetaRead

if "%DBName%"=="" (
    set DBName=N/A
)
if "%DBVer%"=="" (
    set DBVer=N/A
)


:_Start
echo ########################################
echo %AppName%
echo App version: %AppVer%
echo by %AppAuther%
echo.
echo DB name:     %DBName%
echo DB version:  %DBVer%
echo DB Location: %AppListSource%
echo Custom DB:   %CustomDB%
echo.
echo SessionID: %SessionID%
echo ########################################
echo.
echo.

:_chkPerm
rem Check for permissions
echo Checking for permissions...

net session >nul 2>&1
if '%errorlevel%' NEQ '0' (
    echo Administrative privileges not detected.
    echo Requesting administrative privileges...
    echo.
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin_%SessionID%.vbs"
    echo UAC.ShellExecute "%~s0", "%*", "", "runas", 1 >> "%temp%\getadmin_%SessionID%.vbs"

    "%temp%\getadmin_%SessionID%.vbs"

    echo Batch will run in the new window if permission has successfully granted.
    echo Current batch file will exit in 5 seconds...
    ping 127.0.0.1 -n 6 >nul
    set _exitCode=2
    goto _errExit

:gotAdmin
    echo Administrative privileges detected. Continuing the script...
    if exist "%temp%\getadmin_%SessionID%.vbs" ( del "%temp%\getadmin_%SessionID%.vbs" )
    pushd "%cd%"

rem Check DB
echo.
if "%CustomDB%"=="True" (
    echo Custom DB location specified: %CustomDBLocation%
    echo.
)
echo Checking DB...
if "%NoDB%"=="True" (
    echo Failed.
    echo.
    echo ERROR: DB file does not exist.
    echo Specify DB file manually or place DB file with correct name.
    echo.
    echo Will now exit in 5 seconds...
    ping 127.0.0.1 -n 6 >nul
    set _exitCode=4
    goto _errExit
)
if "%DBName%"=="N/A" (
    echo Failed.
    echo.
    echo Warning: Cannot read DB name. This may be because DB is corrupted or wrong DB.
    echo Please check the DB file to prevent unexpected behavior.
    echo.
    goto _errDB
)
if "%DBVer%"=="N/A" (
    echo Failed.
    echo.
    echo Warning: Cannot read DB version. This may be because DB is corrupted or wrong DB.
    echo Please check the DB file to prevent unexpected behavior.
    echo.
    goto _errDB
)
if not "%DBName%"=="%ExpectedDBName%" (
    echo Failed.
    echo.
    echo Warning: DB name "%DBName%" is not expected. This may be because DB is not configured correctly.
    echo Please check the DB file to prevent unexpected behavior.
    echo.
    goto _errDB
)
echo Done.
:_skipDBCheck
goto _runMainCode

:_errDB
set inp=NON
set /p inp="Do you want to continue? [Y/n] "
if /i "%inp%"=="y" (goto _runMainCode)
if /i "%inp%"=="n" (set _exitCode=3 && goto _errExit)
goto _errDB

:_runMainCode
rem Run
echo.
echo Process killing initiated.
echo.
for /f "skip=2 delims= tokens=*" %%A in (%AppListSource%) do (
    echo Killing "%%A"...
    taskkill /f /im "%%A" /t  > nul 2>&1
    echo Done.
    echo.
)
goto _endOldCodeBlk1

rem Old Code Block
:_startOldCodeBlk1
    echo Searching for "%%A"...
    for /f %%p in ('tasklist /nh /fi "IMAGENAME eq %%A"') do if "%%p" == "%%A" (
        echo Found "%%A". Killing the process...
        taskkill /f /im "%%A" /t  > nul 2>&1
        echo Done.
    ) else (
        echo Process "%%A" is not ruunning. Skipping...
    )
    echo.
:_endOldCodeBlk1

echo Done killing Adobe CC processes.
echo.
echo Will now exit in 5 seconds...
ping 127.0.0.1 -n 6 >nul

:_errExit
if "%_exitCode%" == "" ( set _exitCode=1 )
echo.
echo Exiting...
set errExit=True
goto _Exit

:_Exit
pause
if "%errExit%" == "True" (exit /b %_exitCode%) else (exit /b 0)
