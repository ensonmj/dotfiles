@echo off
::
:: Self-contained Windows-to-WSL scp shim.
::
:: Copyright (c) 2020 Dale Phurrough with MIT License:
:: Permission is hereby granted, free of charge, to any person obtaining a copy
:: of this software and associated documentation files (the "Software"), to deal
:: in the Software without restriction, including without limitation the rights
:: to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
:: copies of the Software, and to permit persons to whom the Software is
:: furnished to do so, subject to the following conditions:
:: The above copyright notice and this permission notice shall be included in all
:: copies or substantial portions of the Software.
:: THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
:: IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
:: FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
:: AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
:: LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
:: OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
:: SOFTWARE.
::
:: Converts local Windows paths one argument at a time while preserving
:: scp remote specifications such as user@host:/path.
::
SETLOCAL EnableExtensions
SETLOCAL DisableDelayedExpansion
set "SCP_WRAPPER_FILE=%~f0"
set "SCP_WRAPPER_TEMP=%TEMP%\scp-wsl-%RANDOM%-%RANDOM%.ps1"
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -Command "$lines = @(Get-Content -LiteralPath $env:SCP_WRAPPER_FILE); $start = [Array]::IndexOf($lines, '# POWERSHELL_START'); if ($start -lt 0) { throw 'Embedded PowerShell marker not found.' }; $lines[($start + 1)..($lines.Count - 1)] | Set-Content -LiteralPath $env:SCP_WRAPPER_TEMP -Encoding UTF8"
if ERRORLEVEL 1 exit /b %ERRORLEVEL%
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%SCP_WRAPPER_TEMP%" %*
set "SCP_WRAPPER_EXIT=%ERRORLEVEL%"
del /q "%SCP_WRAPPER_TEMP%" >nul 2>&1
exit /b %SCP_WRAPPER_EXIT%

# POWERSHELL_START
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2.0

$targetDistro = $null

function Convert-ScpArgument {
	param([string] $Argument)

	if ($Argument.StartsWith('-')) {
		return $Argument
	}

	if ($Argument -match '^([A-Za-z]):[\\/](.*)$') {
		$drive = $Matches[1].ToLowerInvariant()
		$path = $Matches[2] -replace '\\', '/'
		return "/mnt/$drive/$path"
	}

	if ($Argument -match '^[A-Za-z]:') {
		throw "Drive-relative paths are ambiguous; use an absolute path such as C:\\path: '$Argument'."
	}

	if ($Argument -match '^scp://' -or
		$Argument -match '^(?:[^@/\\:]+@)?(?:\[[^\]]+\]|[^/\\:]+):') {
		return $Argument
	}

	if ($Argument -match '^\\\\(?:wsl\$|wsl\.localhost)\\([^\\]+)(?:\\(.*))?$') {
		$distro = $Matches[1]
		if ($null -ne $script:targetDistro -and $script:targetDistro -ne $distro) {
			throw "Paths from multiple WSL distributions are not supported: '$script:targetDistro' and '$distro'."
		}

		$script:targetDistro = $distro
		if ($Matches.Count -gt 2 -and $Matches[2]) {
			return '/' + ($Matches[2] -replace '\\', '/')
		}
		return '/'
	}

	if ($Argument -match '^\\\\') {
		throw "Network UNC paths are not mounted automatically in WSL: '$Argument'."
	}

	if ($Argument.StartsWith('\')) {
		$absolutePath = [IO.Path]::GetFullPath($Argument)
		return Convert-ScpArgument $absolutePath
	}

	return $Argument -replace '\\', '/'
}

try {
	$scpArguments = foreach ($argument in $args) {
		Convert-ScpArgument $argument
	}

	$wslArguments = @()
	if ($null -ne $targetDistro) {
		$wslArguments += @('--distribution', $targetDistro)
	}
	$wslArguments += @('--exec', '/usr/bin/scp')
	$wslArguments += $scpArguments

	& "$env:SystemRoot\System32\wsl.exe" @wslArguments
	exit $LASTEXITCODE
}
catch {
	[Console]::Error.WriteLine("scp.bat: $($_.Exception.Message)")
	exit 2
}
