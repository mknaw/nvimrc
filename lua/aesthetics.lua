-- line numbers
vim.opt.number = true
vim.opt.ruler = true

-- theme
vim.cmd([[ colorscheme ayu ]])
vim.opt.termguicolors = true
vim.g['airline#extensions#clock#format'] = '%H:%M'

vim.cmd([[
hi Identifier guifg=foreground
hi CocHintSign guifg=#68959c
]])

vim.api.nvim_set_hl(0, "Constant", { link = "Special" })
vim.api.nvim_set_hl(0, "Parameter", { link = "Special" })
vim.api.nvim_set_hl(0, "Type", { link = "Special" })
vim.api.nvim_set_hl(0, "@attribute", { link = "Special" })
vim.api.nvim_set_hl(0, "@attribute.builtin", { link = "Special" })
vim.api.nvim_set_hl(0, "@variable.builtin", { link = "Special" })
vim.api.nvim_set_hl(0, "@keyword", { link = "Special" })
vim.api.nvim_set_hl(0, "@parameter", { link = "Special" })
vim.api.nvim_set_hl(0, "@default_parameter.value", { link = "Statement" })
vim.api.nvim_set_hl(0, "@type_identifier", { link = "Statement" })
vim.api.nvim_set_hl(0, "@meta", { link = "DiffDelete" })

vim.cmd([[
:set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
  \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
  \,sm:block-blinkwait175-blinkoff150-blinkon175
]])
