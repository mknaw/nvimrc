local set = vim.opt

set.runtimepath:append(',~/.config/nvim')

vim.g.mapleader = ','

require('plugins')
require('aesthetics')

vim.g.python_host_prog = '/usr/local/bin/python2'
vim.g.python3_host_prog = '~/.pyenv/versions/nvim/bin/python3'
vim.g.node_host_prog = '/usr/local/opt/node/bin/node'
vim.g.copilot_node_command = '/usr/local/opt/node/bin/node'

vim.cmd([[ command! Vimrc tabe ~/.config/nvim/init.lua ]])

set.shell = 'zsh'

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
vim.keymap.set({ 'n', 'v' }, 'J', '14j', {})
vim.keymap.set({ 'n', 'v' }, 'K', '14k', {})

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
vim.keymap.set('v', '<C-C>', '"+y', {})
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


local toggle_qf = function()
  local qf_exists = false
  for _, win in pairs(vim.fn.getwininfo()) do
    if win["quickfix"] == 1 then
      qf_exists = true
    end
  end
  if qf_exists == true then
    vim.cmd "cclose"
    return
  end
  if not vim.tbl_isempty(vim.fn.getqflist()) then
    vim.cmd "copen"
  end
end

vim.keymap.set('n', '<space>c', toggle_qf, {})
vim.keymap.set('n', '<space>wq', ':wq!<cr>', {})
vim.keymap.set('n', '<space>wa', ':wall!<cr>', {})
vim.keymap.set('n', '<space>wqa', ':wqall!<cr>', {})
vim.keymap.set('n', '<space>qa', ':qall!<cr>', {})
vim.keymap.set('n', '<space>e', ':e!<cr>', {})
vim.keymap.set('n', '<space>qq', ':q!<cr>', {})
vim.keymap.set('n', '<space>w', ':w<cr>', {})
vim.keymap.set('n', '<space>v', ':vs<cr>', {})
vim.keymap.set('n', '<space>s', ':sp<cr>', {})
vim.keymap.set('n', '<space>t', ':tabe<cr>', {})

-- TODO python only
vim.cmd([[
nnoremap ipdb Oimport ipdb; ipdb.set_trace()<ESC>
nnoremap rdb Ofrom celery.contrib import rdb; rdb.set_trace()<ESC>
nnoremap <space>i :silent execute('!isort -q --dont-order-by-type ' . expand("%:p"))<cr>
]])

local function set_tab_settings(size)
  return function()
    vim.bo.tabstop = size
    vim.bo.shiftwidth = size
    vim.bo.softtabstop = size
  end
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = set_tab_settings(4),
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "typescript", "typescriptreact" },
  callback = set_tab_settings(2),
})

vim.cmd([[
" just do the obvious thing
command! W w
command! Wq wq
command! Q q
command! Vs vs
]])

vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3

--jq_filter = function()
--  local old_reg = vim.fn.getreg('"')
--  vim.cmd('normal! gvy')
--  local cmd = 'echo ' .. vim.fn.shellescape(vim.fn.getreg('"'), true) .. ' | jq .'
--  local result = vim.fn.system(cmd)
--  vim.cmd('normal! "_d')
--  vim.cmd('put =' .. vim.fn.shellescape(result, true))
--  vim.fn.setreg('"', old_reg)
--end

--vim.cmd('command! -range=% Jq <line1>,<line2>lua jq_filter()')

local pyjq = function()
  -- Yank the selection into the unnamed register
  vim.cmd('normal! gvy')

  -- Create a command string to pass the yanked text into the Python script
  local cmd = 'echo ' .. vim.fn.shellescape(vim.fn.getreg('"'), true) .. ' | pyjq'

  -- Execute the command
  local result = vim.fn.systemlist(cmd)

  -- Open a new buffer in a split
  vim.cmd('new')
  vim.cmd('set filetype=json')

  -- Get the buffer number for the current buffer
  local bufnr = vim.api.nvim_get_current_buf()

  -- Set the lines of the buffer to the output
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, result)
end

-- Note that the function call now includes the table name
vim.cmd('command! -range=% Pyjq <line1>,<line2>lua pyjq()')

pyxml = function()
  -- Yank the selection into the unnamed register
  vim.cmd('normal! gvy')

  -- Create a command string to pass the yanked text into the Python script
  local cmd = 'echo ' .. vim.fn.shellescape(vim.fn.getreg('"'), true) .. ' | pyxml'

  -- Execute the command
  local result = vim.fn.systemlist(cmd)

  -- Open a new buffer in a split
  vim.cmd('new')
  vim.cmd('set filetype=xml')

  -- Get the buffer number for the current buffer
  local bufnr = vim.api.nvim_get_current_buf()

  -- Set the lines of the buffer to the output
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, result)
end

-- Note that the function call now includes the table name
vim.cmd('command! -range=% Pyxml <line1>,<line2>lua pyxml()')

vim.cmd([[
    set textwidth=120
    set formatoptions-=t
]])

--vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
--  callback = function() vim.opt.syntax = "off" end
--})
set.cursorline = true

-- Sync clipboard with system clipboard
-- vim.o.clipboard = 'unnamedplus'

set.scrolloff = 5


-- Hide semantic highlights for functions
vim.api.nvim_set_hl(0, '@lsp.type.function', {})

-- Hide all semantic highlights
for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
  vim.api.nvim_set_hl(0, group, {})
end
-- TODO
-- You probably want these inside a |ColorScheme| autocommand.
--
-- " lazy drawing
set.lazyredraw = true
set.ttyfast    = true

vim.api.nvim_set_hl(0, "FloatBorder", { link = "TelescopeNormal" })
vim.api.nvim_set_hl(0, "ErrorMsg", { link = "Todo" })

vim.api.nvim_create_user_command(
  'Rgf',
  function()
    local fileName = vim.fn.expand('%:t')
    vim.api.nvim_command("Rg '" .. fileName .. "'")
  end,
  {}
)

vim.cmd [[
  au BufNewFile,BufRead *.avsc set filetype=json
]]
