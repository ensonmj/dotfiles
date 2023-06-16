-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Leader key {{{
vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- }}}
vim.o.mouse = "a"

-- Encoding {{{
vim.o.encoding = "utf-8"
vim.o.fileencoding = "utf-8"
vim.o.fencs = "utf-8,ucs-bom,gb18030,gbk,gb2312,cp936"
-- A fullwidth character is displayed in vim properly.
-- seems be conflicted with other plugins (ident line)
-- vim.o.ambiwidth = "double"
-- }}}

-- View {{{
vim.o.termguicolors = true
vim.o.number = true
vim.o.colorcolumn = 120
vim.o.signcolumn = "yes:1"
vim.o.cursorcolumn = true
vim.o.cursorline = true

-- vim.o.cmdheight = 0
vim.opt.list = true
vim.opt.listchars = {
  tab = "▸ ",
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

-- Maintain a current line at the time of movement as much as possible.
vim.o.nostartofline = true

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

--  Wrap long line.
vim.o.wrap = true
-- " Wrap conditions.
vim.o.whichwrap = "b,s,<,>,~,[,]"
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
-- }}}

-- Search {{{
-- Ignore the case of normal letters.
vim.o.ignorecase = true
-- If the search pattern contains upper case characters, override ignorecase option.
vim.o.smartcase = true
-- Enable incremental search.
vim.o.incsearch = true
-- Enable highlight search result.
vim.o.hlsearch = true
-- Searches wrap around the end of the file.
vim.o.wrapscan = true
-- }}}

-- Edit {{{
-- Set to auto read when a file is changed from the outside
vim.o.autoread = true
vim.o.autowrite = true

vim.o.complete = ".,w,b,i,t"
vim.o.completeopt = "menuone,noinsert,noselect"

vim.o.textwidth = 120
vim.o.smarttab = true
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.cindent = true
vim.o.shiftwidth = 4

-- yank to clipboard
-- nvim depends on external clipboard tool, such as xclip/xsel
vim.o.clipboard = "unnamedplus"

-- allow backspacing over everything in insert mode
vim.o.backspace = "indent,eol,start"

-- Highlight parenthesis.
vim.o.showmatch = true
vim.o.matchtime = 3
-- Highlight when CursorMoved.
-- set cpoptions-=m
vim.opt.cpoptions:remove("m")
-- Highlight <>.
vim.opt.matchpairs:append("<:>")

-- When on a buffer becomes hidden when it is abandoned.
vim.o.hidden = true

-- 在插入模式按回车时，自动插入当前注释前导符。
vim.opt.formatoptions:append("r")
-- Enable multibyte format.
vim.opt.formatoptions:append({ "m", "M" })

-- Ignore case on insert completion.
vim.o.infercase = true

-- Enable folding.
vim.o.foldenable = true
-- 设置折叠方式
vim.o.foldmethod = "indent"
-- set foldmethod=syntax -- too slow
-- set foldmethod=marker
-- Show folding level.
vim.o.foldcolumn = "3"
vim.o.foldlevel = 99
-- vim.o.foldlevelstart = 1

-- Set undofile
vim.o.undofile = true
vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false
vim.o.updatetime = 200

-- " 自动向当前文件的上级查找tag文件，直到找到为止
vim.o.tags = "./.tags;,.tags"

-- Set keyword help.
-- set keywordprg=:help

-- 记录的历史命令数目
vim.o.history = 1000
-- }}}

-- vim: foldmethod=marker foldlevel=0
