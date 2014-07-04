" ====================================================
" Initialize
" ====================================================
" {{{
" Set augroup.
augroup MyAutoCmd
    autocmd!
augroup END

" Use Vim settings, rather then Vi settings (much better!)."{{{
" This must be first, because it changes other options as a side effect.
set nocompatible

" display incomplete commands
set showcmd

" define the behavior of the selection
set selection=inclusive

" For all text files set 'textwidth' to 80 characters.
autocmd FileType text setlocal textwidth=80

" In many terminal emulators the mouse works just fine, thus enable it.
set mouse=a

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
" Also don't do it when the mark is in the first line, that is the default
" position when opening a file.
autocmd BufReadPost *
            \ if line("'\"") > 1 && line("'\"") <= line("$") |
            \   exe "normal! g`\"" |
            \ endif
"}}}
" }}}
" ====================================================
" plugins bundles
" ====================================================
" NeoBundle"{{{
if has('win32') || has('win64')
    let s:bundles_dir = expand("$VIM/Vimfiles")
else
    let s:bundles_dir = expand("$HOME/.vim/")
endif
let s:neobundle_dir = s:bundles_dir.'neobundle.vim'

if has('vim_starting')
    if isdirectory(s:neobundle_dir)
        execute 'set rtp+='.s:neobundle_dir
    else
        execute printf('!git clone %s://github.com/Shougo/neobundle.vim.git',
                    \ (exists('$http_proxy')?'https':'git'))
                    \ s:neobundle_dir
        execute 'set rtp+='.s:neobundle_dir
    endif
endif

call neobundle#rc(s:bundles_dir)

" let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim', '', 'default'

" My Bundles here:
" 1) original github repos {{{
" Colorscheme {{{
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'joedicastro/vim-molokai256'
NeoBundle 'toupeira/vim-desertink'
" Make terminal themes from GUI themes
NeoBundleLazy 'godlygeek/csapprox', { 'autoload' :
        \ { 'commands' : ['CSApprox', 'CSApproxSnapshot']}}
"}}}

" Shougo {{{
"After install, turn shell ~/.vim/vimproc, (n,g)make -f your_machines_makefile
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

NeoBundle 'Shougo/neocomplete.vim', '', 'default'
call neobundle#config('neocomplete.vim', {
            \ 'lazy' : 1,
            \ 'autoload' : {
            \ 'insert' : 1,
            \ }})

NeoBundle 'Shougo/neosnippet', '', 'default'
call neobundle#config('neosnippet', {
            \ 'lazy' : 1,
            \ 'autoload' : {
            \ 'insert' : 1,
            \ 'filetypes' : 'snippet',
            \ 'unite_sources' : ['snippet', 'neosnippet/user', 'neosnippet/runtime'],
            \ }})

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
NeoBundleLazy 'Shougo/vimfiler', {'autoload' : { 'commands' : ['VimFiler']}}

" Junk files
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
" Git viewer
NeoBundleLazy 'gregsexton/gitv', {'depends':['tpope/vim-fugitive'],
            \ 'autoload':{'commands':'Gitv'}}
"}}}

" Python {{{
"NeoBundle 'nvie/vim-flake8'
"NeoBundle 'kevinw/pyflakes-vim'
"NeoBundle 'fs111/pydoc.vim'
NeoBundleLazy 'klen/python-mode', {'autoload': {'filetypes': ['python']}}
"}}}

" Ruby {{{
NeoBundle 'vim-ruby/vim-ruby'
NeoBundle 'tpope/vim-rails'
NeoBundle 'nelstrom/vim-textobj-rubyblock'
NeoBundle 't9md/vim-textobj-function-ruby'
NeoBundle 'ujihisa/neco-ruby'
"NeoBundle 'ecomba/vim-ruby-refactoring'
"needs methodfinder gem
NeoBundle 'ujihisa/neco-rubymf'
"}}}

" Go {{{
NeoBundle 'fatih/vim-go'
" }}}

" Javascript {{{
NeoBundle 'jelera/vim-javascript-syntax'
NeoBundle 'teramako/jscomplete-vim'
NeoBundle 'nono/jquery.vim'
NeoBundle 'thinca/vim-textobj-function-javascript'
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'elzr/vim-json'
"}}}

" Markup {{{

NeoBundleLazy 'othree/html5.vim', {'autoload':
            \ {'filetypes': ['html', 'xhtml', 'css']}}
NeoBundleLazy 'mattn/emmet-vim', {'autoload':
            \ {'filetypes': ['html', 'xhtml', 'css', 'xml', 'xls', 'markdown']}}
NeoBundleLazy 'sukima/xmledit', {'autoload':
            \ {'filetypes': ['html', 'xhtml', 'xml']}}
NeoBundleLazy 'ap/vim-css-color', {'autoload':
            \ {'filetypes': 'css'}}
NeoBundleLazy 'hail2u/vim-css3-syntax', {'autoload':
            \ {'filetypes': 'css'}}
NeoBundle 'greyblake/vim-preview'
NeoBundle 'vim-pandoc/vim-pandoc'
NeoBundle 'tpope/vim-haml'
NeoBundle 'slim-template/vim-slim'
" Markdown Syntax
NeoBundleLazy 'joedicastro/vim-markdown'
" Makes a Markdown Extra preview into the browser
NeoBundleLazy 'joedicastro/vim-markdown-extra-preview'
" A smart and powerful Color Management tool. Needs to be loaded to be able
" to use the mappings
NeoBundleLazy 'Rykka/colorv.vim', {'autoload' : {
            \ 'commands' : [
                             \ 'ColorV', 'ColorVView', 'ColorVPreview',
                             \ 'ColorVPicker', 'ColorVEdit', 'ColorVEditAll',
                             \ 'ColorVInsert', 'ColorVList', 'ColorVName',
                             \ 'ColorVScheme', 'ColorVSchemeFav',
                             \ 'ColorVSchemeNew', 'ColorVTurn2'],
            \ }}
"}}}

" Text-object {{{
NeoBundle 'kana/vim-textobj-user'
NeoBundle 'kana/vim-textobj-syntax'
NeoBundle 'kana/vim-textobj-indent' " ai, ii, aI, iI
NeoBundle 'kana/vim-textobj-line' " al, il
NeoBundle 'kana/vim-textobj-underscore' " a_, i_
NeoBundle 'kana/vim-textobj-function'
NeoBundle 'kana/vim-textobj-lastpat' " a/, i/, a?, i?
NeoBundle 'kana/vim-textobj-fold'
NeoBundle 'kana/vim-textobj-entire' " ae, ie
NeoBundle 'kana/vim-textobj-diff'
NeoBundle 'kana/vim-textobj-datetime'
NeoBundle 'thinca/vim-textobj-between'
NeoBundle 'thinca/vim-textobj-comment'
NeoBundle 'mattn/vim-textobj-url'
NeoBundle 'anyakichi/vim-textobj-xbrackets'
NeoBundle 'sgur/vim-textobj-parameter'
NeoBundle 'gilligan/textobj-gitgutter'
" Smart selection of the closest text object
NeoBundle 'Shougo/wildfire.vim'
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
" Smart and fast date changer
NeoBundle 'tpope/vim-speeddating'
NeoBundle 'chrisbra/SudoEdit.vim'
NeoBundle 'duff/vim-bufonly'
" multiple cursors
NeoBundle 'terryma/vim-multiple-cursors'

NeoBundle 'kana/vim-wwwsearch'
NeoBundleLazy 'kana/vim-smartword', { 'autoload' : {
            \ 'mappings' : [
            \ '<Plug>(smartword-w)', '<Plug>(smartword-b)', '<Plug>(smartword-ge)']
            \ }}
NeoBundleLazy 'kana/vim-smartchr', { 'autoload' : {
            \ 'insert' : 1,
            \ }}
NeoBundleLazy 'kana/vim-smarttill', { 'autoload' : {
            \ 'mappings' : [
            \ '<Plug>(smarttill-t)', '<Plug>(smarttill-T)']
            \ }}
NeoBundleLazy 'kana/vim-operator-user'
NeoBundleLazy 'kana/vim-operator-replace', {
            \ 'depends' : 'vim-operator-user',
            \ 'autoload' : {
            \ 'mappings' : [
            \ ['nx', '<Plug>(operator-replace)']]
            \ }}

NeoBundle 'jpalardy/vim-slime'
if has('conceal')
    NeoBundle 'Yggdroot/indentLine'
endif
NeoBundleLazy 'joedicastro/vim-pentadactyl', {
            \ 'autoload': {'filetypes': ['pentadactyl']}}
"}}}

" Misc tools {{{
if has('win32') || has('win64')
    NeoBundle 'xolox/vim-shell'
endif
NeoBundle 'xolox/vim-misc'
NeoBundle 'xolox/vim-easytags'

NeoBundle 'scrooloose/syntastic'
NeoBundle 'scrooloose/nerdcommenter'
NeoBundle 'scrooloose/nerdtree', { 'augroup' : 'NERDTreeHijackNetrw' }
NeoBundle 'majutsushi/tagbar'
NeoBundle 'xuhdev/SingleCompile'
" A better looking status line
NeoBundle 'bling/vim-airline'
NeoBundle 'bling/vim-bufferline'
"NeoBundle 'itchyny/lightline.vim'
" shortcut
NeoBundle 'tpope/vim-unimpaired'
NeoBundle 'Lokaltog/vim-easymotion'
" marks admin
NeoBundle 'kshenoy/vim-signature'
" easily window resizing
NeoBundle 'jimsei/winresizer'
NeoBundle 'Valloric/YouCompleteMe', {
            \ 'build' : {
            \   'unix' : './install.sh --clang-completer --system-libclang'
            \ },
            \}
" Auto detect CJK and Unicode file encodings
NeoBundle 'mbbill/fencview'
" Display c/c++ function declaration in vim command/status line
NeoBundle 'mbbill/echofunc'

"}}}
"}}}
" 2) vim-scripts repos {{{
" https://githubcom/vim-scripts/xxx.git
NeoBundle 'vimcdoc'
NeoBundle 'matchit.zip'
"NeoBundle 'Mark--Karkat'
NeoBundle 'a.vim'
NeoBundle 'Txtfmt-The-Vim-Highlighter'
NeoBundle 'DoxygenToolkit.vim'
NeoBundle 'Source-Explorer-srcexpl.vim'
NeoBundle 'SearchComplete'
"NeoBundle 'Pydiction'
"NeoBundle 'dbext.vim'
"}}}
" 3) non github repos {{{
"NeoBundle 'git://git.wincent.com/command-t.git'
NeoBundle 'https://bitbucket.org/abudden/taghighlight', {'type' : 'hg'}
"}}}
"}}}
" ====================================================
" Platform depends
" ====================================================
" {{{
let s:iswin = has('win32') || has('win64')
if s:iswin
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

    " Popup color.
    hi Pmenu ctermbg=8
    hi PmenuSel ctermbg=1
    hi PmenuSbar ctermbg=0
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
"           他编辑器打开含有中文的文件时就会乱码。(set
"           fenc=chinese)
"           "}}}
" ====================================================
"{{{
set encoding=utf-8
set termencoding=utf-8
"let &termencoding=&encoding
set fileencodings=usc-bom,utf-8,chinese
"set fileencoding=chinese

" Default fileformat.
"set fileformat=dos
" Automatic recognition of new line format.
"set fileformats=dos,unix,mac
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
"au BufReadPost quickfix call QfConv()
"}}}
" ====================================================
" View
" ====================================================
"{{{
" colorscheme
colorscheme desertink
"set background=dark

" Show title.
set title
" Title length.
set titlelen=95
" Title string.
set titlestring=%t%(\ %M%)%(\ (%{expand(\"%:p:h\")})%)%(\ %a%)\ -\ %{v:servername}

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

" 信息提示格式
set shortmess=aToOI

" 在底部显示标尺，显示行号列号和百分比
set ruler

" 显示行号
set number

" 光标移动到buffer的顶部和底部时保持3距离
set scrolloff=2

" 设置显示tab和行尾
set list
set listchars=tab:\|\ ,trail:-,extends:>,precedes:<
"set listchars=tab:>-,trail:-,extends:>,precedes:<,eol:$
"set listchars=tab:>-
"set listchars=tab:\|\

" Wrap long line.
set wrap
" Wrap conditions.
set whichwrap+=h,l,<,>,[,],b,s,~

" Turn down a long line appointed in 'breakat'
set linebreak
set showbreak=>\
set breakat=\ \	;:,!?

"Turn on Wild menu
set wildmenu
"set wildmode=longest,list
set wildignore+=*.a,*.o
set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png
set wildignore+=.git,.hg,.svn
set wildignore+=*~,*.swp,*.tmp

" Can supplement a tag in a command-line.
set wildoptions=tagfile

" Display all the information of the tag by the supplement of the Insert mode.
set showfulltag

" Don't complete from other buffer.
set complete=.
"set complete=.,w,b,i,t

" Set popup menu max height.
set pumheight=20

" Adjust window size of preview and help.
"set previewheight=10
"set helpheight=12

" When a line is long, do not omit it in @.
set display=lastline
" Display an invisible letter with hex format.
set display+=uhex

" Use vertical diff format
set diffopt+=vertical

" 记录的历史命令数目
set history=200

" Enable spell check.
set spelllang=en_us

" Report changes.
set report=0

" Splitting a window will put the new window below the current one.
set splitbelow
" Splitting a window will put the new window right the current one.
set splitright
" Set minimal width for current window.
set winwidth=30
" Set minimal height for current window.
set winheight=1
" No equal window size.
set noequalalways

set colorcolumn=80

" Maintain a current line at the time of movement as much as possible.
set nostartofline
" Don't redraw while macro executing.
set lazyredraw

" For conceal
set conceallevel=2
set concealcursor=nc
"set concealcursor=iv

" 自动高亮匹配光标所在所有单词
"autocmd CursorMoved * silent! exe printf('match IncSearch /\<%s\>/', expand('<cword>'))
" 自动给光标所在单词添加下划线
autocmd CursorHold * silent! exe printf('match Underlined /\<%s\>/', expand('<cword>'))

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
                \ | wincmd p | diffthis
endif

" 状态栏显示
" Always display statusline.
set laststatus=2   " 显示状态栏 (默认值为 1, 无法显示状态栏)

" Set maximam command line window.
set cmdwinheight=5
" Height of command line.
"set cmdheight=2
" Show command on statusline.
set showcmd
"}}}
" ====================================================
" Search
" ====================================================
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
" ----------------------------------------------------
"path"{{{
if has("win32")
    "for work"{{{{
    set path+=C:/Program\\\ Files/Microsoft\\\ Visual\\\ Studio\\\ 8/VC/include
    set path+=C:/Program\\\ Files/Microsoft\\\ Visual\\\ Studio\\\ 8/VC/atlmfc/include
    set path+=C:/Program\\\ Files\\\ (x86)/Microsoft\\\ SDKs/Windows/v6.0/Include
    "}}}}
    "for mingw"{{{{
    set path+=C:/MinGW/include
    set path+=C:/MinGW/lib/gcc/mingw32/4.5.2/include
    set path+=C:/MinGW/lib/gcc/mingw32/4.5.2/include-fixed
    set path+=C:/MinGW/lib/gcc/mingw32/4.5.2/include/c++
    set path+=C:/MinGW/lib/gcc/mingw32/4.5.2/include/c++/backward
    set path+=C:/MinGW/lib/gcc/mingw32/4.5.2/include/c++/mingw32
    "}}}}
    "for home"{{{{
    set path+=C:/Program\\\ Files\\\ (x86)/Microsoft\\\ Visual\\\ Studio\\\ 10.0/VC/include
    set path+=C:/Program\\\ Files\\\ (x86)/Microsoft\\\ Visual\\\ Studio\\\ 10.0/VC/atlmfc/include
    set path+=C:/Program\\\ Files\\\ (x86)/Microsoft\\\ SDKs/Windows/v7.0A/Include
    "}}}}
else
    set path+=/opt/tilera/TileraMDE-4.1.3.150969/tilegx/tile/usr/include
    set path+=/opt/tilera/netlib-1.1.0.150605/netlib/include
endif
"}}}
"}}}
" ====================================================
" Edit
" ====================================================
" {{{
"Set to auto read when a file is changed from the outside
set autoread
set autowrite

" 设置没有展开的<Tab>的宽度为4个空格
set tabstop=8
" 新输入的<Tab>展开为n个空格
set expandtab
" 4个空格代替一个输入的<Tab>
set softtabstop=4

" Autoindent width.
" (自动) 缩进每一步使用的空白数目。用于 'cindent'、>>、<< 等。
set shiftwidth=4
" Round indent by shiftwidth.
set shiftround

" Enable modeline.
set modeline
" Use clipboard register.
set clipboard& clipboard+=unnamed

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
"set foldmethod=indent
set foldmethod=syntax
"set foldmethod=expr
"set foldmethod=marker
" Show folding level.
"set foldcolumn=1
set foldcolumn=3
"启动vim时不要自动折叠代码
"set foldlevel=100
set fillchars=vert:\|
set commentstring=%s

" grep选项
"set grepprg=grep\ -nri
" Use vimgrep.
"set grepprg=internal
" Use grep.
set grepprg=grep\ -nH

" Set undofile
set undofile

" auto change the current working director
set autochdir
"autocmd BufEnter * silent! lcd %:p:h

" 自动向当前文件的上级查找tag文件，直到找到为止
set tags=./tags;

" Set keyword help.
"set keywordprg=:help

" 添加帮助支持
if has('win32') || has('win64')
    nmap <F1> :silent !cmd /C start iexplore "http://search.msdn.microsoft.com/search/default.aspx?query=<cword>"<CR>;
else
    source $VIMRUNTIME/ftplugin/man.vim
    "nmap m :Man =expand("")
endif
" }}}
" ====================================================
" Syntax
" ====================================================
" {{{
" Switch syntax highlighting on, when the terminal has colors
syntax on

" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72, 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on

" Copy indent from current line, over to the new line
set autoindent
" Do smart indenting when starting a new line
set smartindent

augroup MyAutoCmd
    " Easily load VimScript.
    autocmd FileType vim nnoremap <silent><buffer> [Space]so :write \| source % \| echo "source " . bufname('%')<CR>

    " Auto reload VimScript.
    autocmd BufWritePost,FileWritePost *.vim if &autoread | source <afile> | echo "source " . bufname('%') | endif

    " Close help and git window by pressing q.
    autocmd FileType help,git-status,git-log,qf,gitcommit,quickrun,qfreplace,ref,simpletap-summary,vcs-commit,vcs-status,vim-hacks
                \ nnoremap <buffer><silent> q :<C-u>call <sid>smart_close()<CR>
    autocmd FileType * if (&readonly || !&modifiable) && !hasmapto('q', 'n')
                \ | nnoremap <buffer><silent> q :<C-u>call <sid>smart_close()<CR>| endif


    " Manage long Rakefile easily
    autocmd BufNewfile,BufRead Rakefile foldmethod=syntax foldnestmax=1

    " Enable omni completion.
    autocmd FileType ada setlocal omnifunc=adacomplete#Complete
    autocmd FileType c setlocal omnifunc=ccomplete#Complete
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    "autocmd FileType java setlocal omnifunc=javacomplete#Complete
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType php setlocal omnifunc=phpcomplete#CompletePHP
    autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
    "autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
    "autocmd FileType sql setlocal omnifunc=sqlcomplete#Complete
    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
augroup END

" Syntax highlight for user commands.
augroup syntax-highlight-extends
    autocmd!
    autocmd Syntax vim call s:set_syntax_of_user_defined_commands()
augroup END

function! s:set_syntax_of_user_defined_commands()
    redir => _
    silent! command
    redir END

    let command_names = []
    for command_info in split(_, '\n')[1:]
        let command_name = matchstr(command_info, '^[!"b]*\s\+\zs\u\w*\ze')
        call add(command_names, command_name)
    endfor

    if empty(command_names) | return | endif

    execute 'syntax keyword vimCommand contained ' . join(command_names)
endfunction
" }}}
" ====================================================
" Session
" ====================================================
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
" Key map
" ====================================================
"{{{
let mapleader = ","
let maplocalleader = ","

nnoremap Qa :qa<CR>
nnoremap Q :q<CR>

"change directory to the file being edited and display it
nnoremap <Leader>cd :cd %:p:h<CR>:pwd<CR>

"windows managment{{{{
function! WinMove(key)
    let t:curwin = winnr()
    exec "wincmd ".a:key
    if (t:curwin == winnr()) "we havent moved
        if (match(a:key,'[jk]')) "were we going up/down
            wincmd v
        else
            wincmd s
        endif
        exec "wincmd ".a:key
    endif
endfunction

map <leader>h :call WinMove('h')<cr>
map <leader>k :call WinMove('k')<cr>
map <leader>l :call WinMove('l')<cr>
map <leader>j :call WinMove('j')<cr>
"close
map <leader>wc :wincmd q<cr>
"rotate
map <leader>wr <C-W>r
"move
map <leader>H :wincmd H<cr>
map <leader>K :wincmd K<cr>
map <leader>L :wincmd L<cr>
map <leader>J :wincmd J<cr>
"resize
nmap <left>  :3wincmd <<cr>
nmap <right> :3wincmd ><cr>
nmap <up>    :3wincmd +<cr>
nmap <down>  :3wincmd -<cr>
"}}}}
"}}}
" ====================================================
" Plugins configuration
" ====================================================
" inner{{{
" Disable GetLatestVimPlugin.vim
let g:loaded_getscriptPlugin = 1
" Disable netrw.vim
let g:loaded_netrwPlugin = 1
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
" Tagbar"{{{
nnoremap <silent> <Leader>tb :TagbarOpenAutoClose()<CR>
let g:tagbar_width = 25
let g:tagbar_compact = 1
let g:tagbar_autoclose = 1
let g:tagbar_autofocus = 1
let g:tagbar_autoshowtag = 1
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
let g:easytags_by_filetype = "~/.neocomplete/tags_cache/"

" Faster syntax highlighting using Python
let g:easytags_python_enabled = 1
let g:easytags_updatetime_autodisable = 1
" highlight is so slow that I close this feature
let g:easytags_on_cursorhold = 0
let g:easytags_auto_highlight = 0
map <C-F11> :UpdateTags -R --fields=+ialS --c-kinds=+p --c++-kinds=+p --extra=+q . <CR><CR>
"}}}
" ----------------------------------------------------
" vim-css-color{{{
let g:ccsColorVimDoNotMessMyUpdatetime = 1
" }}}
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
" nerdtree"{{{
" toggles NERDTree on and off
map <F2> :NERDTreeToggle<CR>
imap <F2> <Esc>:NERDTreeToggle<CR>i
"nnoremap <silent> <BS> :<C-u>NERDTreeToggle<CR>
"}}}
" ----------------------------------------------------
" netrw{{{
"let g:netrw_liststyle=3
let g:netrw_browse_split=4
let g:netrw_preview=1
let g:netrw_altv=1
let g:netrw_list_hide= '*.swp *.swo *~'
" Change default directory.
set browsedir=current
if executable('wget')
    let g:netrw_http_cmd = 'wget'
endif
"}}}
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
nmap <Leader>gd :Gdiff<CR>
nmap <Leader>gp :Git push<CR>
" }}}
" ----------------------------------------------------
" Undotree {{{
nnoremap U :<C-u>UndotreeToggle<CR>
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

call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])
call unite#custom#source('file_mru,file_rec,file_rec/async,grep,locate',
            \ 'ignore_pattern', join(['\.git/', 'tmp/', 'bundle/'], '\|'))

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
    \['▷ git diff (fugitive) ⌘ ,gd',
        \'Gdiff'],
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

" colorv menu {{{
function! GetColorFormat()
    let formats = {'r' : 'RGB',
                  \'n' : 'NAME',
                  \'s' : 'HEX',
                  \'ar': 'RGBA',
                  \'pr': 'RGBP',
                  \'pa': 'RGBAP',
                  \'m' : 'CMYK',
                  \'l' : 'HSL',
                  \'la' : 'HSLA',
                  \'h' : 'HSV',
                  \}
    let formats_menu = ["\n"]
    for [k, v] in items(formats)
        call add(formats_menu, " ".k."\t".v."\n")
    endfor
    let fsel = get(formats, input('Choose a format: '.join(formats_menu).'? '))
    return fsel
endfunction

function! GetColorMethod()
    let methods = {
                   \'h' : 'Hue',
                   \'s' : 'Saturation',
                   \'v' : 'Value',
                   \'m' : 'Monochromatic',
                   \'a' : 'Analogous',
                   \'3' : 'Triadic',
                   \'4' : 'Tetradic',
                   \'n' : 'Neutral',
                   \'c' : 'Clash',
                   \'q' : 'Square',
                   \'5' : 'Five-Tone',
                   \'6' : 'Six-Tone',
                   \'2' : 'Complementary',
                   \'p' : 'Split-Complementary',
                   \'l' : 'Luma',
                   \'g' : 'Turn-To',
                   \}
    let methods_menu = ["\n"]
    for [k, v] in items(methods)
        call add(methods_menu, " ".k."\t".v."\n")
    endfor
    let msel = get(methods, input('Choose a method: '.join(methods_menu).'? '))
    return msel
endfunction

let g:unite_source_menu_menus.colorv = {
    \ 'description' : ' color management
        \ ⌘ [space]c',
    \}
let g:unite_source_menu_menus.colorv.command_candidates = [
    \['▷ open colorv ⌘ ,cv',
        \'ColorV'],
    \['▷ open colorv with the color under the cursor ⌘ ,cw',
        \'ColorVView'],
    \['▷ preview colors ⌘ ,cpp',
        \'ColorVPreview'],
    \['▷ color picker ⌘ ,cd',
        \'ColorVPicker'],
    \['▷ edit the color under the cursor ⌘ ,ce',
        \'ColorVEdit'],
    \['▷ edit the color under the cursor (and all the concurrences) ⌘ ,cE',
        \'ColorVEditAll'],
    \['▷ insert a color ⌘ ,cii',
        \'exe "ColorVInsert " .GetColorFormat()'],
    \['▷ color list relative to the current ⌘ ,cgh',
        \'exe "ColorVList " .GetColorMethod() "
\ ".input("number of colors? (optional): ")
        \ " ".input("number of steps? (optional): ")'],
    \['▷ show colors list (Web W3C colors) ⌘ ,cn',
        \'ColorVName'],
    \['▷ choose color scheme (ColourLovers, Kuler) ⌘ ,css',
        \'ColorVScheme'],
    \['▷ show favorite color schemes ⌘ ,csf',
        \'ColorVSchemeFav'],
    \['▷ new color scheme ⌘ ,csn',
        \'ColorVSchemeNew'],
    \['▷ create hue gradation between two colors',
        \'exe "ColorVTurn2 " " ".input("Color 1 (hex): ")
        \" ".input("Color 2 (hex): ")'],
    \]
nnoremap <silent>[menu]c :Unite -silent menu:colorv<CR>
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
call unite#custom_action('source/sow_moveentry_entry/*', 'sow_moveto_entry', sow_moveto_entry)
call unite#custom_default_action('source/sow_moveentry_entry/*', 'sow_moveto_entry')
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
" smartword.vim"{{{
" Replace w and others with smartword-mappings
nmap w  <Plug>(smartword-w)
nmap b  <Plug>(smartword-b)
nmap ge  <Plug>(smartword-ge)
xmap w  <Plug>(smartword-w)
xmap b  <Plug>(smartword-b)
" Operator pending mode.
omap <Leader>w  <Plug>(smartword-w)
omap <Leader>b  <Plug>(smartword-b)
omap <Leader>ge  <Plug>(smartword-ge)
"}}}
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
" smarttill.vim"{{{
xmap q  <Plug>(smarttill-t)
xmap Q  <Plug>(smarttill-T)
" Operator pending mode.
omap q  <Plug>(smarttill-t)
omap Q  <Plug>(smarttill-T)
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
"let g:syntastic_c_compiler="tile-gcc"
"let g:syntastic_c_include_dirs = ["/opt/tilera/TileraMDE-4.1.3.150969/tilegx/tile/usr/include", "/opt/tilera/netlib-1.1.0.150605/netlib/include", "/opt/tilera/netlib-1.1.0.150605/app/trafgen_netlib/build/include"]
let g:syntastic_enable_signs = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_mode_map = { 'mode': 'active',
            \ 'active_filetypes': ['ruby', 'eruby', 'html', 'xml', 'c', 'cpp'],
            \ 'passive_filetypes': ['javascript', 'css', 'php'] }
" }}}
" ----------------------------------------------------
" SingleCompile"{{{
nmap <F7> :SCCompile
nmap <F5> :SCCompileRun<CR>:SCViewResult<CR>
"}}}
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
" neocomplete{{{
" Use neocomplete.
let g:neocomplete#enable_at_startup = 0

let bundle = neobundle#get('neocomplete.vim')
function! bundle.hooks.on_source(bundle)
    " Use smartcase.
    let g:neocomplete#enable_smart_case = 1
    " Use fuzzy completion.
    let g:neocomplete#enable_fuzzy_completion = 1

    " Set minimum syntax keyword length.
    let g:neocomplete#sources#syntax#min_keyword_length = 3
    " Set auto completion length.
    let g:neocomplete#auto_completion_start_length = 2
    " Set manual completion length.
    let g:neocomplete#manual_completion_start_length = 0
    " Set minimum keyword length.
    let g:neocomplete#min_keyword_length = 3

    " For auto select.
    let g:neocomplete#enable_complete_select = 0
    let g:neocomplete#enable_auto_select = 0
    let g:neocomplete#enable_refresh_always = 0
    if g:neocomplete#enable_complete_select
        set completeopt-=noselect
        set completeopt+=noinsert
    endif

    let g:neocomplete#enable_auto_delimiter = 1
    let g:neocomplete#disable_auto_select_buffer_name_pattern =
                \ '\[Command Line\]'
    let g:neocomplete#max_list = 100
    let g:neocomplete#force_overwrite_completefunc = 1
    if !exists('g:neocomplete#sources#omni#input_patterns')
        let g:neocomplete#sources#omni#input_patterns = {}
    endif
    if !exists('g:neocomplete#sources#omni#functions')
        let g:neocomplete#sources#omni#functions = {}
    endif
    if !exists('g:neocomplete#force_omni_input_patterns')
        let g:neocomplete#force_omni_input_patterns = {}
    endif
    let g:neocomplete#enable_auto_close_preview = 1

    " let g:neocomplete#force_omni_input_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
    let g:neocomplete#sources#omni#input_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'

    " Define keyword pattern.
    if !exists('g:neocomplete#keyword_patterns')
        let g:neocomplete#keyword_patterns = {}
    endif
    let g:neocomplete#keyword_patterns._ = '[0-9a-zA-Z:#_]\+'
    let g:neocomplete#keyword_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

    let g:neocomplete#sources#vim#complete_functions = {
                \ 'Ref' : 'ref#complete',
                \ 'Unite' : 'unite#complete_source',
                \}
    call neocomplete#custom#source('look', 'min_pattern_length', 4)

    " mappings."{{{
    " <C-f>, <C-b>: page move.
    inoremap <expr><C-f> pumvisible() ? "\<PageDown>" : "\<Right>"
    inoremap <expr><C-b> pumvisible() ? "\<PageUp>" : "\<Left>"
    " <C-y>: paste.
    inoremap <expr><C-y> pumvisible() ? neocomplete#close_popup() : "\<C-r>\""
    " <C-e>: close popup.
    inoremap <expr><C-e> pumvisible() ? neocomplete#cancel_popup() : "\<End>"
    " <C-k>: unite completion.
    "imap <C-k> <Plug>(neocomplete_start_unite_complete)
    " <C-h>, <BS>: close popup and delete backword char.
    inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
    inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
    " <C-n>: neocomplete.
    inoremap <expr><C-n> pumvisible() ? "\<C-n>" : "\<C-x>\<C-u>\<C-p>\<Down>"
    " <C-p>: keyword completion.
    inoremap <expr><C-p> pumvisible() ? "\<C-p>" : "\<C-p>\<C-n>"
    "inoremap <expr>' pumvisible() ? neocomplete#close_popup() : "'"

    imap <expr> ` pumvisible() ?
                \ "\<Plug>(neocomplete_start_unite_quick_match)" : '`'

    inoremap <expr><C-x><C-f>
                \ neocomplete#start_manual_complete('filename_complete')

    inoremap <expr><C-g> neocomplete#undo_completion()
    inoremap <expr><C-l> neocomplete#complete_common_string()

    " <TAB>: completion.
    inoremap <expr><TAB> pumvisible() ? "\<C-n>" :
                \ <SID>check_back_space() ? "\<TAB>" :
                \ neocomplete#start_manual_complete()
    " <S-TAB>: completion back.
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

    "}}}
endfunction
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
    if has('conceal')
        set conceallevel=2
    endif
endfunction

unlet bundle

nnoremap <silent> [Window]f :<C-u>Unite neosnippet/user neosnippet/runtime<CR>

"}}}
" ----------------------------------------------------
" vim-go {{{
" Show type info for the word under cursor
au FileType go nmap <Leader>i <Plug>go-info
" Open the relevant Godoc for the word under cursor
au FileType go nmap <Leader>gd <Plug>go-doc
au FileType go nmap <Leader>gv <Plug>go-doc-vertical
" Open the Godoc in browser
au FileType go nmap <Leader>gb <Plug>go-doc-browser
" Commands
au FileType go nmap <Leader>r <Plug>go-run
au FileType go nmap <Leader>b <Plug>go-build
au FileType go nmap <Leader>t <Plug>go-test
" Goto Declaration
au FileType go nmap gd <Plug>go-def
" Open definition/declaration
au FileType go nmap <Leader>ds <Plug>go-def-split
au FileType go nmap <Leader>dv <Plug>go-def-vertical
au FileType go nmap <Leader>dt <Plug>go-def-tab

" Setting
" Disable auto installation of binaries
"let g:go_disable_autoinstall = 1
" Disable auto fmt on save
"let g:go_fmt_autosave = 0
let g:go_snippent_engine = "neosnippet"
" }}}
" ----------------------------------------------------
" vim-slime"{{{
let g:slime_target = "tmux"
let g:slime_paste_file = tempname()
"}}}
" ----------------------------------------------------
" showmarks.vim"{{{
" 自动生成帮助文档,需要手动建立doc文件夹
let g:showmarks_enable=0
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
"let g:airline_left_sep = "|"
"let g:airline_left_alt_sep = "|"
"let g:airline_right_sep = "|"
"let g:airline_right_alt_sep = "|"
" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_alt_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_alt_sep = '◀'

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
"let g:airline_symbols.linenr = '␊'
"let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
"let g:airline_symbols.paste = 'Þ'
"let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'
" }}}
" ----------------------------------------------------
" vim-bufferline {{{
"let g:bufferline_echo = 0
let g:bufferline_rotate = 1
"autocmd VimEnter *
            "\ let &statusline='%{bufferline#refresh_status()}'
            "\ .bufferline#get_status_string()
" }}}
" ====================================================
" Support and Misc
" ====================================================
" check whether characters before current column are all space "{{{
func! s:check_back_space()
    let col = col('.') - 1
    return !col || getline('.')[col - 1] =~ '\s'
endfunc
"}}}
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
"}}}
" ----------------------------------------------------
" vim: foldmethod=marker
