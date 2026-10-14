@echo off
::
:: Self-contained Windows-to-WSL ssh shim.
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
:: Converts paths only for SSH options that consume local files. Arguments after
:: the destination are passed through unchanged as the remote command.
::
:: Install
:: 1.  Windows 10 v1903 or newer with a working WSL installation.
:: 2.  Make a copy of this file and name it the same as your WSL executable plus the extension ".BAT".
::     The extension ".BAT" must be capital letters. For example:
::     a) to run ssh in WSL, name this file "ssh.BAT"
::     b) to run ctags in WSL, name this file "ctags.BAT"
:: 3.  Your WSL .profile and .bashrc must not add any output. Otherwise, their output would be mixed
::     with the WSL executable's output and corrupt the data stream.
:: 4.  Test your install by copying this BAT file to "true.BAT"
:: 5.  At a CMD prompt, type:  true.BAT
:: 6.  You should see no output and no errors
:: 7.  At the same CMD prompt, type:  true.BAT > true.out
:: 8.  You should see no output and no errors
:: 9.  At the same CMD prompt, type:  dir true.out
:: 10. You should see a file named "true.out" with a file size of 0 bytes.
::     If you have any size greater than 0 bytes, then you must edit your WSL .profile and .bashrc
::     so that they add no output to stdout/stderr.
::
:: Hints
:: 1   Be mindful of your PATH
::     a) the location you save this BAT file may be (or not) in your PATH
::     b) the order of your PATH is important. For example, Windows 10 often has installed a Win32 executable
::        named "ssh.EXE" and it is usually in your PATH. If you created "ssh.BAT", then the order in which
::        your PATH is searched will determine which ssh is run.
::     c) If you specify the full path to your ssh.BAT file, you can avoid PATH search issues
:: 2.  To use this file for ssh in VSCode, I recommend your edit VSCode settings.json to declare
::     the full path to this file. Capitalize the drive letter and use double-backslashes to separate
::     the directory names. E.g.:
::         "remote.SSH.path": "C:\\path\\to\\your\\folder\\ssh.BAT",
:: 3.  Some components of VSCode only look in PATH for tools like ssh. These components ignore
::     the settings "remote.SSH.path". You may be forced to edit your PATH, uninstall the Win32 ssh.EXE, etc.
::     so that this "ssh.BAT" is used by VSCode.
::
SETLOCAL EnableExtensions
SETLOCAL DisableDelayedExpansion

:: Previous implementation, retained for reference:
:: set v_params=%*
:: set v_params=%v_params:\=/%
:: set v_params=%v_params:c:=/mnt/c%
:: set v_params=%v_params:"=\"%
:: for /f "delims=" %%a in ('powershell -Command "& {'%v_params%' -replace '\/\/wsl\$\/[^\/]*',''}"') do set "v_params=%%a"
:: C:\Windows\system32\wsl.exe bash -ic "ssh %v_params%"

set "SSH_WRAPPER_FILE=%~f0"
set "SSH_WRAPPER_TEMP=%TEMP%\ssh-wsl-%RANDOM%-%RANDOM%.ps1"
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -Command "$lines = @(Get-Content -LiteralPath $env:SSH_WRAPPER_FILE); $start = [Array]::IndexOf($lines, '# POWERSHELL_START'); if ($start -lt 0) { throw 'Embedded PowerShell marker not found.' }; $lines[($start + 1)..($lines.Count - 1)] | Set-Content -LiteralPath $env:SSH_WRAPPER_TEMP -Encoding UTF8"
if ERRORLEVEL 1 exit /b %ERRORLEVEL%
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%SSH_WRAPPER_TEMP%" %*
set "SSH_WRAPPER_EXIT=%ERRORLEVEL%"
del /q "%SSH_WRAPPER_TEMP%" >nul 2>&1
exit /b %SSH_WRAPPER_EXIT%

# POWERSHELL_START
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2.0
$targetDistro = $null

function Convert-LocalPath {
	param([string] $Path)

	if ($Path -match '^([A-Za-z]):[\\/](.*)$') {
		return '/mnt/' + $Matches[1].ToLowerInvariant() + '/' + ($Matches[2] -replace '\\', '/')
	}
	if ($Path -match '^[A-Za-z]:') {
		throw "Drive-relative paths are ambiguous; use an absolute path: '$Path'."
	}
	if ($Path -match '^\\\\(?:wsl\$|wsl\.localhost)\\([^\\]+)(?:\\(.*))?$') {
		$distro = $Matches[1]
		if ($null -ne $script:targetDistro -and $script:targetDistro -ne $distro) {
			throw "Paths from multiple WSL distributions are not supported."
		}
		$script:targetDistro = $distro
		if ($Matches.Count -gt 2 -and $Matches[2]) {
			return '/' + ($Matches[2] -replace '\\', '/')
		}
		return '/'
	}
	if ($Path -match '^\\\\') {
		throw "Network UNC paths are not mounted automatically in WSL: '$Path'."
	}
	if ($Path.StartsWith('\')) {
		return Convert-LocalPath ([IO.Path]::GetFullPath($Path))
	}
	return $Path -replace '\\', '/'
}

function Convert-SshOptionValue {
	param([string] $Value)

	$pathKeywords = 'CertificateFile|ControlPath|GlobalKnownHostsFile|IdentityAgent|IdentityFile|Include|PKCS11Provider|RevokedHostKeys|SecurityKeyProvider|UserKnownHostsFile|XAuthLocation'
	if ($Value -match "^(?<key>$pathKeywords)(?<separator>\s*=\s*|\s+)(?<path>.+)$") {
		$convertedPath = Convert-LocalPath $Matches.path
		$quotedPath = $convertedPath.Replace('\', '\\').Replace('"', '\"').Replace("'", "\'")
		return $Matches.key + $Matches.separator + '"' + $quotedPath + '"'
	}
	return $Value
}

function Convert-SshArguments {
	param([object[]] $Arguments)

	$result = New-Object System.Collections.Generic.List[string]
	$pathOptions = @('-E', '-F', '-I', '-i', '-S')
	$optionsWithValues = 'BbcDEeFIiJLlmOopQRSWw'
	$index = 0
	while ($index -lt $Arguments.Count) {
		$argument = [string] $Arguments[$index]

		if ($argument -eq '--' -or -not $argument.StartsWith('-') -or $argument -eq '-') {
			$result.Add($argument)
			$index++
			while ($index -lt $Arguments.Count) {
				$result.Add([string] $Arguments[$index++])
			}
			break
		}

		if ($pathOptions -contains $argument) {
			$result.Add($argument)
			$index++
			if ($index -ge $Arguments.Count) { throw "SSH option '$argument' requires a path." }
			$result.Add((Convert-LocalPath ([string] $Arguments[$index++])))
			continue
		}
		if ($argument -eq '-o') {
			$result.Add($argument)
			$index++
			if ($index -ge $Arguments.Count) { throw "SSH option '-o' requires a value." }
			$result.Add((Convert-SshOptionValue ([string] $Arguments[$index++])))
			continue
		}
		if ($argument -match '^-([EFIiS])(.+)$') {
			$result.Add("-$($Matches[1])")
			$result.Add((Convert-LocalPath $Matches[2]))
			$index++
			continue
		}
		if ($argument -match '^-o(.+)$') {
			$result.Add('-o')
			$result.Add((Convert-SshOptionValue $Matches[1]))
			$index++
			continue
		}

		$result.Add($argument)
		if ($argument.Length -eq 2 -and $optionsWithValues.Contains($argument[1])) {
			$index++
			if ($index -ge $Arguments.Count) { throw "SSH option '$argument' requires a value." }
			$result.Add([string] $Arguments[$index])
		}
		$index++
	}
	return $result.ToArray()
}

try {
	$sshArguments = Convert-SshArguments $args
	$wslArguments = @()
	if ($null -ne $targetDistro) {
		$wslArguments += @('--distribution', $targetDistro)
	}
	$wslArguments += @('--exec', '/usr/bin/ssh')
	$wslArguments += $sshArguments
	& "$env:SystemRoot\System32\wsl.exe" @wslArguments
	exit $LASTEXITCODE
}
catch {
	[Console]::Error.WriteLine("ssh.bat: $($_.Exception.Message)")
	exit 2
}
