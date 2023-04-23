local keymap = vim.keymap
-- local opts = { noremap = true, silent = true }
-- vscode.neovim用于注释代码的按键映射
keymap.set("v", "gc", "<Plug>VSCodeCommentary")
keymap.set("n", "gc", "<Plug>VSCodeCommentary")
keymap.set("o", "gc", "<Plug>VSCodeCommentary")
keymap.set("n", "gcc", "<Plug>VSCodeCommentaryLine")
