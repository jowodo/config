" Make shift-insert work like in Xterm
if has('gui_running')
  map <S-Insert> <MiddleMouse>
  map! <S-Insert> <MiddleMouse>
endif

""""""""""""""""""""""""""
" personal modifications
 
" syntax highlighting
filetype plugin indent on
syntax on
set linebreak
colorscheme desert


""""""""""""""""""""""""""""""""""""""""""""""""""""
" -----------------------------------------------------------------------------
"  GENERAL SETTINGS FOR EVERYONE
"  ----------------------------------------------------------------------------
filetype plugin indent on
set nocompatible
set autoindent
set nomodeline " disable modeline vulnerability

" text encoding
set encoding=utf8

" use 4 spaces for tabs
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround

set backspace =indent,eol,start
set hidden
set laststatus =2

" Set linenumbers
set number
set relativenumber
<<<<<<< HEAD
"set spell
colorscheme desert
"colorscheme evening 

=======
"set wrap

"set ruler
"set colorcolumn=90

" Highlight searching
set incsearch
set showmatch
set hlsearch
set ignorecase
set smartcase

if has("nvim")
    set inccommand="nosplit"
endif

set autoread " autoread files
set mouse=a " use mouse for scroll or window size

"syntax on
