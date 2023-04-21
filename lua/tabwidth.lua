function toggle_tabwidth(desired_tabwidth)
  desired_tabwidth = vim.api.nvim_get_option('tabstop')

  if desired_tabwidth then
    if desired_tabwidth ~= 2 and desired_tabwidth ~= 4 then
      print("Invalid tab width. Only 2 and 4 are supported.")
      return
    end
  elseif current_tabwidth == 2 then
    desired_tabwidth = 4
  elseif current_tabwidth == 4 then
    desired_tabwidth = 2
  else
    print("Current tab width is neither 2 nor 4. Not toggling.")
    return
  end

  vim.opt.tabstop = desired_tabwidth
  vim.opt.softtabstop = desired_tabwidth
  vim.opt.shiftwidth = desired_tabwidth
end

-- Expose the function as a global Vim command with optional argument
vim.cmd('command! -nargs=? ToggleTabWidth lua toggle_tabwidth(<args>)')

vim.api.nvim_set_keymap('n', '<C-t>', ':ToggleTabWidth<CR>', { noremap = true })

--toggle_tabwidth(4)
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

-- Add an autocmd to set the tab width to 2 for specific filetypes
-- TODO could clean this up somehow.
vim.cmd([[
  augroup SetTabWidth
    autocmd!
    autocmd FileType lua,js :ToggleTabWidth(2)
    autocmd FileType python :ToggleTabWidth(4)
  augroup END
]])
