local wezterm = require("wezterm")
local M = {}

-- Equivalent to POSIX basename(3)
-- Given "/foo/bar" returns "bar"
-- Given "c:\\foo\\bar" returns "bar"
function M.basename(s)
  return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

-- get local cwd, can't get ssh remote cwd
function M.get_cwd(pane)
  -- path: "file://HOSTNAME/home/user/xxx"
  -- path: "file:///C:/Users/user/xxx", hostname is empty on x86_64-pc-windows-msvc
  -- path: "file:///mnt/c/Users/user/xxx", hostname is empty on WSL
  local cwd = pane:get_current_working_dir()
  if not cwd then
    return nil
  end
  cwd = cwd.file_path
  if not cwd then
    return nil
  end

  -- local hostname = pane:get_user_vars().WEZTERM_HOST

  local home = os.getenv("HOME") or "~"
  -- if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  --   home = os.getenv("USERPROFILE"):gsub("\\", "/")
  -- end

  -- local HOME_DIR = string.format("%s/%s/", hostname, home)
  -- wezterm.log_info("HOME_DIR: " .. HOME_DIR)

  -- shorten the path by using ~ as $HOME.
  -- return cwd == HOME_DIR and " ~" or string.format(" %s", string.gsub(cwd, "(.*/)(.*)/", "%2"))
  return cwd:gsub(home, "~")
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
-- //somehost/mnt/c/... for WSL
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
    wezterm.log_info("invalid path: " .. path)
    -- try to remove "/hostname"
    path = path:gsub("^/[^/]+(/.*)", "%1")
  end
  wezterm.log_info("normalized path: " .. path)
  return path
end

return M
