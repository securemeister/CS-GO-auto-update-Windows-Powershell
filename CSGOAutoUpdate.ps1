$Host.UI.RawUI.WindowTitle = "CS:GO launcher V0.2"
$SteamCMD = 'C:\SteamCMD\steamcmd.exe'
$SteamCMDArgumentList = '+runscript csgo_update.txt'
$CSGOServer = 'C:\CSGO\srcds.exe'
$CSGOServerArgumentList = '-condebug -game csgo -console -usercon +game_type 0 +game_mode 1 -tickrate 128 +map de_dust2'
$CSGOServerConsoleLogFile = 'C:\CSGO\csgo\console.log'
$UpMsgLn1 = [char]3 + 'MasterRequestRestart'
$UpMsgLn2 = 'Your server is out of date.  Please update and restart.'

function PrintStatus($StatusMSG){
    Write-Host (Get-Date) ([char]9) $StatusMSG -ForegroundColor Green
}

function ClearCSGOServerLog{
    PrintStatus 'Clearing CS:GO server log'
    Clear-Content -Path $CSGOServerConsoleLogFile -Force -ErrorAction SilentlyContinue
}

function StopCSGOServer{
    PrintStatus 'Stopping CS:GO server'
    Stop-Process -Name srcds -Force
}

function UpdateFound{
    PrintStatus 'Update found, installing'
}

function NoUpdateFound{
    PrintStatus 'You are up to date'
}

function UpdateCSGOServer{
    PrintStatus 'Updating CS:GO server'
    Start-Process -FilePath $SteamCMD -ArgumentList $SteamCMDArgumentList -Wait
}

function CheckCSGOServerRunning{
    $ProcessActive = Get-Process srcds -ErrorAction SilentlyContinue
    If($ProcessActive -eq $null){
    PrintStatus 'Starting CS:GO server'
    Start-Process -FilePath $CSGOServer -ArgumentList $CSGOServerArgumentList
    }
}

function DetectMissingUpdate{
    $CSGOServerConsoleLogContent = Get-Content -Path $CSGOServerConsoleLogFile -ErrorAction SilentlyContinue
    Try{
        $Script:iUpMsgLn1 = [array]::IndexOf($CSGOServerConsoleLogContent,$UpMsgLn1)
        $Script:iUpMsgLn2 = [array]::IndexOf($CSGOServerConsoleLogContent,$UpMsgLn2)
    }
    Catch [ArgumentNullException]{
        $Script:iUpMsgLn1=$Script:iUpMsgLn2 = 0
    }
}

ClearCSGOServerLog
UpdateCSGOServer
While($True){
    DetectMissingUpdate
        If($iUpMsgLn1 + 1 -eq $iUpMsgLn2){
            UpdateFound
            StopCSGOServer
            ClearCSGOServerLog
            UpdateCSGOServer
            CheckCSGOServerRunning    
        }
        Else{
            CheckCSGOServerRunning
            NoUpdateFound
        }
    Start-Sleep -Seconds 600
}