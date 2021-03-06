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
  autocmd FileType scheme setl lispwords+=if,syntax-rules,syntax-case,define-values,define-struct,define-syntax-parameter,let-values,let*-values
  autocmd FileType scheme setl lispwords+=match,match*,match-let,match-let*,match-letrec,match-lambda,match-lambda*,match-lambda**,define/match
  autocmd FileType scheme setl lispwords+=match-define,define-syntax-rule,module,module+,module*,parameterize
  autocmd FileType scheme setl lispwords+=for,for/fold,for/list,for/vector,for/set
  autocmd FileType scheme setl lispwords+=define-type,define:,define-struct:,let:,let*:,letrec:,lambda:
  autocmd FileType scheme setl lispwords+=test,define-relation,fresh,run,run*,project,fresh/p
  autocmd FileType scheme setl lispwords+=let*/and,let/if,let/list,let*/state,let/vars,define-vector-type,define-vector-type*
  autocmd FileType scheme setl lispwords+=case/goal,case/stream
  autocmd FileType scheme setl lispwords+=let/cps,let/files
  autocmd FileType scheme setl lispwords+=let/seq,app/seq,let/return,case/p,case/byte,case/char,case/token,lambda/token,let/token
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

let g:paredit_mode = 0

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

let g:CoqIDEDefaultMap = 1
let g:tagbar_compact = 1
let g:tagbar_indent = 1
let g:tagbar_autoclose = 1
let g:tagbar_autofocus = 1

let g:toggle_list_no_mappings = 1

let g:ctrlp_map = '<leader>ff'
let g:ctrlp_show_hidden = 1
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'

let g:syntastic_check_on_open = 0
let g:syntastic_auto_loc_list = 0
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

vnoremap <leader>ta :Tabularize/=
vnoremap <leader>tz :Tabularize/:\zs<left><left><left>

nnoremap > :tabnext<CR>
nnoremap < :tabprev<CR>

nnoremap <C-p> :bprev<CR>
nnoremap <C-n> :bnext<CR>
nnoremap <leader>bb :ls<CR>:buffer<space>
nnoremap <leader>bst :BufScratchTab<CR>
nnoremap <leader>bsv :BufScratchVSplit<CR>
nnoremap <leader>bss :BufScratchSplit<CR>
nnoremap <leader>bd :bd<CR>
nnoremap <leader>bc :bp<bar>sp<bar>bn<bar>bd<CR>
nnoremap <leader>bt :ConqueTermV<space>bash<CR>
nnoremap <leader>nn :NERDTreeToggle<CR>

"let g:conque_repl_send_key = '<leader>rr'
"nmap <leader>ra ,btracket

nnoremap <leader>rrr :r!
nnoremap <leader>rrt :BufScratchTab<bar>r!
nnoremap <leader>rrv :BufScratchVSplit<bar>r!
nnoremap <leader>rrs :BufScratchSplit<bar>r!

nnoremap <leader>dd :windo diffthis<CR>
nnoremap <leader>dq :windo diffoff<CR>

nnoremap <leader>ge :Gedit<space>
nnoremap <leader>gs :tabe %<CR>:Gstatus<CR>
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gd :tabe %<CR>:Gdiff<CR>
nnoremap <leader>gla :vs<CR>:Git! log --decorate --stat<CR>
nnoremap <leader>glf :vs<CR>:Glog -- %<CR>

nnoremap <leader>ggt :BufScratchTab<bar>r!git<space>grep<space>''<left>
nnoremap <leader>ggv :BufScratchVSplit<bar>r!git<space>grep<space>''<left>
nnoremap <leader>ggs :BufScratchSplit<bar>r!git<space>grep<space>''<left>
nnoremap <leader>gGt :BufScratchTab<bar>r!grep-vcs<space>-r<space>.<space>-e<space>''<left>
nnoremap <leader>gGv :BufScratchVSplit<bar>r!grep-vcs<space>-r<space>.<space>-e<space>''<left>
nnoremap <leader>gGs :BufScratchSplit<bar>r!grep-vcs<space>-r<space>.<space>-e<space>''<left>
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

nnoremap <leader>coc :CoffeeCompile<CR>
nnoremap <leader>com :CoffeeMake<CR>
