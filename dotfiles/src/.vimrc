set nocompatible
runtime bundle/pathogen/autoload/pathogen.vim
call pathogen#infect()
call pathogen#helptags()

set background=dark
colorscheme solarized
"colorscheme morning

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
set nofoldenable
set timeoutlen=1000 ttimeoutlen=0
set termwinscroll=1000000

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
command! -bar BufScratch tabnew|call <SID>BufMakeScratch()
command! -bar BufScratchTab tabnew|call <SID>BufMakeScratch()
command! -bar BufScratchVSplit vnew|call <SID>BufMakeScratch()
command! -bar BufScratchSplit new|call <SID>BufMakeScratch()
fun! <SID>ReOpenBuffers()
  bufdo e
  syntax on
endfun
command! -bar BufReOpen call <SID>ReOpenBuffers()

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
  autocmd BufRead,BufNewFile *.dbk set filetype=scheme
  autocmd FileType scheme setl lispwords-=if
  autocmd FileType scheme setl lispwords+=syntax-rules,syntax-case,syntax-parse,define-values,define-struct,define-syntax-parameter,let-values,let*-values
  autocmd FileType scheme setl lispwords+=with-syntax,with-syntax*,define-match-expander,with-handlers,declare-parser,syntax-dismantle
  autocmd FileType scheme setl lispwords+=local,splicing-local,splicing-letrec-syntax,splicing-let-syntax,
  autocmd FileType scheme setl lispwords+=splicing-letrec*,splicing-letrec,splicing-let,splicing-let*
  autocmd FileType scheme setl lispwords+=splicing-letrec*-values,splicing-letrec-values,splicing-let-values,splicing-let*-values
  autocmd FileType scheme setl lispwords+=match,match*,match-let,match-let*,match-letrec,match-lambda,match-lambda*,match-lambda**,define/match
  autocmd FileType scheme setl lispwords+=match-define,define-syntax-rule,module,module+,module*,parameterize,syntax-parameterize
  autocmd FileType scheme setl lispwords+=for,for/fold,for/list,for/vector,for/set
  autocmd FileType scheme setl lispwords+=define-type,define:,define-struct:,let:,let*:,letrec:,lambda:
  autocmd FileType scheme setl lispwords+=test,define-relation,fresh,run,run*,project,fresh/p,define-relation/table
  autocmd FileType scheme setl lispwords+=define-lifted-relation,fresh/level
  autocmd FileType scheme setl lispwords+=let*/and,let/if,let/list,let*/state,let/vars,define-vector-type,define-vector-type*,define-variant
  autocmd FileType scheme setl lispwords+=caseq,casev
  autocmd FileType scheme setl lispwords+=case/goal,case/stream
  autocmd FileType scheme setl lispwords+=let/cps,let/files,simple-match,simple-match-lambda,parser-lambda
  autocmd FileType scheme setl lispwords+=let/seq,app/seq,let/return,case/p,case/byte,case/char,case/token,lambda/token,let/token
  autocmd FileType scheme setl lispwords+=exist,all,<<=,<<+,<<-,<<~,<<+=,declare,dbk,define-dbk,section
  autocmd BufRead,BufNewFile SConstruct set filetype=python
  autocmd BufReadPost fugitive://* set bufhidden=delete
  autocmd FileType make setlocal ts=8 sts=8 sw=8 noexpandtab
augroup END

augroup AutoRainbowParentheses
  autocmd!
  autocmd VimEnter * RainbowParenthesesToggle
  autocmd Syntax * RainbowParenthesesLoadRound
  autocmd Syntax * RainbowParenthesesLoadSquare
  autocmd Syntax * RainbowParenthesesLoadBraces
augroup END

let $BASH_ENV = "~/.vim-bash-env"

let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ]

let mapleader = ","

let g:tagbar_compact = 1
let g:tagbar_indent = 1
let g:tagbar_autoclose = 1
let g:tagbar_autofocus = 1

let g:toggle_list_no_mappings = 1

let g:ctrlp_map = '<leader>ff'
let g:ctrlp_show_hidden = 1
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'

let NERDTreeShowHidden=1

tnoremap <C-w>n <C-w>N

noremap ; :
nnoremap Y y$

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <leader>mm <C-w>=
nnoremap <leader>mh <C-w><bar>
nnoremap <leader>mj <C-w>_
nnoremap _ <C-w>-
nnoremap + <C-w>+
nnoremap - <C-w><
nnoremap = <C-w>>

nnoremap zI :set foldmethod=indent<CR>

nnoremap gF :vertical wincmd f<CR>
"select most recently modified text
nnoremap gV `[V`]
vmap <C-k> [egv
vmap <C-j> ]egv
vmap s S

cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-b> <Left>
cnoremap <C-d> <Del>

inoremap <C-n> <C-x><C-o>

nnoremap <leader>ll :call ToggleLocationList()<CR>
nnoremap <leader>qq :call ToggleQuickfixList()<CR>

nnoremap <leader>tt :TagbarToggle<CR>

vnoremap <leader>ts :Tabularize<CR>
vnoremap <leader>ta :Tabularize/=
vnoremap <leader>tz :Tabularize/:\zs<left><left><left>

nnoremap > :tabnext<CR>
nnoremap < :tabprev<CR>

nnoremap <leader>nn :NERDTreeToggle<CR>
nnoremap <C-p> :bprev<CR>
nnoremap <C-n> :bnext<CR>
nnoremap <leader>bb :ls<CR>:buffer<space>
nnoremap <leader>bs :BufScratchVSplit<CR>
nnoremap <leader>bd :bd<CR>
nnoremap <leader>bc :bp<bar>sp<bar>bn<bar>bd<CR>
nnoremap <leader>bt :vertical :term<space>
"paste into the terminal buffer contained in the window to our left
nnoremap <leader>bp <C-w>h<C-w>""<CR><C-w>l
vmap <leader>bp y<leader>bp
"paste the last result from the terminal buffer repl contained in the window to our left
nnoremap <leader>br <C-w>h<C-w>Nk$v%ya<C-w>lo<C-c>p
nnoremap <leader>bR <C-w>h<C-w>Nk$v0ya<C-w>lo<C-c>p

nnoremap <leader>R :r!
nnoremap <leader>rr :r!

nnoremap <leader>ww :.!
vnoremap <leader>ww :!
nnoremap <leader>W :.!bash<CR>
vnoremap <leader>W :!bash<CR>

nnoremap <leader>dd :windo diffthis<CR>
nnoremap <leader>dq :windo diffoff<CR>

nnoremap <leader>ge :Gedit<space>
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gd :tabe %<CR>:Gdiff<CR>
nnoremap <leader>gla :vs<CR>:Git! log --decorate --stat<CR>
nnoremap <leader>glf :vs<CR>:Glog -- %<CR>

nnoremap <leader>gg :BufScratchVSplit<bar>r!git<space>grep<space>''<left>
nnoremap <leader>gG :BufScratchVSplit<bar>r!grep-vcs<space>-r<space>.<space>-e<space>''<left>
nnoremap <leader>fF :BufScratchTab<bar>r!find-vcs<space>.<space>-name<space>''<space>-print<left><left><left><left><left><left><left><left>

cnoremap %% <C-R>=expand("%:p:h")."/"<CR>
map <leader>ee :NERDTree<space>%%<CR>
nnoremap <leader>eE :NERDTree<space>

set sessionoptions-=options
let g:session_autoload = 'no'
let g:session_autosave = 'no'
nnoremap <leader>ss :SaveSession <left><right>
nnoremap <leader>so :OpenSession<CR>
nnoremap <leader>sc :CloseSession<CR>
nnoremap <leader>sd :DeleteSession<CR>
nnoremap <leader>sts :SaveTabSession <left><right>
nnoremap <leader>sto :AppendTabSession<CR>
nnoremap <leader>stc :CloseTabSession<CR>
