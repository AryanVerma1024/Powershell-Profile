# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
}

# GitHub Completion
if (Test-Path "$Home\Documents\PowerShell\githubCompletion.ps1") {
    . "$Home\Documents\PowerShell\githubCompletion.ps1"
}

# mpv Completion
if (Test-Path "$Home\Documents\PowerShell\mpvPowershellCompletion.ps1") {
    . "$Home\Documents\PowerShell\mpvPowershellCompletion.ps1"
}

# Aliases
if (Test-Path "$Home\Documents\PowerShell\aliases.ps1") {
    . "$Home\Documents\PowerShell\aliases.ps1"
}

# Functions
if (Test-Path "$Home\Documents\PowerShell\helperFunctions.ps1") {
    . "$Home\Documents\PowerShell\helperFunctions.ps1"
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

$env:NODE_PATH = "C:\Users\Aryan\AppData\Roaming\npm\node_modules"

# oh-my-posh init
# original path $env:POSH_THEMES_PATH/kali-m.omp.json
oh-my-posh init pwsh --config "$Home\Documents\PowerShell\kali-m.omp.json" | Invoke-Expression