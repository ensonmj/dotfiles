local wezterm = require("wezterm")

-- Initial startup
wezterm.on("gui-startup", function(cmd)
  local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

local function basename(s)
  return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

-- change the title of tab to current working directory.
-- ref:
-- https://wezfurlong.org/wezterm/config/lua/window-events/format-tab-title.html#format-tab-title
-- https://wezfurlong.org/wezterm/config/lua/PaneInformation.html
-- https://wezfurlong.org/wezterm/config/lua/pane/get_current_working_dir.html
wezterm.on(
  'format-tab-title',
  function(tab, tabs, panes, config, hover, max_width)
    local pane = tab.active_pane
    -- cwd is a URI with file:// as beginning
    local cwd = pane.current_working_dir

    local home_dir = os.getenv('HOME')
    -- remove the prefix from directory
    local res = string.sub(cwd, 20)
    -- shorten the path by using ~ as $HOME.
    local dir = string.gsub(res, home_dir, '~')

    local index = ""
    if #tabs > 1 then
      index = string.format("%d: ", tab.tab_index + 1)
    end
  
    local process = basename(pane.foreground_process_name)
    
    return index .. process .. "@" .. basename(cwd)
  end
)

wezterm.on(
  "update-right-status",
  function(window)
    local date = wezterm.strftime("%Y-%m-%d %H:%M:%S ")
    window:set_right_status(
      wezterm.format(
        {
          { Text = date }
        }
      )
    )
  end
)
