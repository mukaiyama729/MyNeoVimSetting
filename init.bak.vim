" Run, vim -c "PlugInstall"
set autoread
set hidden
set noswapfile
set nobackup
set nowritebackup
autocmd BufWritePre * :%s/\s\+$//ge
syntax enable
set regexpengine=0
set synmaxcol=200
set tabstop=2 shiftwidth=2 softtabstop=0
set autoindent
set smartindent
set cindent
set noexpandtab
set backspace=indent,eol,start
set formatoptions=lmoq
set whichwrap=b,s,h,s,<,>,[,]
set wildmenu
set wildmode=list:full
set wrapscan
set ignorecase
set smartcase
set incsearch
set hlsearch
set showmatch
set showcmd
set showmode
set number
set nowrap
set list
set listchars=tab:>\
set notitle
set scrolloff=5
set display=uhex

if &compatible
  set nocompatible
endif

function! ZenkakuSpace()
    highlight ZenkakuSpace cterm=reverse ctermfg=DarkMagenta gui=reverse guifg=DarkMagenta
endfunction

if has('syntax')
    augroup ZenkakuSpace
        autocmd!
        autocmd ColorScheme       * call ZenkakuSpace()
        autocmd VimEnter,WinEnter * match ZenkakuSpace /　/
    augroup END
    call ZenkakuSpace()
endif

set cursorline
augroup cch
        autocmd! cch
        autocmd WinLeave * set nocursorline
        autocmd WinEnter,BufRead * set cursorline
augroup END
hi clear CursorLine
hi CursorLine gui=underline
hi CursorLine ctermbg=black guibg=black

set laststatus=2
set statusline=%<%f\ #%n%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%y%=%l,%c%V%8P

set termencoding=utf-8
set encoding=utf-8
set fileencodings=utf-8,cp932,euc-jp,iso-2022-jp
set ffs=unix,dos,mac
if exists('&ambiwidth')
        set ambiwidth=double
endif


set tw=0
set number
set title
set showmatch
set matchtime=1
set matchpairs& matchpairs+=<:>
set list
set visualbell
set laststatus=2
set ruler
set clipboard=unnamed
syntax on
set virtualedit=onemore
set autoindent
set smartindent
set expandtab
set softtabstop=2
set shiftwidth=2
set whichwrap=b,s,h,l,<,>,[,],~
set backspace=indent,eol,start
set ignorecase
set smartcase
set wrapscan
set hlsearch

set incsearch
nmap <Esc><Esc> :nohlsearch<CR><Esc>
set mouse=a
"set ttymouse=xterm2
set foldmethod=indent
set foldlevel=10
set foldcolumn=3
set shortmess-=S
let g:netrw_dirhistmax = 0


augroup vimrcEx
  au BufRead * if line("'\"") > 0 && line("'\"") <= line("$") |
  \ exe "normal g`\"" | endif
augroup END


if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  unlet s:enc_euc
  unlet s:enc_jis
endif
if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif

syntax enable
colorscheme slate
" リーダーキーの設定（オプション）
let mapleader = ","
" # tab
" :set expandtab
" :set noexpandtab
" # paste
" :set paste
" :set nopaste
autocmd BufRead,BufNewFile *.env let b:coc_enabled = 0

let g:coc_disable_startup_warning = 1
let g:coc_global_extensions = ['coc-rust-analyzer']
let g:python_highlight_all = 1
call plug#begin('~/.vim/plugged')
Plug 'itchyny/lightline.vim'
Plug 'whatyouhide/vim-gotham'
Plug 'preservim/nerdtree'
Plug 'tomasiser/vim-code-dark'
Plug 'tomtom/tcomment_vim'
Plug 'th2ch-g/my-vim-sonictemplate'
Plug 'machakann/vim-sandwich'
Plug 'pappasam/coc-jedi', { 'do': 'yarn install --frozen-lockfile && yarn build', 'branch': 'main' }
Plug 'vim-python/python-syntax'
Plug 'yaegassy/coc-pylsp', {'do': 'yarn install --frozen-lockfile'}
Plug 'Exafunction/codeium.vim', { 'branch': 'main' }
Plug 'ianks/vim-tsx'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Deps
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'stevearc/dressing.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'MunifTanjim/nui.nvim'
Plug 'MeanderingProgrammer/render-markdown.nvim'

" Optional deps
Plug 'hrsh7th/nvim-cmp'
Plug 'nvim-tree/nvim-web-devicons' "or Plug 'echasnovski/mini.icons'
Plug 'HakonHarnes/img-clip.nvim'
Plug 'zbirenbaum/copilot.lua'

" Yay, pass source=true if you want to build from source
Plug 'yetone/avante.nvim', { 'branch': 'main', 'do': 'make' }
call plug#end()

" avante.nvim の設定を追加
augroup AvanteSetup
  autocmd!
  autocmd User avante.nvim lua require('avante').setup()
augroup END
syntax enable
colorscheme slate

autocmd VimEnter * NERDTree
let g:codeium_disable_bindings = 1
" Normal mode
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <leader>f :NERDTreeFind<CR>
nnoremap <C-j> 5j
nnoremap <C-k> 5k
nnoremap <leader>k O<Esc>
nnoremap <leader>j o<Esc>
nmap <silent> K :call CocActionAsync('doHover')<CR>
" nnoremap <silent> gd :call CocAction('jumpDefinition')<CR>
nnoremap <silent> gd :split \| call CocAction('jumpDefinition')<CR>
nmap <silent> gr <Plug>(coc-references)
" Insert mode
inoremap { {}<Left>
inoremap {<Enter> {}<Left><CR><ESC><S-o>
inoremap ( ()<ESC>i
inoremap (<Enter> ()<Left><CR><ESC><S-o>
inoremap [ []<ESC>i
inoremap [<Enter> []<Left><CR><ESC><S-o>
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>
inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-u> <C-o>d0
inoremap <C-w> <C-o>dB
inoremap <C-i> <Esc>O
inoremap <C-o> <Esc>o
imap <script><silent><nowait><expr> <C-g> codeium#Accept()
imap <script><silent><nowait><expr> <C-f> codeium#AcceptNextWord()
imap <script><silent><nowait><expr> <C-d> codeium#AcceptNextLine()
imap <C-;>   <Cmd>call codeium#CycleCompletions(1)<CR>
imap <C-,>   <Cmd>call codeium#CycleCompletions(-1)<CR>
imap <C-x>   <Cmd>call codeium#Clear()<CR>

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
"if has('nvim')
"  inoremap <silent><expr> <c-space> coc#refresh()
"else
"  inoremap <silent><expr> <c-@> coc#refresh()
"endif
" InsertモードでCtrl + Shift + j で下に行を追加
" Visual mode
vnoremap <C-j> 5j
vnoremap <C-k> 5k

