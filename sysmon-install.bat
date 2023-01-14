::install-sysmon.bat
if exist C:\Windows\sysmon\sysconfig-export.xml (
	goto check
)	else (
	goto copysysmon
)
:check
fc C:\Windows\sysmon\sysmonconfig-export.xml Z:\sysmonconfig-export.xml > nul
if "%ERRORLEVEL%" EQU "1" (
	goto copysysmon
)	else (
	goto querysysmon
)

:copysysmon
mkdir C:\Windows\sysmon
cd /D Z:
copy /z /y Z:\sysmonconfig-export.xml C:\Windows\sysmon
Sysmon64 -c C:\Windows\sysmon\sysmonconfig-export.xml

:querysysmon
sc query "Sysmon" | find "RUNNING"
if "%ERRORLEVEL%" EQU "1" (
	goto startsysmon
)

:startsysmon
net start Sysmon64

if "%ERRORLEVEL%" EQU "1" (
	goto installsysmon
)

:install sysmon
"Z:\Sysmon64.exe" /accepteula -i c:\windows\sysmon\sysmonconfig-export.xml