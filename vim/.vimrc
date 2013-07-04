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
" 1)original repos on github
"NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'toupeira/vim-desertink'

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

"NeoBundle 'Shougo/neocomplcache', '', 'default'
"call neobundle#config('neocomplcache', {
"\ 'lazy' : 1,
"\ 'autoload' : {
"\ 'commands' : 'NeoComplCacheEnable',
"\ }})

"NeoBundle 'Shougo/neocomplcache-rsense', '', 'default'
"call neobundle#config('neocomplcache-rsense', {
"\ 'lazy' : 1,
"\ 'depends' : 'Shougo/neocomplcache',
"\ 'autoload' : { 'filetypes' : 'ruby'  }
"\ })

NeoBundle 'Shougo/neobundle-vim-scripts', '', 'default'

"NeoBundle 'Shougo/neocomplcache-clang_complete'
"NeoBundleLazy 'Rip-Rip/clang_complete', {
"\ 'autoload' : {
"\     'filetypes' : ['c', 'cpp'],
"\    },
"\ }
"NeoBundle 'ujihisa/neco-look'

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
NeoBundleLazy 'Shougo/unite-help', {
            \ 'autoload' : { 'unite_sources' : 'help' }}
NeoBundleLazy 'tsukkee/unite-tag', { 
            \ 'autoload' : { 'unite_sources' : 'tag' }}
NeoBundleLazy 'osyo-manga/unite-quickfix', {
            \ 'autoload' : { 'unite_sources' : 'quickfix' }}
NeoBundleLazy 'osyo-manga/unite-filetype', {
            \ 'autoload' : { 'unite_sources' : 'filetype' }}
NeoBundleLazy 'ujihisa/unite-locate', {
            \ 'autoload' : {'unite_sources' : 'locate' }}
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
NeoBundle 'tacroe/unite-mark'
NeoBundle 'basyura/unite-rails'
NeoBundle 'tungd/unite-session'

if has('win32') || has('win64')
    NeoBundle 'xolox/vim-shell'
endif
NeoBundle 'xolox/vim-misc'
NeoBundle 'xolox/vim-easytags'
"NeoBundle 'abudden/TagHighlight'

NeoBundle 'scrooloose/syntastic'
NeoBundle 'scrooloose/nerdcommenter'
NeoBundle 'scrooloose/nerdtree', { 'augroup' : 'NERDTreeHijackNetrw' }
NeoBundle 'majutsushi/tagbar'
NeoBundle 'xuhdev/SingleCompile'

NeoBundleLazy 'sjl/gundo.vim', { 'autoload' : {
            \ 'commands' : 'GundoToggle'
            \ }}
NeoBundle 'tpope/vim-git'
NeoBundle 'tpope/vim-fugitive', { 'augroup' : 'fugitive' }
NeoBundle 'gregsexton/gitv'

"vim-endwise fix conflict with delimitMate in imap <cr>
"when load after delimitMate
NeoBundle 'Raimondi/delimitMate'
NeoBundle 'tpope/vim-endwise'
NeoBundle 'tpope/vim-repeat'
NeoBundle 'tpope/vim-surround'
NeoBundle 'chrisbra/SudoEdit.vim'

NeoBundle 'kana/vim-wwwsearch'
NeoBundle 'kana/vim-scratch'
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
NeoBundle 'kana/vim-textobj-user'
NeoBundle 'kana/vim-textobj-syntax'
NeoBundle 'kana/vim-textobj-indent'
NeoBundle 'kana/vim-textobj-line'
NeoBundle 'kana/vim-textobj-function'
NeoBundle 'kana/vim-textobj-lastpat'
NeoBundle 'kana/vim-textobj-fold'
NeoBundle 'kana/vim-textobj-entire'
NeoBundle 'kana/vim-textobj-diff'
NeoBundle 'kana/vim-textobj-datetime'
NeoBundle 'thinca/vim-textobj-between'
NeoBundle 'thinca/vim-textobj-comment'
NeoBundle 'mattn/vim-textobj-url'
NeoBundle 'anyakichi/vim-textobj-xbrackets'
NeoBundle 'sgur/vim-textobj-parameter'

"python
"NeoBundle 'nvie/vim-flake8'
"NeoBundle 'kevinw/pyflakes-vim'
"NeoBundle 'fs111/pydoc.vim'

"ruby
NeoBundle 'vim-ruby/vim-ruby'
NeoBundle 'tpope/vim-rails'
NeoBundle 'nelstrom/vim-textobj-rubyblock'
NeoBundle 't9md/vim-textobj-function-ruby'
NeoBundle 'ujihisa/neco-ruby'
"NeoBundle 'ecomba/vim-ruby-refactoring'
"needs methodfinder gem
NeoBundle 'ujihisa/neco-rubymf'

"markup
NeoBundle 'othree/html5.vim'
NeoBundle 'mattn/zencoding-vim'
NeoBundle 'sukima/xmledit'
NeoBundle 'ap/vim-css-color'
NeoBundle 'hail2u/vim-css3-syntax'
NeoBundle 'greyblake/vim-preview'
NeoBundle 'vim-pandoc/vim-pandoc'
NeoBundle 'tpope/vim-haml'
NeoBundle 'slim-template/vim-slim'

"javascript
NeoBundle 'jelera/vim-javascript-syntax'
NeoBundle 'teramako/jscomplete-vim'
NeoBundle 'nono/jquery.vim'
NeoBundle 'thinca/vim-textobj-function-javascript'
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'elzr/vim-json'

NeoBundle 'jpalardy/vim-slime'
if has('conceal')
    NeoBundle 'Yggdroot/indentLine'
endif

" 2)vim-scripts repos
" https://githubcom/vim-scripts/xxx.git
NeoBundle 'vimcdoc'
NeoBundle 'matchit.zip'
NeoBundle 'FencView.vim'
NeoBundle 'ShowMarks'
"NeoBundle 'Mark--Karkat'
NeoBundle 'a.vim'
"NeoBundle 'echofunc.vim'
NeoBundle 'Txtfmt-The-Vim-Highlighter'
NeoBundle 'DoxygenToolkit.vim'
NeoBundle 'Source-Explorer-srcexpl.vim'
NeoBundle 'SearchComplete'
"NeoBundle 'Pydiction'
"NeoBundle 'dbext.vim'

" 3)non github repos
"NeoBundle 'git://git.wincent.com/command-t.git'
"
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

" View
" ====================================================
"{{{
" colorscheme
colorscheme desertink

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
" 状态栏格式定义
set statusline=
set statusline+=%#Visual#\ %{getcwd()} "current work directory
set statusline+=%#DiffAdd#\ %f  "path to the file in the buffer, relative to current directory
set statusline+=\%h%m%r%w" "flag
" filetype               encoding     file format    
set statusline+=\[%{strlen(&ft)?&ft:'none'},%{&encoding},%{&fileformat}]
set statusline+=%#Error#\%{fugitive#statusline()}%#Pmenu#
set statusline+=%=%#DiffChange#\ %l/%L[%p%%],%v

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
"}}}
" ====================================================
" Edit
" ====================================================
" {{{
"Set to auto read when a file is changed from the outside
set autoread
set autowrite

" 设置没有展开的<Tab>的宽度为4个空格
set tabstop=4
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
set foldmethod=indent
"set foldmethod=syntax
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
    nmap m :Man =expand("")
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
let g:easytags_by_filetype = "~/.neocon/tags_cache/"

" Faster syntax highlighting using Python
let g:easytags_python_enabled = 1
let g:easytags_on_cursorhold = 0
let g:easytags_updatetime_autodisable = 1
" highlight is so slow that I close this feature
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
let g:DoxygenToolkit_briefTag_pre="@Synopsis  "
let g:DoxygenToolkit_paramTag_pre="@Param "
let g:DoxygenToolkit_returnTag="@Returns   "
let g:DoxygenToolkit_blockHeader="---------------------------------------------"
let g:DoxygenToolkit_blockFooter="---------------------------------------------"
let g:DoxygenToolkit_authorName="majiana"
let g:DoxygenToolkit_licenseTag="My own license"   "<-- !!! Does not end with "\<enter>"
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
" Gundo"{{{
nnoremap U :<C-u>GundoToggle<CR>
" }}}
" ----------------------------------------------------
" unite"{{{
"let g:unite_enable_start_insert = 1
" The prefix key.
nnoremap    [unite]   <Nop>
xnoremap    [unite]   <Nop>
nmap    <LocalLeader>u [unite]
xmap    <LocalLeader>u [unite]
imap <LocalLeader>u <C-\><C-N>[unite]
imap <LocalLeader>c <Plug>(neocomplcache_start_unite_complete)

nnoremap <expr><silent> [unite]b  <SID>unite_build()
function! s:unite_build()
    return ":\<C-u>Unite -buffer-name=build". tabpagenr() ." -no-quit build\<CR>"
endfunction
nnoremap <silent> [unite]r  :<C-u>Unite -buffer-name=register register history/yank<CR>
nnoremap <silent> [unite]o  :<C-u>Unite outline -start-insert<CR>
nnoremap <silent> [unite]t  :<C-u>UniteWithCursorWord -buffer-name=tag tag<CR>
nnoremap <silent> [unite]w  :<C-u>UniteWithCursorWord -buffer-name=register
            \ buffer file_mru bookmark file<CR>
nnoremap <silent> [unite]h  :<C-u>Unite history/command<CR>
nnoremap <silent> [unite]q  :<C-u>Unite qflist -no-quit<CR>
nnoremap <silent> [unite]g  :<C-u>Unite grep -buffer-name=search -no-quit<CR>
nnoremap <silent> <C-k>  :<C-u>Unite change jump<CR>
nnoremap <silent> [unite]c  :<C-u>Unite change<CR>
nnoremap <silent> [unite]f  :<C-u>Unite -buffer-name=resume resume<CR>
nnoremap <silent> [unite]d  :<C-u>Unite -buffer-name=files -default-action=lcd directory_mru<CR>
nnoremap <silent> [unite]ma  :<C-u>Unite mapping<CR>
nnoremap <silent> [unite]me  :<C-u>Unite output:message<CR>
inoremap <silent> <C-z>  <C-o>:call unite#start_complete(['register'], {'is_insert' : 1})<CR>

" tags"{{{
" The prefix key.
nnoremap    [Tag]   <Nop>
nmap    <LocalLeader>t [Tag]
" Jump.
nnoremap <silent><expr> [Tag]t  &filetype == 'help' ?  "\<C-]>" :
            \ ":\<C-u>UniteWithCursorWord -buffer-name=tag tag\<CR>"
" Jump next.
nnoremap <silent> [Tag]n  :<C-u>tag<CR>
" Jump previous.
nnoremap <silent><expr> [Tag]p  &filetype == 'help' ?
            \ ":\<C-u>pop\<CR>" : ":\<C-u>Unite jump\<CR>"
"}}}

" Execute help.
nnoremap <C-h>  :<C-u>UniteWithInput help<CR>
" Execute help by cursor keyword.
nnoremap <silent> g<C-h>  :<C-u>UniteWithCursorWord help<CR>

let g:unite_enable_split_vertically = 0
let g:unite_source_history_yank_enable = 1
let g:unite_winheight = 20

call unite#custom_alias('file', 'h', 'left')
call unite#custom_default_action('directory', 'narrow')

" migemo.
call unite#custom_filters('line_migemo', ['matcher_migemo', 'sorter_default', 'converter_default'])

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

let g:unite_cursor_line_highlight = 'TabLineSel'
let g:unite_abbr_highlight = 'TabLine'
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
" unite-menu"{{{
let g:unite_source_menu_menus = {}
let g:unite_source_menu_menus.test = {
            \     'description' : 'Test menu',
            \ }
let g:unite_source_menu_menus.test.candidates = {
            \       'ghci'      : 'VimShellInteractive ghci',
            \       'python'    : 'VimShellInteractive python',
            \       'Unite Beautiful Attack' : 'Unite -auto-preview colorscheme',
            \     }
function g:unite_source_menu_menus.test.map(key, value)
    return {
                \       'word' : a:key, 'kind' : 'command',
                \       'action__command' : a:value,
                \     }
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
" surround.vim"{{{
let g:surround_no_mappings = 1
autocmd MyAutoCmd FileType * call s:define_surround_keymappings()

function! s:define_surround_keymappings()
    if !&l:modifiable
        silent! nunmap <buffer> ds
        silent! nunmap <buffer> cs
        silent! nunmap <buffer> ys
        silent! nunmap <buffer> yS
    else
        nmap <buffer> ds <Plug>Dsurround
        nmap <buffer> cs <Plug>Csurround
        nmap <buffer> ys <Plug>Ysurround
        nmap <buffer> yS <Plug>YSurround
    endif
endfunction
"}}}" ----------------------------------------------------
" ----------------------------------------------------
" delimitMate{{{
"let g:delimitMate_matchpairs = "(:),[:],{:}"
"let g:delimitMate_quotes = "\" ' `"
let g:delimitMate_expand_cr = 1
"let g:delimitMate_expand_space = 0
" }}}
" ----------------------------------------------------
" Syntastic{{{
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
"}}}"
"" ----------------------------------------------------
" neocomplete{{{
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1

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
    imap <C-k> <Plug>(neocomplete_start_unite_complete)
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
    function! s:check_back_space() "{{{
        let col = col('.') - 1
        return !col || getline('.')[col - 1] =~ '\s'
    endfunction"}}}
    " <S-TAB>: completion back.
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

    " For cursor moving in insert mode(Not recommended)
    inoremap <expr><Left> neocomplete#close_popup() . "\<Left>"
    inoremap <expr><Right> neocomplete#close_popup() . "\<Right>"
    inoremap <expr><Up> neocomplete#close_popup() . "\<Up>"
    inoremap <expr><Down> neocomplete#close_popup() . "\<Down>"
    "}}}
endfunction
unlet bundle
" }}}
" ----------------------------------------------------
" neosnippet.vim"{{{
let bundle = neobundle#get('neosnippet')
function! bundle.hooks.on_source(bundle)
    "imap <silent>L <Plug>(neosnippet_jump_or_expand)
    "smap <silent>L <Plug>(neosnippet_jump_or_expand)
    "xmap <silent>L <Plug>(neosnippet_start_unite_snippet_target)
    "imap <silent>K <Plug>(neosnippet_expand_or_jump)
    "smap <silent>K <Plug>(neosnippet_expand_or_jump)
    "imap <silent>G <Plug>(neosnippet_expand)
    "imap <silent>S <Plug>(neosnippet_start_unite_snippet)
    "xmap <silent>o <Plug>(neosnippet_register_oneshot_snippet)
    "xmap <silent>U <Plug>(neosnippet_expand_target)

    let g:neosnippet#enable_snipmate_compatibility = 1

    " let g:snippets_dir = '~/.vim/snippets/,~/.vim/bundle/snipmate/snippets/'
    let g:neosnippet#snippets_directory = '~/.vim/snippets'
endfunction

unlet bundle

nnoremap <silent> [Window]f :<C-u>Unite neosnippet/user neosnippet/runtime<CR>

"}}}
" ----------------------------------------------------
"" neocomplcache"{{{
"" Use neocomplcache.
"let g:neocomplcache_enable_at_startup = 0

"let bundle = neobundle#get('neocomplcache')
"function! bundle.hooks.on_source(bundle)
"" Use smartcase.
"let g:neocomplcache_enable_smart_case = 0
"" Use camel case completion.
"let g:neocomplcache_enable_camel_case_completion = 0
"" Use underbar completion.
"let g:neocomplcache_enable_underbar_completion = 0
"" Use fuzzy completion.
"let g:neocomplcache_enable_fuzzy_completion = 0

"" Set minimum syntax keyword length.
"let g:neocomplcache_min_syntax_length = 3
"" Set auto completion length.
"let g:neocomplcache_auto_completion_start_length = 2
"" Set manual completion length.
"let g:neocomplcache_manual_completion_start_length = 0
"" Set minimum keyword length.
"let g:neocomplcache_min_keyword_length = 3
"" let g:neocomplcache_enable_cursor_hold_i = v:version > 703 ||
"" \ v:version == 703 && has('patch289')
"let g:neocomplcache_enable_cursor_hold_i = 0
"let g:neocomplcache_cursor_hold_i_time = 300
"let g:neocomplcache_enable_insert_char_pre = 0
"let g:neocomplcache_enable_prefetch = 0
"let g:neocomplcache_skip_auto_completion_time = '0.6'

"" For auto select.
"let g:neocomplcache_enable_auto_select = 0

"let g:neocomplcache_enable_auto_delimiter = 1
"let g:neocomplcache_disable_auto_select_buffer_name_pattern =
"\ '\[Command Line\]'
""let g:neocomplcache_disable_auto_complete = 0
"let g:neocomplcache_max_list = 100
"let g:neocomplcache_force_overwrite_completefunc = 1
"if !exists('g:neocomplcache_omni_patterns')
"let g:neocomplcache_omni_patterns = {}
"endif
"if !exists('g:neocomplcache_omni_functions')
"let g:neocomplcache_omni_functions = {}
"endif
"if !exists('g:neocomplcache_force_omni_patterns')
"let g:neocomplcache_force_omni_patterns = {}
"endif
"let g:neocomplcache_enable_auto_close_preview = 1
"" let g:neocomplcache_force_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
"let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'

"" For clang_complete.
"let g:neocomplcache_force_overwrite_completefunc = 1
"let g:neocomplcache_force_omni_patterns.c =
"\ '[^.[:digit:] *\t]\%(\.\|->\)'
"let g:neocomplcache_force_omni_patterns.cpp =
"\ '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
"let g:clang_complete_auto = 0
"let g:clang_auto_select = 0
"let g:clang_use_library = 1

"" Define keyword pattern.
"if !exists('g:neocomplcache_keyword_patterns')
"let g:neocomplcache_keyword_patterns = {}
"endif
"" let g:neocomplcache_keyword_patterns.default = '\h\w*'
"let g:neocomplcache_keyword_patterns['default'] = '[0-9a-zA-Z:#_]\+'
"let g:neocomplcache_keyword_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

"let g:neocomplcache_vim_completefuncs = {
"\ 'Ref' : 'ref#complete',
"\ 'Unite' : 'unite#complete_source',
"\ 'VimShellExecute' :
"\ 'vimshell#vimshell_execute_complete',
"\ 'VimShellInteractive' :
"\ 'vimshell#vimshell_execute_complete',
"\ 'VimShellTerminal' :
"\ 'vimshell#vimshell_execute_complete',
"\ 'VimShell' : 'vimshell#complete',
"\ 'VimFiler' : 'vimfiler#complete',
"\ 'Vinarise' : 'vinarise#complete',
"\}
"imap <expr> ` pumvisible() ?
"\ "\<Plug>(neocomplcache_start_unite_quick_match)" : '`'
"endfunction

"function! CompleteFiles(findstart, base)
"if a:findstart
"" Get cursor word.
"let cur_text = strpart(getline('.'), 0, col('.') - 1)

"return match(cur_text, '\f*$')
"endif

"let words = split(expand(a:base . '*'), '\n')
"let list = []
"let cnt = 0
"for word in words
"call add(list, {
"\ 'word' : word,
"\ 'abbr' : printf('%3d: %s', cnt, word),
"\ 'menu' : 'file_complete'
"\ })
"let cnt += 1
"endfor

"return { 'words' : list, 'refresh' : 'always' }
"endfunction

"unlet bundle
"" }}}
""neocomplcache-clang_complete"{{{
"" use neocomplcache & clang_complete
"" add neocomplcache option
""let g:neocomplcache_force_overwrite_completefunc=1
"" add clang_complete option
""let g:clang_complete_auto=1
""}}}
"" clang_complete"{{{
"" Clang version > 2.8 for c++...
"" After * . , -> and :: => automatically
"" * <C-X><C-U> => "force" the completion.
"" clang * can detect errors inside your code, and highlight them
"" * can open the quickfix window automatically.
"" When using special flags for a project (especially -I and -D ones),
"" put the flags inside the file .clang_complete at the root of your project. 
""
"" some details:
"" '+' - constructor
"" '~' - destructor
"" 'e' - enumerator constant
"" 'a' - parameter ('a' from "argument") of a function, method or template
"" 'u' - unknown or buildin type (int, float, ...)
"" 'n' - namespace or its alias
"" 'p' - template ('p' from "pattern")

"let g:clang_complete_auto = 1
"let g:clang_complete_copen = 1
"let g:clang_hl_errors = 1
"let g:clang_periodic_quickfix = 1
""let g:clang_snippets = 1
""let g:clang_conceal_snippets = 1
"if has("win32")
""let g:clang_exec = expand('$VIM').'/clang.exe'
"let g:clang_user_options = '2>NULL || exit 0'
"let g:clang_library_path = expand('$VIM')
"elseif has("unix")
"let g:clang_user_options = '2>/dev/null || exit 0'
"let g:clang_library_path = '/usr/lib/llvm'
"endif
""let g:clang_complete_macros = 1
"let g:clang_debug = 1
""}}}
"path"{{{
if has("win32")
    "for work"{{{{
    set path+=D:/Work/vista_sdk/Include
    set path+=D:/Work/WpdPack/Include
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
endif
"}}}
" ----------------------------------------------------
" vim-slime"{{{
let g:slime_target = "tmux"
"}}}
" ----------------------------------------------------
" showmarks.vim"{{{
" 自动生成帮助文档,需要手动建立doc文件夹
let g:showmarks_enable=0
"}}}
" ---------------------------------------------------- 
" Cscope"{{{
" 需要添加环境变量
"if has("cscope")
"  set cscopetag   " 使支持用 Ctrl+]  和 Ctrl+t 快捷键在代码间跳来跳去
" check cscope for definition of a symbol before checking ctags: set to 1
" if you want the reverse search order
"  set cscopetagorder=1

" add any cscope database in current directory
"  if filereadable("cscope.out")
"    cs add cscope.out  
" else add the database pointed to by environment variable 
"  elseif $CSCOPE_DB != ""
"    cs add $CSCOPE_DB
"  endif

" show msg when any other cscope db added
"  set cscopeverbose 

"  nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
"  nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
"  nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
"  nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
"  nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
"  nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
"  nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
"  nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>
"endif
"}}}
" ---------------------------------------------------- 
" ====================================================
" Support and Misc
" ====================================================
" {{{
function! s:smart_close()
    if winnr('$') != 1
        close
    endif
endfunction

if !has('vim_starting')
    " Call on_source hook when reloading .vimrc.
    call neobundle#call_hook('on_source')
endif
"}}}
" ---------------------------------------------------- 
" vim: foldmethod=marker
