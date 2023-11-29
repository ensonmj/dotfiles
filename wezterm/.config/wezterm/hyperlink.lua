local wezterm = require("wezterm")
local M = {}

function M.setup(config)
  -- default rules as base
  config.hyperlink_rules = wezterm.default_hyperlink_rules()
  -- caution: use rust regex pattern
  for _, rule in ipairs({
    -- local file "/home/ensonmj/.bashrc:2:1"
    {
      regex = "/[^/\r\n ]+(?:/[^/\r\n ]+)*(:\\d+){0,2}\\b",
      format = "file://$0",
    },
    -- make username/project paths clickable. this implies paths like the following are for github.
    -- ( "nvim-treesitter/nvim-treesitter" | wbthomason/packer.nvim | wez/wezterm | "wez/wezterm.git" )
    -- as long as a full url hyperlink regex exists above this it should not match a full url to
    -- github or gitlab / bitbucket (i.e. https://gitlab.com/user/project.git is still a whole clickable url)
    -- {
    --   regex = [[["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?]],
    --   format = "https://www.github.com/$1/$3",
    -- },
    -- Things that look like URLs with numeric addresses as hosts.
    -- E.g. http://127.0.0.1:8000 for a local development server,
    -- or http://192.168.1.1 for the web interface of many routers.
    {
      regex = [[\b\w+://(?:[\d]{1,3}\.){3}[\d]{1,3}\S*\b]],
      format = "$0",
    },
    -- Things with localhost addresses.
    {
      regex = "\\bhttp://localhost:[0-9]+(?:/\\S*)?\\b",
      format = "$0",
    },
    -- IPv4
    {
      regex = "[0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+",
      format = "$0",
    },
    -- IPv6
    {
      regex = "[0-9a-fA-F]{0,4}:[0-9a-fA-F]{0,4}:[0-9a-fA-F]{0,4}:[0-9a-fA-F]{0,4}\z
          :[0-9a-fA-F]{0,4}:[0-9a-fA-F]{0,4}:[0-9a-fA-F]{0,4}:[0-9a-fA-F]{0,4}",
      format = "$0",
    },
  }) do
    table.insert(config.hyperlink_rules, rule)
  end
end

return M
