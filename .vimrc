" SECTION: Notes"{
" =====================================
" vim:set ft=vim
"
" This my personal .vimrc, I don't recommend you copy it, just
" use the pieces you want (and understands!). When you copy a
" .vimrc in the entirety, weird and unexpexted things can happen
"
" You can use ~/.vimrc.before.local and ~/.vimrc.private
" for your local and private settings
"}

" SECTION: Initialize"{
" =====================================

" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
set nocompatible
filetype off

" CATEGORY: Startup"{
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

if !has('vim_starting')
  let s:tmp = &runtimepath
  set all&
  let &runtimepath = s:tmp
  unlet s:tmp
endif

" The vim cursor can be changed in the insert mode according
" control sequences when a user enters(t_SI) and leaves(t_EI)
let &t_SI .= "\e[3 q"
let &t_EI .= "\e[1 q"

"}

" CATEGORY: Environment"{
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

let s:is_running_win32 = has('win32')
let s:is_running_win64 = has('win64')
let s:is_running_win = has('win32') || has('win64')

let s:is_running_linux = has('unix') && !has('macunix') && !has('win32unix')
let s:is_running_macunix = has("macunix")
let s:is_running_cygwin = has('win32unix')

let s:is_running_gui = has("gui_running")
"}

" CATEGORY: Terminal"{
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

let s:is_using_term_xterm = &term =~ "xterm*"
let s:is_using_term_dterm = &term =~ "dterm*"
let s:is_using_term_rxvt = &term =~ "rxvt*"
let s:is_using_term_screen = &term =~ "screen*"
let s:is_using_term_linux = &term =~ "linux"
let s:is_using_colorful_term=s:is_using_term_xterm ||
                            \s:is_using_term_rxvt ||
                            \s:is_using_term_screen

if exists('$TMUX')
    set clipboard=
endif
"}

" CATEGORY: Config OS"{
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

if s:is_running_win
    " For Windows
    " -----------
    set shellslash
    let $VIMHOME=expand('~/vimfiles')
    let $DROPBOXDIR = expand('~/Dropbox')
    let $VIMCONFIGDIR = expand('~/projects/vimfiles')
    set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
    set clipboard=unnamed
    behave mswin

else
    " For Linux
    " ---------
    let $VIMHOME=expand('~/.vim')
    let $VIMBUNDLE = expand($VIMHOME . '/bundle')
    let $DROPBOXDIR = expand('~/Dropbox')
    let $VIMCONFIGDIR = expand('~/projects/vimfiles')

endif

if s:is_running_macunix
    set clipboard=unnamed
endif

if !s:is_running_win
    set shell=/bin/bash
endif
"}

" CATEGORY: Private"{
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

" Use before config if available
if filereadable(expand("$HOME/.vimrc.before"))
    source $HOME/.vimrc.before
endif

" Use private config if available
if filereadable(expand("$HOME/.vimrc.private"))
    source $HOME/.vimrc.private
endif
"}

" CATEGORY: Neobundle"{
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

" Auto-install NeoBundle (plugins manager)"{
" ---------------------------------------

if !exists('g:iCanHazNeoBundle')
    let iCanHazNeoBundle=1
endif

let neobundle_readme=expand('$VIMBUNDLE/neobundle.vim/README.md')
if !filereadable(neobundle_readme)
    echo "Installing NeoBundle.."
    echo ""
    silent !mkdir -p $VIMBUNDLE
    silent !git clone https://github.com/Shougo/neobundle.vim.git $VIMBUNDLE/neobundle.vim
    let iCanHazNeoBundle=0
endif

if has('vim_starting')
    set rtp+=$VIMBUNDLE/neobundle.vim/
endif

call neobundle#rc('$VIMBUNDLE')

NeoBundleFetch 'shougo/neobundle.vim'
"}

" Install dependencies"{
" ---------------------------------------
"
" Required to run vimshell interactively
NeoBundle 'shougo/vimproc.vim', {
            \'build': {
            \   'windows': 'make -f make_mingw64.mak',
            \   'cygwin' : 'make -f make_cygwin.mak',
            \   'mac'    : 'make -f make_mac.mak',
            \   'unix'   : 'make -f make_unix.mak',
            \   },
            \}

NeoBundle 'MarcWeber/vim-addon-mw-utils'
NeoBundle 'tomtom/tlib_vim'
" ag better than ack
" apt-get install silversearcher-ag
if executable('ag')
    NeoBundle 'mileszs/ack.vim'
    let g:ackprg = 'ag --nogroup --nocolor --column --smart-case'
elseif executable('ack-grep')
    let g:ackprg="ack-grep -H --nocolor --nogroup --column"
    NeoBundle 'mileszs/ack.vim'
elseif executable('ack')
    NeoBundle 'mileszs/ack.vim'
endif
"}

" Install bundles"{
" ---------------------------------------

" .vimrc.before.local config"{

" In your .vimrc.before.local file
" list only the plugin groups you will use
if !exists('g:billinux_bundle_groups')
    let g:billinux_bundle_groups=['general', 'writing', 'neocomplcache', 'programming', 'php', 'sql', 'ruby', 'python', 'javascript', 'html', 'twig', 'css', 'colors', 'misc',]
endif

" To override all the included bundles, add the following to your
" .vimrc.bundles.local file:
"   let g:override_billinux_bundles = 1

" Disable extra bundles installation
"let g:billinux_no_extra_bundles = 1
"}

" Bundle groups"{
" ---------------------------------------

" To prevent installation of extra bundles
let g:billinux_no_extra_bundles = 1

if !exists("g:override_billinux_bundles")

    " CATEGORY: General"{
" ---------------------------------------

    if count(g:billinux_bundle_groups, 'general')
        NeoBundle 'scrooloose/nerdtree'
        NeoBundle 'kien/ctrlp.vim'
        NeoBundle 'tacahiroy/ctrlp-funky'
        NeoBundle 'shougo/unite.vim'
        NeoBundle 'tpope/vim-surround'
        NeoBundle 'godlygeek/csapprox'
        NeoBundle 'shougo/vimshell.vim'
        NeoBundle 'bling/vim-airline'
        " You have to install pre-patched powerline fonts on your system
        " before installing vim-airline
        " https://www.youtube.com/watch?v=zE3STsWTCcA
        " NeoBundle 'lokaltog/powerline-fonts'
        NeoBundle 'bling/vim-bufferline'
        NeoBundle 'matchit.zip'
        NeoBundle 'mbbill/undotree'
        NeoBundle 'Lokaltog/vim-easymotion'
        NeoBundle 'mhinz/vim-signify'
        NeoBundle 'spf13/vim-autoclose'
        NeoBundle 'tpope/vim-abolish.git'

        if !exists('g:billinux_no_extra_bundles')
            NeoBundle 'tpope/vim-repeat'
            NeoBundle 'vim-scripts/figlet.vim'
            NeoBundle 'terryma/vim-multiple-cursors'
            NeoBundle 'vim-scripts/restore_view.vim'
            NeoBundle 'vim-scripts/sessionman.vim'
            NeoBundle 'jistr/vim-nerdtree-tabs'
            NeoBundle 'nathanaelkane/vim-indent-guides'
            NeoBundle 'osyo-manga/vim-over'
            NeoBundle 'kana/vim-textobj-user'
            NeoBundle 'kana/vim-textobj-indent'
            NeoBundle 'gcmt/wildfire.vim'
        endif

    endif
"}

    " CATEGORY: Writing"{
" ---------------------------------------

    if count(g:billinux_bundle_groups, 'writing')
        NeoBundle 'reedes/vim-litecorrect'
        NeoBundle 'reedes/vim-textobj-sentence'
        NeoBundle 'reedes/vim-textobj-quote'
        NeoBundle 'reedes/vim-wordy'
        NeoBundle 'DrawIt'
    endif
"}

    " CATEGORY: General programming"{
" ---------------------------------------

    if count(g:billinux_bundle_groups, 'programming')
        NeoBundle 'mattn/emmet-vim'
        NeoBundle 'godlygeek/tabular'
        NeoBundle 'tpope/vim-fugitive'
        if executable('ctags')
            NeoBundle 'majutsushi/tagbar'
        endif

        if !exists('g:billinux_no_extra_bundles')
            NeoBundle 'scrooloose/syntastic'
            NeoBundle 'mattn/webapi-vim'
            NeoBundle 'mattn/gist-vim'
            NeoBundle 'scrooloose/nerdcommenter'
        endif
    endif
"}

    " CATEGORY: Snippets & AutoComplete"{
" ---------------------------------------

    if count(g:billinux_bundle_groups, 'snipmate')
        NeoBundle 'garbas/vim-snipmate'
        NeoBundle 'honza/vim-snippets'
        " Source support_function.vim to support vim-snippets.
        if filereadable(expand("~/.vim/bundle/vim-snippets/snippets/support_functions.vim"))
            source ~/.vim/bundle/vim-snippets/snippets/support_functions.vim
        endif
    elseif count(g:billinux_bundle_groups, 'youcompleteme')
        NeoBundle 'Valloric/YouCompleteMe'
        NeoBundle 'SirVer/ultisnips'
        NeoBundle 'honza/vim-snippets'
    elseif count(g:billinux_bundle_groups, 'neocomplcache')
        NeoBundle 'Shougo/neocomplcache'
        NeoBundle 'Shougo/neosnippet'
        NeoBundle 'Shougo/neosnippet-snippets'
        NeoBundle 'honza/vim-snippets'
    elseif count(g:billinux_bundle_groups, 'neocomplete')
        NeoBundle 'Shougo/neocomplete.vim.git'
        NeoBundle 'Shougo/neosnippet'
        NeoBundle 'Shougo/neosnippet-snippets'
        NeoBundle 'honza/vim-snippets'
    elseif count(g:billinux_bundle_groups, 'clangcomplete')
        NeoBundle 'Rip-Rip/clang_complete'
    endif
"}

    " CATEGORY: PHP"{
" ---------------------------------------

    if count(g:billinux_bundle_groups, 'php')
        NeoBundle 'spf13/PIV'

        if !exists('g:billinux_no_extra_bundles')
            NeoBundle 'arnaud-lb/vim-php-namespace'
        endif
    endif
"}

" CATEGORY: SQL"{
" -------------------------------------
if count(g:billinux_bundle_groups, 'sql')
    if !exists('g:billinux_no_extra_bundles')
        NeoBundle 'vim-scripts/dbext.vim'
    endif
endif
"}

    " CATEGORY: Python"{
" ---------------------------------------

    if count(g:billinux_bundle_groups, 'python')
        if executable('python')
            NeoBundle 'python.vim'
            NeoBundle 'pythoncomplete'
        endif
    endif
"}

    " CATEGORY: Javascript"{
" ---------------------------------------

    if count(g:billinux_bundle_groups, 'javascript')
        NeoBundle 'pangloss/vim-javascript'
        NeoBundle 'kchmck/vim-coffee-script'
        NeoBundle 'elzr/vim-json'
        NeoBundle 'briancollins/vim-jst'
    endif
"}

    " CATEGORY: HTML"{
" ---------------------------------------

    if count(g:billinux_bundle_groups, 'html')
        NeoBundle 'digitaltoad/vim-jade'
        NeoBundle 'amirh/HTML-AutoCloseTag'

        if !exists('g:billinux_no_extra_bundles')
            NeoBundle 'tpope/vim-haml'
            NeoBundle 'gorodinskiy/vim-coloresque'
        endif
    endif
"}

    " CATEGORY: Twig template"{
" ---------------------------------------

    if count(g:billinux_bundle_groups, 'twig')
        NeoBundle 'beyondwords/vim-twig'
    endif
"}

    " CATEGORY: CSS"{
" ---------------------------------------

    if count(g:billinux_bundle_groups, 'css')
        NeoBundle 'lilydjwg/colorizer'
        NeoBundle 'hail2u/vim-css3-syntax'
        NeoBundle 'wavded/vim-stylus'
    endif
"}

    " CATEGORY: Ruby"{
" ---------------------------------------

    if count(g:billinux_bundle_groups, 'ruby')
        if executable('ruby')
            NeoBundle 'tpope/vim-rails'
            let g:rubycomplete_buffer_loading = 1
            "let g:rubycomplete_classes_in_global = 1
            "let g:rubycomplete_rails = 1
        endif
    endif
"}

    " CATEGORY: Colorschemes"{
" ---------------------------------------

    if count(g:billinux_bundle_groups, 'colors')
        NeoBundle 'altercation/vim-colors-solarized'
        NeoBundle 'tomasr/molokai'
        NeoBundle 'reedes/vim-thematic'

        if !exists('g:billinux_no_extra_bundles')
            NeoBundle 'flazz/vim-colorschemes'
        endif
    endif
"}

    " CATEGORY: Misc"{
" ---------------------------------------

    if count(g:billinux_bundle_groups, 'misc')
        NeoBundle 'tpope/vim-markdown'
        NeoBundle "chrisbra/csv.vim"
    endif
"}

endif

"}

" :Neobundleinstall"{
" ----------------

if iCanHazNeoBundle == 0
    echo "Installing Bundles, please ignore key map error messages"
    echo ""
    :NeoBundleInstall
endif
"}
"}
"}

filetype plugin indent on
:NeoBundleCheck
"}

" SECTION: Autocommands"{
" =====================================

" Vimrc"{
" ---------------------------------------

augroup vimrc
    autocmd!
augroup END

"augroup VIMRC
"    au!
"    autocmd BufWritePost  ~/.vimrc source ~/.vimrc
"augroup END
"}

" Text"{
" ---------------------------------------

augroup Text
    au!
    " Automatically save session on exit.
    au VimLeave * call SaveSession()
    " Navigate line by line through wrapped text (skip wrapped lines).
    au BufReadPre * imap <UP> <ESC>gka
    au BufReadPre * imap <DOWN> <ESC>gja
    " Navigate row by row through wrapped text.
    au BufReadPre * nmap k gk
    au BufReadPre * nmap j gj
    " Correct filetype detection for *.md files.
    au BufRead,BufNewFile *.md set filetype=markdown
augroup END
"}

" Programming"{
" ---------------------------------------

augroup Programming
    au BufRead,BufNewFile *.html set shiftwidth=2
    au BufRead,BufNewFile *.html set softtabstop=2
    au BufRead,BufNewFile *.html set tabstop=2
    au FileType c,cpp,java,go,php,javascript,python,twig,xml,yml,perl autocmd BufWritePre <buffer> if !exists('g:billinux_keep_trailing_whitespace') | call StripTrailingWhitespace() | endif
    au BufRead * normal zR
    au BufRead *.vimrc normal zM
augroup END
"}

" Number"{
" ---------------------------------------

augroup Number
    au!
    autocmd FocusLost * :set number
    autocmd InsertEnter * :set number
    autocmd InsertLeave * :set relativenumber
    autocmd CursorMoved * :set relativenumber
augroup END
"}

" Autoview"{
" ---------------------------------------

augroup Autoview
    au!
    " Autosave & Load Views (?* or *).
    autocmd BufWritePost,WinLeave,BufWinLeave * if MakeViewCheck() | mkview | endif
    autocmd BufWinEnter * if MakeViewCheck() | silent! loadview | endif
augroup END
"}

" Misc"{
" ---------------------------------------

augroup Misc
    " Save when losing focus
    au FocusLost * :wa
    au BufWritePost * call ModeChange()
augroup END
"}
"}

" SECTION: Functions"{
" =====================================

function! NeatFoldText()"{
  let line = ' ' . substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*' . '\d*\s*', '', 'g') . ' '
  let lines_count = v:foldend - v:foldstart + 1
  let lines_count_text = '| ' . printf("%10s", lines_count . ' lines') . ' |'
  let foldchar = matchstr(&fillchars, 'fold:\zs.')
  let foldtextstart = strpart('+' . repeat(foldchar, v:foldlevel*2) . line, 0, (winwidth(0)*2)/3)
  let foldtextend = lines_count_text . repeat(foldchar, 8)
  let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
  return foldtextstart . repeat(foldchar, winwidth(0)-foldtextlength) . foldtextend
endfunction
"set foldtext=NeatFoldText()
"}

function! LoadSession()"{
    " Load last vim session
    if argc() == 0
        execute 'source $VIMHOME/session.vim'
    endif
endfunction
"}

function! SaveSession()"{
    " Save current vim session.
    execute 'mksession! $VIMHOME/session.vim'
endfunction
"}

function! NumberToggle()"{
    if(&relativenumber == 1)
        set norelativenumber
        set number
    else
        set number
        set relativenumber
endif
endfunc
"}

function! StripTrailingWhitespace()"{
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " do the business:
    %s/\s\+$//e
    " clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
"}

function! MakeViewCheck()"{
    if has('quickfix') && &buftype =~ 'nofile' | return 0 | endif
    if expand('%') =~ '\[.*\]' | return 0 | endif
    if empty(glob(expand('%:p'))) | return 0 | endif
    if &modifiable == 0 | return 0 | endif
    if len($TEMP) && expand('%:p:h') == $TEMP | return 0 | endif
    if len($TMP) && expand('%:p:h') == $TMP | return 0 | endif

    let file_name = expand('%:p')
    for ifiles in g:skipview_files
        if file_name =~ ifiles
            return 0
        endif
    endfor

    return 1
endfunction
"}

function ModeChange()"{
"Donne les droits d'exécution si le fichier commence par #!
    if getline(1) =~ "#!"
        silent !chmod a+x <afile>
    endif
endfunction
"}

" function! pastetoggle()"{
function! WrapForTmux(s)
    if !exists('$TMUX')
    return a:s
    endif

    let tmux_start = "\<Esc>Ptmux;"
    let tmux_end = "\<Esc>\\"

    return tmux_start . substitute(a:s, "\<Esc>", "\<Esc>\<Esc>", 'g') . tmux_end
endfunction

let &t_SI .= WrapForTmux("\<Esc>[?2004h")
let &t_EI .= WrapForTmux("\<Esc>[?2004l")

function! XTermPasteBegin()
    set pastetoggle=<Esc>[201~
    set paste
    return ""
endfunction

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()
"}
"}

" SECTION: Encoding"{
" =====================================

set encoding=utf-8
set fileformats=unix,dos,mac

if s:is_running_win
    if has('multi_byte')
        set termencoding=cp850
        setglobal fileencoding=utf-8
        set fileencodings=ucs-bom,utf-8,utf-16le,cp1252,iso-8859-15
    endif
    set fileformat=dos
else
    set termencoding=utf-8
    set fileencoding=utf-8
    scriptencoding utf-8
    set fileformat=unix
endif
"}

" SECTION: Syntax"{
" =====================================

syntax on

" ft-java-syntax
let g:java_highlight_functions = 'style'
let g:java_highlight_all = 1
let g:java_allow_cpp_keywords = 1

" ft-php-syntax
let g:php_folding = 1

" ft-python-syntax
let g:python_highlight_all = 1

" ft-xml-syntax
let g:xml_syntax_folding = 1

" ft-vim-syntax
let g:vimsyntax_noerror = 1

" ft-sh-syntax
let g:is_bash = 1

" ft-ruby-syntax
let ruby_operators = 1
"}

" SECTION: Options"{
" =====================================

" Gui setting"{
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

if s:is_running_gui
    set antialias
    set lines=60
    set columns=120

    " GVim options to make it like Vim
    set guioptions+=c
    set guioptions+=R
    set guioptions-=m
    set guioptions-=r
    set guioptions-=b
    set guioptions-=T
    set guioptions-=R
    set guioptions-=L
    set guioptions-=e

    " Font to run vim-airline (cf.: vim-airline config.
    if s:is_running_linux || s:is_running_cygwin
        set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h11
        "set guifont=Powerline\ Consolas\ 10
    elseif s:is_running_macunix
        set guifont=Powerline\ Consolas\ 10
        "set guifont=Menlo\ Regular\ for\ Powerline:h15
        "set guifont=Droid\ Sans\ Mono\ for \Powerline:h14
        "set guifont=Meslo\ LG\ for\ Powerline:h11
    elseif s:is_running_win
        set guifont=Powerline_Consolas:h10:cANSI
    endif

elseif s:is_using_term_dterm
    set tsl=0

elseif s:is_using_term_rxvt
    " t_SI start insert mode (bar cursor shape)
    " t_EI end insert mode (block cursor shape)
    let &t_SI = "\033]12;red\007"
    let &t_EI = "\033]12;green\007"

    :silent !echo -ne "\033]12;green\007"
    autocmd VimLeave * :silent :!echo -ne "\033]12;green\007"

elseif s:is_using_term_screen
    let &t_SI = "\033P\033]12;red\007\033\\"
    let &t_EI = "\033P\033]12;green\007\033\\"

    :silent !echo -ne "\033P\033]12;green\007\033\\"
    autocmd VimLeave * :silent :!echo -ne "\033P\033]12;green\007\033\\"

elseif isdirectory(expand($VIMBUNDLE . "/csapprox"))
    " To avoid CSApprox workarounds in console
    " disable CSApprox
    let g:CSApprox_loaded=1
else
    set t_Co=256
endif

set ttyfast
"}

" Appearance"{
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

set background=dark
set number
set numberwidth=3
set ruler
set fillchars+=stl:\ ,stlnc:\
set laststatus=2
set noshowmode

set cursorline
autocmd WinLeave * setlocal nocursorline
autocmd WinEnter * setlocal cursorline
"}

" Behavior"{
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

set backspace=indent,eol,start
set viewdir=$VIMHOME/.cache/view
set backupdir=$VIMHOME/.cache/backup
set hidden
set splitright
set splitbelow
set tabpagemax=15
set history=1024
set nowrap
set textwidth=0
set whichwrap=b,s,h,l,<,>,[,]
set title
set virtualedit=onemore
"set mouse=a

set wildmenu
set wildmode=list:longest,full
set suffixes=.o,.h,.bak,.info,.log,~,.out
set wildignorecase
if s:is_running_win
    set wildignore+=*\\..git\\.*,*\\..hg\\.*,*\\..svn\\.*,*\\.bin\\.*,*\pkg\\.*,*\\..bak\\.*,*\\..swp\\.*,*\\..class\\.*,*\\.tags\\.*,*\\..o\\.*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/bin/*,*/pkg/*,*/.bak/*,*/.swp/*,*/.class/*,*/tags/*,*/.o/*
endif

set foldenable
set foldmarker={,}
set foldmethod=marker
set foldlevelstart=0
set foldopen=block,hor,mark,percent,quickfix,tag,search

" VERY useful to restore view
set viewoptions=folds,options,cursor,unix,slash
" To preserve views of the files (includes folds)
if exists("g:loaded_restore_view")
    finish
endif
let g:loaded_restore_view = 1


if !exists("g:skipview_files")
    let g:skipview_files = []
endif

set noswapfile

if !isdirectory($VIMHOME . "/.cache/view")
    call mkdir($VIMHOME . "/.cache/view", "p")
endif
if !isdirectory($VIMHOME . "/.cache/backup")
    call mkdir($VIMHOME . "/.cache/backup", "p")
endif

if has('persistent_undo')
    if !isdirectory($VIMHOME . "/.cache/undo")
        call mkdir($VIMHOME . "/.cache/undo", "p")
    endif
    set undodir=$VIMHOME/.cache/undo
    set undofile
    set undolevels=2048
    set undoreload=10000
endif

set list
set listchars=nbsp:%
set listchars+=tab:>-
set listchars+=trail:~
set listchars+=extends:>
set listchars+=precedes:<
set listchars+=eol:$

set showbreak=-

if has('balloon_eval') && has('unix')
    set ballooneval
endif
"}

" Search"{
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

set hlsearch
set incsearch
set ignorecase
set smartcase

set magic
set showmatch
set matchtime=2
"}

" Errors"{
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

set noerrorbells
set novisualbell
set timeoutlen=500
"set t_vb
"}

" Indent"{
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

set expandtab
set shiftwidth=4
set tabstop=4
set softtabstop=4
set smarttab
"}
"}

" SECTION: Mappings"{
" =====================================

" Leader"{
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

let mapleader=","
let g:mapleader=","
let g:maplocalleader=";"

nnoremap , <Nop>
xnoremap , <Nop>
nnoremap ; <Nop>
xnoremap ; <Nop>
"}

" Mapmode-Fn"{
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

" Map <F11> to / (search) and Ctrl-<F11> to ? (backwards search)
map <F11> /
map <C-F11> ?

" Paste toggles
set pastetoggle=<F12>
"au InsertLeave * set nopaste
"}

" Mapmode-n"{
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

" Unmap arrow keys
noremap <Up> <c-W>k
noremap <Down> <c-W>j
noremap <Left> :bprev <CR>
noremap <Right> :bnext<CR>

" Home row jump to start and end of line
noremap H ^
noremap L $

" Treat long lines as break lines (useful when moving around in them)
nnoremap <silent> k :<C-U>execute 'normal!' (v:count>1 ? "m'".v:count.'k' : 'gk')<Enter>
nnoremap <silent> j :<C-U>execute 'normal!' (v:count>1 ? "m'".v:count.'j' : 'gj')<Enter>

"nnoremap q :q!<cr>
nnoremap <leader>q :qa!<cr>

" To clear search highlighting rather than toggle it and off
noremap <silent> <leader><space> :nohlsearch<CR>

" Resource configuration editing.
nmap <silent> <leader>v :vsplit $MYVIMRC<CR>
nmap <silent> <leader>s :source $MYVIMRC<CR>

" Switch different kind line number
nnoremap <leader>; :call NumberToggle()<cr>

" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>mm mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

nnoremap > >>
nnoremap < <<

nnoremap n nzz
nnoremap N Nzz

"noremap / /\v
"noremap / /\v
"}

" Mapmode-i"{
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

" Keep hands on the keyboard
inoremap jj <ESC>
inoremap kk <ESC>
inoremap jk <ESC>
inoremap kj <ESC>
"}

" Mapmode-v"{
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

" Indent multiple lines with TAB
vmap <Tab> >
vmap <S-Tab> <
" Keep visual selection after identing
vnoremap < <gv
vnoremap > >gv
"}

" Mapmode-nv"{
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

" Yank to Clipboard 
nnoremap <C-y> "+y
vnoremap <C-y> "+y

nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf

" Close all folds except the one(1) the cursor is on, and center.
nnoremap z1 zMzvzz

" Make zO (not zero) recursively open whatever top level fold we're in, no
" matter where the cursor happens to be, and center.
nnoremap zO zCzOzz

"}

" Mapmode-nvo"{
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

" Window navigation
"map <C-j> <C-W>j
"map <C-k> <C-W>k
"map <C-h> <C-W>h
"map <C-l> <C-W>l

map <C-J> <C-W>j<C-W>_
map <C-k> <C-W>k<C-W>_
map <C-h> <C-W>h<C-W>_
map <C-l> <C-W>l<C-W>_

" Adjust viewports to the same size
map <Leader>= <C-w>=
"}

" Mapmode-c"{
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

" write to a file using sudo
cmap w!! %!sudo tee > /dev/null %

" Change Working Directory to that of the current file
cmap cwd lcd %:p:h
cmap cd. lcd %:p:h

"}

" Mapmode-o"{
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
"}

"}

" SECTION: Macros"{
" =====================================

let @a = 'i" =====================================O" SECTION: 5j'
let @b = 'i" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=O" CATEGORY: 5j'
let @c = 'i" -------------------------------------O" PLUGIN: 5j'
let @d = 'i" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=O" 5j'
let @e = 'i" -------------------------------------O" 5j'

"}

" SECTION: Plugins"{
"
" =====================================

" CATEGORY: General"{
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

" PLUGIN: NERDTree"{
" -------------------------------------

if isdirectory(expand($VIMBUNDLE . "/nerdtree"))
    let g:NERDShutUp=1
    let NERDTreeIgnore=['\~$', '\.swp$', '\.git']
    imap <leader>t :set columns=999<CR>:NERDTreeToggle<cr>
    nmap <leader>t :set columns=999<CR>:NERDTreeToggle<cr>
    imap <leader>T :set columns=999<CR>:NERDTreeFind<cr>
    nmap <leader>T :set columns=999<CR>:NERDTreeFind<cr>

    let NERDTreeShowBookmarks=1
    let NERDTreeIgnore=['\.pyc', '\~$', '\.swp$', '\.git', '\.hg', '\.svn']
    let NERDTreeChDirMode=0
    let NERDTreeQuitOnOpen=1
    let NERDTreeMouseMode=2
    let NERDTreeShowHidden=1
    let NERDTreeKeepTreeInNewTab=1
    let g:nerdtree_tabs_open_on_gui_startup=0
endif
"}

" PLUGIN: CtrLP"{
" -------------------------------------

if isdirectory(expand($VIMBUNDLE . "/ctrlp"))
    nnoremap <silent> <leader>t :CtrlP<CR>
    nnoremap <silent> <leader>r :CtrlPMRU<CR>

    let g:ctrlp_map = '<c-p>'
    let g:ctrlp_cmd = 'CtrlP'

    " search for nearest ancestor like .git, .hg, and the directory of the current file
    let g:ctrlp_working_path_mode = 'ra'

    let g:ctrlp_custom_ignore = {
        \ 'dir':  '\.git$\|\.hg$\|\.svn$',
        \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$' }

    " Show the match window at the top of the screen
    let g:ctrlp_match_window_bottom = 1

    " Maxiumum height of match window
    let g:ctrlp_max_height = 8

    " Jump to a file if it's open already
    let g:ctrlp_switch_buffer = 'et'

    " Enable caching
    let g:ctrlp_use_caching = 1

    " Speed up by not removing clearing cache evertime
    let g:ctrlp_clear_cache_on_exit=0

    " Show me dotfiles
    let g:ctrlp_show_hidden = 1

    " Number of recently opened files
    let g:ctrlp_mruf_max = 250

    " On Windows use 'dir' as fallback command.
    if s:is_running_win
        let s:ctrlp_fallback = 'dir %s /-n /b /s /a-d'
    elseif executable('ag')
        let s:ctrlp_fallback = 'ag %s --nocolor -l -g ""'
    elseif executable('ack-grep')
        let s:ctrlp_fallback = 'ack-grep %s --nocolor -f'
    elseif executable('ack')
        let s:ctrlp_fallback = 'ack %s --nocolor -f'
    else
        let s:ctrlp_fallback = 'find %s -type f'
    endif

    let g:ctrlp_user_command = {
        \ 'types': {
            \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
            \ 2: ['.hg', 'hg --cwd %s locate -I .'],
        \ },
        \ 'fallback': s:ctrlp_fallback
    \ }

    if isdirectory(expand($VIMBUNDLE . "/ctrlp-funky"))
        " CtrlP extensions
        let g:ctrlp_extensions = ['funky']

        "funky
        nnoremap <Leader>fu :CtrlPFunky<Cr>
    endif

endif
"}

" APPLICATION: ag: the silver searcher"{
" -------------------------------------"
if executable('ag')
    " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

    " ag is fast enough that CtrlP doesn't need to cache
    let g:ctrlp_use_caching = 0
    let g:ackprg = 'ag --smart-case --nogroup --nocolor --column'
    set grepprg=ag\ --nogroup\ --nocolor
endif
"}

" PLUGIN: Unite"{
" -------------------------------------

if isdirectory(expand($VIMBUNDLE . "/unite.vim"))
    " Recently edited files can be searched with <Leader>m
    nnoremap <silent> <Leader>m :Unite -buffer-name=recent -winheight=10 file_mru<cr>

    " Open buffers can be navigated with <Leader>b
    nnoremap <Leader>b :Unite -buffer-name=buffers -winheight=10 buffer<cr>

    " My application can be searched with <Leader>f
    nnoremap <Leader>f :Unite grep:.<cr>

    " CtrlP search
    call unite#filters#matcher_default#use(['matcher_fuzzy'])
    call unite#filters#sorter_default#use(['sorter_rank'])
    call unite#custom#source('file_rec/async','sorters','sorter_rank')
    " replacing unite with ctrl-p
    nnoremap <silent> <C-s-p> :Unite -start-insert -buffer-name=files -winheight=10 file_rec/async<cr>

endif
"}

" PLUGIN: Surround"{
" -------------------------------------

if isdirectory(expand($VIMBUNDLE . "/vim-surround"))
endif
"}

" PLUGIN: CSApprox"{
" -------------------------------------

if isdirectory(expand($VIMBUNDLE . "/csapprox"))

endif
"}

" PLUGIN: Vimshell"{
" -------------------------------------

if isdirectory(expand($VIMBUNDLE . "/vimshell.vim"))
    let g:vimshell_prompt = '$ '
    let g:vimshell_user_prompt = '"[" . getcwd() ."]"'
endif
"}

" PLUGIN: Vimproc"{
" -------------------------------------
"
" IF YOU DON'T USE NEOBUNDLE: YOU MUST REMEMBER TO COMPILE AFTER CLONING !!!
" Linux(make), OSX(make or make ARCHS='i386 x86_64')
" Cygwin(make -f make_cygwin.mak)
" Windows using MinGW(64bit Vim) (mingw32-make -f make_mingw64.mak)
" Precomiled version for Vimproc in Windows :
" http://www.kaoriya.net/software/vim/
if isdirectory(expand($VIMBUNDLE . "/vimproc.vim"))
endif
"}

" PLUGIN: Airline"{
" -------------------------------------

" http://www.4thinker.com/vim-airline.html

" Procedure for installing vim-airline :
" 1. Install powerline fonts and symbols :
"   cd ~/.fonts
"   git clone https://github.com/Lokaltog/powerline-fonts
"   git clone https://github.com/runsisi/consolas-font-for-powerline
"   wget https://github.com/Lokaltog/powerline/raw/develop/font/PowerlineSymbols.otf
"   wget https://github.com/Lokaltog/powerline/raw/develop/font/10-powerline-symbols.conf
"   Merge the contents of 10-powerline-symbols.conf to ~/.fonts.conf
"   fc-cache -vf ~/.fonts 

" 2. To view symbols ans specials characters in terminal :
"   gnome-terminal: change the default text font
"   rxvt-unicode:   change font in .Xresources or .Xdefaults file and
"                   run : urxvt -fn 'xft:DejaVu Sans Mono for Powerline-11'
"                   for testing

if isdirectory(expand($VIMBUNDLE . "/vim-airline"))
    let g:airline#extensions#tabline#enabled = 1
    "let g:airline_theme             = 'powerlineish'
    let g:airline_theme             = 'badwolf'
    let g:airline_fugitive_prefix = '⎇'
    let g:airline_paste_symbol = 'ρ'
    " let g:airline_section_x = ''
    " let g:airline_section_y = "%{strlen(&ft)?&ft:'none'}"

    " Cygwin terminal
    if has ('win32unix') && !has('gui_running')
        let g:airline_powerline_fonts = 1
    endif

endif
"}

" PLUGIN: Matchit"{
" -------------------------------------

if isdirectory(expand($VIMBUNDLE . "/matchit.zip"))
    " Load matchit.vim, but only if the user hasn't installed a newer version.
    if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
        runtime! macros/matchit.vim
    endif
    let b:match_ignorecase = 1
endif
"}

" PLUGIN: Undotree"{
" -------------------------------------

if isdirectory(expand($VIMBUNDLE . "/undotree"))
    nnoremap <Leader>u :UndotreeToggle<CR>
    " If undotree is opened, it is likely one wants to interact with it.
    let g:undotree_SetFocusWhenToggle=1
endif
"}

" PLUGIN: Tagbar"{
" -------------------------------------

if isdirectory(expand($VIMBUNDLE . "/tagbar"))
    nnoremap <silent> <leader>tt :TagbarToggle<CR>

    " If using go please install the gotags program using the following
    " go install github.com/jstemmer/gotags
    " And make sure gotags is in your path

    let g:tagbar_type_go = {
        \ 'ctagstype' : 'go',
        \ 'kinds'     : [  'p:package', 'i:imports:1', 'c:constants', 'v:variables',
            \ 't:types',  'n:interfaces', 'w:fields', 'e:embedded', 'm:methods',
            \ 'r:constructor', 'f:functions' ],
        \ 'sro' : '.',
        \ 'kind2scope' : { 't' : 'ctype', 'n' : 'ntype' },
        \ 'scope2kind' : { 'ctype' : 't', 'ntype' : 'n' },
        \ 'ctagsbin'  : 'gotags',
        \ 'ctagsargs' : '-sort -silent'
        \ }
endif
"}

" PLUGIN: Sessionman"{
" -------------------------------------

set sessionoptions=blank,buffers,curdir,folds,tabpages,winsize

if isdirectory(expand($VIMBUNDLE . "/sessionman.vim"))
    nmap <leader>sl :SessionList<CR>
    nmap <leader>ss :SessionSave<CR>
    nmap <leader>sc :SessionClose<CR>
endif
"}

" PLUGIN: Indent-guides"{
" -------------------------------------

if isdirectory(expand($VIMBUNDLE . "/vim-indent-guides"))
    let g:indent_guides_start_level = 2
    let g:indent_guides_guide_size = 1
    let g:indent_guides_enable_on_vim_startup = 1
endif
"}

" PLUGIN: Signify"{
" -------------------------------------

" Try ]c and [c to jump between hunks
if isdirectory(expand($VIMBUNDLE . "/vim-signify"))
    let g:signify_sign_change='~'
    let g:signify_sign_delete='-'
    let g:signify_sign_overwrite=0    " prevent dumping gutter
    let g:signify_update_on_focusgained=1    " dumps gutter if overwrite=1
    let g:signify_sign_color_inherit_from_linenr=1
endif
"}

" PLUGIN: AutoClose"{
" -------------------------------------"

" Comment will not be paired
if isdirectory(expand($VIMBUNDLE . "/vim-autoclose"))
    let g:autoclose_vim_commentmode = 1
endif
"}

" PLUGIN: Abolish"{
" -------------------------------------"

if isdirectory(expand($VIMBUNDLE . "/vim-abolish"))
endif
"}
"}

" CATEGORY: Writing"{
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=


"}

" CATEGORY: Completion"{
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

" PLUGIN: Clang complete (C/C++ autocompletion)"{
" -------------------------------------

if has('unix')
    let g:clang_use_library=1
    let g:clang_hl_errors=1
    let g:clang_complete_copen=1
    let g:clang_periodic_quickfix=0
    autocmd Filetype c,cpp,cxx,h,hxx autocmd BufWritePre <buffer> :call g:ClangUpdateQuickFix()
endif
"}

" PLUGIN: Omnicomplete"{
" -------------------------------------

" To disable omni complete, add the following to your .vimrc.before.local file:
"   let g:billinux_no_omni_complete = 1
if !exists('g:billinux_no_omni_complete')
    if has("autocmd") && exists("+omnifunc")
        autocmd Filetype *
            \if &omnifunc == "" |
            \setlocal omnifunc=syntaxcomplete#Complete |
            \endif
    endif

    hi Pmenu  guifg=#000000 guibg=#F8F8F8 ctermfg=black ctermbg=Lightgray
    hi PmenuSbar  guifg=#8A95A7 guibg=#F8F8F8 gui=NONE ctermfg=darkcyan ctermbg=lightgray cterm=NONE
    hi PmenuThumb  guifg=#F8F8F8 guibg=#8A95A7 gui=NONE ctermfg=lightgray ctermbg=darkcyan cterm=NONE

    " Some convenient mappings
    inoremap <expr> <Esc>      pumvisible() ? "\<C-e>" : "\<Esc>"
    inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"
    inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
    inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
    inoremap <expr> <C-d>      pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
    inoremap <expr> <C-u>      pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<C-u>"

    " Automatically open and close the popup menu / preview window
    au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
    set completeopt=menu,preview,longest
endif
"}

" PLUGIN: YouCompleteMe"{
" -------------------------------------

if count(g:billinux_bundle_groups, 'youcompleteme')
    let g:acp_enableAtStartup = 0

    " enable completion from tags
    let g:ycm_collect_identifiers_from_tags_files = 1

    " remap Ultisnips for compatibility for YCM
    let g:UltiSnipsExpandTrigger = '<C-j>'
    let g:UltiSnipsJumpForwardTrigger = '<C-j>'
    let g:UltiSnipsJumpBackwardTrigger = '<C-k>'

    " Enable omni completion.
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
    autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
    autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

    " Haskell post write lint and check with ghcmod
    " $ `cabal install ghcmod` if missing and ensure
    " ~/.cabal/bin is in your $PATH.
    if !executable("ghcmod")
        autocmd BufWritePost *.hs GhcModCheckAndLintAsync
    endif

    " For snippet_complete marker.
    if !exists("g:billinux_no_conceal")
        if has('conceal')
            set conceallevel=2 concealcursor=i
        endif
    endif

    " Disable the neosnippet preview candidate window
    " When enabled, there can be too much visual noise
    " especially when splits are used.
    set completeopt-=preview
endif
"}

" PLUGIN: Neocomplete"{
" -------------------------------------

if count(g:billinux_bundle_groups, 'neocomplete')
    let g:acp_enableAtStartup = 0
    let g:neocomplete#enable_at_startup = 1
    let g:neocomplete#enable_smart_case = 1
    let g:neocomplete#enable_auto_delimiter = 1
    let g:neocomplete#max_list = 15
    let g:neocomplete#force_overwrite_completefunc = 1


    " Define dictionary.
    let g:neocomplete#sources#dictionary#dictionaries = {
                \ 'default' : '',
                \ 'vimshell' : $HOME.'/.vimshell_hist',
                \ 'scheme' : $HOME.'/.gosh_completions'
                \ }

    " Define keyword.
    if !exists('g:neocomplete#keyword_patterns')
        let g:neocomplete#keyword_patterns = {}
    endif
    let g:neocomplete#keyword_patterns['default'] = '\h\w*'

    " Plugin key-mappings
        " These two lines conflict with the default digraph mapping of <C-K>
        if !exists('g:billinux_no_neosnippet_expand')
            imap <C-k> <Plug>(neosnippet_expand_or_jump)
            smap <C-k> <Plug>(neosnippet_expand_or_jump)
        endif
        if exists('g:billinux_noninvasive_completion')
            iunmap <CR>
            " <ESC> takes you out of insert mode
            inoremap <expr> <Esc>   pumvisible() ? "\<C-y>\<Esc>" : "\<Esc>"
            " <CR> accepts first, then sends the <CR>
            inoremap <expr> <CR>    pumvisible() ? "\<C-y>\<CR>" : "\<CR>"
            " <Down> and <Up> cycle like <Tab> and <S-Tab>
            inoremap <expr> <Down>  pumvisible() ? "\<C-n>" : "\<Down>"
            inoremap <expr> <Up>    pumvisible() ? "\<C-p>" : "\<Up>"
            " Jump up and down the list
            inoremap <expr> <C-d>   pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
            inoremap <expr> <C-u>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<C-u>"
        else
            " <C-k> Complete Snippet
            " <C-k> Jump to next snippet point
            imap <silent><expr><C-k> neosnippet#expandable() ?
                        \ "\<Plug>(neosnippet_expand_or_jump)" : (pumvisible() ?
                        \ "\<C-e>" : "\<Plug>(neosnippet_expand_or_jump)")
            smap <TAB> <Right><Plug>(neosnippet_jump_or_expand)

            inoremap <expr><C-g> neocomplete#undo_completion()
            inoremap <expr><C-l> neocomplete#complete_common_string()
            "inoremap <expr><CR> neocomplete#complete_common_string()

            " <CR>: close popup
            " <s-CR>: close popup and save indent.
            inoremap <expr><s-CR> pumvisible() ? neocomplete#smart_close_popup()"\<CR>" : "\<CR>"

            function! CleverCr()
                if pumvisible()
                    if neosnippet#expandable()
                        let exp = "\<Plug>(neosnippet_expand)"
                        return exp . neocomplete#smart_close_popup()
                    else
                        return neocomplete#smart_close_popup()
                    endif
                else
                    return "\<CR>"
                endif
            endfunction

            " <CR> close popup and save indent or expand snippet 
            imap <expr> <CR> CleverCr() 
            " <C-h>, <BS>: close popup and delete backword char.
            inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
            inoremap <expr><C-y> neocomplete#smart_close_popup()
        endif
        " <TAB>: completion.
        inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
        inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<TAB>"

        " Courtesy of Matteo Cavalleri

        function! CleverTab()
            if pumvisible()
                return "\<C-n>"
            endif 
            let substr = strpart(getline('.'), 0, col('.') - 1)
            let substr = matchstr(substr, '[^ \t]*$')
            if strlen(substr) == 0
                " nothing to match on empty string
                return "\<Tab>"
            else
                " existing text matching
                if neosnippet#expandable_or_jumpable()
                    return "\<Plug>(neosnippet_expand_or_jump)"
                else
                    return neocomplete#start_manual_complete()
                endif
            endif
        endfunction

        imap <expr> <Tab> CleverTab()


    " Enable heavy omni completion.
    if !exists('g:neocomplete#sources#omni#input_patterns')
        let g:neocomplete#sources#omni#input_patterns = {}
    endif
    let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
    let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
    let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
    let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
    let g:neocomplete#sources#omni#input_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'
"}

" PLUGIN: Neocomplcache"{
" -------------------------------------

elseif count(g:billinux_bundle_groups, 'neocomplcache')
    let g:acp_enableAtStartup = 0
    let g:neocomplcache_enable_at_startup = 1
    let g:neocomplcache_enable_camel_case_completion = 1
    let g:neocomplcache_enable_smart_case = 1
    let g:neocomplcache_enable_underbar_completion = 1
    let g:neocomplcache_enable_auto_delimiter = 1
    let g:neocomplcache_max_list = 15
    let g:neocomplcache_force_overwrite_completefunc = 1

    " Define dictionary.
    let g:neocomplcache_dictionary_filetype_lists = {
                \ 'default' : '',
                \ 'vimshell' : $HOME.'/.vimshell_hist',
                \ 'scheme' : $HOME.'/.gosh_completions'
                \ }

    " Define keyword.
    if !exists('g:neocomplcache_keyword_patterns')
        let g:neocomplcache_keyword_patterns = {}
    endif
    let g:neocomplcache_keyword_patterns._ = '\h\w*'

    " Plugin key-mappings 
        " These two lines conflict with the default digraph mapping of <C-K>
        imap <C-k> <Plug>(neosnippet_expand_or_jump)
        smap <C-k> <Plug>(neosnippet_expand_or_jump)
        if exists('g:billinux_noninvasive_completion')
            iunmap <CR>
            " <ESC> takes you out of insert mode
            inoremap <expr> <Esc>   pumvisible() ? "\<C-y>\<Esc>" : "\<Esc>"
            " <CR> accepts first, then sends the <CR>
            inoremap <expr> <CR>    pumvisible() ? "\<C-y>\<CR>" : "\<CR>"
            " <Down> and <Up> cycle like <Tab> and <S-Tab>
            inoremap <expr> <Down>  pumvisible() ? "\<C-n>" : "\<Down>"
            inoremap <expr> <Up>    pumvisible() ? "\<C-p>" : "\<Up>"
            " Jump up and down the list
            inoremap <expr> <C-d>   pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
            inoremap <expr> <C-u>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<C-u>"
        else
            imap <silent><expr><C-k> neosnippet#expandable() ?
                        \ "\<Plug>(neosnippet_expand_or_jump)" : (pumvisible() ?
                        \ "\<C-e>" : "\<Plug>(neosnippet_expand_or_jump)")
            smap <TAB> <Right><Plug>(neosnippet_jump_or_expand)

            inoremap <expr><C-g> neocomplcache#undo_completion()
            inoremap <expr><C-l> neocomplcache#complete_common_string()
            "inoremap <expr><CR> neocomplcache#complete_common_string()

            function! CleverCr()
                if pumvisible()
                    if neosnippet#expandable()
                        let exp = "\<Plug>(neosnippet_expand)"
                        return exp . neocomplcache#close_popup()
                    else
                        return neocomplcache#close_popup()
                    endif
                else
                    return "\<CR>"
                endif
            endfunction

            " <CR> close popup and save indent or expand snippet 
            imap <expr> <CR> CleverCr()

            " <CR>: close popup
            " <s-CR>: close popup and save indent.
            inoremap <expr><s-CR> pumvisible() ? neocomplcache#close_popup()"\<CR>" : "\<CR>"
            "inoremap <expr><CR> pumvisible() ? neocomplcache#close_popup() : "\<CR>"

            " <C-h>, <BS>: close popup and delete backword char.
            inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
            inoremap <expr><C-y> neocomplcache#close_popup()
        endif
        " <TAB>: completion.
        inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
        inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<TAB>"


    " Enable omni completion.
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
    autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
    autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

    " Enable heavy omni completion.
    if !exists('g:neocomplcache_omni_patterns')
        let g:neocomplcache_omni_patterns = {}
    endif
    let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
    let g:neocomplcache_omni_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
    let g:neocomplcache_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
    let g:neocomplcache_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
    let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'
    let g:neocomplcache_omni_patterns.go = '\h\w*\.\?'
"}

" BUILTIN: Normal Vim omni-completion"{
" -------------------------------------

" To disable omni complete, add the following to your .vimrc.before.local file:
"   let g:billinux_no_omni_complete = 1
elseif !exists('g:billinux_no_omni_complete')
    " Enable omni-completion.
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
    autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
    autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

endif
"}

" PLUGIN: Snippets"{
" -------------------------------------

if count(g:billinux_bundle_groups, 'neocomplcache') ||
            \ count(g:billinux_bundle_groups, 'neocomplete')

    " Use honza's snippets.
    let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets'

    " Enable neosnippet snipmate compatibility mode
    let g:neosnippet#enable_snipmate_compatibility = 1

    " For snippet_complete marker.
    if !exists("g:billinux_no_conceal")
        if has('conceal')
            set conceallevel=2 concealcursor=i
        endif
    endif

    " Enable neosnippets when using go
    let g:go_snippet_engine = "neosnippet"

    " Disable the neosnippet preview candidate window
    " When enabled, there can be too much visual noise
    " especially when splits are used.
    set completeopt-=preview
endif
"}

"}

" CATEGORY: Programming"{
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

" PLUGIN: Fugitive"{
" -------------------------------------

if isdirectory(expand($VIMBUNDLE . "/vim-fugitive"))
    nnoremap <silent> <leader>gs :Gstatus<CR>
    nnoremap <silent> <leader>gd :Gdiff<CR>
    nnoremap <silent> <leader>gc :Gcommit<CR>
    nnoremap <silent> <leader>gb :Gblame<CR>
    nnoremap <silent> <leader>gl :Glog<CR>
    nnoremap <silent> <leader>gp :Git push<CR>
    nnoremap <silent> <leader>gr :Gread<CR>
    nnoremap <silent> <leader>gw :Gwrite<CR>
    nnoremap <silent> <leader>ge :Gedit<CR>
    " Mnemonic _i_nteractive
    nnoremap <silent> <leader>gi :Git add -p %<CR>
    nnoremap <silent> <leader>gg :SignifyToggle<CR
endif
"}

" PLUGIN: Emmet"{
" -------------------------------------

if isdirectory(expand($VIMBUNDLE . "/emmet-vim"))
endif
"}

" PLUGIN: Tabular"{
" -------------------------------------

if isdirectory(expand($VIMBUNDLE . "/tabular"))
    nmap <Leader>a& :Tabularize /&<CR>
    vmap <Leader>a& :Tabularize /&<CR>
    nmap <Leader>a= :Tabularize /=<CR>
    vmap <Leader>a= :Tabularize /=<CR>
    nmap <Leader>a: :Tabularize /:<CR>
    vmap <Leader>a: :Tabularize /:<CR>
    nmap <Leader>a:: :Tabularize /:\zs<CR>
    vmap <Leader>a:: :Tabularize /:\zs<CR>
    nmap <Leader>a, :Tabularize /,<CR>
    vmap <Leader>a, :Tabularize /,<CR>
    nmap <Leader>a,, :Tabularize /,\zs<CR>
    vmap <Leader>a,, :Tabularize /,\zs<CR>
    nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
    vmap <Leader>a<Bar> :Tabularize /<Bar><CR>
endif
"}

" PLUGIN: Syntastic"{
" -------------------------------------

if isdirectory(expand($VIMBUNDLE . "/syntastic"))
    let g:syntastic_java_javac_config_file_enabled = 1
    let g:syntastic_always_populate_loc_list=1

    let g:syntastic_cpp_compiler = 'clang++'
    let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'

    map <leader>x :Errors<CR>
    map <leader>a :%!astyle --mode=c --style=ansi -s2 <CR><CR>
endif
"}

"}

" CATEGORY: PHP"{
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

" PLUGIN: PIV"{
" -------------------------------------

if isdirectory(expand($VIMBUNDLE . "/PIV"))
    let g:DisableAutoPHPFolding = 0
    let g:PIVAutoClose = 0
endif
"}

"}

" CATEGORY: SQL"{
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

" PLUGIN: Dbext"{
" -------------------------------------

" https://mutelight.org/dbext-the-last-sql-client-youll-ever-need
" Set your connection profil in ~/.vimrc.before.private
" MySQL
" let g:dbext_default_profile_mysql_local = 'type=MYSQL:user=root:passwd=whatever:dbname=mysql'
" " SQLite
" let g:dbext_default_profile_sqlite_for_rails = 'type=SQLITE:dbname=/path/to/my/sqlite.db'
" " Microsoft SQL Server
" let g:dbext_default_profile_microsoft_production = 'type=SQLSRV:user=sa:passwd=whatever:host=localhost'
" Open a sql file, move your cursor anywhere and <leader>sel (sql execute line)
if isdirectory(expand($VIMBUNDLE . "/dbext.vim"))
endif
"}
"}

" CATEGORY: Ruby"{
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

"}

" CATEGORY: Python"{
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

" PLUGIN: PyMode
" -------------------------------------

if !has('python')
    let g:pymode = 0
endif

if isdirectory(expand($VIMBUNDLE . "/python-mode"))
    let g:pymode_lint_checkers = ['pyflakes']
    let g:pymode_trim_whitespaces = 0
    let g:pymode_options = 0
    let g:pymode_rope = 0
endif

"}

" CATEGORY: Javascript"{
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

" PLUGIN: JSON"{
" -------------------------------------

nmap <leader>jt <Esc>:%!python -m json.tool<CR><Esc>:set filetype=json<CR>
let g:vim_json_syntax_conceal = 0
"}

"}

" CATEGORY: HTML"{
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

" PLUGIN: Jade"{
" -------------------------------------

if isdirectory(expand($VIMBUNDLE . "/vim-jade"))
endif
"}

" PLUGIN: Autoclosetag"{
" -------------------------------------

if isdirectory(expand($VIMBUNDLE . "/HTML-AutoCloseTag"))
    " Make it so AutoCloseTag works for xml and xhtml files as well
    au FileType xhtml,xml ru ftplugin/html/autoclosetag.vim
    nmap <Leader>ac <Plug>ToggleAutoCloseMappings
endif
"}

"}

" Twig"{
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=


"}

" CATEGORY: CSS"{
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

" PLUGIN: Css3 syntax"{
" -------------------------------------

if isdirectory(expand($VIMBUNDLE . "/vim-css3-syntax"))
endif
"}

" PLUGIN: Stylus"{
" -------------------------------------

if isdirectory(expand($VIMBUNDLE . "/vim-stylus"))
endif
"}

"}

" CATEGORY: Colors"{
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

" PLUGIN: Thematic"{
" -------------------------------------

" Themes defined

" Disable thematic bundle
let g:override_billinux_thematic_bundle=1
" Enable a colorscheme
"let g:billinux_color_groups=['solarized',]
let g:billinux_color_groups=['molokai',]

if !exists("g:override_billinux_thematic_bundle")
    if isdirectory(expand($VIMBUNDLE . "/vim-thematic"))
        " All themes are defines here
        let g:thematic#themes = {
        \ 'molokai' :   {'colorscheme': 'molokai',
        \                'airline-theme': 'molokai'
        \               },
        \
        \ 'solarized' : {'colorscheme': 'solarized',
        \                'airline-theme': 'solarized'
        \               },
        \ }

        " Default values to be shared by all defined themes
        let g:thematic#defaults = {
        \ 'background': 'dark',
        \ 'laststatus': 2,
        \ }

        " Additional options for GUI
        let g:thematic#themes ={
        \ 'molokai' :   {'typeface': 'Source Code Pro Light',
        \                'font-size': 12
        \               }
        \ }

        " Setting an initial theme
        let g:thematic#theme_name = 'molokai'

        " Themes keymap
        nnoremap <leader>S :Thematic solarized<CR>
        nnoremap <leader>M :Thematic molokai<CR>
    endif

else

" Colorschemes
" -------------------------------------

    " In your .vimrc.before.local file
    " list only the color groups you will use
    if !exists('g:billinux_color_groups')
        let g:billinux_color_groups=['molokai', 'solarized',]
    endif


    " Molokai theme
    " ---------------
    if count(g:billinux_color_groups, 'molokai')
        if isdirectory(expand($VIMBUNDLE . "/molokai"))
            let g:molokai_background = 236
            "let g:molokai_original = 1
            colorscheme molokai
        endif
    endif

    " Solarized theme
    " ---------------
    if count(g:billinux_color_groups, 'solarized')
        if isdirectory(expand($VIMBUNDLE . "/vim-colors-solarized"))
            let g:solarized_termcolors=256
            let g:solarized_termtrans=1
            let g:solarized_contrast="normal"
            let g:solarized_visibility="normal"
            colorscheme solarized
        endif
    endif

endif
"}

"}

" CATEGORY: Misc"{
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

" PLUGIN: Markdown"{
" -------------------------------------

if isdirectory(expand($VIMBUNDLE . "/vim-markdown"))
endif
"}

" PLUGIN: Csv"{
" -------------------------------------"

if isdirectory(expand($VIMBUNDLE . "/csv.vim"))
endif
"}

" PLUGIN: Ctags"{
" -------------------------------------
set tags=./tags;/,~/.vimtags

" Make tags placed in .git/tags file available in all levels of a repository
let gitroot = substitute(system('git rev-parse --show-toplevel'), '[\n\r]', '', 'g')
if gitroot != ''
    let &tags = &tags . ',' . gitroot . '/.git/tags'
endif
"}

"}
"}

" SECTION: Custom"{
" =====================================

" Use local vimrc if available
if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif

" Use local gvimrc if available and gui is running
if has('gui_running')
    if filereadable(expand("~/.gvimrc"))
        source ~/.gvimrc
    endif
endif

" Use local gvimrc if available and gui is running
if has('gui_running')
    if filereadable(expand("~/.gvimrc.local"))
        source ~/.gvimrc.local
    endif
endif
"}

" SECTION: Tips"{
" =====================================

" CTRL-Q : visual block selection

" Variables"{
" -------------------------------------

" To list all environment variables used by VIM
" :echo $<C-D>
"}

" Indent"{
" -------------------------------------

" Vjj>  :To indent a code block
" >%    : Increase indent of a braced or bracketed block (cursor on first brace)
" =%    : Reindent a braced or bracketed block (cursor on first brace)
" %>    : Decrease indent of a braced or bracketed block (cursor on first brace)
" 5>>   : Indent 5 lines
"}

" Macros"{
" -------------------------------------
" http://blog.sanctum.geek.nz/advanced-vim-macros/
" Saving vim macros into .vimrc
" From normal mode: qa
" Enter whatever commands you want
" From normal mode: q
" Open .vimrc
" "ap to insert the macro into your let @a='...' line
" Apply the 'a' macros 10 times: 10@a
" Applies:
" :normal @a
" :% normal @a
" :10,20 normal @a
" :'<,'> normal @a (on the lines in the current visual selection
" :g/vim/ normal @a (on the lines containing 'vim' pattern
" On a function with key mapping
"function! CalculateAge()
"    normal 03wdei^R=2012-^R"^M^[0j 
"endfunction 
" nnoremap <leader>a :call CalculateAge()<CR>
" To show your 'a' macro: "ap
" Modify whatever you want in that macro and : ^"ay$ to insert changes into
" the "a"register

" You can acces into the Vim registers :reg


"}

set secure  " must be written at the last.  see :help 'secure'

