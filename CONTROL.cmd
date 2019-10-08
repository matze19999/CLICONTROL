rem Geschrieben von
rem Matthias Pröll <matthias.proell@staudigl-druck.de>
rem Staudigl-Druck GmbH & Co. KG
rem Letzte Anpassung: 2019/08/23

@ECHO off
rem chcp 65001
rem chcp 1252
title System Administrator Control Script
set list=localhost
mode con:cols=100 lines=61
cls
echo.
goto computer

:MAIN
cls
echo ===========================================================
echo 	aktuelle(r) Computer: %list%
echo ===========================================================
echo.
echo  [0] ---  PC wechseln
echo  [1] ---  GPupdate ausfhren
echo  [2] ---  PC herunterfahren
echo  [3] ---  PC neustarten
echo.
echo	Daten abfragen:
echo  [4] ---  RDP ”ffnen
echo  [5] ---  IP abfragen
echo  [6] ---  MAC abfragen
echo  [7] ---  DNS-Name abfragen
echo  [8] ---  Systeminfo abfragen
echo  [9] ---  Windows Version anzeigen
echo [10] ---  CPU-Last abfragen
echo [11] ---  Offene Ports abfragen
echo [12] ---  Uptime abfragen
echo [13] ---  Freien Speicher abfragen
echo [14] ---  Liste aller Benutzerprofile abfragen
echo [15] ---  Alle Prozesse anzeigen

echo [16] ---  eingeloggte User abfragen
echo.
echo [17] ---  eingeloggte User abmelden
echo.
echo	Konsolenbefehle:
echo [18] ---  CMD Befehl ausfhren
echo [19] ---  PowerShell Befehl ausfhren
echo [20] ---  PowerShell Remote Verbindung ausfhren
echo.
echo	Daten „ndern:
echo [21] ---  endlos anpingen
echo [22] ---  Computerverwaltung ”ffnen
echo [23] ---  Dienste ”ffnen
echo [24] ---  Nachricht an alle eingeloggten User senden
echo [25] ---  Laufwerk C ”ffnen
echo [26] ---  Laufwerk D ”ffnen
echo [27] ---  Laufwerk E ”ffnen
echo [28] ---  Benutzerprofil l”schen
echo [29] ---  Logon-Script starten
echo [30] ---  Windows Updates suchen und installieren
echo [31] ---  Sophos deinstallieren
echo [32] ---  SSH Verbindung ”ffnen
echo [33] ---  freie IPs abfragen und nach C:\IPs.txt speichern
echo [34] ---  Programm lokal installieren
echo [35] ---  DNS Server „ndern
echo [36] ---  DNS Name „ndern

echo.
echo ----------------------------------------
echo ------------ AD Abfragen ---------------
echo ----------------------------------------
echo.
echo  [40] ---  Alle Win10 Computer abfragen und in C:\Computer10.csv speichern
echo  [41] ---  Alle Win7 Computer abfragen und in C:\Computer7.csv speichern
echo  [42] ---  Alle Server abfragen und in C:\Server.csv speichern
echo  [43] ---  Alle User abfragen und in C:\User.csv speichern
echo.
echo ========================================
echo.


set asw=0
set /p asw="Bitte Auswahl eingeben: "

if %asw%==0 goto computer
if %asw%==1 goto gpupdate
if %asw%==2 goto shutdown
if %asw%==3 goto reboot
if %asw%==4 goto RDP
if %asw%==5 goto IP
if %asw%==6 goto MAC
if %asw%==7 goto DNS
if %asw%==8 goto systeminfo
if %asw%==9 goto getwindowsversion
if %asw%==10 goto cpulast
if %asw%==11 goto ports
if %asw%==12 goto uptime
if %asw%==13 goto freespace
if %asw%==14 goto listprofiles
if %asw%==15 goto showprocesses
if %asw%==16 goto loggedin
if %asw%==17 goto logoff
if %asw%==18 goto cmd
if %asw%==19 goto powershell
if %asw%==20 goto powershellremote
if %asw%==21 goto PING
if %asw%==22 goto compmgmt
if %asw%==23 goto services
if %asw%==24 goto message
if %asw%==25 goto C
if %asw%==26 goto D
if %asw%==27 goto E
if %asw%==28 goto delprof
if %asw%==29 goto logon
if %asw%==30 goto wupdate
if %asw%==31 goto sophos
if %asw%==32 goto ssh
if %asw%==33 goto freeIP
if %asw%==34 goto PROGRAMINSTALLMENU
if %asw%==35 goto setDNS
if %asw%==36 goto changeDNSname
if %asw%==40 goto adcomputer10
if %asw%==41 goto adcomputer7
if %asw%==42 goto adserver
if %asw%==43 goto aduser

:computer
cls
echo Mehrere Computer bitte mit Leerzeichen getrennt angeben.
echo.
echo Wenn eine 1 eingegeben wird, kann von einer Liste aus Computern ausgew„hlt werden.
echo.
set list=0
set /p list=DNS-Name(n) oder IP-Adresse(n) (0 = localhost):	

(for %%a in (%list%) do (
	if %%a==0 (
		goto MAIN
	) else (
		if %%a==1 (
		goto selectgroup
	) else (
		goto MAIN
	))
))
rem echo list% | findstr /i /c:"0" >nul) && (goto MAIN) || (echo.)

	(for %%a in (%list%) do ( 
		ping %%a -n 1 | findstr /i /c:"Zeit"
			
				if errorlevel 1 (
					echo Mindestens ein Computer konnte nicht erreicht werden!
					echo.
					echo pinge alle Computer an....
					echo.
					set status=""
					goto PING_noping

								)
							
	                        )
    goto MAIN	
    )
cls


:selectgroup
cls
echo Welche Gruppe von Computern willst du ausw„hlen?
echo.
echo.
echo  [0] ---  Alle Clients
echo  [1] ---  Alle Windows Server
echo  [2] ---  IT Services
echo.
set groupasw=0
set /p groupasw="Bitte Auswahl eingeben: "

if %groupasw%==0 (
    set list= All windows 10 clients
) else (
    if %groupasw%==1 (
    set list= All Windows Server
) else (
    if %groupasw%==2 (
    set list= All IT Clients
) else (
    goto computer
)))
goto MAIN



:gpupdate
echo.
(for %%a in (%list%) do (
     
    echo.
    echo Bitte warten, Vorgang wird ausgefhrt...
    start powershell Invoke-Command -ComputerName %%a -ScriptBlock {"gpupdate /force"}
    echo.
))
goto PAUSE


:shutdown
cls
echo Soll der PC wirklich heruntergefahren werden?
echo.
set abfrage=N
set /p abfrage="Bitte J oder N eingeben: "
if %abfrage%==J goto shutdown_ja
if %abfrage%==N goto MAIN
cls
goto MAIN

:shutdown_ja
(for %%a in (%list%) do (
     
    echo.
    powershell Invoke-Command -ComputerName %%a -ScriptBlock {shutdown /s /f /t 0}
    echo.
    echo PC wird heruntergefahren!
    echo.
    goto PING
))

:reboot
cls
echo Soll der PC wirklich neu gestartet werden?
echo.
set abfrage=N
set /p abfrage="Bitte J oder N eingeben: "
if %abfrage%==J goto reboot_ja
if %abfrage%==N goto MAIN
cls
goto MAIN

:reboot_ja
cls
(for %%a in (%list%) do (
     
    echo.
    powershell Invoke-Command -ComputerName %%a -ScriptBlock {shutdown /r /f /t 0}
    echo.
    echo PC wird neu gestartet!
    echo.
    goto PING
))

:RDP
(for %%a in (%list%) do (
mstsc /v:%%a
))
goto MAIN

:IP
cls
echo.
(for %%a in (%list%) do (
     
    echo.
    powershell Invoke-Command -ComputerName %%a -ScriptBlock {ipconfig}
    echo.
))
goto PAUSE

:MAC
cls
(for %%a in (%list%) do (
     
    echo.
    powershell Invoke-Command -ComputerName %%a -ScriptBlock {getmac /v}
    echo.
))
goto PAUSE

:DNS
cls
(for %%a in (%list%) do (
     
    echo.
    nslookup %%a
    echo.
))
goto PAUSE

:systeminfo
cls
(for %%a in (%list%) do (
     
    echo.
powershell Invoke-Command -ComputerName %%a -ScriptBlock {systeminfo}
echo.
))
goto PAUSE

:cpulast
cls
(for %%a in (%list%) do (
     
    echo.
    powershell Invoke-Command -ComputerName %%a -ScriptBlock {"Get-WmiObject Win32_Processor | Select-Object LoadPercentage"}
    echo.
))
goto PAUSE

:ports
echo.
cls
(for %%a in (%list%) do (
     
    echo.
    powershell Invoke-Command -ComputerName %%a -ScriptBlock {cmd /c netstat -a}
    echo.
))
goto PAUSE


:uptime
echo.
cls
(for %%a in (%list%) do (
      
    echo.
    powershell Invoke-Command -ComputerName %%a -ScriptBlock {uptime -h}
    echo.
))
goto PAUSE


:freespace
(for %%a in (%list%) do (
    echo.
    cls
    echo "Festplatte C:"
    echo.
    powershell Invoke-Command -ComputerName %%a -ScriptBlock {" & cmd /c fsutil volume diskfree c:"} -ArgumentList '/paef'
    echo.
    echo.
    echo "Festplatte D:"
    echo.
    powershell Invoke-Command -ComputerName %%a -ScriptBlock {" & cmd /c fsutil volume diskfree d:"} -ArgumentList '/paef'
    echo.
    echo.
    echo "Festplatte E:"
    echo.
    powershell Invoke-Command -ComputerName %%a -ScriptBlock {" & cmd /c fsutil volume diskfree e:"} -ArgumentList '/paef'
    echo.
    echo.
    echo "Festplatte I:"
    echo.
    powershell Invoke-Command -ComputerName %%a -ScriptBlock {" & cmd /c fsutil volume diskfree i:"} -ArgumentList '/paef'
    echo.
    echo.
    pause
))
goto MAIN

:cmd
echo.
set /p befehl=Befehl eingeben:
echo.
(for %%a in (%list%) do (
    echo Befehl an %%a: 
    echo.
    powershell Invoke-Command -ComputerName %%a -ScriptBlock {" & cmd /c %befehl%"} -ArgumentList '/paef'
    echo.
    pause
))
goto MAIN


:powershell
echo.
set /p befehl=Befehl eingeben:
echo.
(for %%a in (%list%) do (
    echo Befehl an %%a: 
    echo.
    powershell Invoke-Command -ComputerName %%a -ScriptBlock {%befehl%}
    echo.
    pause
))
goto MAIN


:powershellremote
cls
(for %%a in (%list%) do (
start powershell -NoExit -Command "&{ Enter-PSSession -ComputerName %%a }"
))
goto MAIN

:PING
cls
echo.
(for %%a in (%list%) do (
start cmd.exe @cmd /k "ping -4 -t %%a"
))
goto MAIN

:services
cls
(for %%a in (%list%) do (
     
    echo.
    start services.msc /computer:%%a
))
GOTO MAIN

:PING_noping
cls
echo.
(for %%a in (%list%) do (
start cmd.exe @cmd /k "ping -4 -t %%a"
))
goto computer


:compmgmt
cls
(for %%a in (%list%) do (
     
    echo.
    compmgmt.msc /computer=\\%%a
))
GOTO MAIN


:loggedin
cls
(for %%a in (%list%) do (
     
    echo.
query user /server:%%a
echo.
))
goto PAUSE

:logoff
cls
(for %%a in (%list%) do (
     
    echo.
    qwinsta.exe /Server:%%a
    echo.
    echo.
    set /p ID=Bitte abzumeldende Session ID angeben:	
    echo.
    logoff %ID% /server:%%a
    echo.
    echo Session erfolgreich abgemeldet!
    echo.
))
goto PAUSE


:message
cls
(for %%a in (%list%) do (
     
    echo.
    set /p nachricht=Nachricht eingeben:
    msg /Server:%%a * %nachricht%
    echo.
))
goto PAUSE

:c
(for %%a in (%list%) do (
     
    echo.
    start \\%%a\c$
))
goto MAIN

:d
(for %%a in (%list%) do (
     
    echo.
    start \\%%a\d$
))
goto MAIN

:e
(for %%a in (%list%) do (
     
    echo.
    start \\%%a\e$
))
goto MAIN

:listprofiles
cls
(for %%a in (%list%) do (
     
    echo.
    C:\Windows\System32\DelProf2.exe /c:%%a /l
    echo.
))
goto PAUSE


:showprocesses
cls
echo Willst du nach einem bestimmten Prozess suchen?
echo.
set searchprocess=N
set /p searchprocess="[J/N]:	"
if %searchprocess%==J set /p searchprocessname="Wie ist der Name des Prozesses?:	"
(for %%a in (%list%) do (
	cls
	if %searchprocess%==J powershell Invoke-Command -ComputerName %%a -ScriptBlock {" & cmd /c tasklist | findstr /i /c:%searchprocessname%"}
	if %searchprocess%==N powershell Invoke-Command -ComputerName %%a -ScriptBlock {tasklist}
))
goto PAUSE



:delprof
cls
(for %%a in (%list%) do (
     
    echo.
    set /p profil=Benutzername eingeben:
    C:\Windows\System32\DelProf2.exe /c:%%a /ed:admin* /id:%profil%* /i /u
    echo.
))
goto PAUSE

:logon
cls
(for %%a in (%list%) do (
     
    echo.
    powershell Invoke-Command -ComputerName %%a -ScriptBlock {start \\%USERDNSDOMAIN%\netlogon\logon.cmd}
    echo Logon-Script wird nun ausgefhrt!
    echo.
))
goto PAUSE


:getwindowsversion
cls
(for %%a in (%list%) do (
     
    echo.
    powershell Invoke-Command -ComputerName %%a -ScriptBlock {REG QUERY 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion' /v ReleaseId}
    echo.
))
goto PAUSE

:wupdate
(for %%a in (%list%) do (
cls
powershell Invoke-Command -ComputerName %%a -ScriptBlock {UsoClient ScanInstallWait}
echo Windows Updates werden heruntergeladen und installiert!
echo.
))
goto PAUSE

:sophos
echo.
cls
echo Achtung!
echo Wurde der Manipulationsschutz ber Sophos Central deaktiviert?
echo Und danach 5min gewartet?
echo.
echo Warten bis Uhrzeit:
echo.
rem time /t
powershell (get-date).AddMinutes(5).ToString('HH:mm')
echo.
pause
(for %%a in (%list%) do (
cls
echo.
echo Sophos wird deinstalliert... Bitte warten...
echo.
echo Sophos Dienste werden beendet...
 powershell Invoke-Command -ComputerName %%a -ScriptBlock {Stop-Service "'SAVService'"}
 powershell Invoke-Command -ComputerName %%a -ScriptBlock {Stop-Service "'SAVAdminService'"}
 powershell Invoke-Command -ComputerName %%a -ScriptBlock {Stop-Service "'Sophos AutoUpdate Service'"}
 powershell Invoke-Command -ComputerName %%a -ScriptBlock {Stop-Service "'Sophos Clean Service'"}
 powershell Invoke-Command -ComputerName %%a -ScriptBlock {Stop-Service "'Sophos Device Control Service'"}
 powershell Invoke-Command -ComputerName %%a -ScriptBlock {Stop-Service "'Sophos File Scanner Service'"}
 powershell Invoke-Command -ComputerName %%a -ScriptBlock {Stop-Service "'Sophos Health Service'"}
 powershell Invoke-Command -ComputerName %%a -ScriptBlock {Stop-Service "'Sophos MCS Agent'"}
 powershell Invoke-Command -ComputerName %%a -ScriptBlock {Stop-Service "'Sophos MCS Client'"}
 powershell Invoke-Command -ComputerName %%a -ScriptBlock {Stop-Service "'SntpService'"}
 powershell Invoke-Command -ComputerName %%a -ScriptBlock {Stop-Service "'Sophos Safestore Service'"}
 powershell Invoke-Command -ComputerName %%a -ScriptBlock {Stop-Service "'Sophos System Protection Service'"}
 powershell Invoke-Command -ComputerName %%a -ScriptBlock {Stop-Service "'Sophos Web Control Service'"}
 powershell Invoke-Command -ComputerName %%a -ScriptBlock {Stop-Service "'swi_filter'"}
 powershell Invoke-Command -ComputerName %%a -ScriptBlock {Stop-Service "'swi_service'"}

     
    echo.
    echo Registry Werte werden gesetzt....
    REG ADD "\\%%a\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\SAVService" /t REG_DWORD /v Start /d 0x00000004 /f
    REG ADD "\\%%a\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Sophos MCS Agent" /t REG_DWORD /v Start /d 0x00000004 /f
    REG ADD "\\%%a\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Sophos Endpoint Defense\TamperProtection\Config" /t REG_DWORD /v SAVEnabled /d 0 /f
    REG ADD "\\%%a\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Sophos Endpoint Defense\TamperProtection\Config" /t REG_DWORD /v SEDEnabled /d 0 /f
    REG ADD "\\%%a\HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Sophos\SAVService\TamperProtection" /t REG_DWORD /v Enabled /d 0 /f
    echo.
    echo.
    echo Entferne Sophos...
    echo.
    echo.
	start cmd.exe @cmd /k "echo Computername: %%a && echo. && powershell Invoke-Command -ComputerName %%a -ScriptBlock {C:\ProgramData\Sophos\AutoUpdate\Cache\decoded\uninstaller64\uninstallcli.exe}"
    rem powershell Invoke-Command -ComputerName %%a -ScriptBlock {C:\ProgramData\Sophos\AutoUpdate\Cache\decoded\uninstaller64\uninstallcli.exe}
    echo.
    echo.
    echo L”sche Dienste...
    powershell Invoke-Command -ComputerName %%a -ScriptBlock {sc.exe delete "'SAVService'"}
    powershell Invoke-Command -ComputerName %%a -ScriptBlock {sc.exe delete "'SAVAdminService'"}
    powershell Invoke-Command -ComputerName %%a -ScriptBlock {sc.exe delete "'Sophos AutoUpdate Service'"}
    powershell Invoke-Command -ComputerName %%a -ScriptBlock {sc.exe delete "'Sophos Clean Service'"}
    powershell Invoke-Command -ComputerName %%a -ScriptBlock {sc.exe delete "'Sophos Device Control Service'"}
    powershell Invoke-Command -ComputerName %%a -ScriptBlock {sc.exe delete "'Sophos File Scanner Service'"}
    powershell Invoke-Command -ComputerName %%a -ScriptBlock {sc.exe delete "'Sophos Health Service'"}
    powershell Invoke-Command -ComputerName %%a -ScriptBlock {sc.exe delete "'Sophos MCS Agent'"}
    powershell Invoke-Command -ComputerName %%a -ScriptBlock {sc.exe delete "'Sophos MCS Client'"}
    powershell Invoke-Command -ComputerName %%a -ScriptBlock {sc.exe delete "'SntpService'"}
    powershell Invoke-Command -ComputerName %%a -ScriptBlock {sc.exe delete "'Sophos Safestore Service'"}
    powershell Invoke-Command -ComputerName %%a -ScriptBlock {sc.exe delete "'Sophos System Protection Service'"}
    powershell Invoke-Command -ComputerName %%a -ScriptBlock {sc.exe delete "'Sophos Web Control Service'"}
    powershell Invoke-Command -ComputerName %%a -ScriptBlock {sc.exe delete "'swi_filter'"}
    powershell Invoke-Command -ComputerName %%a -ScriptBlock {sc.exe delete "'swi_service'"}
))
goto PAUSE

:ssh
(for %%a in (%list%) do (
     
    echo.
cls
ssh %%a
echo.
))
goto PAUSE


:freeIP
del C:\IPs.txt 2> nul
setlocal enableextensions enabledelayedexpansion
set /a count = 1
:loop
set ip=10.1.112.%count%
ping %ip% -n 1 -w 1 2> nul | find "Anforderung" > nul
if errorlevel 1 goto nichtfrei
if errorlevel 0 goto frei
:nichtfrei
rem echo %IP% ist nicht frei >> C:\IPs.txt
set /a count=count+1
if %ip% EQU 10.1.112.255 goto PAUSE else goto loop
goto loop
:frei
echo %IP% ist frei >> C:\IPs.txt
echo %IP% ist frei
set /a count=count+1
if %ip% EQU 10.1.112.255 goto MAIN else goto loop
goto loop




:PROGRAMINSTALLMENU
net session 2> nul
IF %ERRORLEVEL% NEQ 0 (
	cls
    echo Bitte Script als Admin starten!
    echo.
    pause 
    exit 1
)


cls
echo ==================================================
echo     Bitte Programm zum installieren ausw„hlen:
echo ==================================================
echo.
echo  [0] ---  Programm schlieáen
echo.
echo  [1] ---  AndroidDebugBridge 
echo  [2] ---  CPU-Z 
echo  [3] ---  Google Chrome 
echo  [4] ---  Notepad++ 
echo  [5] ---  PDFsam 
echo  [6] ---  Putty 
echo  [7] ---  TeamViewer 
echo  [8] ---  Telegram 
echo  [9] ---  Treesize 
echo  [10] ---  VNC Viewer 
echo  [11] ---  VS Code 
echo  [12] ---  WinRar 
echo  [13] ---  WhatsApp 



echo.

set programasw=0
set /p programasw="Bitte Auswahl eingeben: "

if %programasw%==0 exit
if %programasw%==1 goto adbinstall
if %programasw%==2 goto cpuzinstall
if %programasw%==3 goto chromeinstall
if %programasw%==4 goto notepadplusplusinstall
if %programasw%==5 goto pdfsaminstall
if %programasw%==6 goto puttyinstall
if %programasw%==7 goto teamviewerinstall
if %programasw%==8 goto telegraminstall
if %programasw%==9 goto treesizeinstall
if %programasw%==10 goto vncviewerinstall
if %programasw%==11 goto vscodeinstall
if %programasw%==12 goto winrarinstall
if %programasw%==13 goto whatsappinstall


:adbinstall
echo.
echo Bitte warten, Vorgang wird ausgefhrt...

    echo.
	powershell Invoke-WebRequest "https://dl.google.com/android/repository/platform-tools-latest-windows.zip" -OutFile C:\adb.zip
	powershell Expand-Archive -Force -LiteralPath C:\adb.zip -DestinationPath C:\adb 
	robocopy C:\adb\platform-tools C:\adb /e /is /it /Move
	rd C:\adb\platform-tools /s /q
	setx adb 'C:\adb\adb.exe' /m
	setx fastboot 'C:\adb\fastboot.exe' /m

	del C:\adb.zip

goto gotoPROGRAMINSTALLMENU


:chromeinstall
echo.
echo Bitte warten, Vorgang wird ausgefhrt...

    echo.
	powershell Invoke-WebRequest "https://dl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D%26iid%3D%7BA0F9D3CD-AB93-E4DF-C67D-36C5BC8CBA63%7D%26lang%3Den%26browser%3D4%26usagestats%3D0%26appname%3DGoogle%2520Chrome%26needsadmin%3Dtrue%26ap%3Dx64-stable-statsdef_0%26brand%3DGCEB/dl/chrome/install/GoogleChromeEnterpriseBundle64.zip" -OutFile C:\chrome.zip
	powershell Expand-Archive -Force -LiteralPath C:\chrome.zip -DestinationPath C:\chrome
	msiexec /i C:\chrome\Installers\GoogleChromeStandaloneEnterprise64.msi
	timeout 90
	rd C:\chrome /s /q
	del C:\chrome.zip

goto gotoPROGRAMINSTALLMENU

:vscodeinstall
echo.
echo Bitte warten, Vorgang wird ausgefhrt...

    echo.
	powershell Invoke-WebRequest "https://az764295.vo.msecnd.net/stable/a622c65b2c713c890fcf4fbf07cf34049d5fe758/VSCodeSetup-x64-1.34.0.exe" -OutFile C:\vscode.exe
	C:\vscode.exe /VERYSILENT /mergetasks=!runcode
	timeout 60
	del C:\vscode.exe

goto gotoPROGRAMINSTALLMENU

:telegraminstall
echo.
echo Bitte warten, Vorgang wird ausgefhrt...

    echo.
	powershell Invoke-WebRequest "https://telegram.org/dl/desktop/win" -OutFile C:\telegram.exe
	C:\telegram.exe /SP- /VERYSILENT
	del C:\telegram.exe

goto gotoPROGRAMINSTALLMENU

:treesizeinstall
echo.
echo Bitte warten, Vorgang wird ausgefhrt...

    echo.
	powershell Invoke-WebRequest "https://www.jam-software.de/treesize_free/TreeSizeFreeSetup.exe" -OutFile C:\treesize.exe
	C:\treesize.exe /SILENT /SUPPRESSMSGBOXES
	del C:\treesize.exe

goto gotoPROGRAMINSTALLMENU

:teamviewerinstall
echo.
echo Bitte warten, Vorgang wird ausgefhrt...

    echo.
	powershell Invoke-WebRequest "https://download.teamviewer.com/full" -OutFile C:\teamviewer.exe
	C:\teamviewer.exe /S /norestart
	del C:\teamviewer.exe

goto gotoPROGRAMINSTALLMENU

:whatsappinstall
echo.
echo Bitte warten, Vorgang wird ausgefhrt...

    echo.
	powershell Invoke-WebRequest "https://web.whatsapp.com/desktop/windows/release/x64/WhatsAppSetup.exe" -OutFile C:\whatsapp.exe
	C:\whatsapp.exe /S
	del C:\whatsapp.exe
	powershell Invoke-WebRequest "https://github.com/D4koon/WhatsappTray/releases/download/v1.4.3/WhatsappTrayV1.4.3.exe" -OutFile C:\whatsapptray.exe
	C:\whatsapptray.exe /Silent
	del C:\whatsapptray.exe

goto gotoPROGRAMINSTALLMENU

:notepadplusplusinstall
echo.
echo Bitte warten, Vorgang wird ausgefhrt...

    echo.
	powershell Invoke-WebRequest "https://notepad-plus-plus.org/repository/7.x/7.7/npp.7.7.Installer.x64.exe" -OutFile C:\notepadplusplus.exe
	C:\notepadplusplus.exe /S
	del C:\notepadplusplus.exe

goto gotoPROGRAMINSTALLMENU

:winrarinstall
echo.
echo Bitte warten, Vorgang wird ausgefhrt...

    echo.
	powershell Invoke-WebRequest "https://www.netzmechanik.de/dl/4/winrar-x64-571d.exe" -OutFile C:\winrar.exe
	C:\winrar.exe /S
	del C:\winrar.exe

goto gotoPROGRAMINSTALLMENU

:puttyinstall
echo.
echo Bitte warten, Vorgang wird ausgefhrt...

    echo.
	powershell Invoke-WebRequest "https://the.earth.li/~sgtatham/putty/latest/w64/putty-64bit-0.71-installer.msi" -OutFile C:\putty.msi
	msiexec /qb /i C:\putty.msi
	timeout 20
	del C:\putty.msi

goto gotoPROGRAMINSTALLMENU

:cpuzinstall
echo.
echo Bitte warten, Vorgang wird ausgefhrt...

    echo.
	powershell Invoke-WebRequest "http://download.cpuid.com/cpu-z/cpu-z_1.89-en.exe" -OutFile C:\cpuz.exe
	C:\cpuz.exe /SILENT
	del C:\cpuz.exe

goto gotoPROGRAMINSTALLMENU

:pdfsaminstall
echo.
echo Bitte warten, Vorgang wird ausgefhrt...

    echo.
	powershell Invoke-WebRequest "https://github.com/torakiki/pdfsam/releases/download/v4.0.3/pdfsam-4.0.3.msi" -OutFile C:\pdfsam.msi
	msiexec /qb /i C:\pdfsam.msi
	timeout 30
	del C:\pdfsam.msi

goto gotoPROGRAMINSTALLMENU

:vncviewerinstall
echo.
echo Bitte warten, Vorgang wird ausgefhrt...

    echo.
	powershell Invoke-WebRequest "https://www.realvnc.com/download/file/viewer.files/VNC-Viewer-6.19.325-Windows.exe" -OutFile C:\vncviewer.exe
	C:\vncviewer.exe /qn /norestart
	del C:\vncviewer.exe

goto gotoPROGRAMINSTALLMENU

rem ======================================================================


:setDNS

cls
echo ===========================================================
echo 	Was m”chtest du tun?
echo ===========================================================
echo.
echo  [0] ---  Zum Hauptmen
echo  [1] ---  DNS Server anzeigen
echo  [2] ---  DNS Server auf DC festlegen
echo  [3] ---  DNS Server auf DHCP festlegen
echo.
echo.
set /p dnsaus=Befehl eingeben:
echo.

if %dnsaus%==0 goto MAIN
if %dnsaus%==1 goto showDNSServer
if %dnsaus%==2 goto setDNSDC
if %dnsaus%==3 goto setDNSDHCP

:showDNSSERVER
(for %%a in (%list%) do (
    echo.
    powershell Invoke-Command -ComputerName %%a -ScriptBlock {ipconfig /all}
    echo.
    pause
))
goto setDNS

:setDNSDC
(for %%a in (%list%) do (
    echo.
    powershell Invoke-Command -ComputerName %%a -ScriptBlock {" & cmd /c netsh interface ip set dns "Ethernet" static DC3"} -ArgumentList '/paef' 2> nul
	timeout 2
	powershell Invoke-Command -ComputerName %%a -ScriptBlock {" & cmd /c netsh interface ip add dns "Ethernet" DC2"} -ArgumentList '/paef'2> nul
    echo DNS Server erfolgreich auf die Domain Controller gesetzt!
	echo.
    pause
))
goto setDNS

:setDNSDHCP
(for %%a in (%list%) do (
    echo.
    powershell Invoke-Command -ComputerName %%a -ScriptBlock {" & cmd /c netsh interface ip set dns "Ethernet" dhcp"} -ArgumentList '/paef' 2> nul
    echo DNS Server erfolgreich auf DHCP gesetzt!
	echo.
    pause
))
goto setDNS

:changeDNSname
(for %%a in (%list%) do (
    cls
	echo ===========================================================
	echo 	Welchen neuen Computername willst du für %%a setzen?
	echo ===========================================================
	echo.
	set /p newDNSNAME=Name eingeben:	
	echo.
	powershell Rename-Computer -ComputerName "%%a" -NewName "$env:newDNSNAME" -Confirm 
	echo.
	echo Computername wurde ge„ndert!
	pause
))
goto MAIN
	

:adcomputer10
powershell.exe -File "adcomputer10.ps1"
echo.
echo Datei erstellt und befllt!
echo.
goto PAUSE

:adcomputer7
powershell.exe -File "adcomputer7.ps1"
echo.
echo Datei erstellt und befllt!
echo.
goto PAUSE

:adserver
powershell.exe -File "adserver.ps1"
echo.
echo Datei erstellt und befllt!
echo.
goto PAUSE

:aduser
powershell.exe -File "aduser.ps1"
echo.
echo Datei erstellt und befllt!
echo.
goto PAUSE


:PAUSE
pause
goto MAIN
