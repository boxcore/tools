:: nmap install
set TpName=nmap
set BIN_NMAP="C:\Program Files (x86)\Nmap\nmap.exe"
echo %BIN_NMAP%
if not exist %BIN_NMAP% (
    echo "[check] %TpName% Not Install, downloading..."
    set DownTpUrl=%DownHost1%/nmap-7.80-setup.exe
    for %%a in ("!DownTpUrl!") do set "DownTpName=%%~nxa"
    if not exist %DirDownload%\!DownTpName! ( DownloadFile.vbs "!DownTpUrl!" "%DirDownload%\!DownTpName!" )
    if not exist %DirDownload%\!DownTpName! ( 
        echo !DownTpName! download error, try another link
        set DownTpUrl=https://nmap.org/dist/nmap-7.80-setup.exe
        DownloadFile.vbs "!DownTpUrl!" "%DirDownload%\!DownTpName!"
    )
    start /WAIT %DirDownload%\!DownTpName!
) else (
    echo "[check] %TpName% already installed"
)

:: 添加host
REM :: ## install telnet
REM echo "[install] telnet"
REM dism /online /Enable-Feature /FeatureName:TelnetClient
if not exist %BIN_NMAP% (
    echo "NMAP Install Error.."
    pause
    exit /B
)
REM set hostspath=%SystemRoot%\System32\drivers\etc\hosts
REM %BIN_NMAP% -sT -p 7891 main.ssr|findstr "open">nul 2>nul
REM if %errorlevel%==0 ( echo "[check] main hosts port check ok" ) else (
REM     echo "[check] main hosts port check error, try add hosts now.."
REM     attrib -R %hostspath%
REM     echo %MainHost% main.ssr>>%hostspath%
REM     attrib +R %hostspath%
REM     %BIN_NMAP% -sT -p 2087 main.ssr|findstr "open">nul 2>nul
REM     if !errorlevel!==0 ( echo "[ok] main hosts port check ok" ) else ( echo "[error] main hosts port add failure" )
REM )