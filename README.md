# CS-GO-auto-update-Windows-Powershell
This little project / tool provides an auto update function for CSGO (Counter-Strike Global Offensive) servers running under Windows using Powershell.


What does this script do?

This script is built very simply. In general this tool starts up the CSGO server (based on srcds.exe) and checks every 10 minutes if updates are available. Is an update needed, the server will be stopped and the update process will start. After update is complete, the script starts the CSGO server again. If there is no update available, the script verify if the server is still running (no crash etc.).


How does the detection of a missing update work?

When Valve is deploying a new update, your server is stopping with the message 'MasterRequestRestart' &  'Your server is out of date.  Please update and restart.' The script analyses the log of your server console. If those mentioned lines were found in the log file, the update process will start.


How do I implement this script?

First of all you need a working CSGO server. After that, you can implement this script. You need to adjust following settings:

Path to SteamCMD
$SteamCMD = 'C:\SteamCMD\steamcmd.exe'

Path to CSGO Update Script (also attached)
$SteamCMDArgumentList = '+runscript csgo_update.txt'

Path to CSGO server (srcds)
$CSGOServer = 'C:\CSGO\srcds.exe'

ArgumentList for CSGO server -> IMPORTANT: '-condebug' needs to be activated, otherwise the script cannot detect updates.
$CSGOServerArgumentList = '-condebug -game csgo -console -usercon +game_type 0 +game_mode 1 -tickrate 128 +map de_dust2'

Path to the console log file (-condebug -> mentioned above)
$CSGOServerConsoleLogFile = 'C:\CSGO\csgo\console.log'

After everything is configured correctly, you can right click the script an run with PowerShell.
You do not need to run the script as an administrator (elevated prompt). Please verify that every NTFS permissions on the folders of your CSGO server is setup change for everyone. Otherwise the update will fail, because the script is not allowed to write into the specific folders. If you do not want to grant change for everyone, you need to run the script as an administrator (elevated prompt)

Please ensure too, that you allow to run scripts like this, otherwise it will not start up.
To do so, execute following in an elevated PowerShell prompt: Set-ExecutionPolicy -ExecutionPolicy Unrestricted
