param(
    [Parameter(Mandatory = $true)] [string] $Source,
    [Parameter(Mandatory = $true)] [string] $Target
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2.0

$targetDirectory = Split-Path -Parent $Target
New-Item -ItemType Directory -Force -Path $targetDirectory | Out-Null

$item = Get-Item -Force -LiteralPath $Target -ErrorAction SilentlyContinue
if ($null -ne $item) {
    if (($item.LinkType -eq 'SymbolicLink' -or $item.LinkType -eq 'HardLink') -and @($item.Target) -contains $Source) {
        Write-Host "Up to date: $Target"
        exit 0
    }
}

$temporaryLink = Join-Path $targetDirectory ".$(Split-Path -Leaf $Target).dotfiles-link-$PID"
$backup = $null
try {
    try {
        New-Item -ItemType SymbolicLink -Path $temporaryLink -Target $Source | Out-Null
    }
    catch {
        if ($_.FullyQualifiedErrorId -notlike '*NewItemSymbolicLinkElevationRequired*') {
            throw
        }
        try {
            New-Item -ItemType HardLink -Path $temporaryLink -Target $Source | Out-Null
        }
        catch {
            throw 'Creating a link requires Windows Developer Mode or an elevated terminal when the source is not on the same Windows volume.'
        }
    }

    if ($null -ne $item) {
        $backup = "$Target.bak"
        if (Test-Path -LiteralPath $backup) {
            $backup = "$backup.$(Get-Date -Format 'yyyyMMddHHmmss')"
        }
        Move-Item -LiteralPath $Target -Destination $backup
        Write-Host "Backed up: $backup"
    }

    Move-Item -LiteralPath $temporaryLink -Destination $Target
}
catch {
    Remove-Item -Force -LiteralPath $temporaryLink -ErrorAction SilentlyContinue
    if ($null -ne $backup -and -not (Test-Path -LiteralPath $Target)) {
        Move-Item -LiteralPath $backup -Destination $Target
    }
    throw
}

Write-Host "Linked: $Target -> $Source"