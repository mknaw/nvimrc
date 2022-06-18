
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
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'MattesGroeger/vim-bookmarks'
Plug 'tom-anders/telescope-vim-bookmarks.nvim'
Plug 'AckslD/nvim-neoclip.lua'

" VCS
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'kristijanhusak/vim-create-pr'

" syntax
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" Plug 'kh3phr3n/python-syntax'
" Plug 'eagletmt/ghcmod-vim'
" Plug 'Shougo/vimproc'
" Plug 'leafgarland/typescript-vim'
" Plug 'peitalin/vim-jsx-typescript'
" Plug 'elixir-editors/vim-elixir'
Plug 'tweekmonster/django-plus.vim'
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'neovimhaskell/haskell-vim'
Plug 'psiska/telescope-hoogle.nvim'

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

let mapleader=","

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
" set smartindent
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

" theme
colorscheme ayu
" set background=dark
" colorscheme gruvbox
" set background=light
" let g:gruvbox_termcolors = 256
set termguicolors

hi WarningMsg guifg=#c72a2a
hi DiffDelete guibg=clear guifg=#c72a2a

" backspace fix
set backspace=2

" highlight search
set hlsearch
" highlight current line
set cursorline

" highlight last inserted text
nnoremap gV `[v`]

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
"let g:python3_host_prog = '/usr/local/bin/python3'
let g:python3_host_prog = '~/.pyenv/versions/nvim/bin/python3'

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

" FAR
let g:far#source = 'rgnvim'

" Telescope
nnoremap <leader>g <cmd>Telescope find_files<cr>
nnoremap <leader>b <cmd>Telescope buffers<cr>
nnoremap <leader>t <cmd>lua require('telescope.builtin').tags()<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fo <cmd>lua require('telescope.builtin').oldfiles()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
nnoremap <leader>fc <cmd>lua require('telescope.builtin').commands()<cr>
nnoremap <leader>fs <cmd>lua require('telescope.builtin').search_history()<cr>
nnoremap <leader>fq <cmd>lua require('telescope.builtin').quickfix()<cr>
nnoremap <leader>fr <cmd>lua require('telescope.builtin').registers()<cr>
nnoremap <leader>fz <cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>
nnoremap <leader>fm <cmd>lua require('telescope').extensions.vim_bookmarks.all()<cr>
nnoremap <leader>fy <cmd>lua require('telescope').extensions.neoclip.default()<cr>

lua << EOF
require('telescope').setup{
  defaults = {
      mappings = {
        i = {
          ["<C-j>"] = require('telescope.actions').move_selection_next,
          ["<C-k>"] = require('telescope.actions').move_selection_previous,
        },
      },
  },
}

-- Extensions
require('telescope').load_extension('vim_bookmarks')
require('telescope').load_extension('hoogle')

require('neoclip').setup({
  keys = {
    telescope = {
      i = {
        paste_behind = '<c-o>',
      },
    },
  },
})
EOF

function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

" quickr preview on cursor
" let g:quickr_preview_on_cursor = 1

" emmet
" let g:user_emmet_install_global = 0
" autocmd FileType html,css EmmetInstall
let g:user_emmet_leader_key='<C-y>'

let g:netrw_banner = 0
let g:netrw_liststyle = 3

" set statusline+=%{FugitiveStatusline()}
set diffopt+=vertical

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

vnoremap $ $h

" eol yank without newline
nnoremap yy y$

" big cut
nnoremap X VX
nnoremap Y VY

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
    nnoremap <silent> <Up>    :resize +5<CR>
    nnoremap <silent> <Down>  :resize -5<CR>
    nnoremap <silent> <Left>  :vertical resize -5<CR>
    nnoremap <silent> <Right> :vertical resize +5<CR>
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

nnoremap ipdb Oimport ipdb; ipdb.set_trace()<ESC>

" just do the obvious thing
command! W w
command! Wq wq
command! Q q
command! Vs vs

set previewheight=80
nnoremap ga :Git add .<CR>
nnoremap gs :Git<CR>
nnoremap gw :Gwrite<CR>
nnoremap gc :Git commit<CR>
nnoremap gca :Git commit --amend<CR>
nnoremap gcne :Git commit --amend --no-edit<CR>
nnoremap gd :Git diff<CR>
nnoremap gm :GMove 
nnoremap gco :GBranches<CR>
nnoremap grid :Git rebase -i develop<CR>
nnoremap gpoh :Git push origin head<CR>
nnoremap gpfoh :Git push --force origin head<CR>

autocmd FileType qf setlocal wrap

let g:UltiSnipsExpandTrigger="<c-s>"
let g:UltiSnipsListSnippets="<c-_>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsSnippetDirectories=[$HOME."/.vim/snippets", $HOME."/.vim/plugged/vim_snippets/snippets"] 

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

nmap <space>rn <Plug>(coc-rename)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> ,d <Plug>(coc-definition)
nmap <silent> ,dv :call CocAction('jumpDefinition', 'vsplit')<CR>
nmap <silent> ,ds :call CocAction('jumpDefinition', 'split')<CR>
nmap <silent> ,dt :call CocAction('jumpDefinition', 'tabe')<CR>
nmap <silent> <space>y <Plug>(coc-type-definition)
nmap <silent> <space>i <Plug>(coc-implementation)
nmap <silent> <space>r <Plug>(coc-references)

let g:coc_disable_transparent_cursor = 1

command! OrganizeImports CocCommand pyright.organizeimports

" nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
nnoremap <space>a  :<C-u>CocList diagnostics<cr>

nnoremap <silent> ,D :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a v<Plug>(coc-codeaction-selected)

" LuaLine config
" TODO this complains when editing git commits etc.
lua << END
local function clock()
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
    lualine_a = {'filename'},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {'tabs'},
    lualine_z = {clock}
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

lua << END
require'nvim-tree'.setup()
END

nnoremap <C-n> :NvimTreeToggle<CR>

nnoremap <space>c :ccl<cr>
nnoremap <space>q :wq<cr>
nnoremap <space>w :w<cr>
nnoremap <space>v :vs<cr>
nnoremap <space>t :tabe<cr>

hi CocHintSign guifg=#68959c
nnoremap <space>th :CocCommand rust-analyzer.toggleInlayHints<CR>

lua << END
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  incremental_selection = { enable = true },
  textobjects = { enable = true },
}
END

" TBH for the most part I should probably just remap the link targets
hi! link TSConstant Special
hi! link TSParameter Constant
" TODO would love different for declaration vs reference.
hi! link TSType Special
hi! link TSTypeBuiltin TSException
hi Identifier guifg=foreground

set nofoldenable

command! -nargs=0 Prettier :CocCommand prettier.forceFormatDocument

let g:bookmark_no_default_key_mappings = 1
nmap mm <Plug>BookmarkToggle
nmap mx <Plug>BookmarkClearAll
