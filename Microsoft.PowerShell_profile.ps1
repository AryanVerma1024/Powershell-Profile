# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
}

# GitHub Completion
if (Test-Path "$Home\Documents\PowerShell\githubCompletion.ps1") {
    . "$Home\Documents\PowerShell\githubCompletion.ps1"
}

# Aliases
if (Test-Path "$Home\Documents\PowerShell\aliases.ps1") {
    . "$Home\Documents\PowerShell\aliases.ps1"
}

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

    $initialPos = $host.UI.RawUI.CursorPosition

    $previousLines = 0

    do {
        $Host.UI.RawUI.CursorPosition = $initialPos

        # Clear to the end of the screen
        Write-Host (" " * ($Host.UI.RawUI.MaxWindowSize.Width - 1 - $initialPos.X))

        # clear previous output
        Write-Host (" " * $previousLines * ($Host.UI.RawUI.MaxWindowSize.Width - 1))

        $Host.UI.RawUI.CursorPosition = $initialPos

        # Run the command
        Invoke-Expression "$Command $Arguments"

        # get count of lines in output
        $previousLines = ($host.UI.RawUI.CursorPosition.Y - $initialPos.Y)

        # Sleep for the interval
        Start-Sleep -Seconds $Interval

    } while($EndTime -gt (Get-Date) -or $Endless)
}

# For Interactive History Search
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows

# Terminal Icons in dir/ls
# Import-Module -Name Terminal-Icons

if (-not (Test-IsElevated)) {
    #region conda initialize
    # !! Contents within this block are managed by 'conda init' !!
    If (Test-Path "C:\Users\Aryan\miniconda3\Scripts\conda.exe") {
        (& "C:\Users\Aryan\miniconda3\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | Where-Object { $_ } | Invoke-Expression
    }
    #endregion
}

# Do not show conda environment in prompt --managed by oh-my-posh
$env:VIRTUAL_ENV_DISABLE_PROMPT = 1

# oh-my-posh init
# original path $env:POSH_THEMES_PATH/kali-m.omp.json
oh-my-posh init pwsh --config "$Home\Documents\PowerShell\kali-m.omp.json" | Invoke-Expression