" ====================================================
" Initialize(platform depends)
" ----------------------------------------------------
" {{{
if has('win32') || has('win64')
    " For Windows"{{{
    " 设置终端提示使用语言，解决consle输出乱码
    language messages zh_CN.UTF-8
    language time English

    " In Windows, can't find exe, when $PATH isn't contained $VIM.
    if $PATH !~? '\(^\|;\)' . escape($VIM, '\\') . '\(;\|$\)'
        let $PATH = $VIM . ';' . $PATH
    endif

    if has('gui_running')
        " 使用guifont设置英文字体
        set guifont=Courier_New:h12:w7
        " 使用guifontwide设置中文等宽字体
        set guifontwide=NSimSun-18030,NSimSun
    endif

    " Exchange path separator.
    set shellslash

    " directory fow swap file
    set directory+=$TMP

    " directory for persistent undo
    set undodir=$TMP
    "}}}
else
    " For Linux"{{{
    " 设置终端提示使用语言，解决consle输出乱码
    language messages en_US.UTF-8
    language time en_US.UTF-8

    " directory for persistent undo
    set undodir=/tmp
    "}}}
endif
"}}}
" ====================================================
" Encoding "{{{
" 注意新建文件跟空文件的区别
" 新建文件：使用vim建立的新文件，此时编码按照fileencoding来设置
" 空文件：  比如在windows下，使用右键新建文本文档，这样就建立了一个空白文件
"           vim打开此空白文件，会探测文件编码，由于文件是空白，所有探测结果
"           肯定是fileencodings中的第一个（此处utf-8），这样在windows下用其
"           他编辑器打开含有中文的文件时就会乱码。(set fenc=chinese)
"           "}}}
" ----------------------------------------------------
"{{{
set encoding=utf-8
set termencoding=utf-8
" set fileencoding=chinese
set fileencodings=usc-bom,utf-8,chinese,latin1

" A fullwidth character is displayed in vim properly.
set ambiwidth=double
"}}}
" ====================================================
" View
" ----------------------------------------------------
"{{{
" Height of command line.
set cmdheight=2

set colorcolumn=80

" For conceal
set conceallevel=2
set concealcursor=nc

" When a line is long, do not omit it in @.
" Display an invisible letter with hex format.
set display=lastline,uhex

" Use vertical diff format
set diffopt+=vertical

" 状态栏显示
set laststatus=2

" Don't redraw while macro executing.
set lazyredraw

" 设置显示tab和行尾
set list
" set listchars=tab:\|\ ,trail:-,extends:>,precedes:<,nbsp:␣
set listchars=tab:▸\ 
" set listchars+=trail:▫
set listchars+=trail:-
set listchars+=nbsp:⦸      " CIRCLED REVERSE SOLIDUS (U+29B8, UTF-8: E2 A6 B8)
set listchars+=extends:»   " RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00BB, UTF-8: C2 BB)
set listchars+=precedes:«  " LEFT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00AB, UTF-8: C2 AB)

" In many terminal emulators the mouse works just fine, thus enable it.
set mouse=a

" 显示行号
set number

" No equal window size.
set noequalalways

" Maintain a current line at the time of movement as much as possible.
set nostartofline

" Set popup menu max height.
set pumheight=20

" Report changes.
set report=0

" 在底部显示标尺，显示行号列号和百分比
set ruler

" 光标移动到buffer的顶部和底部时保持3距离
set scrolloff=2

" 信息提示格式
set shortmess=acToOI

" Display all the information of the tag by the supplement of the Insert mode.
set showfulltag

" Show (partial) command on statusline.
set showcmd

" define the behavior of the selection
set selection=inclusive

" Splitting a window will put the new window below the current one.
set splitbelow
" Splitting a window will put the new window right the current one.
set splitright

" Show title.
set title
" Title length.
set titlelen=95
" Title string.
set titlestring=%t%(\ %M%)%(\ (%{expand(\"%:p:h\")})%)%(\ %a%)\ -\ %{v:servername}

" Wrap long line.
set wrap
" Wrap conditions.
set whichwrap+=h,l,<,>,[,],b,s,~
" Turn down a long line appointed in 'breakat'
set linebreak
set breakat=\ \	;:,!?
" set showbreak=>\
set showbreak=↪

"Turn on Wild menu
set wildmenu
"set wildmode=longest,list
set wildignore+=*.a,*.o,*.obj
set wildignore+=*~,*.swp,*.swo,*.tmp
set wildignore+=.git,.hg,.svn

" Can supplement a tag in a command-line.
set wildoptions=tagfile

" modeline
set modeline
"}}}
" ====================================================
" Search
" ----------------------------------------------------
"{{{
" Ignore the case of normal letters.
set ignorecase
" If the search pattern contains upper case characters, override ignorecase option.
set smartcase

" Enable incremental search.
set incsearch
" Enable highlight search result.
set hlsearch

" Searches wrap around the end of the file.
set wrapscan
"}}}
" ====================================================
" Edit
" ----------------------------------------------------
" {{{
"Set to auto read when a file is changed from the outside
set autoread
set autowrite

" Don't complete from other buffer.
" set complete=.
"set complete=.,w,b,i,t
" set completeopt=menuone,noinsert,noselect

set smarttab
set tabstop=4
set expandtab
set softtabstop=4
set autoindent
set smartindent
set shiftwidth=4
set shiftround

" yank to clipboard
if has("clipboard")
    set clipboard=unnamed " copy to the system clipboard

    if has("unnamedplus") " X11 support
        set clipboard+=unnamedplus
    endif
endif

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Highlight parenthesis.
set showmatch
" Highlight when CursorMoved.
set cpoptions-=m
set matchtime=3
" Highlight <>.
set matchpairs+=<:>

" When on a buffer becomes hidden when it is abandoned.
set hidden

" 在插入模式按回车时，自动插入当前注释前导符。
set formatoptions+=r
" Enable multibyte format.
set formatoptions+=mM

" Ignore case on insert completion.
set infercase

" Enable folding.
set foldenable
" 设置折叠方式
set foldmethod=indent
"set foldmethod=syntax " too slow
"set foldmethod=marker
" Show folding level.
set foldcolumn=3
set foldlevel=99

" Set undofile
set undofile

" 自动向当前文件的上级查找tag文件，直到找到为止
set tags=./.tags;,.tags

" Set keyword help.
"set keywordprg=:help

" 记录的历史命令数目
set history=1000
" }}}
" ====================================================
" Session
" ----------------------------------------------------
" viminfo"{{{
" create viminfo :wviminfo [file]
" load viminfo :rviminfo [file]
"}}}
" session"{{{
" create sesssion :mksession [file]
" load session :source {file}
set sessionoptions-=curdir
set sessionoptions+=sesdir
"}}}
" ====================================================
" Command
" ----------------------------------------------------
" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis
" In case /tmp get's clean out, make a new tmp directory for vim
command! MkTmpdir call mkdir(fnamemodify(tempname(), ":p:h"))
" ====================================================
" Set my autogroup
" ----------------------------------------------------
augroup MyAutoCmd
    autocmd!
    " Auto reload vimrc and VimScript
    "autocmd BufWritePost,FileWritePost .vimrc,*.vim if &autoread | source <afile> | endif

    " 自动给光标所在单词添加下划线
    autocmd CursorHold * silent! exe printf('match Underlined /\<%s\>/', expand('<cword>'))
    " 自动高亮匹配光标所在所有单词
    "autocmd CursorMoved * silent! exe printf('match IncSearch /\<%s\>/', expand('<cword>'))

    " For all text files set 'textwidth' to 80 characters.
    autocmd FileType text setlocal textwidth=80

    " Close help and git window by pressing q.
    autocmd FileType help,qf,quickrun,qfreplace,ref,git-status,git-log,gitcommit
                \ nnoremap <buffer><silent> q :<C-u>call <sid>smart_close()<CR>
    autocmd FileType * if (&readonly || !&modifiable) && !hasmapto('q', 'n')
                \ | nnoremap <buffer><silent> q :<C-u>call <sid>smart_close()<CR>| endif

    " view"{{{
    " save fold and other status
    "au BufWinLeave *.* mkview
    " load all saved status
    "au BufWinEnter *.* silent loadview
    "}}}

    " 解决quickfix 窗口乱码
    " autocmd BufReadPost quickfix call QfConv()
augroup END

" {{{
func! s:smart_close()
    if winnr('$') != 1
        close
    endif
endfunc
func! QfConvCU()
    let qflist = getqflist()
    for i in qflist
        let i.text = iconv(i.text, "cp936", "utf-8")
    endfor
    call setqflist(qflist)
endfunc
func! QfConvUC()
    let qflist = getqflist()
    for i in qflist
        let i.text = iconv(i.text, "utf-8", "cp936")
    endfor
    call setqflist(qflist)
endfunc
" }}}
" ====================================================
" Plugins {{{
" ----------------------------------------------------
if has('win32') || has('win64')
    let s:bundle_dir = expand("$VIM/Vimfiles")
else
    let s:bundle_dir = expand("$HOME/.vim")
endif
let s:plug_dst = s:bundle_dir . '/autoload/plug.vim'
if empty(glob(s:plug_dst))
    let s:plug_src = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    execute printf('!curl -fLo %s --create-dirs %s', s:plug_dst, s:plug_src)
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

" VCS {{{
Plug 'tpope/vim-fugitive'
" Show cvs repository changes in the current file
Plug 'mhinz/vim-signify'
"}}}

" CPP {{{
Plug 'octol/vim-cpp-enhanced-highlight'
" }}}

" Go {{{
" vim-go {{{
" Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries'}
" " Disable auto installation of binaries
" let g:go_disable_autoinstall = 1

" let g:go_fmt_command = "goimports"
" let g:go_fmt_fail_silently = 1
" let g:go_metalinter_autosave = 1
" let g:to_auto_type_info = 1
" let g:go_list_type = "quickfix"

" " highlight
" let g:go_highlight_functions = 1
" let g:go_highlight_methods = 1
" let g:go_highlight_fields = 1
" let g:go_highlight_types = 1
" let g:go_highlight_operators = 1
" let g:go_highlight_build_constraints = 1
" }}}
" }}}

" Python {{{
" {{{
Plug 'vim-python/python-syntax'
let g:python_highlight_all = 1
" }}}
Plug 'python-mode/python-mode'
let g:pymode_rope_regenerate_on_write = 0
" SimpylFold {{{
Plug 'tmhedberg/SimpylFold'
let g:SimpylFold_docstring_preview = 1
" }}}
Plug 'sillybun/autoformatpythonstatement', {'do': './install.sh'}
"}}}

" Javascript {{{
Plug 'pangloss/vim-javascript'
"}}}

" Markup {{{
" vim-json {{{
Plug 'elzr/vim-json'
let g:vim_json_syntax_conceal = 0
" }}}
Plug 'cespare/vim-toml'
" tabular {{{
Plug 'godlygeek/tabular'
" }}}
Plug 'plasticboy/vim-markdown' " the tabular plugin must come before vim-markdown
Plug 'othree/html5.vim'
Plug 'mattn/emmet-vim'
Plug 'sukima/xmledit'
" vim-css-color{{{
Plug 'ap/vim-css-color'
let g:ccsColorVimDoNotMessMyUpdatetime = 1
" }}}
Plug 'hail2u/vim-css3-syntax'
"}}}

" Text-object {{{
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-syntax'
Plug 'kana/vim-textobj-indent' " ai/ii for a block of similarly indented lines, aI/iI for a block of lines with the same indentation
Plug 'kana/vim-textobj-underscore' " a_, i_
Plug 'kana/vim-textobj-function' " af/if and aF/iF for a function/extensible for any language
Plug 'kana/vim-textobj-lastpat' " a/, i/, a?, i? for a region matched to the last search pattern
Plug 'kana/vim-textobj-fold' " az/iz for a block of folded lines
Plug 'kana/vim-textobj-datetime' " ada/ida and others for date and time
Plug 'Julian/vim-textobj-brace' " aj/ij for the closet region betwen any of () [] or {}
Plug 'glts/vim-textobj-comment' " ac/ic for a comment
Plug 'rhysd/vim-textobj-continuous-line' " av/iv for lines continued by \ in c++,sh,and others
Plug 'vimtaku/vim-textobj-keyvalue' " ak/ik, av/iv for key/value
Plug 'sgur/vim-textobj-parameter' " a,/i, for an argument to a function
Plug 'mattn/vim-textobj-url' " au/iu for a URL
Plug 'gcmt/wildfire.vim' " smart selection of the closest text object
"}}}

" Text manipulation {{{
"vim-endwise fix conflict with delimitMate in imap <cr>
"when load after delimitMate
" delimitMate{{{
" Autocompletion of (, [, {, ', ", ...
Plug 'Raimondi/delimitMate'
let g:delimitMate_matchpairs = "(:),[:],{:}"
let g:delimitMate_expand_cr = 1
" }}}
Plug 'tpope/vim-endwise'
" extend repetitions by the 'dot' key
Plug 'tpope/vim-repeat'
" to surround vim objects with a pair of identical chars
Plug 'tpope/vim-surround'

" smartchr.vim"{{{
Plug 'kana/vim-smartchr'
"}}}
Plug 'kana/vim-operator-user'
Plug 'kana/vim-operator-replace'

Plug 'Yggdroot/indentLine'
Plug 'othree/eregex.vim'
"}}}

" A better looking status line
" vim-airline {{{
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline_theme='base16'
" }}}
" vim-bufferline {{{
Plug 'bling/vim-bufferline'
let g:bufferline_rotate = 1
let g:bufferline_fixed_index = 0 "always first
" }}}
" shortcut
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-obsession'
Plug 'Lokaltog/vim-easymotion'
" marks admin
"Plug 'kshenoy/vim-signature'
" Auto detect CJK and Unicode file encodings
Plug 'mbbill/fencview'
" Display c/c++ function declaration in vim command/status line
Plug 'mbbill/echofunc'
" For edit .tmux.conf
Plug 'tmux-plugins/vim-tmux'
" Restore 'FocusGained' and 'FocusLost' autocommand events when using vim in tmux
Plug 'tmux-plugins/vim-tmux-focus-events'
" Use '*' and '#' to search current selection
Plug 'bronson/vim-visual-star-search'
" echodoc.vim"{{{z
Plug 'Shougo/echodoc'
let g:echodoc_enable_at_startup = 1
"}}}

" Misc tools {{{
Plug 'toupeira/vim-desertink' " colorscheme
Plug 'liuchengxu/vim-which-key'
Plug 'Shougo/junkfile.vim' " Create scratch files with filetype

Plug 'kopischke/vim-stay'
Plug 'Yggdroot/LeaderF', {'do': './install.sh'}
Plug 'rickhowe/diffchar.vim'
Plug 'AndrewRadev/linediff.vim'
Plug 'vim-scripts/indentpython.vim'
Plug 'vim-scripts/matchit.zip'
Plug 'vim-scripts/a.vim'
"}}}

" ale linter {{{
Plug 'w0rp/ale'
let g:ale_fix_on_save = 1
let g:ale_echo_msg_format = '[%linter%] %code: %%s'
let g:airline#extensions#ale#enabled = 1
"}}}

call plug#end()
" }}}
" ====================================================
" settings after plugin
" ====================================================
" colorscheme {{{
colorscheme desertink
" }}}
" ====================================================
" Key map
" ----------------------------------------------------
"{{{
let mapleader = "\<Space>"
let maplocalleader = ","

" vim-which-key {{{
" Define prefix dictionary
" let g:which_key_map =  {}
nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
nnoremap <silent> <localleader> :<c-u>WhichKey  ','<CR>
" }}}

" Easy expansion of the active file directory
" taken from Practical Vim
cnoremap <expr> %% getcmdtype() == ":" ? expand('%:h').'/' : '%%'
"change directory to the file being edited and display it
nnoremap <Leader>cd :cd %:p:h<CR>:pwd<CR>

"windows managment{{{{
"close
map <Leader>wc :wincmd q<cr>
"rotate
map <Leader>wr :wincmd r<cr>
"move
map <Leader>wh :wincmd H<cr>
map <Leader>wk :wincmd K<cr>
map <Leader>wl :wincmd L<cr>
map <Leader>wj :wincmd J<cr>
"resize
map <Leader>wH :3wincmd <<cr>
map <Leader>wK :3wincmd ><cr>
map <Leader>wL :3wincmd +<cr>
map <Leader>wJ :3wincmd -<cr>
"}}}}

" tabular {{{
nmap <Leader>a= :Tabularize /=<CR>
vmap <Leader>a= :Tabularize /=<CR>
nmap <Leader>a: :Tabularize /:\zs<CR>
vmap <Leader>a: :Tabularize /:\zs<CR>
" }}}

" wildfire {{{
" " selects the next closest text object
" map <SPACE> <Plug>(wildfire-fuel)
" " selects the previous closest text object
" vmap <C-SPACE> <Plug>(wildfire-water)
" " quick selection
" nmap <Leader>s <Plug>(wildfire-quick-select)
" }}}

augroup MyAutoCmd
    " vim-go {{{
    " Commands
    autocmd FileType go nmap <Leader>r <Plug>(go-run)
    autocmd FileType go nmap <Leader>b <Plug>(go-build)
    autocmd FileType go nmap <Leader>t <Plug>(go-test)
    " Open definition/declaration
    autocmd FileType go nmap <Leader>ds <Plug>(go-def-split)
    autocmd FileType go nmap <Leader>dv <Plug>(go-def-vertical)
    autocmd FileType go nmap <Leader>dt <Plug>(go-def-tab)
    " Open the relevant Godoc for the word under cursor
    autocmd FileType go nmap <Leader>gd <Plug>(go-doc)
    autocmd FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
    " Show a list of interfaces which is implemented by the type under cursor
    autocmd FileType go nmap <Leader>s <Plug>(go-implements)
    " Show type info for the word under cursor
    autocmd FileType go nmap <Leader>i <Plug>(go-info)
    " Rename the identifier under the cursor
    autocmd FileType go nmap <Leader>e <Plug>(go-rename)
    " }}}

    " smartchr {{{
    autocmd FileType vim inoremap <buffer> <expr> . smartchr#loop('.', ' . ', '..', '...')
    autocmd FileType c,cpp inoremap <buffer> <expr> . smartchr#loop('.', '->', '...')
    autocmd FileType eruby
                \ inoremap <buffer> <expr> > smartchr#loop('>', '%>')
                \| inoremap <buffer> <expr> < smartchr#loop('<', '<%', '<%=')
    " }}}
augroup END
"}}}
" ====================================================
" vim: foldmethod=marker foldlevel=0
