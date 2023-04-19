-- line numbers
vim.opt.number = true
vim.opt.ruler = true

-- theme
vim.cmd([[ colorscheme ayu ]])
vim.opt.termguicolors = true
vim.g['airline#extensions#clock#format'] = '%H:%M'

vim.cmd([[
hi! link Constant Special
hi! link Parameter Constant
hi! link Type Special
hi Identifier guifg=foreground
hi CocHintSign guifg=#68959c
]])
