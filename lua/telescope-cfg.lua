
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

vim.cmd([[
" Telescope
nnoremap <leader>g <cmd>Telescope find_files<cr>
nnoremap <leader>sp <cmd>Telescope find_files cwd=~/sp/<cr>
nnoremap <leader>cf <cmd>Telescope find_files cwd=~/.config/nvim/<cr>
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
nnoremap <leader>hg <cmd>lua require('telescope').extensions.hoogle.list()<cr>
]])
