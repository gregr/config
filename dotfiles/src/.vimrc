set nocompatible
set fileformats=unix,dos,mac
set backspace=indent,eol,start
set scrolloff=10
set autoread nobackup nowb hidden lazyredraw
set autoindent smartindent shiftround
set incsearch ignorecase smartcase hlsearch
set showmatch showcmd
set laststatus=2
set statusline=\ %F%m%r%h%y\ %n\ %w%=[\ %l/%L:%c\ ]
set wildmenu wildmode=list:longest,full
set list listchars=tab:>-,trail:-

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

set ts=2 sts=2 sw=2 expandtab

if has("autocmd")
  autocmd BufWritePost .vimrc source $MYVIMRC
  autocmd BufWritePre * :call <SID>RStripAll()
  autocmd BufRead,BufNewFile *.rkt set filetype=scheme
  autocmd FileType make setlocal ts=8 sts=8 sw=8 noexpandtab
endif

let g:netrw_liststyle = 0
let g:netrw_browse_split = 0
let g:netrw_altv = 1

let mapleader = ","
noremap ; :

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <C-m> <C-w>_
nnoremap _ <C-w>-
nnoremap + <C-w>+
nnoremap - <C-w><
nnoremap = <C-w>>

nnoremap gF :vertical wincmd f<CR>
nnoremap gV `[V`]
vmap <C-k> xkPgV
vmap <C-j> xpgV

cnoremap %% <C-R>=expand("%:p:h")."/"<CR>

nnoremap <leader>d :bp<bar>sp<bar>bn<bar>bd<CR>
nnoremap <leader>D :bp<bar>sp<bar>bn<bar>bd!<CR>
nnoremap <leader>G :vnew<bar>r!grep<space>-e<space>
nnoremap <leader>g :vnew<bar>r!grep<space>-r<space>.<space>-e<space>
nnoremap <leader>f :vnew<bar>r!find<space>.<space>-name<space>
nnoremap <leader>F :vnew<bar>r!find<space>.<space>-regextype<space>posix-extended<space>-regex<space>
map <leader>e :vs<space>%%<CR>

color desert
