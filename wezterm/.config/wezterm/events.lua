local wezterm = require("wezterm")
local utils = require("utils")

-- Initial startup
-- wezterm.on("gui-startup", function(cmd)
--   local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
--   window:gui_window():maximize()
-- end)

-- wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
--   local SOLID_LEFT_ARROW = utf8.char(0xe0ba)
--   local SOLID_RIGHT_ARROW = utf8.char(0xe0bc)
--   local SUB_IDX = {
--     "₁",
--     "₂",
--     "₃",
--     "₄",
--     "₅",
--     "₆",
--     "₇",
--     "₈",
--     "₉",
--     "₁₀",
--     "₁₁",
--     "₁₂",
--     "₁₃",
--     "₁₄",
--     "₁₅",
--     "₁₆",
--     "₁₇",
--     "₁₈",
--     "₁₉",
--     "₂₀",
--   }
--   local SUP_IDX = {
--     "¹",
--     "²",
--     "³",
--     "⁴",
--     "⁵",
--     "⁶",
--     "⁷",
--     "⁸",
--     "⁹",
--     "¹⁰",
--     "¹¹",
--     "¹²",
--     "¹³",
--     "¹⁴",
--     "¹⁵",
--     "¹⁶",
--     "¹⁷",
--     "¹⁸",
--     "¹⁹",
--     "²⁰",
--   }
--
--   local left_arrow = SOLID_LEFT_ARROW
--   if tab.tab_index == 0 then
--     left_arrow = ""
--   end
--   local right_arrow = SOLID_RIGHT_ARROW
--   if tab.tab_index == #tabs - 1 then
--     right_arrow = ""
--   end
--
--   local tid = SUB_IDX[tab.tab_index + 1]
--   local pid = SUP_IDX[tab.active_pane.pane_index + 1]
--
--   local function get_icon_title()
--     if pcall(function()
--       tab:get_title()
--     end) then
--       return wezterm.format({
--         {
--           Text = string.format(" %s ", tab:get_title()),
--         },
--       })
--     end
--
--     local process_name = tab.active_pane.foreground_process_name
--     -- remove suffix (wslhost.exe -> wslhost; python3.11 -> python)
--     process_name = utils.basename(process_name):gsub("%d*%.%w+$", "")
--     if not process_name or process_name == "" then
--       process_name = "unknown"
--     end
--
--     -- https://wezfurlong.org/wezterm/config/lua/wezterm/nerdfonts.html
--     local process_icons = {
--       ["unknown"] = wezterm.nerdfonts.cod_workspace_unknown,
--       ["zsh"] = wezterm.nerdfonts.dev_terminal,
--       ["bash"] = wezterm.nerdfonts.cod_terminal_bash,
--       ["wslhost"] = wezterm.nerdfonts.cod_terminal_cmd,
--       ["nvim"] = wezterm.nerdfonts.custom_vim,
--       ["vim"] = wezterm.nerdfonts.dev_vim,
--       ["wget"] = wezterm.nerdfonts.md_arrow_down_bold_box,
--       ["curl"] = wezterm.nerdfonts.md_arrow_down_bold_box_outline,
--       ["tar"] = wezterm.nerdfonts.cod_file_zip,
--       ["unzip"] = wezterm.nerdfonts.cod_file_zip,
--       ["top"] = wezterm.nerdfonts.md_chart_donut_variant,
--       ["docker"] = wezterm.nerdfonts.linux_docker,
--       ["git"] = wezterm.nerdfonts.dev_git,
--       ["cargo"] = wezterm.nerdfonts.dev_rust,
--       ["go"] = wezterm.nerdfonts.dev_go,
--       ["python"] = wezterm.nerdfonts.dev_python,
--       ["lua"] = wezterm.nerdfonts.seti_lua,
--       ["node"] = wezterm.nerdfonts.dev_nodejs_small,
--     }
--
--     return wezterm.format({
--       {
--         Text = string.format(" %s ", process_icons[process_name] or process_name),
--       },
--     })
--   end
--   local title = get_icon_title()
--
--   local foreground = "#1C1B19"
--   local background = "#4E4E4E"
--   if tab.is_active then
--     background = "#FBB829"
--   else
--     -- alert unseen output on non active tabs
--     local has_unseen_output = false
--     for _, pane in ipairs(tab.panes) do
--       if pane.has_unseen_output then
--         has_unseen_output = true
--         break
--       end
--     end
--     if has_unseen_output then
--       title = title .. wezterm.nerdfonts.seti_yml
--       background = "#FE5722"
--     elseif hover then
--       background = "#FF8700"
--     end
--   end
--
--   local edge_foreground = background
--   local edge_background = "#121212"
--   local dim_foreground = "#3A3A3A"
--
--   return {
--     { Attribute = { Intensity = "Bold" } },
--     { Background = { Color = edge_background } },
--     { Foreground = { Color = edge_foreground } },
--     { Text = left_arrow },
--     { Background = { Color = background } },
--     { Foreground = { Color = foreground } },
--     { Text = tid },
--     { Text = title },
--     { Foreground = { Color = dim_foreground } },
--     { Text = pid },
--     { Background = { Color = edge_background } },
--     { Foreground = { Color = edge_foreground } },
--     { Text = right_arrow },
--     { Attribute = { Intensity = "Normal" } },
--   }
-- end)

wezterm.on("update-status", function(window, pane)
  local cells = {}

  -- show which key table is active in the status area
  local name = window:active_key_table()
  if name then
    table.insert(cells, "  " .. name)
  end

  local workspace = window:active_workspace()
  if workspace ~= "default" then
    table.insert(cells, "  " .. workspace)
  end

  local hostname, cwd = utils.get_hostname_cwd(pane)
  if hostname then
    table.insert(cells, "  " .. hostname) -- utf8.char(0xeb99)
  end
  if cwd then
    table.insert(cells, " " .. cwd)
  end

  local date = wezterm.strftime("%a %b %-d %H:%M")
  table.insert(cells, "  " .. date)

  local COLORS = {
    "#3c1361",
    "#52307c",
    "#663a82",
    "#7c5295",
    "#b491c8",
  }
  -- The filled in variant of the < symbol
  local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider
  -- The filled in variant of the > symbol
  -- local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

  local text_fg = "#c0c0c0"
  local elements = {}
  local num_cells = 0

  table.insert(elements, { Foreground = { Color = "#3c1361" } })
  table.insert(elements, { Text = SOLID_LEFT_ARROW })

  local function push(text, is_last)
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
  wezterm.log_info("open-uri: " .. uri)
  local start, match_end = uri:find("file://")
  if start == 1 then
    local file = uri:sub(match_end + 1)

    local direction = "Left"
    local editor_pane = pane:tab():get_pane_direction(direction)
    if editor_pane == nil then
      -- local command = { args = { "bash", "-c", "nvim " .. file } }
      local command = { args = { "helix", file } } -- for helix
      local action = wezterm.action({ SplitPane = { direction = direction, command = command } })
      window:perform_action(action, pane)
    else
      local command = ":open " .. file .. "\r\n" -- for helix
      local action = wezterm.action.SendString(command)
      window:perform_action(action, editor_pane)
    end
    -- prevent the default action from opening in a browser
    return false
  end
  -- otherwise, by not specifying a return value, we allow later
  -- handlers and ultimately the default action to caused the
  -- URI to be opened in the browser
end)

wezterm.on("toggle-opacity", function(window)
  local overrides = window:get_config_overrides() or {}
  if not overrides.window_background_opacity then
    overrides.window_background_opacity = 0.5
  else
    overrides.window_background_opacity = nil
  end
  window:set_config_overrides(overrides)
end)
