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
