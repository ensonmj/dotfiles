local wezterm = require("wezterm")
local mod = {}

function mod.setup(config)
  local menu = {}

  if wezterm.target_triple == "x86_64-unknown-linux-gnu" then
    table.insert(menu, {
      label = "zsh",
      args = { "/bin/zsh", "-l" },
    })
  elseif wezterm.target_triple == "x86_64-pc-windows-msvc" then
    table.insert(menu, {
      label = "PowerShell",
      args = { "powershell.exe", "-NoLogo" },
    })
    table.insert(menu, {
      label = "CMD",
      args = { "cmd.exe" },
    })
  elseif wezterm.target_triple == "x86_64-apple-darwin" then
    table.insert(menu, {
      label = "zsh",
      args = { "/bin/zsh", "-l" },
    })
  elseif wezterm.target_triple == "aarch64-apple-darwin" then
    table.insert(menu, {
      label = "zsh",
      args = { "/opt/homebrew/bin/zsh", "-l" },
    })
  end

  config.launch_menu = menu
end

return mod
