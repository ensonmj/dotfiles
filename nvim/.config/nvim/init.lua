-- local vscode = vim.g.vscode == 1
if vim.g.vscode then
  require("vscode.config.autocmds")
  require("vscode.config.keymaps")
  require("vscode.config.options")
  require("vscode.config.lazy")
else
  -- bootstrap lazy.nvim, LazyVim and other plugins
  require("config.lazy")
end
