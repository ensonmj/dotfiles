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
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local pane = tab.active_pane

  local index = ""
  if #tabs > 1 then
    index = string.format(" %d:", tab.tab_index + 1)
  end

  local process = basename(pane.foreground_process_name)

  return index .. process .. " "
end)

wezterm.on("update-right-status", function(window, pane)
  local cells = {}

  -- show which key table is active in the status area
  local name = window:active_key_table()
  if name then
    table.insert(cells, name)
  end

  local cwd_uri = pane:get_current_working_dir()
  if cwd_uri then
    cwd_uri = cwd_uri:sub(8) -- remove "file://"
    local slash = cwd_uri:find("/")
    if slash then
      hostname = cwd_uri:sub(1, slash - 1)
      local dot = hostname:find("[.]")
      if dot then
        hostname = hostname:sub(1, dot - 1)
      end
      table.insert(cells, hostname)

      cwd = cwd_uri:sub(slash)
      local home_dir = os.getenv("HOME")
      -- shorten the path by using ~ as $HOME.
      local cwd = string.gsub(cwd, home_dir, "~")

      -- table.insert(cells, cwd:sub(2))
      table.insert(cells, cwd)
    end
  end

  local date = wezterm.strftime("%a %b %-d %H:%M")
  table.insert(cells, date)

  local COLORS = {
    "#3c1361",
    "#52307c",
    "#663a82",
    "#7c5295",
    "#b491c8",
  }
  -- local SOLID_LEFT_ARROW = utf8.char(0xff0b2)
  -- local SOLID_RIGHT_ARROW = utf8.char(0xff0b0)
  -- The filled in variant of the < symbol
  local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider
  -- The filled in variant of the > symbol
  local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

  local text_fg = "#c0c0c0"
  local elements = {}
  local num_cells = 0

  table.insert(elements, { Foreground = { Color = "#3c1361" } })
  table.insert(elements, { Text = SOLID_LEFT_ARROW })

  function push(text, is_last)
    local cell_no = num_cells + 1
    table.insert(elements, { Foreground = { Color = text_fg } })
    table.insert(elements, { Background = { Color = COLORS[cell_no] } })
    table.insert(elements, { Text = " " .. text .. " " })
    if not is_last then
      table.insert(elements, { Foreground = { Color = COLORS[cell_no + 1] } })
      table.insert(elements, { Text = SOLID_LEFT_ARROW })
    end
    num_cells = num_cells + 1
  end

  while #cells > 0 do
    local cell = table.remove(cells, 1)
    push(cell, #cells == 0)
  end

  window:set_right_status(wezterm.format(elements))
end)

wezterm.on("open-uri", function(window, pane, uri)
  local start, match_end = uri:find("file://")
  if start == 1 then
    local file = uri:sub(match_end + 1)
    window:perform_action(
      wezterm.action({ SpawnCommandInNewWindow = { args = { "bash", "-c", "nvim " .. file } } }),
      pane
    )
    return false
  end
end)

wezterm.on("toggle-opacity", function(window, pane)
  local overrides = window:get_config_overrides() or {}
  if not overrides.window_background_opacity then
    overrides.window_background_opacity = 0.5
  else
    overrides.window_background_opacity = nil
  end
  window:set_config_overrides(overrides)
end)
