
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
      fzy_native = {
          override_generic_sorter = false,
          override_file_sorter = true,
      }
  }
}

--vim.keymap.set('n', '<leader>g', '<cmd>Telescope find_files<cr>', {})
-- TODO should probably be able to just get this from the rtp?
--vim.keymap.set('n', '<leader>nv', '<cmd>Telescope find_files cwd=~/.local/share/nvim/site/pack/packer/start<cr>', {})
-- vim.keymap.set('n', '<leader>fs', "<cmd>lua require('telescope.builtin').search_history()<cr>", {})
vim.keymap.set('n', '<leader>fm', '<cmd>Telescope harpoon marks<CR>', {})

--vim.keymap.set('n', '<leader>fs', "<cmd>lua require('telescope').extensions.luasnip.luasnip{}<cr>", {})

--require('telescope').load_extension('fzy_native')
