
require('telescope').setup{
  defaults = {
      mappings = {
        i = {
          ["<C-j>"] = require('telescope.actions').move_selection_next,
          ["<C-k>"] = require('telescope.actions').move_selection_previous,
        },
      },
  },
  extensions = {
    hoogle = {
      render = 'default',       -- Select the preview render engine: default|treesitter
                                -- default = simple approach to render the document
                                -- treesitter = render the document by utilizing treesitter's html parser
      renders = {               -- Render specific options
        treesitter = {
          remove_wrap = false   -- Remove hoogle's own text wrapping. E.g. if you uses neovim's buffer wrapping
                                -- (autocmd User TelescopePreviewerLoaded setlocal wrap)
        }
      }
    }
  },
}

vim.cmd([[
" Telescope
nnoremap <leader>g <cmd>Telescope find_files<cr>
nnoremap <leader>sp <cmd>Telescope find_files cwd=~/sp/<cr>
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

-- Extensions
require('telescope').load_extension('vim_bookmarks')
require('telescope').load_extension('hoogle')

require("telescope").load_extension("refactoring")
-- remap to open the Telescope refactoring menu in visual mode
vim.api.nvim_set_keymap(
  "v",
  "<leader>rr",
  "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
  { noremap = true }
)
