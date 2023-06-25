local wezterm = require("wezterm")
local M = {}

-- Equivalent to POSIX basename(3)
-- Given "/foo/bar" returns "bar"
-- Given "c:\\foo\\bar" returns "bar"
function M.basename(s)
  return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

-- shorten the path by using ~ as $HOME.
function M.shorten_path(path)
  local home = os.getenv("HOME")
  if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    home = os.getenv("USERPROFILE"):gsub("\\", "/")
  end
  return path:gsub("^" .. home, "~")
end

-- path: "file://HOSTNAME/home/user/xxx"
-- path: "file:///C:/Users/user/xxx", hostname is empty on x86_64-pc-windows-msvc
function M.get_hostname_cwd(pane)
  local path = pane:get_current_working_dir()

  local uri = path:sub(8) -- remove "file://"
  local slash = uri:find("/")
  if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    local cwd = M.shorten_path(uri:sub(slash + 1)) -- remove extra "/"
    return nil, cwd
  end

  local hostname = uri:sub(1, slash - 1)
  local dot = hostname:find("[.]")
  if dot then
    hostname = hostname:sub(1, dot - 1)
  end

  local cwd = M.shorten_path(uri:sub(slash))
  return hostname, cwd
end

return M
