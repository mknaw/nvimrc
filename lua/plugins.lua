-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use {
    'kyazdani42/nvim-tree.lua',
    opt = True,
    cmd = { 'NvimTreeToggle' },
    keys = { 'n', '<C-n>' },
    config = function()
      require('nvim-tree').setup()
      vim.api.nvim_set_keymap("n", "<C-n>", ':NvimTreeToggle<CR>', { silent = true })
    end,
  }
  use 'kyazdani42/nvim-web-devicons'
  use { 'brooth/far.vim', opt = true, cmd = { 'Far' } }
  use {
      'scrooloose/nerdcommenter',
      opt = true,
      keys = { '<leader>cc', '<leader>cu' },
      cmd = { 'NERDCommenterToggle', 'NERDCommenter' },
  }
  use { 'jremmen/vim-ripgrep', opt = true, cmd = { 'Rg' } }
  use 'jiangmiao/auto-pairs'
  use { 'chrisbra/csv.vim', ft = { 'csv' } }
  use 'kana/vim-textobj-user'
  use 'chaoren/vim-wordmotion'
  use 'tpope/vim-surround'
  use {
    'mattn/emmet-vim',
    ft = { 'html' },
    opt = true,
    cmd = { 'EmmetInstall', 'EmmetUpdate', 'EmmetInstall!' },
  }
  use 'kshenoy/vim-signature'  -- gutter letters when making bookmarks
  use 'yssl/QFEnter'  -- open quickfix in various panes
  -- TODO
  --use {
    --'L3MON4D3/LuaSnip',
    --run = 'make install_jsregexp',
    --config = function()
        --vim.cmd([[ imap <silent><expr> <C-s> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>' ]])
    --end,
  --}
  use 'SirVer/ultisnips'
  use 'honza/vim-snippets'
  use {
    'Wansmer/treesj',
    requires = { 'nvim-treesitter' },
    config = function()
      require('treesj').setup({
        use_default_keymaps = false,
      })
      vim.keymap.set('n', '<space>m', require('treesj').toggle)
    end,
  }
  use 'ludovicchabant/vim-gutentags'
  use 'nvim-lua/plenary.nvim'
  use {
    'nvim-telescope/telescope.nvim',
    config = function() require('telescope-cfg') end,
  }
  use {
    'MattesGroeger/vim-bookmarks',
    opt = true,
    -- TODO extract some vars for the telescope bindings
    keys = { 'n', '<leader>fm' },
    config = function() require('telescope').load_extension('vim_bookmarks') end,
  }
  use 'tom-anders/telescope-vim-bookmarks.nvim'
  use {
    'AckslD/nvim-neoclip.lua',
    requires = { 'nvim-telescope/telescope.nvim' },
    config = function()
      require('neoclip').setup({
        keys = {
          telescope = {
            i = {
              paste_behind = '<c-o>',
            },
          },
        },
      })
    end,
  }
  use 'mbbill/undotree'
  use 'jeetsukumaran/vim-indentwise'  -- jump by indents
  use 'github/copilot.vim'
  --use 'andythigpen/nvim-coverage'
  use {
    'ThePrimeagen/refactoring.nvim',
    opt = true,
    keys = { 'v', '<leader>rr' },
    config = function()
        require('telescope').load_extension('refactoring')
        -- remap to open the Telescope refactoring menu in visual mode
        vim.api.nvim_set_keymap(
          'v',
          '<leader>rr',
          "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
          { noremap = true }
        )
    end,
  }

  -- VCS
  use 'tpope/vim-fugitive'
  use {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup({
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map('n', ']c',
            function()
              if vim.wo.diff then return ']c' end
              vim.schedule(function() gs.next_hunk() end)
              return '<Ignore>'
            end,
            {expr=true}
          )

          map('n', '[c',
            function()
              if vim.wo.diff then return '[c' end
              vim.schedule(function() gs.prev_hunk() end)
              return '<Ignore>'
            end,
            {expr=true}
          )
          
          map('n', 'gb', function() gs.blame_line{full=true} end)
        end
       })
    end,
  }
  use { 'kristijanhusak/vim-create-pr', opt = true, cmd = { 'PR' } }

  -- syntax
  use {
    'neoclide/coc.nvim',
    config = function() require('coc-cfg') end,
  }
  use {
    'nvim-treesitter/nvim-treesitter',
    config = function() require('treesitter-cfg') end,
  }
  use { 'nvim-treesitter/playground', opt = true, cmd = { 'TSPlaygroundToggle', 'TSNodeUnderCursor' } }
  use {
    'psiska/telescope-hoogle.nvim',
    opt = true,
    ft = { 'haskell' },
    config = function() require('telescope').load_extension('hoogle') end,
  }
  use 'lukas-reineke/indent-blankline.nvim'

  -- aesthetics
  use 'ayu-theme/ayu-vim'
  use {
    'nvim-lualine/lualine.nvim',
    config = function() require('lualine-cfg') end,
  }

end)

vim.cmd([[ source ~/.config/nvim/plugin/argtextobj.vim ]])

vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.api.nvim_set_keymap('i', '<C-^>', 'copilot#Accept("<CR>")', { silent = true, expr = true })
vim.api.nvim_set_keymap('i', '<C-j>', 'copilot#Next<CR>', { silent = true, expr = true })
vim.api.nvim_set_keymap('i', '<C-k>', 'copilot#Prev<CR>', { silent = true, expr = true })
vim.api.nvim_set_keymap('n', '<space>p', ':Copilot panel<CR>', { silent = true, expr = true })


vim.cmd([[
let g:far#source = 'rg'
" let g:far#source = 'rgnvim'
let g:far#default_file_mask = '/'
let g:far#window_width = 120
vnoremap <C-g> "hy:Far<SPACE><C-r>h<SPACE>
]])

vim.g.user_emmet_leader_key = '<C-y>'
vim.cmd([[
let g:user_emmet_settings = {
\  'html' : {
\    'block_all_childless' : 1,
\  },
\}
]])

vim.g.UltiSnipsExpandTrigger = "<c-s>"
vim.g.UltiSnipsListSnippets = "<c-_>"
vim.g.UltiSnipsJumpForwardTrigger = "<c-j>"
vim.g.UltiSnipsJumpBackwardTrigger = "<c-k>"
vim.cmd([[
let g#UltiSnipsSnippetDirectories = [$HOME."/.vim/snippets", $HOME."/.vim/plugged/vim_snippets/snippets"] 
]])

require('gitsigns').setup()
