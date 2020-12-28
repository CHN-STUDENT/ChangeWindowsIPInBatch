# ChangeWindowsIPInBatch
批处理更改 Windows 网卡 IP 设置

一、 首先查看网卡名字，批处理中运行 `netsh interface show interface` 结果可能如下

``` batch
D:\GitHub>netsh interface show interface

管理员状态     状态           类型             接口名称
-------------------------------------------------------------------------
已启用            已连接            专用               VMware Network Adapter VMnet1
已启用            已连接            专用               VMware Network Adapter VMnet8
已启用            已连接            专用               本地连接* 10
已启用            已连接            专用               WLAN
已启用            已断开连接          专用               以太网
```
中文的话记得直接复制中文


二、 根据所需修改下面批处理的变量，记得用 GB2312 编码存成 ip.bat，本项目的话记得自己修改
(不要问我为什么，编码问题会造成各种f___问题)

```
@ECHO OFF 

rem To check all NIC name.use:  >>  netsh interface show interface  <<


set addr=10.100.8.184
set mask=255.255.255.0
set gateway=10.100.8.1
set dns1=172.16.172.82
set dns2=172.16.172.83
set nic=以太网


:retry
echo. Your NIC name is %nic%
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
rem job done, then exit with a pause before
pause
exit /b 0

:BSNL
netsh interface ip set address %nic% dhcp
netsh interface ip set dns %nic% dhcp
pause
```

这个批处理自带权限提升，无需右键管理员
