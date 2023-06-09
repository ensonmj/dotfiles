local wezterm = require("wezterm")
local M = {}

function M.setup(config)
  config.ssh_domains = wezterm.default_ssh_domains()
  for _, dom in ipairs(config.ssh_domains) do
    dom.assume_shell = "Posix"
  end

  config.unix_domains = {
    {
      name = "mj.icx",
      -- should install wezterm binary in system path(eg. /usr/bin/wezterm)
      -- sudo ln -s `which wezterm` /usr/bin/wezterm
      proxy_command = { "ssh", "-T", "-A", "mj.icx", "wezterm", "cli", "proxy" },
    },
  }

  if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    config.default_domain = "WSL:Ubuntu"
  end
end

return M
