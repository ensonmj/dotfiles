-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Leader key
-- vim.g.mapleader = ","

-- Color scheme
vim.o.termguicolors = true

-- Encoding {{{
vim.o.encoding = "utf-8"
vim.o.fileencoding = "utf-8"
vim.o.fencs = "utf-8,ucs-bom,gb18030,gbk,gb2312,cp936"
-- A fullwidth character is displayed in vim properly.
-- seems be conflicted with other plugins
-- vim.o.ambiwidth = "double"
-- }}}

-- View {{{
vim.o.number = true
vim.o.relativenumber = true
vim.o.colorcolumn = 120
-- vim.o.signcolumn = "auto:2"
-- vim.o.signcolumn = "number"
vim.o.signcolumn = "yes:1"
vim.o.cursorcolumn = true
vim.o.cursorline = true

-- vim.o.cmdheight = 0
vim.opt.list = true
vim.opt.listchars = {
  tab = "▸\\-",
  trail = "-",
  extends = "❯",
  precedes = "❮",
  nbsp = "␣",
  -- extends = "»", -- RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00BB, UTF-8: C2 BB)
  -- precedes = "«", -- LEFT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00AB, UTF-8: C2 AB)
  -- nbsp = "⦸ ", -- CIRCLED REVERSE SOLIDUS (U+29B8, UTF-8: E2 A6 B8)
}

-- conceal
vim.o.conceallevel = 2
vim.o.concealcursor = "nc"

-- When a line is long, do not omit it in @.
-- Display an invisible letter with hex format.
vim.o.display = "lastline,uhex"

-- Use vertical diff format
vim.opt.diffopt:append("vertical")
-- }}}

-- Maintain a current line at the time of movement as much as possible.
vim.o.nostartofline = true
--  Report changes.
vim.o.report = 0

-- 在底部显示标尺，显示行号列号和百分比
vim.o.ruler = true

-- 光标移动到buffer的顶部和底部时保持3距离
vim.o.scrolloff = 2

-- 信息提示格式
-- vim.o.shortmess="acToOI"

-- Display all the information of the tag by the supplement of the Insert mode.
vim.o.showfulltag = true

-- Show (partial) command on statusline.
vim.o.showcmd = true

-- define the behavior of the selection
vim.o.selection = "inclusive"

-- Splitting a window will put the new window below the current one.
vim.o.splitbelow = true
-- Splitting a window will put the new window right the current one.
vim.o.splitright = true

-- Show title.
vim.o.title = true
-- Title length.
vim.o.titlelen = 95
-- " Title string.
vim.o.titlestring = '%t%(\\ %M%)%(\\ (%{expand("%:p:h")})%)%(\\ %a%)\\ -\\ %{v:servername}'

--  Wrap long line.
vim.o.wrap = true
-- " Wrap conditions.
-- vim.opt.whichwrap:append({ "h", "l", "<", ">", "[", "]", "b", "s", "~" })
-- Turn down a long line appointed in 'breakat'
vim.o.linebreak = true
vim.o.breakat = "\\ \\	;:,!?"
-- " set showbreak=>\
vim.o.showbreak = "↪"

-- Turn on wild menu
vim.o.wildmenu = true
-- "set wildmode=longest,list
vim.opt.wildignore:append({ "*.a", "*.o", "*.obj" })
vim.opt.wildignore:append({ "*~", "*.swp", "*.swo", "*.tmp" })
vim.opt.wildignore:append({ ".git", ".hg", ".svn" })
-- " Can supplement a tag in a command-line.
vim.o.wildoptions = "tagfile"

vim.o.smarttab = true
vim.o.expandtab = true
vim.o.textwidth = 120
vim.o.smartindent = true
vim.o.autoindent = true
vim.o.cindent = true
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.tabstop = 4

vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.ignorecase = true

vim.o.showmatch = true
vim.o.matchtime = 1

vim.o.hidden = true
vim.o.updatetime = 100
vim.o.laststatus = 2
vim.o.history = 500
vim.o.backup = false
vim.o.swapfile = false
vim.o.foldenable = true
vim.o.autoread = true
vim.o.autowrite = true
vim.o.mouse = "a"

-- filetype
local cmd = vim.cmd
local ncmd = vim.api.nvim_command
ncmd("filetype plugin indent on")
cmd([[ autocmd FileType lua setlocal tabstop=4 shiftwidth=4 softtabstop=4 textwidth=120 noexpandtab]])
cmd([[ autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4 textwidth=120 ]])
cmd([[ autocmd FileType json,jsonnet setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab ]])
cmd([[ autocmd FileType go setlocal tabstop=4 shiftwidth=4 softtabstop=4 textwidth=120 noexpandtab ]])
cmd([[ autocmd FileType html,htmldjango,xhtml,haml setlocal tabstop=2 shiftwidth=2 softtabstop=2 textwidth=0 ]])
cmd([[ autocmd FileType yaml setlocal tabstop=2 shiftwidth=2 softtabstop=2 textwidth=0 expandtab ]])
cmd([[ autocmd FileType less,sass,scss,css setlocal tabstop=2 shiftwidth=2 softtabstop=2 textwidth=120 ]])
cmd([[ autocmd FileType javascript,javascript.jsx,typescript setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab ]])
cmd([[ autocmd FileType NvimTree setlocal tabstop=2 shiftwidth=2 softtabstop=2 textwidth=0 ]])
cmd([[ autocmd BufNewFile,BufRead *.proto setfiletype proto ]])
cmd([[ autocmd FileType proto setlocal shiftwidth=4 expandtab ]])
