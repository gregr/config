set nocompatible
set fileformats=unix,dos,mac
syntax on
filetype plugin indent on
autocmd BufRead,BufNewFile *.rkt set filetype=scheme
fun! <SID>PreserveExec(command)
  let _s=@/
  let l = line(".")
  let c = col(".")
  execute a:command
  let @/=_s
  call cursor(l, c)
endfun
fun! <SID>RStripAll()
  call <SID>PreserveExec("%s/\\s\\+$//e")
endfun
autocmd BufWritePre * :call <SID>RStripAll()
set autoread nobackup nowb
set backspace=indent,eol,start
set autoindent smartindent expandtab tabstop=8 softtabstop=2
set shiftround shiftwidth=2
set incsearch ignorecase smartcase hlsearch
set showmatch
set list listchars=tab:>-,trail:-
set laststatus=2
set statusline=\ %F%m%r%h%y\ %n\ %w%=[\ %l/%L:%c\ ]
set wildmenu wildmode=list:longest,full
set scrolloff=10
set hidden
set lazyredraw

let mapleader = ","
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

map <C-m> <C-w>_
map _ <C-w>-
map + <C-w>+
map - <C-w><
map = <C-w>>

noremap ; :
noremap : ;
color desert
