" ====================================================
" Initialize(platform depends)
" ----------------------------------------------------
" {{{
augroup MyAutoCmd
    autocmd!
augroup END

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

    " Exchange path separator.
    set shellslash

    " directory for persistent undo
    set undodir=/tmp

    " For non GVim.
    if !has('gui_running')
        " Enable 256 color terminal.
        if !exists('$TMUX')
            set t_Co=256
        endif
    endif
    "}}}
endif
"}}}
" ====================================================
" Encoding（兼容Linux）"{{{
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
"set termencoding=utf-8
"set fileencoding=chinese
set fileencodings=usc-bom,utf-8,chinese

" A fullwidth character is displayed in vim properly.
"set ambiwidth=double

" 解决quickfix 窗口乱码
function! QfConvCU()
    let qflist = getqflist()
    for i in qflist
        let i.text = iconv(i.text, "cp936", "utf-8")
    endfor
    call setqflist(qflist)
endfunction
function! QfConvUC()
    let qflist = getqflist()
    for i in qflist
        let i.text = iconv(i.text, "utf-8", "cp936")
    endfor
    call setqflist(qflist)
endfunction
augroup MyAutoCmd
"    autocmd BufReadPost quickfix call QfConv()
augroup END
"}}}
" ====================================================
" View
" ----------------------------------------------------
"{{{
" Set maximam command line window.
set cmdwinheight=5
" Height of command line.
"set cmdheight=2

set colorcolumn=80

" Don't complete from other buffer.
set complete=.
"set complete=.,w,b,i,t

" For conceal
set conceallevel=2
set concealcursor=nc
"set concealcursor=iv

" When a line is long, do not omit it in @.
set display=lastline
" Display an invisible letter with hex format.
set display+=uhex

" Use vertical diff format
set diffopt+=vertical

" 设置窗口
" set lines=35
" set columns=100

" 不显示工具栏
set guioptions-=T

" 不显示菜单栏
"set guioptions-=m
" 不显示撕裂菜单
set guioptions-=t
" 解决菜单乱码
source $VIMRUNTIME/delmenu.vim
" 加载默认菜单
source $VIMRUNTIME/menu.vim
" 设置菜单语言
"set langmenu=en_US

" 记录的历史命令数目
set history=200

" 状态栏显示
" Always display statusline.
set laststatus=2   " 显示状态栏 (默认值为 1, 无法显示状态栏)

" Don't redraw while macro executing.
set lazyredraw

" 设置显示tab和行尾
set list
set listchars=tab:\|\ ,trail:-,extends:>,precedes:<,nbsp:␣

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
set shortmess=aToOI

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
set wildignore+=*.a,*.o
set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png
set wildignore+=.git,.hg,.svn
set wildignore+=*~,*.swp,*.tmp

" Can supplement a tag in a command-line.
set wildoptions=tagfile

" Set minimal width for current window.
set winwidth=30
" Set minimal height for current window.
set winheight=1

" Adjust window size of preview and help.
"set previewheight=10
"set helpheight=12

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
"}}}
" ====================================================
" Edit
" ----------------------------------------------------
" {{{
"Set to auto read when a file is changed from the outside
set autoread
set autowrite

" 'ts' is how tab characters are displayed;
" 'sts' is how many "spaces" to insert when the tab key is pressed;
" 'sw' is how many "spaces" to use per indent level;
" 'et' is whether to use spaces or tabs;
" 'sta' lets you insert 'sw' "spaces" when pressing tab at the beginning of a line.
" 设置没有展开的<Tab>的宽度为4个空格
set tabstop=4
" 4个空格代替一个输入的<Tab>
set softtabstop=4
" (自动) 缩进每一步使用的空白数目。用于 'cindent'、>>、<< 等。
set shiftwidth=4
" 新输入的<Tab>展开为空格
set expandtab
" 行首<Tab>按照shiftwidth展开
set smarttab
" Round indent by shiftwidth.
set shiftround

" Enable modeline.
set modeline
" Use + as clipboard register.
set clipboard^=unnamedplus

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" do not keep a backup file, use versions instead
set nobackup

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
" syntax is too slow
"set foldmethod=syntax
"set foldmethod=marker
" Show folding level.
"set foldcolumn=1
set foldcolumn=3

" grep选项
"set grepprg=grep\ -nri
" Use vimgrep.
"set grepprg=internal
" Use grep.
set grepprg=grep\ -nH

" Set undofile
set undofile

" auto change the current working director
"set autochdir
"autocmd BufEnter * silent! lcd %:p:h

" 自动向当前文件的上级查找tag文件，直到找到为止
" support vim-easytags
set tags=./tags;~/.vimtags

" Set keyword help.
"set keywordprg=:help
" }}}
" ====================================================
" Syntax
" ----------------------------------------------------
" {{{
" Switch syntax highlighting on, when the terminal has colors
syntax on

" Copy indent from current line, over to the new line
set autoindent
" Do smart indenting when starting a new line
set smartindent

augroup MyAutoCmd
    " 自动给光标所在单词添加下划线
    autocmd CursorHold * silent! exe printf('match Underlined /\<%s\>/', expand('<cword>'))
    " 自动高亮匹配光标所在所有单词
    "autocmd CursorMoved * silent! exe printf('match IncSearch /\<%s\>/', expand('<cword>'))
    "
    " For all text files set 'textwidth' to 80 characters.
    autocmd FileType text setlocal textwidth=80

    " Auto reload vimrc and VimScript
    autocmd BufWritePost,FileWritePost .vimrc,*.vim if &autoread | source <afile> | endif

    " Close help and git window by pressing q.
    autocmd FileType help,qf,quickrun,qfreplace,ref,git-status,git-log,gitcommit
                \ nnoremap <buffer><silent> q :<C-u>call <sid>smart_close()<CR>
    autocmd FileType * if (&readonly || !&modifiable) && !hasmapto('q', 'n')
                \ | nnoremap <buffer><silent> q :<C-u>call <sid>smart_close()<CR>| endif

    " auto filetype command
    autocmd FileType ruby setlocal sts=2 sw=2 et
    autocmd FileType eruby setlocal sts=2 sw=2 et fdm=indent
    autocmd FileType yaml setlocal sts=2 sw=2 et
    autocmd FileType css setlocal sts=2 sw=2 et
    autocmd FileType scss setlocal sts=2 sw=2 et
    autocmd FileType python setlocal sts=4 sw=4 et
    autocmd FileType javascript setlocal sts=2 sw=2 et
    autocmd FileType html setlocal sts=2 sw=2 et fdm=indent
augroup END
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
" view"{{{
" save fold and other status
"au BufWinLeave *.* mkview
" load all saved status
"au BufWinEnter *.* silent loadview
"}}}
" ====================================================
" Command
" ----------------------------------------------------
" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
            \ | wincmd p | diffthis
" In case /tmp get's clean out, make a new tmp directory for vim
command! MkTmpdir call mkdir(fnamemodify(tempname(), ":p:h"))
" ====================================================
" Key map
" ----------------------------------------------------
"{{{
let mapleader = ","
let maplocalleader = ","

nnoremap Qa :qa<CR>
nnoremap Q :q<CR>

"change directory to the file being edited and display it
nnoremap <Leader>cd :cd %:p:h<CR>:pwd<CR>

"windows managment{{{{
"close
map <leader>wc :wincmd q<cr>
"rotate
map <leader>wr :wincmd r<cr>
"move
map <leader>wh :wincmd H<cr>
map <leader>wk :wincmd K<cr>
map <leader>wl :wincmd L<cr>
map <leader>wj :wincmd J<cr>
"resize
map <leader>wH :3wincmd <<cr>
map <leader>wK :3wincmd ><cr>
map <leader>wL :3wincmd +<cr>
map <leader>wJ :3wincmd -<cr>
"}}}}
"}}}
" ====================================================
" Plugins bundles
" ----------------------------------------------------
" NeoBundle"{{{
if has('win32') || has('win64')
    let s:bundles_dir = expand("$VIM/Vimfiles")
else
    let s:bundles_dir = expand("$HOME/.vim/")
endif
let s:neobundle_dir = s:bundles_dir . 'neobundle.vim'

if has('vim_starting')
    if isdirectory(s:neobundle_dir)
        execute 'set rtp+=' . s:neobundle_dir
    else
        execute printf('!git clone %s://github.com/Shougo/neobundle.vim.git',
                    \ (exists('$http_proxy')?'https':'git'))
                    \ s:neobundle_dir
        execute 'set rtp+=' . s:neobundle_dir
    endif
endif

call neobundle#begin(s:bundles_dir)

" let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim', '', 'default'

" My Bundles here:
" 1) original github repos {{{
" Colorscheme {{{
NeoBundle 'toupeira/vim-desertink'
NeoBundle 'altercation/vim-colors-solarized'
"}}}

" Shougo {{{
NeoBundle 'Shougo/vimproc', '', 'default'
call neobundle#config('vimproc', {
            \ 'build' : {
            \   'windows' : 'make -f make_mingw32.mak',
            \   'cygwin' : 'make -f make_cygwin.mak',
            \   'mac' : 'make -f make_mac.mak',
            \   'unix' : 'make -f make_unix.mak',
            \   },
            \ })

NeoBundle 'Shougo/echodoc', '', 'default'
call neobundle#config('echodoc',{
            \ 'lazy' : 1,
            \ 'autoload' : {
            \   'insert' : 1,
            \}})

NeoBundle 'Shougo/neosnippet', '', 'default'
call neobundle#config('neosnippet', {
            \ 'lazy' : 1,
            \ 'autoload' : {
            \ 'insert' : 1,
            \ 'filetypes' : 'snippet',
            \ 'unite_sources' : ['snippet', 'neosnippet/user', 'neosnippet/runtime'],
            \ }})
NeoBundle 'Shougo/neosnippet-snippets'

NeoBundle 'Shougo/neobundle-vim-scripts', '', 'default'

" Unite {{{
NeoBundle 'Shougo/unite.vim', '', 'default'
call neobundle#config('unite.vim',{
            \ 'lazy' : 1,
            \ 'autoload' : {
            \ 'commands' : [{ 'name' : 'Unite',
            \ 'complete' : 'customlist,unite#complete_source'},
            \ 'UniteWithCursorWord', 'UniteWithInput']
            \ }})
NeoBundleLazy 'Shougo/unite-build', {
            \ 'autoload' : { 'unite_sources' : 'build' }}
NeoBundleLazy 'Shougo/unite-outline', {
            \ 'autoload' : { 'unite_sources' : 'outline' }}
NeoBundleLazy 'Shougo/unite-session', {
            \ 'autoload' : { 'unite_sources' : 'session',
            \ 'commands' : ['UniteSessionSave', 'UniteSessionLoad']}}
NeoBundleLazy 'Shougo/unite-help', {
            \ 'autoload' : { 'unite_sources' : 'help' }}
NeoBundleLazy 'osyo-manga/unite-filetype', {
            \ 'autoload' : { 'unite_sources' : 'filetype' }}
NeoBundleLazy 'osyo-manga/unite-quickfix', {
            \ 'autoload' : { 'unite_sources': ['quickfix', 'location_list']}}
NeoBundleLazy 'osyo-manga/unite-fold', {
            \ 'autoload' : { 'unite_sources' : 'fold'}}
NeoBundleLazy 'ujihisa/unite-locate', {
            \ 'autoload' : { 'unite_sources' : 'locate' }}
NeoBundleLazy 'ujihisa/unite-colorscheme', {
            \ 'autoload' : { 'unite_sources' : 'colorscheme'}}
NeoBundleLazy 'tacroe/unite-mark', {
            \ 'autoload' : { 'unite_sources' : 'mark'}}
NeoBundleLazy 'tsukkee/unite-tag', {
            \ 'autoload' : { 'unite_sources' : 'tag' }}
NeoBundleLazy 'thinca/vim-unite-history', {
            \ 'autoload' : {
            \ 'unite_sources' : ['history/command', 'history/search']
            \ }}
NeoBundle 't9md/vim-unite-ack'
NeoBundle 'sgur/unite-qf'
NeoBundle 'sgur/unite-git_grep'
NeoBundle 'basyura/unite-rails'
NeoBundle 'soh335/unite-qflist'
NeoBundle 'tacroe/unite-alias'
NeoBundle 'basyura/unite-rails'
"}}}

" File explorer (needed where ranger is not available)
" depends on unite.vim
NeoBundleLazy 'Shougo/vimfiler', {'autoload' : { 'commands' : ['VimFiler']}}

" Create scratch files with filetype
NeoBundleLazy 'Shougo/junkfile.vim', {
            \ 'autoload' : { 'commands' : 'JunkfileOpen',
            \ 'unite_sources' : ['junkfile','junkfile/new']}}
"}}}

" VCS {{{
" browse the vim undo tree
NeoBundleLazy 'mbbill/undotree', {'autoload':{'commands':'UndotreeToggle'}}
NeoBundle 'tpope/vim-git'
NeoBundle 'tpope/vim-fugitive', { 'augroup' : 'fugitive' }
" Show git repository changes in the current file
NeoBundle 'airblade/vim-gitgutter'
NeoBundle 'mhinz/vim-signify'
" Git viewer
NeoBundleLazy 'gregsexton/gitv', {'depends':['tpope/vim-fugitive'],
            \ 'autoload':{'commands':'Gitv'}}
"}}}

" Python {{{
NeoBundleLazy 'klen/python-mode', {'autoload': {'filetypes': ['python']}}
"}}}

" Ruby {{{
NeoBundle 'vim-ruby/vim-ruby'
NeoBundle 'tpope/vim-rails'
"}}}

" Go {{{
NeoBundle 'fatih/vim-go'
" }}}

" Javascript {{{
NeoBundleLazy 'pangloss/vim-javascript', {'autoload':{'filetypes':['javascript']}}
NeoBundle 'elzr/vim-json'
"}}}

" Markup {{{
NeoBundleLazy 'joedicastro/vim-markdown'
NeoBundleLazy 'othree/html5.vim', {'autoload':
            \ {'filetypes': ['html', 'xhtml', 'eruby', 'css', 'scss']}}
NeoBundleLazy 'mattn/emmet-vim', {'autoload':
            \ {'filetypes': ['html', 'xhtml', 'xml', 'xls', 'markdown',
            \ 'eruby', 'css', 'scss']}}
NeoBundleLazy 'sukima/xmledit', {'autoload':
            \ {'filetypes': ['html', 'xhtml', 'xml', 'eruby']}}
NeoBundleLazy 'ap/vim-css-color', {'autoload':
            \ {'filetypes': ['css', 'scss']}}
NeoBundleLazy 'hail2u/vim-css3-syntax', {'autoload':
            \ {'filetypes': ['css', 'scss']}}
NeoBundle 'greyblake/vim-preview'
"NeoBundle 'tpope/vim-haml'
"NeoBundle 'slim-template/vim-slim'
"}}}

" Text-object {{{
NeoBundle 'kana/vim-textobj-user'
NeoBundle 'kana/vim-textobj-syntax'
NeoBundle 'kana/vim-textobj-indent' " ai/ii for a block of similarly indented lines, aI/iI for a block of lines with the same indentation
NeoBundle 'kana/vim-textobj-underscore' " a_, i_
NeoBundle 'kana/vim-textobj-function' "af/if and aF/iF for a function/extensible for any language
NeoBundle 'kana/vim-textobj-lastpat' " a/, i/, a?, i? for a region matched to the last search pattern
NeoBundle 'kana/vim-textobj-fold' "az/iz for a block of folded lines
NeoBundle 'kana/vim-textobj-datetime' " ada/ida and others for date and time
NeoBundle 'Julian/vim-textobj-brace' " aj/ij for the closet region betwen any of () [] or {}
NeoBundle 'glts/vim-textobj-comment' " ac/ic for a comment
NeoBundle 'rhysd/vim-textobj-continuous-line' "av/iv for lines continued by \ in c++,sh,and others
NeoBundle 'vimtaku/vim-textobj-keyvalue' " ak/ik, av/iv for key/value
NeoBundle 'sgur/vim-textobj-parameter' " a,/i, for an argument to a function
NeoBundle 'mattn/vim-textobj-url' "au/iu for a URL
" Smart selection of the closest text object
NeoBundle 'gcmt/wildfire.vim'
"}}}

" Text manipulation {{{
"vim-endwise fix conflict with delimitMate in imap <cr>
"when load after delimitMate
" Autocompletion of (, [, {, ', ", ...
NeoBundle 'Raimondi/delimitMate'
NeoBundle 'tpope/vim-endwise'
" extend repetitions by the 'dot' key
NeoBundle 'tpope/vim-repeat'
" to surround vim objects with a pair of identical chars
NeoBundle 'tpope/vim-surround'

NeoBundleLazy 'kana/vim-smartchr', { 'autoload' : {
            \ 'insert' : 1,
            \ }}
NeoBundleLazy 'kana/vim-operator-user'
NeoBundleLazy 'kana/vim-operator-replace', {
            \ 'depends' : 'vim-operator-user',
            \ 'autoload' : {
            \ 'mappings' : [
            \ ['nx', '<Plug>(operator-replace)']]
            \ }}

NeoBundle 'jpalardy/vim-slime'
NeoBundle 'Yggdroot/indentLine'
NeoBundle 'othree/eregex.vim'
"}}}

" Misc tools {{{
NeoBundle 'kopischke/vim-stay'
NeoBundle 'junegunn/fzf'
NeoBundle 'junegunn/fzf.vim'
NeoBundle 'xolox/vim-misc'
NeoBundle 'xolox/vim-easytags'

NeoBundle 'scrooloose/syntastic'
NeoBundle 'majutsushi/tagbar'
" A better looking status line
NeoBundle 'bling/vim-airline'
NeoBundle 'bling/vim-bufferline'
" shortcut
NeoBundle 'tpope/vim-unimpaired'
NeoBundle 'tpope/vim-eunuch'
NeoBundle 'tpope/vim-commentary'
NeoBundle 'tpope/vim-obsession'
NeoBundle 'Lokaltog/vim-easymotion'
" marks admin
"NeoBundle 'kshenoy/vim-signature'
let g:neobundle#install_process_timeout = 1800 "YouCompleteMe is so slow
NeoBundle 'Valloric/YouCompleteMe', {
            \ 'build' : {
            \   'unix' : './install.py --clang-completer --system-libclang --gocode-completer'
            \ },
            \}
" Auto detect CJK and Unicode file encodings
NeoBundle 'mbbill/fencview'
" Display c/c++ function declaration in vim command/status line
NeoBundle 'mbbill/echofunc'
" For edit .tmux.conf
NeoBundle 'tmux-plugins/vim-tmux'
" Restore 'FocusGained' and 'FocusLost' autocommand events when using vim in tmux
NeoBundle 'tmux-plugins/vim-tmux-focus-events'

"}}}
"}}}
" 2) vim-scripts repos {{{
" https://githubcom/vim-scripts/xxx.git
NeoBundle 'matchit.zip'
NeoBundle 'a.vim'
NeoBundle 'DoxygenToolkit.vim'
"}}}
"}}}

call neobundle#end()

" Enable file type detection.
filetype plugin indent on

"}}}
" ====================================================
" Plugins configuration
" ----------------------------------------------------
" inner{{{
" Disable GetLatestVimPlugin.vim
let g:loaded_getscriptPlugin = 1

" colorscheme
colorscheme desertink
"set background=dark
" }}}
" ----------------------------------------------------
" vim-color-solarized {{{
let g:solarized_termcolors = 256
let g:solarized_underline = 0
" }}}
" ----------------------------------------------------
" Ctags"{{{
" Usage:ctags -R --c++-kinds=+p --fields=+ialS --extra=+q "$@"(文件目录)
" --c++-kinds=+p ：为C++文件增加函数原型的标签
" --fields=+ialS ：在标签文件中加入继承信息(i)、类成员的访问控制信息(a)
"                  源文件包含tag(l)[用于echofunc.vim]、以及函数的指纹(S)
" --extra=+q     ：为标签增加类修饰符。注意，如果没有此选项，将不能对类成员补全
" map <ctrl>+F12 to generate ctags for current folder:
map <C-F12> :!ctags -R --c-kinds=+p --c++-kinds=+p --fields=+ialS --extra=+q . <CR><CR>
"}}}
" ----------------------------------------------------
" vim-easytags"{{{
" use the following setting to enable project specific tags files
let g:easytags_include_members = 1
"If you like one of the existing styles you can link them:
"highlight link cMember Special
" You can also define your own style if you want:
"highlight cMember gui=italic
let g:easytags_dynamic_files = 1

" Faster syntax highlighting using Python
let g:easytags_python_enabled = 1
let g:easytags_updatetime_autodisable = 1
" highlight is so slow that I close this feature
let g:easytags_on_cursorhold = 0
let g:easytags_auto_highlight = 0
map <C-F11> :UpdateTags -R --c-kinds=+p --c++-kinds=+p --fields=+ialS --extra=+q . <CR><CR>
"}}}
" ----------------------------------------------------
" Tagbar"{{{
nnoremap <silent> <Leader>tb :TagbarOpenAutoClose()<CR>
let g:tagbar_width = 25
let g:tagbar_compact = 1
let g:tagbar_autoclose = 1
let g:tagbar_autofocus = 1
let g:tagbar_autoshowtag = 1
"}}}
" ----------------------------------------------------
" TagHighlight"{{{
if ! exists('g:TagHighlightSettings')
    let g:TagHighlightSettings = {}
endif
let g:TagHighlightSettings['LanguageDetectionMethods'] =
            \ ['Extension', 'FileType']
"highlight tagbar
let g:TagHighlightSettings['FileTypeLanguageOverrides'] =
            \ {'tagbar': 'c'}
"Highlight git commit messages
let g:TagHighlightSettings['FileTypeLanguageOverrides'] =
            \ {'gitcommit': 'c'}
" }}}
" ----------------------------------------------------
" vim-css-color{{{
let g:ccsColorVimDoNotMessMyUpdatetime = 1
" }}}
" ----------------------------------------------------
" DoxygenToolkit"{{{
"let g:DoxygenToolkit_commentType="C++"
let g:DoxygenToolkit_authorName="Ma Jian <majiana@sugon.com>"
let g:DoxygenToolkit_licenseTag="My own license"
"let g:DoxygenToolkit_briefTag_funcName="yes"
"}}}
" ----------------------------------------------------
" fugitive"{{{
" it is a default behavior
"autocmd BufNewFile,BufRead fugitive://* set bufhidden=delete
nmap <Leader>gs :Gstatus<CR>
nmap <Leader>gb :Gblame<CR>
nmap <Leader>gp :Git push<CR>
" }}}
" ----------------------------------------------------
" unite"{{{
"let g:unite_enable_start_insert = 1
let g:unite_enable_split_vertically = 0
let g:unite_winheight = 15
"let g:unite_cursor_line_highlight = 'TabLineSel'
"let g:unite_abbr_highlight = 'TabLine'
let g:unite_source_history_yank_enable = 1
let g:unite_source_file_mru_time_format = ''
let g:unite_source_file_mru_filename_format = ':~:.'
let g:unite_source_file_mru_limit = 300
let g:unite_source_directory_mru_time_format = ''
let g:unite_source_directory_mru_limit = 300
let g:unite_quick_match_table = {
            \'a' : 1, 's' : 2, 'd' : 3, 'f' : 4, 'g' : 5, 'h' : 6, 'k' : 7, 'l' : 8, ';' : 9,
            \'q' : 10, 'w' : 11, 'e' : 12, 'r' : 13, 't' : 14, 'y' : 15, 'u' : 16, 'i' : 17, 'o' : 18, 'p' : 19,
            \'1' : 20, '2' : 21, '3' : 22, '4' : 23, '5' : 24, '6' : 25, '7' : 26, '8' : 27, '9' : 28, '0' : 29,
            \}
if executable('ag')
    let g:unite_source_grep_command='ag'
    let g:unite_source_grep_default_opts='--nocolor --nogroup -a -S'
    let g:unite_source_grep_recursive_opt=''
    let g:unite_source_grep_search_word_highlight = 1
elseif executable('ack')
    let g:unite_source_grep_command='ack'
    let g:unite_source_grep_default_opts='--no-group --no-color'
    let g:unite_source_grep_recursive_opt=''
    let g:unite_source_grep_search_word_highlight = 1
endif

" key mappings"{{{
" The prefix key.
nnoremap    [unite]   <Nop>
xnoremap    [unite]   <Nop>
nmap    <Leader>u [unite]
xmap    <Leader>u [unite]

" files
nnoremap <silent> [unite]o :Unite -silent -start-insert file<CR>
nnoremap <silent> [unite]O :Unite -silent -start-insert file_rec/async<CR>
nnoremap <silent> [unite]m :Unite -silent file_mru<CR>
" buffers
nnoremap <silent> [unite]b :Unite -silent buffer<CR>
" tabs
nnoremap <silent> [unite]B :Unite -silent tab<CR>
" buffer search
nnoremap <silent> [unite]f :Unite -silent -no-split -start-insert -auto-preview
            \ line<CR>
nnoremap <silent> [unite]/ :UniteWithCursorWord -silent -no-split -auto-preview
            \ line<CR>
" yankring
nnoremap <silent> [unite]i :Unite -silent history/yank<CR>
" grep
nnoremap <silent> [unite]a :Unite -silent -no-quit grep<CR>
" help
nnoremap <silent> [unite]h  :UniteWithInput help<CR>
nnoremap <silent> [unite]* :UniteWithCursorWord -silent help<CR>
" tasksl
nnoremap <silent> [unite]; :Unite -silent -toggle
            \ grep:%::FIXME\|TODO\|NOTE\|XXX\|COMBAK\|@todo<CR>
" outlines (also ctags)
nnoremap <silent> [unite]t :Unite -silent -vertical -winwidth=40
            \ -direction=topleft -toggle outline<CR>
" junk files
  nnoremap <silent> [unite]d :Unite -silent junkfile/new junkfile<CR>

" tags"{{{
" The prefix key.
nnoremap    [Tag]   <Nop>
nmap    <Leader>t [Tag]
" Jump.
nnoremap <silent><expr> [Tag]t  &filetype == 'help' ?  "\<C-]>" :
            \ ":\<C-u>UniteWithCursorWord -buffer-name=tag tag\<CR>"
" Jump next.
nnoremap <silent> [Tag]n  :<C-u>tag<CR>
" Jump previous.
nnoremap <silent><expr> [Tag]p  &filetype == 'help' ?
            \ ":\<C-u>pop\<CR>" : ":\<C-u>Unite jump\<CR>"
"}}}

" in unite source key mappings
autocmd MyAutoCmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()"{{{
    " Overwrite settings.
    imap <buffer>  jj      <Plug>(unite_insert_leave)
    imap <buffer> <TAB>   <Plug>(unite_select_next_line)
    imap <buffer> <C-w>     <Plug>(unite_delete_backward_path)
    imap <buffer> '     <Plug>(unite_quick_match_default_action)
    nmap <buffer> '     <Plug>(unite_quick_match_default_action)
    imap <buffer><expr> x
                \ unite#smart_map('x', "\<Plug>(unite_quick_match_choose_action)")
    nmap <buffer> x     <Plug>(unite_quick_match_choose_action)
    nmap <buffer> cd     <Plug>(unite_quick_match_default_action)
    imap <buffer> <C-g>     <Plug>(unite_input_directory)
    nmap <buffer> <C-z>     <Plug>(unite_toggle_transpose_window)
    imap <buffer> <C-z>     <Plug>(unite_toggle_transpose_window)
    imap <buffer> <C-y>     <Plug>(unite_narrowing_path)
    nmap <buffer> <C-y>     <Plug>(unite_narrowing_path)
    nmap <buffer> <C-j>     <Plug>(unite_toggle_auto_preview)
    nmap <buffer> <C-r>     <Plug>(unite_narrowing_input_history)
    imap <buffer> <C-r>     <Plug>(unite_narrowing_input_history)
    nmap <silent><buffer> <Tab>     :call <SID>NextWindow()<CR>
    nnoremap <silent><buffer><expr> l
                \ unite#smart_map('l', unite#do_action('default'))
    nunmap <buffer> x
    iunmap <buffer> x

    let unite = unite#get_current_unite()
    if unite.buffer_name =~# '^search'
        nnoremap <silent><buffer><expr> r     unite#do_action('replace')
    else
        nnoremap <silent><buffer><expr> r     unite#do_action('rename')
    endif

    nnoremap <silent><buffer><expr> cd     unite#do_action('lcd')
    nnoremap <buffer><expr> S      unite#mappings#set_current_filters(
                \ empty(unite#mappings#get_current_filters()) ? ['sorter_reverse'] : [])
endfunction"}}}
"}}}

" unite-menu"{{{
" menu prefix key (for all Unite menus) {{{
nnoremap [menu] <Nop>
nmap <Leader>um [menu]
" }}}

" menus menu
nnoremap <silent>[menu]u :Unite -silent -winheight=20 menu<CR>

let g:unite_source_menu_menus = {}
" files and dirs menu {{{
let g:unite_source_menu_menus.files = {
    \ 'description' : ' files & dirs
        \ ⌘ [space]o',
    \}
let g:unite_source_menu_menus.files.command_candidates = [
    \['▷ open file ⌘ ,o',
        \'Unite -start-insert file'],
    \['▷ open more recently used files ⌘ ,m',
        \'Unite file_mru'],
    \['▷ open file with recursive search ⌘ ,O',
        \'Unite -start-insert file_rec/async'],
    \['▷ edit new file',
        \'Unite file/new'],
    \['▷ search directory',
        \'Unite directory'],
    \['▷ search recently used directories',
        \'Unite directory_mru'],
    \['▷ search directory with recursive search',
        \'Unite directory_rec/async'],
    \['▷ make new directory',
        \'Unite directory/new'],
    \['▷ change working directory',
        \'Unite -default-action=lcd directory'],
    \['▷ know current working directory',
        \'Unite output:pwd'],
    \['▷ junk files ⌘ ,d',
        \'Unite junkfile/new junkfile'],
    \['▷ save as root ⌘ :w!!',
        \'exe "write !sudo tee % >/dev/null"'],
    \['▷ quick save ⌘ ,w',
        \'normal ,w'],
    \['▷ open ranger ⌘ ,x',
        \'call <SID>ranger_chooser()'],
    \['▷ open vimfiler ⌘ ,X',
        \'VimFiler'],
    \]
nnoremap <silent>[menu]o :Unite -silent -winheight=17 -start-insert
            \ menu:files<CR>
" }}}

" file searching menu {{{
let g:unite_source_menu_menus.grep = {
    \ 'description' : ' search files
        \ ⌘ [space]a',
    \}
let g:unite_source_menu_menus.grep.command_candidates = [
    \['▷ grep (ag → ack → grep) ⌘ ,a',
        \'Unite -no-quit grep'],
    \['▷ find',
        \'Unite find'],
    \['▷ locate',
        \'Unite -start-insert locate'],
    \['▷ vimgrep (very slow)',
        \'Unite vimgrep'],
    \]
nnoremap <silent>[menu]a :Unite -silent menu:grep<CR>
" }}}

" buffers, tabs & windows menu {{{
let g:unite_source_menu_menus.navigation = {
    \ 'description' : ' navigate by buffers, tabs & windows
        \ ⌘ [space]b',
    \}
let g:unite_source_menu_menus.navigation.command_candidates = [
    \['▷ buffers ⌘ ,b',
        \'Unite buffer'],
    \['▷ tabs ⌘ ,B',
        \'Unite tab'],
    \['▷ windows',
        \'Unite window'],
    \['▷ location list',
        \'Unite location_list'],
    \['▷ quickfix',
        \'Unite quickfix'],
    \['▷ resize windows ⌘ C-C C-W',
        \'WinResizerStartResize'],
    \['▷ new vertical window ⌘ ,v',
        \'vsplit'],
    \['▷ new horizontal window ⌘ ,h',
        \'split'],
    \['▷ close current window ⌘ ,k',
        \'close'],
    \['▷ toggle quickfix window ⌘ ,q',
        \'normal ,q'],
    \['▷ zoom ⌘ ,z',
        \'ZoomWinTabToggle'],
    \['▷ delete buffer ⌘ ,K',
        \'bd'],
    \]
nnoremap <silent>[menu]b :Unite -silent menu:navigation<CR>
" }}}

" buffer internal searching menu {{{
let g:unite_source_menu_menus.searching = {
    \ 'description' : ' searchs inside the current buffer
        \ ⌘ [space]f',
    \}
let g:unite_source_menu_menus.searching.command_candidates = [
    \['▷ search line ⌘ ,f',
        \'Unite -auto-preview -start-insert line'],
    \['▷ search word under the cursor ⌘ [space]8',
        \'UniteWithCursorWord -no-split -auto-preview line'],
    \['▷ search outlines & tags (ctags) ⌘ ,t',
        \'Unite -vertical -winwidth=40 -direction=topleft -toggle outline'],
    \['▷ search marks',
        \'Unite -auto-preview mark'],
    \['▷ search folds',
        \'Unite -vertical -winwidth=30 -auto-highlight fold'],
    \['▷ search changes',
        \'Unite change'],
    \['▷ search jumps',
        \'Unite jump'],
    \['▷ search undos',
        \'Unite undo'],
    \['▷ search tasks ⌘ ,;',
        \'Unite -toggle grep:%::FIXME|TODO|NOTE|XXX|COMBAK|@todo'],
    \]
nnoremap <silent>[menu]f :Unite -silent menu:searching<CR>
" }}}

" yanks, registers & history menu {{{
let g:unite_source_menu_menus.registers = {
    \ 'description' : ' yanks, registers & history
        \ ⌘ [space]i',
    \}
let g:unite_source_menu_menus.registers.command_candidates = [
    \['▷ yanks ⌘ ,i',
        \'Unite history/yank'],
    \['▷ commands (history) ⌘ q:',
        \'Unite history/command'],
    \['▷ searches (history) ⌘ q/',
        \'Unite history/search'],
    \['▷ registers',
        \'Unite register'],
    \['▷ messages',
        \'Unite output:messages'],
    \['▷ undo tree (gundo) ⌘ ,u',
        \'GundoToggle'],
    \]
nnoremap <silent>[menu]i :Unite -silent menu:registers<CR>
" }}}

" spelling menu {{{
let g:unite_source_menu_menus.spelling = {
    \ 'description' : ' spell checking
        \ ⌘ [space]s',
    \}
let g:unite_source_menu_menus.spelling.command_candidates = [
    \['▷ spell checking in Spanish ⌘ ,ss',
        \'setlocal spell spelllang=es'],
    \['▷ spell checking in English ⌘ ,se',
        \'setlocal spell spelllang=en'],
    \['▷ turn off spell checking ⌘ ,so',
        \'setlocal nospell'],
    \['▷ jumps to next bad spell word and show suggestions ⌘ ,sc',
        \'normal ,sc'],
    \['▷ jumps to next bad spell word ⌘ ,sn',
        \'normal ,sn'],
    \['▷ suggestions ⌘ ,sp',
        \'normal ,sp'],
    \['▷ add word to dictionary ⌘ ,sa',
        \'normal ,sa'],
    \]
nnoremap <silent>[menu]s :Unite -silent menu:spelling<CR>
" }}}

" text edition menu {{{
let g:unite_source_menu_menus.text = {
    \ 'description' : ' text edition
        \ ⌘ [space]e',
    \}
let g:unite_source_menu_menus.text.command_candidates = [
    \['▷ toggle search results highlight ⌘ ,eq',
        \'set invhlsearch'],
    \['▷ toggle line numbers ⌘ ,l',
        \'call ToggleRelativeAbsoluteNumber()'],
    \['▷ toggle wrapping ⌘ ,ew',
        \'call ToggleWrap()'],
    \['▷ show hidden chars ⌘ ,eh',
        \'set list!'],
    \['▷ toggle fold ⌘ /',
        \'normal za'],
    \['▷ open all folds ⌘ zR',
        \'normal zR'],
    \['▷ close all folds ⌘ zM',
        \'normal zM'],
    \['▷ copy to the clipboard ⌘ ,y',
        \'normal ,y'],
    \['▷ paste from the clipboard ⌘ ,p',
        \'normal ,p'],
    \['▷ toggle paste mode ⌘ ,P',
        \'normal ,P'],
    \['▷ remove trailing whitespaces ⌘ ,et',
        \'normal ,et'],
    \['▷ text statistics ⌘ ,es',
        \'Unite output:normal\ ,es -no-cursor-line'],
    \['▷ show word frequency ⌘ ,ef',
        \'Unite output:WordFrequency'],
    \['▷ show available digraphs',
        \'digraphs'],
    \['▷ insert lorem ipsum text',
        \'exe "Loremipsum" input("numero de palabras: ")'],
    \['▷ show current char info ⌘ ga',
        \'normal ga'],
    \]
nnoremap <silent>[menu]e :Unite -silent -winheight=20 menu:text <CR>
" }}}

" neobundle menu {{{
let g:unite_source_menu_menus.neobundle = {
    \ 'description' : ' plugins administration with neobundle
        \ ⌘ [space]n',
    \}
let g:unite_source_menu_menus.neobundle.command_candidates = [
    \['▷ neobundle',
        \'Unite neobundle'],
    \['▷ neobundle log',
        \'Unite neobundle/log'],
    \['▷ neobundle lazy',
        \'Unite neobundle/lazy'],
    \['▷ neobundle update',
        \'Unite neobundle/update'],
    \['▷ neobundle search',
        \'Unite neobundle/search'],
    \['▷ neobundle install',
        \'Unite neobundle/install'],
    \['▷ neobundle check',
        \'Unite -no-empty output:NeoBundleCheck'],
    \['▷ neobundle docs',
        \'Unite output:NeoBundleDocs'],
    \['▷ neobundle clean',
        \'NeoBundleClean'],
    \['▷ neobundle list',
        \'Unite output:NeoBundleList'],
    \['▷ neobundle direct edit',
        \'NeoBundleDirectEdit'],
    \]
nnoremap <silent>[menu]n :Unite -silent -start-insert menu:neobundle<CR>
" }}}

" git menu {{{
let g:unite_source_menu_menus.git = {
    \ 'description' : ' admin git repositories
        \ ⌘ [space]g',
    \}
let g:unite_source_menu_menus.git.command_candidates = [
    \['▷ tig ⌘ ,gt',
        \'normal ,gt'],
    \['▷ git viewer (gitv) ⌘ ,gv',
        \'normal ,gv'],
    \['▷ git viewer - buffer (gitv) ⌘ ,gV',
        \'normal ,gV'],
    \['▷ git status (fugitive) ⌘ ,gs',
        \'Gstatus'],
    \['▷ git commit (fugitive) ⌘ ,gc',
        \'Gcommit'],
    \['▷ git log (fugitive) ⌘ ,gl',
        \'exe "silent Glog | Unite -no-quit quickfix"'],
    \['▷ git log - all (fugitive) ⌘ ,gL',
        \'exe "silent Glog -all | Unite -no-quit quickfix"'],
    \['▷ git blame (fugitive) ⌘ ,gb',
        \'Gblame'],
    \['▷ git add/stage (fugitive) ⌘ ,gw',
        \'Gwrite'],
    \['▷ git checkout (fugitive) ⌘ ,go',
        \'Gread'],
    \['▷ git rm (fugitive) ⌘ ,gR',
        \'Gremove'],
    \['▷ git mv (fugitive) ⌘ ,gm',
        \'exe "Gmove " input("destino: ")'],
    \['▷ git push (fugitive, buffer output) ⌘ ,gp',
        \'Git! push'],
    \['▷ git pull (fugitive, buffer output) ⌘ ,gP',
        \'Git! pull'],
    \['▷ git command (fugitive, buffer output) ⌘ ,gi',
        \'exe "Git! " input("comando git: ")'],
    \['▷ git edit (fugitive) ⌘ ,gE',
        \'exe "command Gedit " input(":Gedit ")'],
    \['▷ git grep (fugitive) ⌘ ,gg',
        \'exe "silent Ggrep -i ".input("Pattern: ") | Unite -no-quit quickfix'],
    \['▷ git grep - messages (fugitive) ⌘ ,ggm',
        \'exe "silent Glog --grep=".input("Pattern: ")." | Unite -no-quit quickfix"'],
    \['▷ git grep - text (fugitive) ⌘ ,ggt',
        \'exe "silent Glog -S".input("Pattern: ")." | Unite -no-quit quickfix"'],
    \['▷ git init ⌘ ,gn',
        \'Unite output:echo\ system("git\ init")'],
    \['▷ git cd (fugitive)',
        \'Gcd'],
    \['▷ git lcd (fugitive)',
        \'Glcd'],
    \['▷ git browse (fugitive) ⌘ ,gB',
        \'Gbrowse'],
    \]
nnoremap <silent>[menu]g :Unite -silent -winheight=26 -start-insert menu:git<CR>
" }}}

" code menu {{{
let g:unite_source_menu_menus.code = {
    \ 'description' : ' code tools
        \ ⌘ [space]p',
    \}
let g:unite_source_menu_menus.code.command_candidates = [
    \['▷ run python code (pymode) ⌘ ,r',
        \'Pyrun'],
    \['▷ show docs for the current word (pymode) ⌘ K',
        \'normal K'],
    \['▷ insert a breakpoint (pymode) ⌘ ,B',
        \'normal ,B'],
    \['▷ togle pylint revison (pymode)',
        \'PyLintToggle'],
    \['▷ run with python2 in tmux panel (vimux) ⌘ ,rr',
        \'normal ,rr'],
    \['▷ run with python3 in tmux panel (vimux) ⌘ ,r3',
        \'normal ,r3'],
    \['▷ run with python2 & time in tmux panel (vimux) ⌘ ,rt',
        \'normal ,rt'],
    \['▷ run with pypy & time in tmux panel (vimux) ⌘ ,rp',
        \'normal ,rp'],
    \['▷ command prompt to run in a tmux panel (vimux) ⌘ ,rc',
        \'VimuxPromptCommand'],
    \['▷ repeat last command (vimux) ⌘ ,rl',
        \'VimuxRunLastCommand'],
    \['▷ stop command execution in tmux panel (vimux) ⌘ ,rs',
        \'VimuxInterruptRunner'],
    \['▷ inspect tmux panel (vimux) ⌘ ,ri',
        \'VimuxInspectRunner'],
    \['▷ close tmux panel (vimux) ⌘ ,rq',
        \'VimuxCloseRunner'],
    \['▷ rope autocompletion (rope) ⌘ C-[espacio]',
        \'RopeCodeAssist'],
    \['▷ go to definition (rope) ⌘ C-C g',
        \'RopeGotoDefinition'],
    \['▷ reorganize imports (rope) ⌘ C-C r o',
        \'RopeOrganizeImports'],
    \['▷ refactorize - rename (rope) ⌘ C-C r r',
        \'RopeRename'],
    \['▷ refactorize - extract variable (rope) ⌘ C-C r l',
        \'RopeExtractVariable'],
    \['▷ refactorize - extract method (rope) ⌘ C-C r m',
        \'RopeExtractMethod'],
    \['▷ refactorize - inline (rope) ⌘ C-C r i',
        \'RopeInline'],
    \['▷ refactorize - move (rope) ⌘ C-C r v',
        \'RopeMove'],
    \['▷ refactorize - restructure (rope) ⌘ C-C r x',
        \'RopeRestructure'],
    \['▷ refactorize - use function (rope) ⌘ C-C r u',
        \'RopeUseFunction'],
    \['▷ refactorize - introduce factory (rope) ⌘ C-C r f',
        \'RopeIntroduceFactory'],
    \['▷ refactorize - change signature (rope) ⌘ C-C r s',
        \'RopeChangeSignature'],
    \['▷ refactorize - rename current module (rope) ⌘ C-C r 1 r',
        \'RopeRenameCurrentModule'],
    \['▷ refactorize - move current module (rope) ⌘ C-C r 1 m',
        \'RopeMoveCurrentModule'],
    \['▷ refactorize - module to package (rope) ⌘ C-C r 1 p',
        \'RopeModuleToPackage'],
    \['▷ show docs for current word (rope) ⌘ C-C r a d',
        \'RopeShowDoc'],
    \['▷ syntastic check (syntastic)',
        \'SyntasticCheck'],
    \['▷ syntastic errors (syntastic)',
        \'Errors'],
    \['▷ list virtualenvs (virtualenv)',
        \'Unite output:VirtualEnvList'],
    \['▷ activate virtualenv (virtualenv)',
        \'VirtualEnvActivate'],
    \['▷ deactivate virtualenv (virtualenv)',
        \'VirtualEnvDeactivate'],
    \['▷ run coverage2 (coveragepy)',
        \'call system("coverage2 run ".bufname("%")) | Coveragepy report'],
    \['▷ run coverage3 (coveragepy)',
        \'call system("coverage3 run ".bufname("%")) | Coveragepy report'],
    \['▷ toggle coverage report (coveragepy)',
        \'Coveragepy session'],
    \['▷ toggle coverage marks (coveragepy)',
        \'Coveragepy show'],
    \['▷ count lines of code',
        \'Unite -default-action= output:call\\ LinesOfCode()'],
    \['▷ toggle indent lines ⌘ ,L',
        \'IndentLinesToggle'],
    \]
nnoremap <silent>[menu]p :Unite -silent -winheight=42 menu:code<CR>
" }}}

" markdown menu {{{
let g:unite_source_menu_menus.markdown = {
    \ 'description' : ' preview markdown extra docs
        \ ⌘ [space]k',
    \}
let g:unite_source_menu_menus.markdown.command_candidates = [
    \['▷ preview',
        \'Me'],
    \['▷ refresh',
        \'Mer'],
    \]
nnoremap <silent>[menu]k :Unite -silent menu:markdown<CR>
" }}}

" sessions menu {{{
let g:unite_source_menu_menus.sessions = {
    \ 'description' : ' sessions
        \ ⌘ [space]h',
    \}
let g:unite_source_menu_menus.sessions.command_candidates = [
    \['▷ load session',
        \'Unite session'],
    \['▷ make session (default)',
        \'UniteSessionSave'],
    \['▷ make session (custom)',
        \'exe "UniteSessionSave " input("name: ")'],
    \]
nnoremap <silent>[menu]h :Unite -silent menu:sessions<CR>
" }}}

" bookmarks menu {{{
let g:unite_source_menu_menus.bookmarks = {
    \ 'description' : ' bookmarks
        \ ⌘ [space]m',
    \}
let g:unite_source_menu_menus.bookmarks.command_candidates = [
    \['▷ open bookmarks',
        \'Unite bookmark:*'],
    \['▷ add bookmark',
        \'UniteBookmarkAdd'],
    \]
nnoremap <silent>[menu]m :Unite -silent menu:bookmarks<CR>
" }}}

" vim menu {{{
let g:unite_source_menu_menus.vim = {
    \ 'description' : ' vim
        \ ⌘ [space]v',
    \}
let g:unite_source_menu_menus.vim.command_candidates = [
    \['▷ choose colorscheme',
        \'Unite colorscheme -auto-preview'],
    \['▷ mappings',
        \'Unite mapping -start-insert'],
    \['▷ edit configuration file (vimrc)',
        \'edit $MYVIMRC'],
    \['▷ choose filetype',
        \'Unite -start-insert filetype'],
    \['▷ vim help',
        \'Unite -start-insert help'],
    \['▷ vim commands',
        \'Unite -start-insert command'],
    \['▷ vim functions',
        \'Unite -start-insert function'],
    \['▷ vim runtimepath',
        \'Unite -start-insert runtimepath'],
    \['▷ vim command output',
        \'Unite output'],
    \['▷ unite sources',
        \'Unite source'],
    \['▷ kill process',
        \'Unite -default-action=sigkill -start-insert process'],
    \['▷ launch executable (dmenu like)',
        \'Unite -start-insert launcher'],
    \['▷ clear powerline cache',
        \'PowerlineClearCache'],
    \]
nnoremap <silent>[menu]v :Unite menu:vim -silent -start-insert<CR>
" }}}

" }}}
" unite-alias.{{{
let g:unite_source_alias_aliases = {}
let g:unite_source_alias_aliases.test = {
            \ 'source' : 'file_rec',
            \ 'args'   : '~/',
            \ }
let g:unite_source_alias_aliases.line_migemo = {
            \ 'source' : 'line',
            \ }

let g:unite_source_alias_aliases.sow_moveentry_entry = {
            \ 'source': 'sow_gatherentry',
            \ }
let sow_moveto_entry ={'description': 'action :move entry to ...',}
function! sow_moveto_entry.func(candidates)
    echo "test"
endfunction
"}}}
" unite-session."{{{
" Save session automatically.
let g:unite_source_session_enable_auto_save = 1
" autocmd MyAutoCmd VimEnter * UniteSessionLoad
"}}}
" unite-tag"{{{
" use unite-tag instead of <C-]>
"autocmd BufEnter *
"\  if empty(&buftype)
"\|     nnoremap <buffer> <C-]> :<C-u>UniteWithCursorWord -immediately tag<CR>
"\| endif
"}}}
" unite-grep"{{{
let g:unite_source_grep_default_opts = '-iRHn'
"}}}
"}}}
" ----------------------------------------------------
" VimFiler {{{
let g:vimfiler_as_default_explorer = 1
let g:vimfiler_restore_alternate_file = 1
"let g:vimfiler_preview_action = 'auto_preview'
let g:vimfiler_tree_leaf_icon = "⋮"
let g:vimfiler_tree_leaf_icon = '┆'
let g:vimfiler_tree_opened_icon = "▼"
let g:vimfiler_tree_closed_icon = "▷"
let g:vimfiler_tree_indentation = 1
let g:vimfiler_file_icon = ' '
let g:vimfiler_readonly_file_icon = ''
let g:vimfiler_marked_file_icon = '✓'
let g:vimfiler_quick_look_command = 'gloobus-preview'

let g:vimfiler_ignore_pattern =
    \ '^\%(\.git\|\.idea\|\.DS_Store\|\.vagrant\|\.stversions\|\.tmp'
    \ .'\|node_modules\|.*\.pyc\|.*\.egg-info\|__pycache__\)$'

map <F2> :VimFiler<CR>
" }}}
" ----------------------------------------------------
" smartchr.vim"{{{
let bundle = neobundle#get('vim-smartchr')
function! bundle.hooks.on_source(bundle)
    "inoremap <expr> , smartchr#one_of(', ', ',')

    " Smart =.
    inoremap <expr> =
                \ search('\(&\<bar><bar>\<bar>+\<bar>-\<bar>/\<bar>>\<bar><\) \%#', 'bcn')? '<bs>= '
                \ : search('\(*\<bar>!\)\%#', 'bcn') ? '= '
                \ : smartchr#one_of('=', ' = ', ' == ')
    augroup MyAutoCmd
        " Substitute .. into -> .
        autocmd FileType c,cpp inoremap <buffer> <expr> . smartchr#loop('.', '->', '...')
        autocmd FileType perl,php inoremap <buffer> <expr> . smartchr#loop(' . ', '->', '.')
        autocmd FileType perl,php inoremap <buffer> <expr> - smartchr#loop('-', '->')
        autocmd FileType vim inoremap <buffer> <expr> . smartchr#loop('.', ' . ', '..', '...')

        autocmd FileType haskell,int-ghci
                    \ inoremap <buffer> <expr> + smartchr#loop('+', ' ++ ')
                    \| inoremap <buffer> <expr> - smartchr#loop('-', ' -> ', ' <- ')
                    \| inoremap <buffer> <expr> $ smartchr#loop(' $ ', '$')
                    \| inoremap <buffer> <expr> \ smartchr#loop('\ ', '\')
                    \| inoremap <buffer> <expr> : smartchr#loop(':', ' :: ', ' : ')
                    \| inoremap <buffer> <expr> . smartchr#loop('.', ' . ', '..')

        autocmd FileType scala
                    \ inoremap <buffer> <expr> - smartchr#loop('-', ' -> ', ' <- ')
                    \| inoremap <buffer> <expr> = smartchr#loop(' = ', '=', ' => ')
                    \| inoremap <buffer> <expr> : smartchr#loop(': ', ':', ' :: ')
                    \| inoremap <buffer> <expr> . smartchr#loop('.', ' => ')

        autocmd FileType eruby
                    \ inoremap <buffer> <expr> > smartchr#loop('>', '%>')
                    \| inoremap <buffer> <expr> < smartchr#loop('<', '<%', '<%=')
    augroup END
endfunction
unlet bundle
"}}}
" ----------------------------------------------------
" delimitMate{{{
let g:delimitMate_matchpairs = "(:),[:],{:}"
"let g:delimitMate_quotes = "\" ' `"
let g:delimitMate_expand_cr = 1
"let g:delimitMate_expand_space = 0
" }}}
" ----------------------------------------------------
" Syntastic{{{
"let g:syntastic_c_compiler="clang"
"let g:syntastic_c_include_dirs = ["",""]
let g:syntastic_enable_signs = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_mode_map = { 'mode': 'active',
            \ 'active_filetypes': ['ruby', 'eruby', 'html', 'xml', 'c', 'cpp', 'go', 'py'],
            \ 'passive_filetypes': ['javascript', 'css', 'php'] }
" }}}
" ----------------------------------------------------
" echodoc.vim"{{{
let bundle = neobundle#get('echodoc')
function! bundle.hooks.on_source(bundle)
    let g:echodoc_enable_at_startup = 1
endfunction
unlet bundle
"}}}
" ----------------------------------------------------
" YouCompleteMe"{{{
let bundle = neobundle#get('YouCompleteMe')
" check whether characters before current column are all space "{{{
func! s:check_back_space()
    let col = col('.') - 1
    return !col || getline('.')[col - 1] =~ '\s'
endfunc
"}}}
func! bundle.hooks.on_source(bundle)
    "let g:ycm_server_use_vim_stdout = 1
    "let g:ycm_server_log_level = 'debug'
    let g:ycm_key_invoke_completion = '<Tab>'
    let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
    let g:ycm_confirm_extra_conf = 0

    nnoremap <Leader>jd :YcmCompleter GoToDefinitionElseDeclaration<CR>
    "inoremap <expr><S-TAB> pumvisible() ? "\<C-n>" :
    "\ <SID>check_back_space() ? "\<TAB>" :
    "\ "\<C-x>\<C-o>"
endfunc!
unlet bundle
" }}}
" ----------------------------------------------------
" neosnippet.vim"{{{
let bundle = neobundle#get('neosnippet')
function! bundle.hooks.on_source(bundle)
    imap <C-k> <Plug>(neosnippet_jump_or_expand)
    smap <C-k> <Plug>(neosnippet_jump_or_expand)
    xmap <C-k> <Plug>(neosnippet_expand_target)
    "xmap <silent>L <Plug>(neosnippet_start_unite_snippet_target)
    "imap <silent>K <Plug>(neosnippet_expand_or_jump)
    "smap <silent>K <Plug>(neosnippet_expand_or_jump)
    "imap <silent>G <Plug>(neosnippet_expand)
    "imap <silent>S <Plug>(neosnippet_start_unite_snippet)
    "xmap <silent>o <Plug>(neosnippet_register_oneshot_snippet)

    " SuperTab like snippets behavior.
    "imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
                "\ "\<Plug>(neosnippet_expand_or_jump)"
                "\: pumvisible() ? "\<C-n>" : "\<TAB>"
    "smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
                "\ "\<Plug>(neosnippet_expand_or_jump)"
                "\: "\<TAB>"

    "let g:neosnippet#enable_snipmate_compatibility = 1

    " let g:snippets_dir = '~/.vim/snippets/,~/.vim/bundle/snipmate/snippets/'
    "let g:neosnippet#snippets_directory = '~/.vim/snippets'
endfunction
unlet bundle

nnoremap <silent> [Window]f :<C-u>Unite neosnippet/user neosnippet/runtime<CR>

"}}}
" ----------------------------------------------------
" vim-go {{{
" Commands
au FileType go nmap <Leader>r <Plug>(go-run)
au FileType go nmap <Leader>b <Plug>(go-build)
au FileType go nmap <Leader>t <Plug>(go-test)
" Open definition/declaration
au FileType go nmap <Leader>ds <Plug>(go-def-split)
au FileType go nmap <Leader>dv <Plug>(go-def-vertical)
au FileType go nmap <Leader>dt <Plug>(go-def-tab)
" Open the relevant Godoc for the word under cursor
au FileType go nmap <Leader>gd <Plug>(go-doc)
au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
" Show a list of interfaces which is implemented by the type under cursor
au FileType go nmap <Leader>s <Plug>(go-implements)
" Show type info for the word under cursor
au FileType go nmap <Leader>i <Plug>(go-info)
" Rename the identifier under the cursor
au FileType go nmap <Leader>e <Plug>(go-rename)

" Setting
" Disable auto installation of binaries
let g:go_disable_autoinstall = 1

" Disable auto fmt on save
"let g:go_fmt_autosave = 0
let g:go_fmt_command = "goimports"
let g:go_fmt_fail_silently = 1

let g:to_auto_type_info = 1
let g:go_snippent_engine = "neosnippet"

" highlight
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

" using with syntastic
let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
let g:syntastic_mode_map = {'mode': 'active', 'passive_filetypes': ['go']}
let g:go_list_type = "quickfix"
" }}}
" ----------------------------------------------------
" vim-slime"{{{
let g:slime_target = "tmux"
let g:slime_paste_file = tempname()
"}}}
" ----------------------------------------------------
" Cscope"{{{
" 需要添加环境变量
if has("cscope")
  set cscopetag   " 使支持用 Ctrl+]  和 Ctrl+t 快捷键在代码间跳来跳去
" check cscope for definition of a symbol before checking ctags: set to 1
" if you want the reverse search order
  set cscopetagorder=1

  if has("vim_starting")
      let s:cs_db = expand("$HOME/cscope.out")
      " add any cscope database in current directory
      if filereadable(s:cs_db)
          cs add s:cs_db
          " else add the database pointed to by environment variable
      elseif $CSCOPE_DB != ""
          cs add $CSCOPE_DB
      endif
      unlet s:cs_db
  endif

" show msg when any other cscope db added
  set cscopeverbose

  nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
  nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
  nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
  nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
  nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
  nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
  nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
  nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>
endif
"}}}
" ----------------------------------------------------
" vim-airline {{{
" 状态栏格式定义
" unicode symbols
let g:airline_left_sep = '▶'
let g:airline_left_alt_sep = '»'
let g:airline_right_sep = '◀'
let g:airline_right_alt_sep = '«'
" don't show bufferline in statusline
let g:airline_section_c = '%t'

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.whitespace = 'Ξ'
" }}}
" ----------------------------------------------------
" vim-bufferline {{{
let g:bufferline_rotate = 1
let g:bufferline_fixed_index = 0 "always first
" }}}
" ----------------------------------------------------
" wildfire.vim {{{
" This selects the next closest text object.
map <SPACE> <Plug>(wildfire-fuel)
" This selects the previous closest text object.
vmap <C-SPACE> <Plug>(wildfire-water)
" Quick selection
nmap <leader>s <Plug>(wildfire-quick-select)
" }}}
" ----------------------------------------------------
" python-mode {{{
" python-mode autocomplete conflict with YouCompleteMe
let g:pymode_rope_completion = 0
" }}}
" ====================================================
" Support and Misc
" ----------------------------------------------------
" Use Ranger as a file explorer {{{
func! s:ranger_chooser()
    exec "silent !ranger --choosefile=/tmp/chosenfile " . expand("%:p:h")
    if filereadable('/tmp/chosenfile')
        exec 'edit ' . system('cat /tmp/chosenfile')
        call system('rm /tmp/chosenfile')
    endif
    redraw!
endfunc
map <Leader>x :call <SID>ranger_chooser()<CR>
" }}}
" {{{
func! s:smart_close()
    if winnr('$') != 1
        close
    endif
endfunc

if !has('vim_starting')
    " Call on_source hook when reloading .vimrc.
    call neobundle#call_hook('on_source')
endif
" }}}
" ====================================================
" vim: foldmethod=marker
