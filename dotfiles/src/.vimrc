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
set completeopt=longest,menuone
set showfulltag

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
fun! <SID>BufMakeScratch()
  setl buftype=nofile
  setl bufhidden=hide
  setl noswapfile
  setl buflisted
endfun
command! -bar BufScratch vnew|call <SID>BufMakeScratch()

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

let mapleader = ","

let g:tagbar_compact = 1
let g:tagbar_indent = 1
let g:tagbar_autoclose = 1
let g:tagbar_autofocus = 1

let g:ctrlp_map = '<leader>ff'
let g:ctrlp_show_hidden = 1
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'

let g:syntastic_check_on_open = 0
let g:syntastic_auto_loc_list = 1
let g:syntastic_python_checker_args = '--ignore=E111,E121,E123,E125,E301,E302,E401,E701,E702,W191'

let NERDTreeShowHidden=1

let ConqueTerm_EscKey = '<C-c>'
let ConqueTerm_SendVisKey = '<leader>bp'

noremap ; :
nnoremap Y y$

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <leader>mm <C-w><bar>
nnoremap <leader>mn <C-w>_
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
cnoremap <C-d> <Del>

inoremap <C-n> <C-x><C-o>

nnoremap <leader>tt :TagbarToggle<CR>

nnoremap <C-p> :bprev<CR>
nnoremap <C-n> :bnext<CR>
nnoremap <leader>bb :ls<CR>:buffer<space>
nnoremap <leader>bs :BufScratch<CR>
nnoremap <leader>bd :bd<CR>
nnoremap <leader>bc :bp<bar>sp<bar>bn<bar>bd<CR>
nnoremap <leader>bt :ConqueTermV<space>bash<CR>
nnoremap <leader>nn :NERDTreeToggle<CR>

nnoremap <leader>qq :copen<CR>
nnoremap <leader>qc :cclose<CR>
nnoremap <leader>qj :.cc<CR>

nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>gl :Glog<space>-20<space>--<space>%<CR>

nnoremap <leader>gg :BufScratch<bar>r!git<space>grep<space>''<left>
nnoremap <leader>gG :BufScratch<bar>r!grep-vcs<space>-r<space>.<space>-e<space>''<left>
nnoremap <leader>fF :BufScratch<bar>r!find-vcs<space>.<space>-name<space>''<space>-print<left><left><left><left><left><left><left><left>

cnoremap %% <C-R>=expand("%:p:h")."/"<CR>
map <leader>ee :NERDTree<space>
map <leader>eE :NERDTree<space>%%<CR>

nnoremap <leader>coc :CoffeeCompile<CR>
nnoremap <leader>com :CoffeeMake<CR>

color desert
