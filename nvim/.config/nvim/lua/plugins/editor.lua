return {
  -- guess indent
  {
    "nmac427/guess-indent.nvim",
    vscode = true,
    config = function()
      require("guess-indent").setup({})
    end,
  },
  -- toggleterm
  {
    "akinsho/toggleterm.nvim",
    config = function()
      require("toggleterm").setup({
        open_mapping = [[<c-\>]],
        shade_terminals = false,
        -- add --login so ~/.zprofile is loaded
        -- https://vi.stackexchange.com/questions/16019/neovim-terminal-not-reading-bash-profile/16021#16021
        shell = "zsh --login",
      })
    end,
    keys = {
      { [[<C-\>]] },
      {
        "<leader>tv",
        function()
          local count = vim.v.count1
          require("toggleterm").toggle(count, 0, vim.loop.cwd(), "vertical")
        end,
        desc = "ToggleTerm (vertical)",
      },
      {
        "<leader>th",
        function()
          local count = vim.v.count1
          require("toggleterm").toggle(count, 10, vim.loop.cwd(), "horizontal")
        end,
        desc = "ToggleTerm (horizontal)",
      },
    },
  },

  -- customize file explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
      filesystem = {
        follow_current_file = true, -- This will find and focus the file in the active buffer every
        -- time the current file is changed while the tree is open.
        group_empty_dirs = true, -- when true, empty folders will be grouped together
        hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
      },
      event_handlers = {
        {
          event = "file_opened",
          handler = function(file_path)
            --auto close
            require("neo-tree").close_all()
          end,
        },
      },
    },
  },

  -- git blame
  {
    "f-person/git-blame.nvim",
    event = "BufReadPre",
  },

  -- git conflict
  {
    "akinsho/git-conflict.nvim",
    event = "BufReadPre",
    config = true,
  },

  -- add zen-mode
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    config = true,
    keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
  },
}
