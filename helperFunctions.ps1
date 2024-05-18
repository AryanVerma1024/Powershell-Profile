# Check if current session is elevated
function Test-IsElevated {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Function to show complete command history
function Show-History {
    Get-Content (Get-PSReadlineOption).HistorySavePath
}

# Function to emulate Linux `watch` command
function Watch-Command {
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Command,
        [Parameter(Mandatory = $false)]
        [string]$Arguments = "",
        [Parameter(Mandatory = $false)]
        [int]$Interval = 2,
        [Parameter(Mandatory = $false)]
        [int]$Duration = 0,
        [Parameter(Mandatory = $false)]
        [switch]$Endless
    )
    # Set the end time if duration is specified
    if ($Duration -gt 0) {
        $EndTime = (Get-Date).AddSeconds($Duration)
    }
    if ($Command.Split(" ").Count -gt 1) {
        throw "Command should be a single string. Use Arguments parameter for additional arguments."
    }
    [Console]::TreatControlCAsInput = $true
    Write-Host "`e[?1049h" # Enable alternate screen buffer
    do {
        Clear-Host
        # Run the command
        Invoke-Expression "$Command $Arguments"
        # Sleep for the interval
        Start-Sleep -Seconds $Interval
        if ([Console]::KeyAvailable) {
            $key = [Console]::ReadKey($true)
            if ($key.Key -eq "C" -and ($key.Modifiers -band [ConsoleModifiers]::Control) -eq [ConsoleModifiers]::Control) {
                Write-Host "Keybord Interrupt detected. Exiting..."
                break
            }
        }
    } while ($EndTime -gt (Get-Date) -or $Endless)

    Write-Host "`e[?1049l" # Disable alternate screen buffer
    [Console]::TreatControlCAsInput = $false
    Write-Host "End of Watch"
}

# Function to start shizuku on connected device
function Enable-Shizuku {
    if (-not (Get-Command adb -ErrorAction SilentlyContinue)) {
        Write-Host "ADB is not installed. Please install ADB and try again."
        return
    }
    # adb shell sh /storage/emulated/0/Android/data/moe.shizuku.privileged.api/start.sh
    Invoke-Expression "adb shell sh /storage/emulated/0/Android/data/moe.shizuku.privileged.api/start.sh"
}