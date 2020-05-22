@echo off
color 2F
title WinServerInit
:: Windows中转机软件初始脚本
:: 开启延迟变量 解决if语句中set变量异常
setlocal EnableDelayedExpansion
REM @chcp 437
set CURDIR=%cd%
echo Cur path: %CURDIR%
:: 获取admin权限
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
goto UACPrompt
) else ( goto gotAdmin )
:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
exit /B
:gotAdmin
if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )

:: 设置初始变量

:: 检查gfw
set BinPing=c:\windows\system32\ping.exe
%BinPing% -n 2 www.google.com>nul
if %errorlevel%==0 (
    echo VeryGood,You'r not in china
    set DownHost1=https://bitbucket.org/xxx/down/downloads
) else (
    set DownHost1=http://box.cn-bj.ufileos.com
)


:: 创建工作目录
md "C:\workspace"
md "C:\workspace\Downloads"
md "C:\workspace\bin"
setx path "%path%;C:\workspace\bin;"
set DirWork=C:\workspace
set DirDownload=C:\workspace\Downloads
set Save=%DirDownload%
REM if exist %Save% (echo Save Path：%Save%) else (mkdir %Save% & echo Created Dir OK：%Save%)
REM if not defined Save set "Save=%cd%"
(echo Download Wscript.Arguments^(0^),Wscript.Arguments^(1^)
echo Sub Download^(url,target^)
echo   Const adTypeBinary = 1
echo   Const adSaveCreateOverWrite = 2
echo   Dim http,ado
echo   Set http = CreateObject^("Msxml2.ServerXMLHTTP"^)
echo   http.open "GET",url,False
echo   http.send
echo   Set ado = createobject^("Adodb.Stream"^)
echo   ado.Type = adTypeBinary
echo   ado.Open
echo   ado.Write http.responseBody
echo   ado.SaveToFile target
echo   ado.Close
echo End Sub)>DownloadFile.vbs

reg query HKEY_CURRENT_USER\Software\Google\Chrome\BLBeacon\|find /i "version">nul 2>nul
if %errorlevel%==0 ( echo "[check] GoogleChrome：Installed" ) else (
    echo "[check] GoogleChrome：not install"
    set DownTpUrl=%DownHost1%/ChromeSetup.exe
    for %%a in ("!DownTpUrl!") do set "DownTpName=%%~nxa"
    echo "Downloading !DownTpName! from !DownTpUrl!..."

    if not exist %DirDownload%\!DownTpName! ( DownloadFile.vbs "!DownTpUrl!" "%DirDownload%\!DownTpName!" )
    REM if not exist %DirDownload%\!DownTpName! (
    REM     echo !DownTpName! download error, try another link
    REM     set DownTpUrl=%DownHost2%/ChromeSetup.exe
    REM     DownloadFile.vbs "!DownTpUrl!" "%DirDownload%\!DownTpName!" 
    REM )
    start /WAIT %DirDownload%\!DownTpName! 
    reg query HKEY_CURRENT_USER\Software\Google\Chrome\BLBeacon\|find /i "version">nul 2>nul
    if !errorlevel!==0 ( echo "[ok] GoogleChrome Installed" ) else ( echo "[error] GoogleChrome Install Error.." )
)
echo.

:: code install
set TpName=VSCode
set BIN_CODE="C:\Program Files\Microsoft VS Code\Code.exe"
echo "Checking %TpName%..."
if exist %BIN_CODE% ( echo "[check] %TpName%：Installed" ) else (
    set DownTpUrl=%DownHost1%/VSCodeSetup-x64-1.45.1.exe
    echo "[check] %TpName%: Not Install"
    for %%a in ("!DownTpUrl!") do set "DownTpName=%%~nxa"
    if not exist %DirDownload%\!DownTpName! ( DownloadFile.vbs "!DownTpUrl!" "%DirDownload%\!DownTpName!" )
    
    start /WAIT %DirDownload%\!DownTpName!
    if exist %BIN_CODE% ( echo "[ok] %TpName% Installed" ) else ( echo "[error] %TpName% Install Error" )
)

:: winrar install
set TpName=WinRAR
SET BIN_RAR="C:\Program Files\WinRAR\WinRAR.exe"
echo "Checking %TpName%.."
if not exist %BIN_RAR% (
    echo "[check] WinRAR: not install"
    set UrlWinrar=%DownHost1%/winrar-x64-571tc.exe
    set UrlWinrarKey=%DownHost1%/rarreg.key

    for %%a in ("!UrlWinrar!") do set "FileNameWinrar=%%~nxa"
    if not exist %DirDownload%\!FileNameWinrar! ( DownloadFile.vbs "!UrlWinrar!" "%DirDownload%\!FileNameWinrar!" )
    for %%a in ("!UrlWinrarKey!") do set "FileNameWinrarKey=%%~nxa"
    if not exist %DirDownload%\!FileNameWinrarKey! ( DownloadFile.vbs "!UrlWinrarKey!" "%DirDownload%\!FileNameWinrarKey!" )

    start /WAIT %DirDownload%\!FileNameWinrar!
    copy /y /r %DirDownload%\!FileNameWinrarKey!\ "C:\Program Files\WinRAR\" 
) else (
    echo "[check] Winrar already installed"
)

:: cmder install
set TpName=cmder
echo "Checking %TpName%..."
if not exist "C:\workspace\soft\cmder\Cmder.exe" (
    set DownTpUrl=%DownHost1%/cmder.7z
    for %%a in ("!DownTpUrl!") do set "DownTpName=%%~nxa"
    if not exist %DirDownload%\!DownTpName! ( DownloadFile.vbs "!DownTpUrl!" "%DirDownload%\!DownTpName!" )
    if not exist %DirDownload%\!DownTpName! ( 
        echo !DownTpName! download error, try another link
        set DownTpUrl=https://github.com/cmderdev/cmder/releases/download/v1.3.12/cmder.7z
        DownloadFile.vbs "!DownTpUrl!" "%DirDownload%\!DownTpName!"
    )
    %BIN_RAR% x "%DirDownload%\!DownTpName!" C:\workspace\soft\cmder\

) else (
    echo "[check] cmder already installed"
)
if not exist "C:\Users\Public\Desktop\Cmder" (
    if exist "C:\workspace\soft\cmder\Cmder.exe" ( mklink "C:\Users\Public\Desktop\Cmder" "C:\workspace\soft\cmder\Cmder.exe" )
)


:: xshell install
set TpName=xshell
echo "Checking %TpName%..."
if not exist "C:\Program Files (x86)\NetSarang\Xshell 6\Xshell.exe" (
    set DownTpUrl=%DownHost1%/xshell.exe
    for %%a in ("!DownTpUrl!") do set "DownTpName=%%~nxa"
    if not exist %DirDownload%\!DownTpName! ( DownloadFile.vbs "!DownTpUrl!" "%DirDownload%\!DownTpName!" )

    start /WAIT %DirDownload%\!DownTpName!
) else (
    echo "[check] %TpName% already installed"
)


:: huorong install
set TpName=huorong
echo "Checking %TpName%..."
if not exist "C:\Program Files (x86)\Huorong\Sysdiag\bin\HipsMain.exe" (
    set DownTpUrl=%DownHost1%/sysdiag-full-5.0.43.23.exe
    for %%a in ("!DownTpUrl!") do set "DownTpName=%%~nxa"
    if not exist %DirDownload%\!DownTpName! ( DownloadFile.vbs "!DownTpUrl!" "%DirDownload%\!DownTpName!" )

    start /WAIT %DirDownload%\!DownTpName!
) else (
    echo "[check] %TpName% already installed"
)

:: brave install
set TpName=brave
echo "Checking %TpName%..."
if not exist "C:\Program Files (x86)\BraveSoftware\Brave-Browser\Application\brave.exe" (
    set DownTpUrl=%DownHost1%/BraveBrowserSetup.exe
    for %%a in ("!DownTpUrl!") do set "DownTpName=%%~nxa"
    if not exist %DirDownload%\!DownTpName! ( DownloadFile.vbs "!DownTpUrl!" "%DirDownload%\!DownTpName!" )

    start /WAIT %DirDownload%\!DownTpName!
) else (
    echo "[check] %TpName% already installed"
)

:: install rclone
set TpName=rclone
echo "Checking %TpName%..."
if not exist "C:\workspace\bin\rclone.exe" (
    set DownTpUrl=%DownHost1%/rclone-v1.51.0-windows-amd64.zip
    for %%a in ("!DownTpUrl!") do set "DownTpName=%%~nxa"
    if not exist %DirDownload%\!DownTpName! ( DownloadFile.vbs "!DownTpUrl!" "%DirDownload%\!DownTpName!" )

    %BIN_RAR% x "%DirDownload%\!DownTpName!" C:\workspace\soft\
    copy C:\workspace\soft\rclone-v1.51.0-windows-amd64\rclone.exe C:\workspace\bin\

) else (
    echo "[check] %TpName% already installed"
)


:: install BaiduPCS
set TpName=BaiduPCS
echo "Checking %TpName%..."
if not exist "C:\workspace\bin\BaiduPCS.exe" (
    set DownTpUrl=%DownHost1%/BaiduPCS-Go-v3.6.2-windows-x64.zip
    for %%a in ("!DownTpUrl!") do set "DownTpName=%%~nxa"
    if not exist %DirDownload%\!DownTpName! ( DownloadFile.vbs "!DownTpUrl!" "%DirDownload%\!DownTpName!" )

    rem "C:\Program Files\WinRAR\WinRAR.exe" x "C:\workspace\Downloads\BaiduPCS-Go-v3.6.2-windows-x64.zip" C:\workspace\soft\
    %BIN_RAR% x "%DirDownload%\!DownTpName!" C:\workspace\soft\
    copy C:\workspace\soft\BaiduPCS-Go-v3.6.2-windows-x64\BaiduPCS-Go.exe C:\workspace\bin\

) else (
    echo "[check] %TpName% already installed"
)

::下载完删除生成的vbs文件和临时文件
del DownloadFile.vbs
pause