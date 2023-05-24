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
  local short_path = path:gsub("^" .. home, "~")
  if short_path == "" then
    return path
  end
  return short_path
end

-- path: "file://hostname/home/user/xxx"
function M.split_hostname_cwd(path)
  local hostname = ""
  local cwd = ""
  if path then
    local uri = path:sub(8) -- remove "file://"
    local slash = uri:find("/")
    if slash then
      hostname = uri:sub(1, slash - 1)
      local dot = hostname:find("[.]")
      if dot then
        hostname = hostname:sub(1, dot - 1)
      end

      cwd = M.shorten_path(uri:sub(slash))
    end
  end
  return hostname, cwd
end

function M.exists(fname)
  local stat = vim.loop.fs_stat(vim.fn.expand(fname))
  return (stat and stat.type) or false
end

return M
