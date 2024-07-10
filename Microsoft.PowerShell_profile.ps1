# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
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
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key Ctrl+p -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key Ctrl+n -Function HistorySearchForward

# Terminal Icons in dir/ls
# Import-Module -Name Terminal-Icons

if (-not (Test-IsElevated)) {
    #region conda initialize
    # !! Contents within this block are managed by 'conda init' !!
    If (Test-Path "$Home\miniconda3\Scripts\conda.exe") {
        (& "$Home\miniconda3\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | Where-Object { $_ } | Invoke-Expression
    }
    #endregion
}

# Do not show conda environment in prompt --managed by oh-my-posh
$env:VIRTUAL_ENV_DISABLE_PROMPT = 1

$env:NODE_PATH = "$($env:APPDATA)\npm\node_modules"

# oh-my-posh init
# original themes path $env:POSH_THEMES_PATH
oh-my-posh init pwsh --config "$Home\Documents\PowerShell\omp_config.toml" | Invoke-Expression