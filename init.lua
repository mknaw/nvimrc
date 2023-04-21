local set = vim.opt

set.runtimepath:append(',~/.config/nvim')

vim.g.mapleader = ','

require('plugins')
require('aesthetics')
require('tabwidth')

vim.g.python_host_prog = '/usr/local/bin/python2'
vim.g.python3_host_prog = '~/.pyenv/versions/nvim/bin/python3'
vim.g.node_host_prog = '/usr/local/opt/node/bin/node'
vim.g.copilot_node_command = '/usr/local/opt/node/bin/node'

vim.cmd([[ command! Vimrc tabe ~/.config/nvim/init.lua ]])

set.shell = 'zsh'

set.syntax = 'off'  -- trees sat
set.autoindent = true
set.splitright = true
set.splitbelow = true
set.showmatch = true
set.autoread = true

set.wrap = false
set.expandtab = true

-- always display the status line
set.laststatus = 2

set.previewheight = 80

set.colorcolumn = '110'
-- TODO could move this to some sort of per-lang config
vim.cmd([[
au BufNewFile,BufRead *.py setlocal colorcolumn=120
au BufNewFile,BufRead *.js setlocal colorcolumn=80
au BufNewFile,BufRead *.ts setlocal colorcolumn=80
au BufNewFile,BufRead *.tsx setlocal colorcolumn=80
au BufNewFile,BufRead *.rs setlocal colorcolumn=100
]])

vim.keymap.set('i', 'jj', '<ESC>', {})

-- clear highlights
vim.keymap.set('n', ',<space>', ':noh<CR>', { silent = true })

-- last buffer remap
vim.keymap.set('n', '<space>b', '<c-^>', { silent = true })

-- eol yank without newline
vim.keymap.set('n', 'yy', 'y$', {})

-- big steps
vim.keymap.set({ 'n', 'v' }, 'J', '10j', {})
vim.keymap.set({ 'n', 'v' }, 'K', '10k', {})

-- big cut
vim.keymap.set('n', 'X', 'VX', {})
vim.keymap.set('n', 'Y', 'VY', {})

vim.keymap.set('v', '$', '$h', {})

-- avoid exit
vim.keymap.set('n', 'ZZ', 'zz', {})
-- margin at top after jump
vim.keymap.set('n', 'zt', 'zt3k3j', {})

-- merge lines with L
vim.keymap.set('n', 'L', 'J', {})

-- delete without yank by default
vim.keymap.set({ 'n', 'v' }, 'd', '"_d', {})
vim.keymap.set({ 'n', 'v' }, 'c', '"_c', {})
vim.keymap.set('n', 'x', '"_x', {})

-- copy to clipboard in general
vim.keymap.set('v', '<C-C>', '"*y', {})
-- visual search + replace
vim.keymap.set('v', '<C-r>', '"hy:%s/<C-r>h//gc<left><left><left>', {})

vim.keymap.set('n', '<Up>', ':resize +5<CR>', { silent = true })
vim.keymap.set('n', '<Down>', ':resize -5<CR>', { silent = true })
vim.keymap.set('n', '<Left>', ':vertical resize -5<CR>', { silent = true })
vim.keymap.set('n', '<Right>', ':vertical resize +5<CR>', { silent = true })

vim.keymap.set('n', '<C-H><C-H>', 'gT', {})
vim.keymap.set('n', '<C-L><C-L>', 'gt', {})
vim.keymap.set('n', '<C-J>', '<C-W><C-J>', {})
vim.keymap.set('n', '<C-K>', '<C-W><C-K>', {})
vim.keymap.set('n', '<C-L>', '<C-W><C-L>', {})
vim.keymap.set('n', '<C-H>', '<C-W><C-H>', {})

vim.cmd([[
" wordmotion
let g:wordmotion_mappings = {
\ 'w' : ',w',
\ 'b' : ',b',
\ 'e' : ',e',
\ 'ge' : 'g,e',
\ 'aw' : 'a,w',
\ 'iw' : 'i,w',
\ }

]])

vim.keymap.set('n', '<space>c', ':ccl<cr>', {})
vim.keymap.set('n', '<space>q', ':wq!<cr>', {})
vim.keymap.set('n', '<space>e', ':e!<cr>', {})
vim.keymap.set('n', '<space>qq', ':q!<cr>', {})
vim.keymap.set('n', '<space>w', ':w<cr>', {})
vim.keymap.set('n', '<space>v', ':vs<cr>', {})
vim.keymap.set('n', '<space>s', ':sp<cr>', {})
vim.keymap.set('n', '<space>t', ':tabe<cr>', {})
vim.keymap.set('n', '<space>f', ':Format<cr>', {})

-- TODO python only
vim.cmd([[
nnoremap ipdb Oimport ipdb; ipdb.set_trace()<ESC>
nnoremap rdb Ofrom celery.contrib import rdb; rdb.set_trace()<ESC>
nnoremap <space>i :silent execute('!isort -q --dont-order-by-type ' . expand("%:p"))<cr>
]])

vim.cmd([[
" just do the obvious thing
command! W w
command! Wq wq
command! Q q
command! Vs vs
]])

vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
