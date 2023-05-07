local wezterm = require("wezterm")

local launch_menu = {}

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  ssh_cmd = { "powershell.exe" }

  table.insert(launch_menu, {
    label = "WSL",
    args = { "wsl.exe" },
    --   args = {  "wsl.exe", "--cd", "/home/<user>/<dir1>" }
  })

  table.insert(launch_menu, {
    label = "PowerShell",
    args = { "powershell.exe", "-NoLogo" },
  })

  table.insert(launch_menu, {
    label = "CMD",
    args = { "cmd.exe" },
  })
elseif wezterm.target_triple == "x86_64-apple-darwin" then
  table.insert(launch_menu, {
    label = "Zsh-NewWindow",
    args = { "/bin/zsh", "-l" },
  })
  default_prog = { "/bin/zsh", "-l" }
  require("key-bind-mac")
elseif wezterm.target_triple == "aarch64-apple-darwin" then
  table.insert(launch_menu, {
    label = "zsh",
    args = { "/opt/homebrew/bin/zsh", "-l" },
  })
  default_prog = { "/opt/homebrew/bin/zsh", "-l" }
end

return launch_menu
