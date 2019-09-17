@ECHO off

rem Geschrieben von
rem Matthias Pröll <proell.matthias@gmail.com>
rem Staudigl-Druck GmbH & Co. KG
rem Letzte Anpassung: 2019/09/17

mode con:cols=100 lines=50
cls
echo.
goto computer
:MAIN
cls
echo 	aktueller Computer: %computer%
echo.
echo ========================================
echo.
echo  [0] ---  PC wechseln
echo  [1] ---  GPupdate ausfhren
echo  [2] ---  PC herunterfahren
echo  [3] ---  PC neustarten
echo.
echo  [4] ---  IP abfragen
echo  [5] ---  MAC abfragen
echo  [6] ---  DNS-Name abfragen
echo  [7] ---  Systeminfo abfragen
echo  [8] ---  CPU-Last abfragen
echo  [9] ---  Offene Ports abfragen
echo [10] ---  Uptime abfragen
echo [11] ---  Freien Speicher abfragen
echo [12] ---  Liste aller Benutzerprofile abfragen
echo [13] ---  eingeloggte User abfragen
echo.
echo [14] ---  eingeloggte User abmelden
echo.
echo [15] ---  CMD Befehl ausfhren
echo [16] ---  PowerShell Befehl ausfhren
echo [17] ---  PowerShell Remote Verbindung ausfhren
echo.
echo [18] ---  endlos anpingen
echo [19] ---  Dienste ”ffnen
echo [20] ---  Nachricht an alle eingeloggten User senden
echo [21] ---  Laufwerk C ”ffnen
echo [22] ---  Laufwerk D ”ffnen
echo [23] ---  Laufwerk E ”ffnen
echo [24] ---  Benutzerprofil l”schen
echo [25] ---  Logon-Script starten
echo [26] ---  Windows Updates suchen und installieren
echo [27] ---  Sophos deinstallieren

echo.
echo ----------------------------------------
echo ----------- AD Abfragen ----------------
echo ----------------------------------------
echo.
echo  [30] ---  Alle Win10 Computer abfragen und in C:\Computer10.csv speichern
echo  [31] ---  Alle Win7 Computer abfragen und in C:\Computer7.csv speichern
echo  [32] ---  Alle Server abfragen und in C:\Server.csv speichern
echo  [33] ---  Alle User abfragen und in C:\User.csv speichern
echo.
echo ========================================
echo.


set asw=0
set /p asw="Bitte Auswahl eingeben: "

if %asw%==0 goto computer
if %asw%==1 goto gpupdate
if %asw%==2 goto shutdown
if %asw%==3 goto reboot
if %asw%==4 goto IP
if %asw%==5 goto MAC
if %asw%==6 goto DNS
if %asw%==7 goto systeminfo
if %asw%==8 goto cpulast
if %asw%==9 goto ports
if %asw%==10 goto uptime
if %asw%==11 goto freespace
if %asw%==12 goto listprofiles
if %asw%==13 goto loggedin
if %asw%==14 goto logoff
if %asw%==15 goto cmd
if %asw%==16 goto powershell
if %asw%==17 goto powershellremote
if %asw%==18 goto PING
if %asw%==19 goto services
if %asw%==20 goto message
if %asw%==21 goto C
if %asw%==22 goto D
if %asw%==23 goto E
if %asw%==24 goto delprof
if %asw%==25 goto logon
if %asw%==26 goto wupdate
if %asw%==27 goto sophos
if %asw%==30 goto adcomputer10
if %asw%==31 goto adcomputer7
if %asw%==32 goto adserver
if %asw%==33 goto aduser
cls
goto MAIN


:computer
cls
set /p computer=DNS-Name oder IP-Adresse:	
ping %computer% -n 1 > nul 2> nul
if errorlevel 1 (
echo.
echo Ziel nicht erreichbar, bitte w„hle einen anderen Computer
echo.
pause
goto computer
) else (
goto MAIN
)

:gpupdate
echo.
echo Bitte warten, Vorgang wird ausgefhrt...
powershell Invoke-Command -ComputerName %computer% -ScriptBlock {"gpupdate /force"}
echo.
pause
goto MAIN


:shutdown
powershell Invoke-Command -ComputerName %computer% -ScriptBlock {shutdown /s /f /t 0}
echo.
echo PC wird heruntergefahren!
echo.
pause
goto PING

:reboot
powershell Invoke-Command -ComputerName %computer% -ScriptBlock {shutdown /r /f /t 0}
echo.
echo PC wird neu gestartet!
echo.
pause
goto PING


:IP
cls
echo.
powershell Invoke-Command -ComputerName %computer% -ScriptBlock {ipconfig}
echo.
pause
goto MAIN

:MAC
cls
echo.
powershell Invoke-Command -ComputerName %computer% -ScriptBlock {getmac /v}
echo.
pause
goto MAIN

:DNS
cls
echo.
nslookup %computer%
echo.
pause
goto MAIN

:systeminfo
cls
echo.
powershell Invoke-Command -ComputerName %computer% -ScriptBlock {systeminfo}
echo.
pause
goto MAIN

:cpulast
cls
echo.
powershell Invoke-Command -ComputerName %computer% -ScriptBlock {"Get-WmiObject Win32_Processor | Select-Object LoadPercentage"}
echo.
pause
goto MAIN

:ports
echo.
cls
powershell Invoke-Command -ComputerName %computer% -ScriptBlock {netstat -a}
echo.
pause
goto MAIN


:uptime
echo.
cls
powershell Invoke-Command -ComputerName %computer% -ScriptBlock {uptime -h}
echo.
pause
goto MAIN


:freespace
echo.
cls
echo "Festplatte C:"
echo.
powershell Invoke-Command -ComputerName %computer% -ScriptBlock {" & cmd /c fsutil volume diskfree c:"} -ArgumentList '/paef'
echo.
echo.
echo "Festplatte D:"
echo.
powershell Invoke-Command -ComputerName %computer% -ScriptBlock {" & cmd /c fsutil volume diskfree d:"} -ArgumentList '/paef'
echo.
echo.
echo "Festplatte E:"
echo.
powershell Invoke-Command -ComputerName %computer% -ScriptBlock {" & cmd /c fsutil volume diskfree e:"} -ArgumentList '/paef'
echo.
echo.
echo "Festplatte I:"
echo.
powershell Invoke-Command -ComputerName %computer% -ScriptBlock {" & cmd /c fsutil volume diskfree i:"} -ArgumentList '/paef'
echo.
echo.
pause
goto MAIN

:cmd
echo.
set /p befehl=Befehl eingeben:
echo.
powershell Invoke-Command -ComputerName %computer% -ScriptBlock {" & cmd /c %befehl%"} -ArgumentList '/paef'
echo.
pause
goto MAIN


:powershell
echo.
set /p befehl=Befehl eingeben:
echo.
powershell Invoke-Command -ComputerName %computer% -ScriptBlock {%befehl%}
pause
goto MAIN

:powershellremote
cls
start powershell -NoExit -Command "&{ Enter-PSSession -ComputerName %computer% }"
goto MAIN

:PING
cls
echo.
start cmd.exe @cmd /k "ping -t %computer%"
echo.
goto MAIN

:services
cls
echo.
start services.msc /computer:%computer%
GOTO MAIN


:loggedin
cls
echo.
query user /server:
echo.
pause
goto MAIN

:logoff
cls
echo.
qwinsta.exe /Server:%computer%
echo.
echo.
set /p ID=Bitte abzumeldende Session ID angeben:	
echo.
logoff %ID% /server:%computer%
echo.
echo Session erfolgreich abgemeldet!
echo.
pause
goto MAIN


:message
cls
echo.
set /p nachricht=Nachricht eingeben:
msg /Server:%computer% * %nachricht%
echo.
pause
goto MAIN

:c
start \\%computer%\c$
goto MAIN

:d
start \\%computer%\d$
goto MAIN

:e
start \\%computer%\e$
goto MAIN

:listprofiles
cls
echo.
C:\Windows\System32\DelProf2.exe /c:%computer% /l
echo.
pause
goto MAIN


:delprof
cls
echo.
set /p profil=Benutzername eingeben:
C:\Windows\System32\DelProf2.exe /c:%computer% /ed:admin* /id:%profil%* /i /u
echo.
pause
goto MAIN

:logon
cls
echo.
start \\domaincontroller\netlogon\logon.cmd
echo Logon-Script wird nun ausgef”hrt!
echo.
pause
goto MAIN


:wupdate
:uptime
echo.
cls
powershell Invoke-Command -ComputerName %computer% -ScriptBlock {UsoClient ScanInstallWait}
echo Windows Updates werden heruntergeladen und installiert!
echo.
pause
goto MAIN

:sophos
echo.
cls
echo Achtung!
echo Wurde der Manipulationsschutz ber Sophos Central deaktiviert?
echo und danach 5min gewartet?
echo.
echo aktuelle Uhrzeit:
echo.
time /t
echo.
pause
cls
echo.
echo Sophos wird deinstalliert... Bitte warten...
echo.
echo.
powershell Invoke-Command -ComputerName %computer% -ScriptBlock {net stop "SAVService"}
powershell Invoke-Command -ComputerName %computer% -ScriptBlock {net stop "Sophos AutoUpdate Service"}
powershell Invoke-Command -ComputerName %computer% -ScriptBlock {C:\ProgramData\Sophos\AutoUpdate\Cache\decoded\uninstaller64\uninstallcli.exe}
echo.
pause
goto MAIN


:adcomputer10
powershell.exe -File "\\server\it\Software\Powershell_Scripts\Active Directory\adcomputer10.ps1"
echo.
echo Datei erstellt und befllt!
echo.
pause
goto Main

:adcomputer7
powershell.exe -File "\\server\it\Software\Powershell_Scripts\Active Directory\adcomputer7.ps1"
echo.
echo Datei erstellt und befllt!
echo.
pause
goto Main

:adserver
powershell.exe -File "\\server\it\Software\Powershell_Scripts\Active Directory\adserver.ps1"
echo.
echo Datei erstellt und befllt!
echo.
pause
goto Main

:aduser
powershell.exe -File "\\server\it\Software\Powershell_Scripts\Active Directory\aduser.ps1"
echo.
echo Datei erstellt und befllt!
echo.
pause
goto Main
