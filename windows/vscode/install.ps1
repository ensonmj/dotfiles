param(
    [string] $CodeUserDirectory = (Join-Path $env:APPDATA 'Code\User'),
    [string] $SharedConfigDirectory = (Join-Path $PSScriptRoot '..\..\vscode'),
    [switch] $SkipExtensions
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2.0

$SharedConfigDirectory = (Resolve-Path -LiteralPath $SharedConfigDirectory).Path
$linkFile = Join-Path $PSScriptRoot '..\link-file.ps1'
& $linkFile -Source (Join-Path $SharedConfigDirectory 'settings.json') -Target (Join-Path $codeUserDirectory 'settings.json')
& $linkFile -Source (Join-Path $SharedConfigDirectory 'keybindings.json') -Target (Join-Path $codeUserDirectory 'keybindings.json')

if ($SkipExtensions) {
    exit 0
}

$code = Get-Command code -ErrorAction SilentlyContinue
if ($null -eq $code) {
    Write-Warning 'VS Code CLI was not found in PATH; extension installation was skipped.'
    exit 0
}

$extensionsJson = Get-Content -Raw -LiteralPath (Join-Path $SharedConfigDirectory 'extensions.json')
$extensionsJson = $extensionsJson -replace '(?m)^\s*//.*$', ''
$extensions = ($extensionsJson | ConvertFrom-Json).recommendations
foreach ($extension in $extensions) {
    & $code.Source --install-extension $extension
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to install VS Code extension: $extension"
    }
}