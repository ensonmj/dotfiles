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
  if not path then
    return nil, nil
  end

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

-- function M.isDir(name)
--     if type(name)~="string" then return false end
--     return os.execute('test -d '..name)
-- end

-- function M.isFile(name)
--     if type(name)~="string" then return false end
--     return os.execute('test -f '..name)
-- end

-- function M.exists(name)
--     if type(name)~="string" then return false end
--     return os.execute('test -e '..name)
-- end

--- Check if a file or directory exists in this path
function M.exists(file)
  local ok, err, code = os.rename(file, file)
  -- code==13: Permission denied, but it exists
  return (ok or code == 13) and true or false
end

--- Check if a directory exists in this path
function M.isdir(path)
  -- "/" works on both Unix and Windows
  return M.exists(path .. "/")
end

-- //somehost/etc/fstab:2:1:3
-- //localhost/etc/fstab
-- ///etc/fstab
-- /etc/fstab:2:1
-- /etc/fstab:2
-- //c:/etc/fstab:2:1
function M.normalize_path(path)
  -- remove extra "/"
  if path:match("///") then
    return M.normalize_path(path:sub(3))
  elseif path:match("//") then
    return M.normalize_path(path:sub(2))
  end

  -- caution: use lua regex pattern
  -- test without ":row:col"
  local file = string.gsub(path, ":%d+", "")
  if not M.exists(file) then
    -- try to remove "/hostname"
    path = string.gsub(path, "(/[%w:]+)(/.*)", "%2")
  end
  wezterm.log_info("normalized path: " .. path)
  return path
end

return M
