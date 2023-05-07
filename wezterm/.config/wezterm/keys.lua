local wezterm = require("wezterm")

  return {
    -- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
    { key = "a", mods = "LEADER|CTRL",  action = wezterm.action{SendString="\x01"}},
    { key = "l", mods = "ALT",          action = wezterm.action.ShowLauncher },
    { key = "-", mods = "LEADER",       action = wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}},
    { key = "\\",mods = "LEADER",       action = wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
    { key = "z", mods = "LEADER",       action = "TogglePaneZoomState" },
    { key = "c", mods = "LEADER",       action = wezterm.action{SpawnTab="CurrentPaneDomain"}},
    { key = "h", mods = "LEADER",       action = wezterm.action{ActivatePaneDirection="Left"}},
    { key = "j", mods = "LEADER",       action = wezterm.action{ActivatePaneDirection="Down"}},
    { key = "k", mods = "LEADER",       action = wezterm.action{ActivatePaneDirection="Up"}},
    { key = "l", mods = "LEADER",       action = wezterm.action{ActivatePaneDirection="Right"}},
    { key = "H", mods = "LEADER|SHIFT", action = wezterm.action{AdjustPaneSize={"Left", 5}}},
    { key = "J", mods = "LEADER|SHIFT", action = wezterm.action{AdjustPaneSize={"Down", 5}}},
    { key = "K", mods = "LEADER|SHIFT", action = wezterm.action{AdjustPaneSize={"Up", 5}}},
    { key = "L", mods = "LEADER|SHIFT", action = wezterm.action{AdjustPaneSize={"Right", 5}}},
    -- 控制左右移动面板
    { key = "LeftArrow", mods = "ALT",  action = wezterm.action{ActivateTabRelative=-1}},
    { key = "RightArrow", mods = "ALT", action = wezterm.action{ActivateTabRelative=1}},
    { key = "1", mods = "LEADER",       action = wezterm.action{ActivateTab=0}},
    { key = "2", mods = "LEADER",       action = wezterm.action{ActivateTab=1}},
    { key = "3", mods = "LEADER",       action = wezterm.action{ActivateTab=2}},
    { key = "4", mods = "LEADER",       action = wezterm.action{ActivateTab=3}},
    { key = "5", mods = "LEADER",       action = wezterm.action{ActivateTab=4}},
    { key = "6", mods = "LEADER",       action = wezterm.action{ActivateTab=5}},
    { key = "7", mods = "LEADER",       action = wezterm.action{ActivateTab=6}},
    { key = "8", mods = "LEADER",       action = wezterm.action{ActivateTab=7}},
    { key = "9", mods = "LEADER",       action = wezterm.action{ActivateTab=8}},
    { key = "&", mods = "LEADER|SHIFT", action = wezterm.action{CloseCurrentTab={confirm=true}}},
    { key = "x", mods = "LEADER",       action = wezterm.action{CloseCurrentPane={confirm=true}}},

    { key = "n", mods="SHIFT|CTRL",     action="ToggleFullScreen" },
    -- 新建窗口
    {
      key = "n",
      mods = "CTRL",
      action = wezterm.action.SpawnCommandInNewTab({
        label = "Zsh",
        args = { "/bin/zsh", "-l" },
      }),
    },
    -- 搜索
    {
      key = "f",
      mods = "CTRL",
      action = wezterm.action.Search({
        CaseInSensitiveString = "", -- 大小写不敏感
        -- CaseSensitiveString = ''-- 大小写敏感
      }),
    },
    -- { key = "v", mods="SHIFT|CTRL",     action="Paste"},
    -- { key = "c", mods="SHIFT|CTRL",     action="Copy"},
    -- { -- 清屏
    --   key = "k",
    --   mods = "CMD",
    --   action = wezterm.action.Multiple({
    --     wezterm.action.ClearScrollback("ScrollbackAndViewport"),
    --     wezterm.action.SendKey({
    --       key = "L",
    --       mods = "CTRL",
    --     }),
    --   }),
    -- },
    -- { -- 快速移动到行首行尾
    --   key = "LeftArrow",
    --   mods = "CTRL",
    --   action = wezterm.action.SendKey({
    --     key = "Home",
    --     mods = "NONE",
    --   }),
    -- },
    -- {
    --   key = "RightArrow",
    --   mods = "CTRL",
    --   action = wezterm.action.SendKey({
    --     key = "End",
    --     mods = "NONE",
    --   }),
    -- },
  }
