local wezterm = require("wezterm")
local M = {}

function M.setup(config)
  config.ssh_domains = wezterm.default_ssh_domains()
  for _, dom in ipairs(config.ssh_domains) do
    dom.assume_shell = "Posix"
  end

  -- Can't define same name unix_domains in client and server
  -- Maybe should comment out all unix_domains in server
  -- Or remove same entry in ~/.ssh/config
  local unix_domains = {}
  for name, _ in pairs(wezterm.enumerate_ssh_hosts()) do
    table.insert(unix_domains, {
      name = name,
      -- should install wezterm binary in system path(eg. /usr/bin/wezterm)
      -- sudo ln -s `which wezterm` /usr/bin/wezterm
      proxy_command = { "ssh", "-T", "-A", name, "wezterm", "cli", "proxy" },
    })
  end
  config.unix_domains = unix_domains

  if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    config.default_domain = "WSL:Ubuntu"
  end
end

return M
