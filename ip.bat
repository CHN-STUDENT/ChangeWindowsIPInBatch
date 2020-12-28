@echo off
cd /d "%~dp0"

rem Save as GB2312 code
rem To check all NIC name.use:  >>  netsh interface show interface  <<

set addr=10.100.8.184
set mask=255.255.255.0
set gateway=10.100.8.1
set dns1=172.16.172.82
set dns2=172.16.172.83
set nic=ÒÔÌ«Íø

rem get Administrator 's  permission 
rem https://www.zhihu.com/question/34541107
cacls.exe "%SystemDrive%\System Volume Information" >nul 2>nul
if %errorlevel%==0 goto Admin
if exist "%temp%\getadmin.vbs" del /f /q "%temp%\getadmin.vbs"
echo Set RequestUAC = CreateObject^("Shell.Application"^)>"%temp%\getadmin.vbs"
echo RequestUAC.ShellExecute "%~s0","","","runas",1 >>"%temp%\getadmin.vbs"
echo WScript.Quit >>"%temp%\getadmin.vbs"
"%temp%\getadmin.vbs" /f
if exist "%temp%\getadmin.vbs" del /f /q "%temp%\getadmin.vbs"
exit

:Admin
goto retry

rem https://stackoverflow.com/questions/33037811/batch-commands-to-change-ip-and-dns
:retry
echo.Your NIC name is %nic%
SET /P no= press 1 for StaticIP , 2 for DhcpIP:

IF "%no%"=="1" GOTO BUZZ
IF "%no%"=="2" GOTO BSNL
rem if %no% is not 1 nor 2 then exit or goto :retry.
exit /b 0

:BUZZ
netsh interface ipv4 set address name=%nic% source=static ^
      addr=%addr% mask=%mask% gateway=%gateway%
netsh interface ip add dns name=%nic% addr=%dns1%
netsh interface ip add dns name=%nic%  addr=%dns2% index=2
echo. Done!
rem job done, then exit with a pause before
pause
exit /b 0

:BSNL
netsh interface ip set address %nic% dhcp
netsh interface ip set dns %nic% dhcp
echo. Done!
pause