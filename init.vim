
filetype plugin indent on

set nocompatible              " be iMproved, required
syntax on
set encoding=utf8

set shell=zsh

""""""""""""""""""""""
""" VUNDLE PLUGINS
""""""""""""""""""""""

call plug#begin('~/.vim/plugged')

" utility
Plug 'kyazdani42/nvim-tree.lua'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'brooth/far.vim'
Plug 'scrooloose/nerdcommenter'
" Plug 'neomake/neomake'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" Plug 'yuki-yano/fzf-preview.vim'
Plug 'mileszs/ack.vim'
Plug 'jremmen/vim-ripgrep'
" Plug 'Shougo/neocomplete.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'chrisbra/csv.vim'
Plug 'kana/vim-textobj-user'
Plug 'chaoren/vim-wordmotion'
" Plug 'ronakg/quickr-preview.vim'
Plug 'tpope/vim-surround'
Plug 'mattn/emmet-vim'
Plug 'kshenoy/vim-signature'
Plug 'christoomey/vim-sort-motion'
Plug 'yssl/QFEnter'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'ludovicchabant/vim-gutentags' " TODO figure out how to gen tags for site-packages

" VCS
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" syntax
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'kh3phr3n/python-syntax'
" Plug 'eagletmt/ghcmod-vim'
" Plug 'Shougo/vimproc'
" Plug 'rust-lang/rust.vim'
" Plug 'leafgarland/typescript-vim'
" Plug 'peitalin/vim-jsx-typescript'
" Plug 'elixir-editors/vim-elixir'
" Plug 'tweekmonster/django-plus.vim'

" aesthetics
" Plug 'morhetz/gruvbox'
Plug 'ayu-theme/ayu-vim'
Plug 'nvim-lualine/lualine.nvim'

call plug#end()

" source ~/.config/nvim/plugin/matchit.vim
source ~/.config/nvim/plugin/argtextobj.vim
" source ~/.config/nvim/plugin/camelcasemotion.vim

""""""""""""""
""" CONFIG
""""""""""""""

let mapleader="\\"

let g:airline#extensions#clock#format = '%H:%M'

" filetype plugin on

autocmd BufEnter * :syntax sync fromstart
:syntax sync minlines=10000
set redrawtime=10000

set showcmd

set wildignore+=*.orig,*.pyc

" tags
set tags=./tags,tags

" tabs
set autoindent
set smartindent
filetype indent on

fu! SetTabs()
  " toggle between 2 & 4 spaces for tabs
  if !exists('s:tabwidth') || s:tabwidth == 2
    let s:tabwidth = 4
  else
    let s:tabwidth = 2
  endif
  let &softtabstop = s:tabwidth
  let &shiftwidth = s:tabwidth
  set expandtab
endfunction

call SetTabs()
nmap <C-t> :silent call SetTabs()<CR>

set splitright
set splitbelow

set showmatch

set autoread

" quickfix across whole width even in vsplit
" TODO check if this actually works...
botright cwindow

" wrapping
set wrap!

" TODO pretty much never even use this
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
" set background=dark
" colorscheme gruvbox
" set background=light
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
set colorcolumn=110
au BufNewFile,BufRead *.py setlocal colorcolumn=120
au BufNewFile,BufRead *.js setlocal colorcolumn=80
au BufNewFile,BufRead *.ts setlocal colorcolumn=80
au BufNewFile,BufRead *.tsx setlocal colorcolumn=80

" always display the status line
set laststatus=2

let g:python_host_prog = '/usr/local/bin/python2'
let g:python3_host_prog = '/usr/local/bin/python3'

" code folding
set foldmethod=indent
" Keep all folds open when a file is opened
augroup OpenAllFoldsOnFileOpen
    autocmd!
    autocmd BufRead * normal zR
augroup END

nnoremap \ :Rg<SPACE>

let g:far#source = 'rg'
let g:far#default_file_mask = '/'
let g:far#window_width = 120
vnoremap <C-g> "hy:Far<SPACE><C-r>h<SPACE>

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
\   'python': ['flake8'],
\   'javascript': ['eslint'],
\   'typescript': ['eslint'],
\   'elixir': ['elixir-ls'],
\}
let g:ale_elixir_elixir_ls_release = expand("~/.elixir-ls/rel/")


" Syntastic
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 0
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 1
"let g:syntastic_py_checkers = ['flake8']

" FAR
let g:far#source = 'agnvim'

" FZF
set rtp+=/usr/local/opt/fzf

" Default fzf layout
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.8 } }
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Conditional'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

let g:fzf_history_dir = '~/.local/share/fzf-history'
let g:fzf_preview_window = ['right:50%', 'ctrl-/']
nnoremap ,f :FZF<CR>
" nnoremap ,ff :Buffers<CR>
nnoremap ,l :Lines<CR>
nnoremap ,t :Tags<CR>

function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" TODO would be good to read the `g:fzf_preview_window` var instead of
"      repeating here.
command! -bang -nargs=* LinesWithPreview
    \ call fzf#vim#grep(
    \   'rg --with-filename --column --line-number --no-heading --color=always --smart-case . '.fnameescape(expand('%')), 1,
    \   fzf#vim#with_preview({
    \       'options': '--delimiter : --no-sort'}),
    \   0)
nnoremap H :LinesWithPreview<CR>

" quickr preview on cursor
" let g:quickr_preview_on_cursor = 1

" emmet
" let g:user_emmet_install_global = 0
" autocmd FileType html,css EmmetInstall
let g:user_emmet_leader_key='<C-y>'

let g:netrw_banner = 0
let g:netrw_liststyle = 3

let g:ped_edit_command = 'tabedit'

" set statusline+=%{FugitiveStatusline()}
set diffopt+=vertical

"""""""""""""""
""" COMMANDS   
"""""""""""""""
command! Vimrc tabe ~/.config/nvim/init.vim

command! F FZF

""""""""""""""""""
""" KEYMAPPINGS
""""""""""""""""""

nnoremap <silent> ,<space> :noh<CR>
nnoremap <silent> <space>, :syntax sync fromstart<CR>

inoremap jj <ESC>

vnoremap $ $h

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
nnoremap dr "_d$h
nnoremap cr c$h
nnoremap yr y$h
nnoremap vr v$h

" copy to clipboard in general
" TODO have to fix this so it copies to clipboard -and- to register.
nnoremap y "*y
vnoremap y "*y
vnoremap <C-C> "*y

" visual search + replace
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

" splits
" move more sensibly
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
" resize panels
nnoremap <silent> <space>j :exe "resize " . (&lines * 3/2)<CR>
nnoremap <silent> <space>k :exe "resize " . (&lines * 2/3)<CR>
nnoremap <silent> <space>h :exe "vertical resize " . (&columns * 3/2)<CR>
nnoremap <silent> <space>l :exe "vertical resize " . (&columns * 2/3)<CR>

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

" wordmotion
let g:wordmotion_mappings = {
\ 'w' : ',w',
\ 'b' : ',b',
\ 'e' : ',e',
\ 'ge' : 'g,e',
\ 'aw' : 'a,w',
\ 'iw' : 'i,w',
\ }

" NERDcommenter
let g:NERDSpaceDelims = 1
let g:NERDCustomDelimiters = { 'django': { 'left': '{#', 'right': '#}', 'leftAlt': '{% comment %}', 'rightAlt': '{% endcomment %}' } }

" YCM
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_autoclose_preview_window_after_completion = 1

nnoremap ipdb Oimport ipdb; ipdb.set_trace()<ESC>

" just do the obvious thing
command! W w
command! Wq wq
command! Q q
command! Vs vs

autocmd FileType qf setlocal wrap

let g:UltiSnipsExpandTrigger="<c-s>"
let g:UltiSnipsListSnippets="<c-_>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsSnippetDirectories=["UltiSnips", $HOME."/.vim/snippets"] 
nnoremap gd :Gdiffsplit<CR>
nnoremap gm :GMove 

let g:user_emmet_settings = {
\  'html' : {
\    'block_all_childless' : 1,
\  },
\}

let g:qfenter_keymap = {
\ 'vopen': ['<C-v>'],
\ 'topen': ['<C-t>'],
\}

" CoC config
set updatetime=300

if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
nnoremap <space>a  :<C-u>CocList diagnostics<cr>

" LuaLine config
lua << END
local function hello()
  return os.date("%m/%d %I:%M", os.time())
end
require'lualine'.setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {},
    always_divide_middle = true,
  },
  tabline = {
    lualine_a = {'buffers'},
    lualine_b = {'branch'},
    lualine_c = {'filename'},
    lualine_x = {},
    lualine_y = {'tabs'},
    lualine_z = {hello}
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {
        'branch',
        'diff',
        {'diagnostics', sources={'nvim_lsp', 'coc'}}},
    lualine_c = {'filename'},
    lualine_x = {'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  extensions = {}
}
END
