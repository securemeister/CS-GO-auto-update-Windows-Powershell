# CS-GO-auto-update-Windows-Powershell
This little project / tool provides an auto update function for CSGO (Counter-Strike Global Offensive) servers running under Windows using Powershell.

What does this script do?

This script is built very simply. In general this tool starts up the CSGO server (based on srcds.exe) and checks every 10 minutes if updates are available. Is an update needed, the server will be stopped and the update process will start. After update is complete, the script starts the CSGO server again. If there is no update available, the script verify if the server is still running (no crash etc.).

##Test
