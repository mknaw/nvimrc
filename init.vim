
filetype plugin indent on

set nocompatible              " be iMproved, required
syntax on
set encoding=utf8

""""""""""""""""""""""
""" VUNDLE PLUGINS
""""""""""""""""""""""

filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'

" utility
Plugin 'scrooloose/nerdtree'
Plugin 'brooth/far.vim'
Plugin 'majutsushi/tagbar'
Plugin 'scrooloose/nerdcommenter'
Plugin 'neomake/neomake'
Plugin 'junegunn/fzf'
Plugin 'mileszs/ack.vim'
Plugin 'rking/ag.vim'
Plugin 'Shougo/neocomplete.vim'
Plugin 'Townk/vim-autoclose'
Plugin 'chrisbra/csv.vim'
" Plugin 'ronakg/quickr-preview.vim'
Plugin 'tpope/vim-surround'
Plugin 'phleet/vim-mercenary'
" Plugin 'mattn/emmet-vim'
Plugin 'kshenoy/vim-signature'
Plugin 'christoomey/vim-sort-motion'

" syntax
Plugin 'ycm-core/YouCompleteMe'
"Plugin 'vim-syntastic/syntastic'
Plugin 'w0rp/ale'
" Plugin 'vim-python/python-syntax'
Plugin 'kh3phr3n/python-syntax'
Plugin 'eagletmt/ghcmod-vim'
Plugin 'Shougo/vimproc'

" aesthetics
Plugin 'flazz/vim-colorschemes'
Plugin 'morhetz/gruvbox'
Plugin 'ayu-theme/ayu-vim'
Plugin 'matveyt/vim-modest'
Plugin 'joshdick/onedark.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

call vundle#end()
filetype plugin indent on

source ~/.config/nvim/plugin/matchit.vim

""""""""""""""
""" CONFIG
""""""""""""""

filetype plugin on

autocmd BufEnter * :syntax sync fromstart

set showcmd

set wildignore+=*.orig,*.pyc

" tags
set tags=./tags,tags

" tabs
set tabstop=8
set softtabstop=4
set expandtab
set shiftwidth=4
set autoindent
set smartindent

filetype indent on

set splitright
set splitbelow

set showmatch

set autoread

" wrapping
set wrap!

" airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
nnoremap <space>1 :1tabn<CR>
nnoremap <space>2 :2tabn<CR>
nnoremap <space>3 :3tabn<CR>
nnoremap <space>4 :4tabn<CR>
nnoremap <space>5 :5tabn<CR>
nnoremap <space>6 :6tabn<CR>
nnoremap <space>7 :7tabn<CR>
nnoremap <space>8 :8tabn<CR>
nnoremap <space>9 :9tabn<CR>

" theme
colorscheme ayu
set background=dark
" let g:gruvbox_termcolors = 256
set termguicolors

" backspace fix
set backspace=2

" highlight search
set hlsearch
" highlight current line
set cursorline

" highlight last inserted text
nnoremap gV `[v`]

" enable some mouse
set mouse=n

" line numbers
set number
set ruler
" margin
set colorcolumn=120

" always display the status line
set laststatus=2

let g:python_host_prog = '/usr/local/bin/python2'

" code folding
set foldmethod=indent
" Keep all folds open when a file is opened
augroup OpenAllFoldsOnFileOpen
    autocmd!
    autocmd BufRead * normal zR
augroup END

" Ack
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" Ale
let g:airline#extensions#ale#enabled = 1
let g:ale_lint_on_enter = 1
let g:ale_sign_column_always = 1
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '◗'
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_linters = {
\            'python': ['flake8'],
\            'javascript': ['eslint'],
\}

" Syntastic
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 0
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 1
"let g:syntastic_py_checkers = ['flake8']

" FZF
set rtp+=/usr/local/opt/fzf
" Default fzf layout
" - down / up / left / right
let g:fzf_layout = { 'down': '~40%' }

" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" quickr preview on cursor
" let g:quickr_preview_on_cursor = 1

" emmet
let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall
let g:user_emmet_leader_key='<C-X>'

"""""""""""""""
""" COMMANDS   
"""""""""""""""
command! Vimrc tabe ~/.config/nvim/init.vim

""""""""""""""""""
""" KEYMAPPINGS
""""""""""""""""""

nnoremap <silent> ,<space> :noh<CR>
nnoremap <silent> <space>, :syntax sync fromstart<CR>
inoremap jj <ESC>

" eol yank without newline
nnoremap yy y$

" big cut
nnoremap X VX

" delete without yank by default
nnoremap d "_d
vnoremap d "_d
nnoremap c "_c
vnoremap c "_c
nnoremap x "_x

" rest of line shortkeys
nnoremap dr d$
nnoremap cr c$
nnoremap yr y$

" copy to clipboard in general
nnoremap y "*y
vnoremap y "*y
vnoremap <C-C> "*y

" visual search + replace
vnoremap <C-f> "hy:/<C-r>h
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

" global vimgrep
nnoremap \ :Ag<SPACE>

" splits
" move more sensibly
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
" resize panels
nnoremap <silent> <space>j :exe "resize " . (winheight(0) * 3/2)<CR>
nnoremap <silent> <space>k :exe "resize " . (winheight(0) * 2/3)<CR>
nnoremap <silent> <space>h :exe "vertical resize " . (winwidth(0) * 3/2)<CR>
nnoremap <silent> <space>l :exe "vertical resize " . (winwidth(0) * 2/3)<CR>

" tab traversal
nnoremap <C-H><C-H> gT
nnoremap <C-L><C-L> gt

" avoid exit
nnoremap ZZ zz

" margin at top after jump
nnoremap zt zt3k3j

" center after next match
nnoremap n nzz
nnoremap N Nzz

" fuck
let g:wanker_mode=1
if get(g:, 'wanker_mode')
    nnoremap <silent> <Up>    :resize -2<CR>
    nnoremap <silent> <Down>  :resize +2<CR>
    nnoremap <silent> <Left>  :vertical resize -2<CR>
    nnoremap <silent> <Right> :vertical resize +2<CR>
endif

" giant steps
nnoremap J 10j
vnoremap J 10j
nnoremap K 10k
vnoremap K 10k

" bol / eol shortkeys
map <C-o> ^
map <C-p> $

" merge lines with L
nnoremap L J

" NERDTree
map <C-n> :NERDTreeToggle<CR>
" open on startup
"autocmd vimenter * NERDTree
"au VimEnter * wincmd l
" close if only NERDTree left
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" ignore .pyc
let NERDTreeIgnore = ['\.pyc$', '\.orig$']

" YCM
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_autoclose_preview_window_after_completion = 1

" tagbar
nmap <C-t> :TagbarToggle<CR>
let g:tagbar_width = 75 
let g:tagbar_autoclose = 0

nnoremap ipdb Oimport ipdb; ipdb.set_trace()<ESC>

