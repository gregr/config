set nocompatible
runtime bundle/pathogen/autoload/pathogen.vim
call pathogen#infect()
call pathogen#helptags()

set fileformats=unix,dos,mac
set backspace=indent,eol,start
set scrolloff=10
set relativenumber
set autoread nobackup nowb hidden lazyredraw
set autoindent smartindent shiftround
set incsearch ignorecase smartcase hlsearch
set showmatch showcmd
set laststatus=2
set statusline=\ %n\ %F%m%r%y%{fugitive#statusline()}\ %w%=[\ %l/%L:%c\ ]
set wildmenu wildmode=list:longest,full
set list listchars=tab:>-,trail:-
set ts=2 sts=2 sw=2 expandtab

syntax on
filetype plugin indent on

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

augroup AutoloadVimrc
  autocmd!
  autocmd BufWritePost .vimrc source $MYVIMRC
augroup END

let g:autotidy = 1
augroup AutoTidy
  autocmd!
  autocmd BufWritePre * if g:autotidy|:call <SID>RStripAll()|endif
augroup END

augroup AutoFileType
  autocmd!
  autocmd BufRead,BufNewFile *.rkt set filetype=scheme
  autocmd BufRead,BufNewFile SConstruct set filetype=python
  autocmd BufReadPost fugitive://* set bufhidden=delete
  autocmd FileType make setlocal ts=8 sts=8 sw=8 noexpandtab
augroup END

let g:netrw_liststyle = 0
let g:netrw_browse_split = 0
let g:netrw_altv = 1

let mapleader = ","
noremap ; :
nnoremap Y y$

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <C-m> <C-w>=
nnoremap _ <C-w>-
nnoremap + <C-w>+
nnoremap - <C-w><
nnoremap = <C-w>>

nnoremap gF :vertical wincmd f<CR>
"select most recently modified text
nnoremap gV `[V`]
vmap <C-k> [egv
vmap <C-j> ]egv

cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-d> <Del>

nnoremap <C-p> :bprev<CR>
nnoremap <C-n> :bnext<CR>
nnoremap <leader>bb :buffers<CR>:buffer<space>

nnoremap <leader>dd :bp<bar>sp<bar>bn<bar>bd<CR>
nnoremap <leader>dc :bd<CR>
nnoremap <leader>D :bd!<CR>

nnoremap <leader>gg :vnew<bar>r!git<space>grep<space>''<left>
nnoremap <leader>gG :vnew<bar>r!grep-vcs<space>-r<space>.<space>-e<space>''<left>
nnoremap <leader>ff :vnew<bar>r!find-vcs<space>.<space>-name<space>''<space>-print<left><left><left><left><left><left><left><left>
nnoremap <leader>fF :vnew<bar>r!find<space>.<space>-regextype<space>posix-extended<space>-regex<space>''<left>

cnoremap %% <C-R>=expand("%:p:h")."/"<CR>
map <leader>ee :vs<space>%%<CR>
map <leader>eE :e<space>%%<CR>

color desert
