local wezterm = require("wezterm")
local act = wezterm.action
local M = {}

function M.setup(config)
  config.disable_default_key_bindings = true
  config.use_dead_keys = false -- Allow using ^ with single key press.
  config.leader = { key = "a", mods = "CTRL" }
  config.keys = {
    -- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
    { key = "a", mods = "LEADER|CTRL", action = act.SendString("\x01") },
    -- debug
    { key = "d", mods = "SHIFT|CTRL", action = act.ShowDebugOverlay },
    -- launch menu
    { key = "l", mods = "SHIFT|CTRL", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES|DOMAINS" }) },
    -- command palette
    { key = "p", mods = "SHIFT|CTRL", action = act.ActivateCommandPalette },
    -- workspace
    { key = "<", mods = "SHIFT|CTRL", action = act.SwitchWorkspaceRelative(-1) },
    { key = ">", mods = "SHIFT|CTRL", action = act.SwitchWorkspaceRelative(1) },
    -- window
    { key = "Enter", mods = "SHIFT|CTRL", action = act.ToggleFullScreen },
    { key = "+", mods = "SHIFT|CTRL", action = act.IncreaseFontSize },
    { key = "-", mods = "SHIFT|CTRL", action = act.DecreaseFontSize },
    { key = "=", mods = "CTRL", action = act.ResetFontSize },
    -- tab
    { key = "t", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
    { key = "q", mods = "LEADER", action = act.CloseCurrentTab({ confirm = true }) },
    {
      key = "e",
      mods = "LEADER",
      action = act.PromptInputLine({
        description = "Enter new name for tab",
        action = wezterm.action_callback(function(window, pane, line)
          -- line will be `nil` if they hit escape without entering anything
          if line then
            window:active_tab():set_title(line)
          end
        end),
      }),
    },
    { key = "1", mods = "LEADER", action = act.ActivateTab(0) },
    { key = "2", mods = "LEADER", action = act.ActivateTab(1) },
    { key = "3", mods = "LEADER", action = act.ActivateTab(2) },
    { key = "4", mods = "LEADER", action = act.ActivateTab(3) },
    { key = "5", mods = "LEADER", action = act.ActivateTab(4) },
    { key = "6", mods = "LEADER", action = act.ActivateTab(5) },
    { key = "7", mods = "LEADER", action = act.ActivateTab(6) },
    { key = "8", mods = "LEADER", action = act.ActivateTab(7) },
    { key = "9", mods = "LEADER", action = act.ActivateTab(-1) },
    -- pane
    { key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
    { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
    { key = "-", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
    { key = "\\", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { key = "f", mods = "LEADER", action = act.Search("CurrentSelectionOrEmptyString") },
    { key = "v", mods = "LEADER", action = act.PasteFrom("Clipboard") },
    { key = "V", mods = "LEADER|SHIFT", action = act.PasteFrom("PrimarySelection") },
    -- Quick select path
    { key = "S", mods = "SHIFT|CTRL", action = act.QuickSelect },
    -- Open browser with quickselect https://github.com/wez/wezterm/issues/1362#issuecomment-1000457693
    {
      key = "O",
      mods = "SHIFT|CTRL",
      action = act.QuickSelectArgs({
        label = "OPEN URL",
        patterns = {
          "https?://\\S+",
        },
        action = wezterm.action_callback(function(window, pane)
          local url = window:get_selection_text_for_pane(pane)
          wezterm.log_info("Opening: " .. url)
          wezterm.open_with(url)
        end),
      }),
    },
    -- KeyTable
    { key = "c", mods = "LEADER", action = act.ActivateCopyMode },
    -- LEADER-'r': resize-pane mode until we cancel that mode.
    {
      key = "r",
      mods = "LEADER",
      action = act.ActivateKeyTable({
        name = "resize_pane",
        one_shot = false,
      }),
    },
    -- LEADER-'w': activate-pane mode until we press some other key or until timeout (1000ms)
    {
      key = "w",
      mods = "LEADER",
      action = act.ActivateKeyTable({
        name = "activate_pane",
        timeout_milliseconds = 1000,
      }),
    },
  }
  config.key_tables = {
    -- Defines the keys that are active in our resize-pane mode.
    -- Since we're likely to want to make multiple adjustments,
    -- we made the activation one_shot=false. We therefore need
    -- to define a key assignment for getting out of this mode.
    -- 'resize_pane' here corresponds to the name="resize_pane" in
    -- the key assignments above.
    resize_pane = {
      { key = "LeftArrow", action = act.AdjustPaneSize({ "Left", 1 }) },
      { key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },

      { key = "RightArrow", action = act.AdjustPaneSize({ "Right", 1 }) },
      { key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },

      { key = "UpArrow", action = act.AdjustPaneSize({ "Up", 1 }) },
      { key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },

      { key = "DownArrow", action = act.AdjustPaneSize({ "Down", 1 }) },
      { key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },

      -- Cancel the mode by pressing escape
      { key = "Escape", action = "PopKeyTable" },
    },

    -- Defines the keys that are active in our activate-pane mode.
    -- 'activate_pane' here corresponds to the name="activate_pane" in
    -- the key assignments above.
    activate_pane = {
      { key = "LeftArrow", action = act.ActivatePaneDirection("Left") },
      { key = "h", action = act.ActivatePaneDirection("Left") },

      { key = "RightArrow", action = act.ActivatePaneDirection("Right") },
      { key = "l", action = act.ActivatePaneDirection("Right") },

      { key = "UpArrow", action = act.ActivatePaneDirection("Up") },
      { key = "k", action = act.ActivatePaneDirection("Up") },

      { key = "DownArrow", action = act.ActivatePaneDirection("Down") },
      { key = "j", action = act.ActivatePaneDirection("Down") },
    },
  }
end

return M
