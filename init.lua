vim.opt.runtimepath:append(',~/.config/nvim')

vim.g.mapleader = ','

require('plugins')
require('aesthetics')
require('treesitter-cfg')

require('coc-cfg')

require('telescope-cfg')
require('lualine-cfg')


vim.g.python_host_prog = '/usr/local/bin/python2'
vim.g.python3_host_prog = '~/.pyenv/versions/nvim/bin/python3'
vim.g.node_host_prog = '/usr/local/opt/node/bin/node'
vim.g.copilot_node_command = '/usr/local/opt/node/bin/node'

vim.cmd([[ command! Vimrc tabe ~/.config/nvim/init.lua ]])

vim.opt.shell = 'zsh'

vim.opt.autoindent = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.showmatch = true
vim.opt.autoread = true

-- always display the status line
vim.opt.laststatus = 2

vim.opt.previewheight = 80

vim.opt.colorcolumn = '110'
-- TODO could move this to some sort of per-lang config
vim.cmd([[
au BufNewFile,BufRead *.py setlocal colorcolumn=120
au BufNewFile,BufRead *.js setlocal colorcolumn=80
au BufNewFile,BufRead *.ts setlocal colorcolumn=80
au BufNewFile,BufRead *.tsx setlocal colorcolumn=80
au BufNewFile,BufRead *.rs setlocal colorcolumn=100
]])


-- TODO move to a keymaps.lua file?

vim.cmd([[
" last buffer remap
nnoremap <silent> <space>b <c-^>

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

" avoid exit
nnoremap ZZ zz

" margin at top after jump
nnoremap zt zt3k3j

" center after next match
nnoremap n nzz
nnoremap N Nzz


" nav
nnoremap J 10j
vnoremap J 10j
nnoremap K 10k
vnoremap K 10k
nnoremap <silent> <Up>    :resize +5<CR>
nnoremap <silent> <Down>  :resize -5<CR>
nnoremap <silent> <Left>  :vertical resize -5<CR>
nnoremap <silent> <Right> :vertical resize +5<CR>
nnoremap <C-H><C-H> gT
nnoremap <C-L><C-L> gt
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
" resize panels ... TODO I dont really use these
nnoremap <silent> <space>j :exe "resize " . (&lines * 3/2)<CR>
nnoremap <silent> <space>k :exe "resize " . (&lines * 2/3)<CR>
nnoremap <silent> <space>h :exe "vertical resize " . (&columns * 3/2)<CR>
nnoremap <silent> <space>l :exe "vertical resize " . (&columns * 2/3)<CR>

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

]])

vim.cmd([[
nnoremap \ :Rg<SPACE>
nnoremap <leader>fw :Rg <cword><CR>
]])

vim.cmd([[
nnoremap <space>c :ccl<cr>
nnoremap <space>q :wq!<cr>
nnoremap <space>e :e!<cr>
nnoremap <space>qq :q!<cr>
nnoremap <space>w :w<cr>
nnoremap <space>v :vs<cr>
nnoremap <space>s :sp<cr>
nnoremap <space>t :tabe<cr>
nnoremap <space>i :silent execute('!isort -q --dont-order-by-type ' . expand("%:p"))<cr>
nnoremap <space>f :Format<cr>
]])

vim.cmd([[
nnoremap ipdb Oimport ipdb; ipdb.set_trace()<ESC>
nnoremap rdb Ofrom celery.contrib import rdb; rdb.set_trace()<ESC>
]])

vim.cmd([[
" just do the obvious thing
command! W w
command! Wq wq
command! Q q
command! Vs vs
]])


vim.cmd([[
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
]])

require('neoclip').setup({
  keys = {
    telescope = {
      i = {
        paste_behind = '<c-o>',
      },
    },
  },
})
