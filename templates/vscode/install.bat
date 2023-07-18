@echo off

mklink "%userprofile%\AppData\Roaming\Code\User\settings.json" "%~dp0\settings.json"
mklink "%userprofile%\AppData\Roaming\Code\User\keybindings.json" "%~dp0\keybindings.json"

set EXT="%~dp0\extensions.json"
wsl.exe bash -c "jq '.recommendations[]' $(wslpath %EXT%)" | wsl.exe xargs -n 1 cmd.exe /c start /B code --install-extension
