return {
  {
    "esensar/nvim-dev-container",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    cond = function()
      return (vim.fn.isdirectory(".devcontainer") ~= 0) or (vim.fn.filereadable(".devcontainer.json") ~= 0)
    end,
    opts = {
      generate_commands = true,
      container_runtime = "docker",
    },
  },

  -- customize nvim-cmp configs
  -- Use <tab> for completion and snippets (supertab)
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local cmp = require("cmp")

      -- This is reaaaally not easy to setup :D
      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.confirm({ select = false })
            -- if the popup is not visible then open the popup
          elseif has_words_before() then
            cmp.complete()
            -- otherwise fallback
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end, { "i", "s" }),
      })
    end,
  },

  -- scopes
  {
    "tiagovla/scope.nvim",
    event = "VeryLazy",
    config = true,
  },

  -- tidy
  {
    "mcauley-penney/tidy.nvim",
    event = "VeryLazy",
    config = {
      filetype_exclude = { "markdown", "diff" },
    },
  },
}
