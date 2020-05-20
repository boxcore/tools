: python2 install
set TpName=Python2
if not exist "C:\Python27\python.exe" (
    echo "%TpName% not installed, downloading"
    set DownTpUrl=%DownHost1%/python-2.7.17.amd64.msi
    for %%a in ("!DownTpUrl!") do set "DownTpName=%%~nxa"
    if not exist %DirDownload%\!DownTpName! ( DownloadFile.vbs "!DownTpUrl!" "%DirDownload%\!DownTpName!" )
    start /WAIT %DirDownload%\!DownTpName!
) else (
    echo "[check] Python2 already installed"
)

:: pip update
set TpName="PIP19"
set PATH=C:\Python27\;C:\Python27\Scripts;%PATH%
set BIN_PIP="C:\Python27\Scripts\pip.exe"
if not exist "C:\Python27\python.exe" (
    echo "Python2 Install Error.."
    pause
    exit /B
)
if not exist "C:\Python27\Scripts\pip-19.3.1\setup.py" ( 
    echo "[check] %TpName%：Not Install"
    set DownTpUrl=%DownHost1%/pip-19.3.1.tar.gz
    set DownTpName=pip-19.3.1.tar.gz
    if not exist %DirDownload%\!DownTpName! ( DownloadFile.vbs "!DownTpUrl!" "%DirDownload%\!DownTpName!" )

    %BIN_RAR% x "%DirDownload%\!DownTpName!" C:\Python27\Scripts\
    cd C:\Python27\Scripts\
    del *.exe
    cd C:\Python27\Scripts\pip-19.3.1\
    python setup.py build
    python setup.py install
    if exist %BIN_PIP% ( echo "[ok] %TpName% Installed" ) else ( echo "[error] %TpName% Install Error!" )
    cd %CURDIR%

) else ( echo "[check] %TpName% already installed" )

:: pip 源： 
:: -i https://mirrors.ustc.edu.cn/pypi/web/simple
:: -i https://pypi.douban.com/simple
REM pip install -i https://mirrors.ustc.edu.cn/pypi/web/simple pip==10.0.1 -U
REM python -m pip install -U pip

if exist "C:\Python27\python.exe" if exist "C:\Python27\Scripts\pip-19.3.1\setup.py" (
    echo "Python2 and PIP19 install ok.."
) else (
    echo "Python2 and PIP19 install error.."
    pause
    exit /B
)

:: 安装pip依赖包
ping -n 2 www.google.com>nul 2>nul
if %errorlevel%==0 ( 
    set PIP_IMAGE=
) else (
    set PIP_IMAGE=-i https://mirrors.ustc.edu.cn/pypi/web/simple
)
pip install %PIP_IMAGE% requests wget selenium configparser simplejson progressbar pywin32
set TpName=PipPycurl
pip list|findstr "pycurl">nul 2>nul
if %errorlevel%==0 ( echo "[check] %TpName%：Installed" ) else (
    echo "[check] %TpName%: Not Install"
    :: from:https://www.lfd.uci.edu/~gohlke/pythonlibs/
    pip install %DownHost1%/pycurl-7.43.0.3-cp27-cp27m-win_amd64.whl
    pip list|findstr "pycurl">nul 2>nul
    if %errorlevel%==0 ( echo "[ok] %TpName% Installed" ) else ( echo "[error] %TpName% Install Error" )
)