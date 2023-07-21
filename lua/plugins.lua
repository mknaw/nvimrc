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
      config = function()
        vim.g.NERDDefaultAlign = 'left'
      end,
  }
  use {
    'jremmen/vim-ripgrep',
    config = function()
      vim.keymap.set('n', '\\', ':Rg<SPACE>', {})
      vim.keymap.set('n', '<leader>fw', ':Rg <cword><CR>', {})
    end
  }
  use 'jiangmiao/auto-pairs'
  use { 'chrisbra/csv.vim', ft = { 'csv' } }
  use 'kana/vim-textobj-user'
  use 'chaoren/vim-wordmotion'
  use 'tpope/vim-surround'
  use {
    'nvim-treesitter/nvim-treesitter-context',
    config = function()
        require'treesitter-context'.setup{
          enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
          max_lines = 1, -- How many lines the window should span. Values <= 0 mean no limit.
          min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
          line_numbers = true,
          multiline_threshold = 1, -- Maximum number of lines to collapse for a single context line
          trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
          mode = 'topline',  -- Line used to calculate context. Choices: 'cursor', 'topline'
          -- Separator between context and content. Should be a single character string, like '-'.
          -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
          separator = nil,
          zindex = 20, -- The Z-index of the context window
          on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
        }
    end
  }
  use {
    'mattn/emmet-vim',
    ft = { 'html', 'typescriptreact' },
    opt = true,
    cmd = { 'EmmetInstall', 'EmmetUpdate', 'EmmetInstall!' },
  }
  use 'kshenoy/vim-signature'  -- gutter letters when making bookmarks
  use 'yssl/QFEnter'  -- open quickfix in various panes

  use {
    'L3MON4D3/LuaSnip',
    run = 'make install_jsregexp',
    config = function()
      require('luasnip.loaders.from_vscode').lazy_load() local ls = require 'luasnip'

      vim.keymap.set({ 'i', 's' }, '<c-s>', function()
        if ls.expand_or_jumpable() then
          ls.expand_or_jump()
        end
      end, { silent = true })

      vim.keymap.set({ 'i', 's' }, '<c-j>', function()
        if ls.expand_or_jumpable() then
          ls.jump(1)
        end
      end, { silent = true })

      vim.keymap.set({ 'i', 's' }, '<c-k>', function()
        if ls.expand_or_jumpable() then
          ls.jump(-1)
        end
      end, { silent = true })

      --vim.cmd([[
      --  " imap <silent><expr> <C-s> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<C-s>'
      --  inoremap <silent> <C-j> <cmd>lua require('luasnip').jump(1)<Cr>
      --  snoremap <silent> <C-j> <cmd>lua require('luasnip').jump(1)<Cr>
      --  inoremap <silent> <C-k> <cmd>lua require('luasnip').jump(-1)<Cr>
      --  snoremap <silent> <C-k> <cmd>lua require('luasnip').jump(-1)<Cr>
      --]])
    end,
  }
  use 'rafamadriz/friendly-snippets'
  use {
    'SirVer/ultisnips',
    cond = false,
    config = function()
      vim.g.UltiSnipsExpandTrigger = "<c-s>"
      vim.g.UltiSnipsListSnippets = "<c-_>"
      vim.g.UltiSnipsJumpForwardTrigger = "<c-j>"
      vim.g.UltiSnipsJumpBackwardTrigger = "<c-k>"
      vim.cmd([[
        let g#UltiSnipsSnippetDirectories = [$HOME."/.vim/snippets", $HOME."/.vim/plugged/vim_snippets/snippets"] 
      ]])
    end,
  }
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
  -- use 'ludovicchabant/vim-gutentags'
  use 'nvim-lua/plenary.nvim'
  use {
    'nvim-telescope/telescope.nvim',
    config = function()
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

      vim.keymap.set('n', '<leader>g', '<cmd>Telescope find_files<cr>', {})
      vim.keymap.set('n', '<leader>sp', '<cmd>Telescope find_files cwd=~/sp/<cr>', {})
      vim.keymap.set('n', '<leader>ei', '<cmd>Telescope find_files cwd=~/ei/<cr>', {})
      vim.keymap.set('n', '<leader>cf', '<cmd>Telescope find_files cwd=~/.config/nvim/<cr>', {})
      -- TODO should probably be able to just get this from the rtp?
      vim.keymap.set('n', '<leader>nv', '<cmd>Telescope find_files cwd=~/.local/share/nvim/site/pack/packer/start<cr>', {})
      vim.keymap.set('n', '<leader>b', '<cmd>Telescope buffers', {})
      vim.keymap.set('n', '<leader>t', "<cmd>lua require('telescope.builtin').tags()<cr>", {})
      vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', {})
      vim.keymap.set('n', '<leader>fo', "<cmd>lua require('telescope.builtin').oldfiles()<cr>", {})
      vim.keymap.set('n', '<leader>fh', "<cmd>lua require('telescope.builtin').help_tags()<cr>", {})
      vim.keymap.set('n', '<leader>fc', "<cmd>lua require('telescope.builtin').commands()<cr>", {})
      -- vim.keymap.set('n', '<leader>fs', "<cmd>lua require('telescope.builtin').search_history()<cr>", {})
      vim.keymap.set('n', '<leader>fq', "<cmd>lua require('telescope.builtin').quickfix()<cr>", {})
      vim.keymap.set('n', '<leader>fr', "<cmd>lua require('telescope.builtin').registers()<cr>", {})
      vim.keymap.set('n', '<leader>fz', "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>", {})
      vim.keymap.set('n', '<leader>fm', '<cmd>Telescope harpoon marks<CR>', {})

      require('telescope').load_extension('luasnip')
      vim.keymap.set('n', '<leader>fs', "<cmd>lua require('telescope').extensions.luasnip.luasnip{}<cr>", {})

      require('telescope').load_extension('fzy_native')
    end,
  }
  use 'nvim-telescope/telescope-fzy-native.nvim'
  use {
    'MattesGroeger/vim-bookmarks',
    opt = false,
    -- TODO extract some vars for the telescope bindings
    --keys = { 'n', '<leader>fm' },
    --config = function()
      --require('telescope').load_extension('vim_bookmarks')
      --vim.keymap.set('n', '<leader>fm', "<cmd>lua require('telescope').extensions.vim_bookmarks.all()<cr>", {})
    --end,
  }
  use {
    'ThePrimeagen/harpoon',
    requires = { 'nvim-telescope/telescope.nvim' },
    config = function()
      require("telescope").load_extension('harpoon')

      require('harpoon').setup({
        mark_branch = true,
        -- enable tabline with harpoon marks
        tabline = true,
      })

      vim.keymap.set('n', 'mm', '<cmd>lua require("harpoon.mark").add_file()<cr>', {})
      vim.keymap.set('n', 'mx', '<cmd>lua require("harpoon.mark").clear_all()<cr>', {})
      vim.keymap.set('n', 'm,', '<cmd>lua require("harpoon.ui").nav_prev()<cr>', {})
      vim.keymap.set('n', 'm.', '<cmd>lua require("harpoon.ui").nav_next()<cr>', {})
    end
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
      vim.keymap.set('n', '<leader>fy', "<cmd>lua require('telescope').extensions.neoclip.default()<cr>", {})
    end,
  }
  use {
    'benfowler/telescope-luasnip.nvim',
    module = 'telescope._extensions.luasnip',  -- if you wish to lazy-load
  }

  use 'mbbill/undotree'
  use 'jeetsukumaran/vim-indentwise'  -- jump by indents
  use {
    'github/copilot.vim',
    config = function()
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
      vim.api.nvim_set_keymap('i', '<C-^>', 'copilot#Accept("<CR>")', { silent = true, expr = true })
      -- vim.api.nvim_set_keymap('i', '<C-j>', 'copilot#Next<CR>', { silent = true, expr = true })
      -- vim.api.nvim_set_keymap('i', '<C-k>', 'copilot#Prev<CR>', { silent = true, expr = true })
      vim.api.nvim_set_keymap('n', '<space>p', ':Copilot panel<CR>', { silent = true, expr = true })
    end
  }
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
  use {
    'tpope/vim-fugitive',
    config = function()
      vim.keymap.set('n', 'ga', ':Git add .<CR>', {})
      vim.keymap.set('n', 'gs', ':Git<CR>', {})
      vim.keymap.set('n', 'gw', ':Gwrite<CR>', {})
      vim.keymap.set('n', 'gc', ':Git commit<CR>', {})
      vim.keymap.set('n', 'gca', ':Git commit --amend<CR>', {})
      vim.keymap.set('n', 'gcne', ':Git commit --amend --no-edit<CR>', {})
      vim.keymap.set('n', 'gd', ':Git diff<CR>', {})
      vim.keymap.set('n', 'gm', ':GMove ', {})
      vim.keymap.set('n', 'gco', ':GBranches<CR>', {})
      vim.keymap.set('n', 'grid', ':Git rebase -i develop<CR>', {})
      vim.keymap.set('n', 'gpoh', ':Git push origin head<CR>', {})
      vim.keymap.set('n', 'gpfoh', ':Git push --force origin head<CR>', {})
    end,
  }
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

          map('n', 'gb', function() gs.blame_line{full=true} end)
          map('n', 'rh', gs.reset_hunk)

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
        end
       })
    end,
  }
  use { 'kristijanhusak/vim-create-pr', opt = true, cmd = { 'PR' } }

  use {
    "klen/nvim-test",
    config = function()
      require('nvim-test').setup()
      vim.keymap.set('n', '<SPACE>x', ':TestNearest<CR>', {})
    end
  }

  -- syntax
  use {
    'neoclide/coc.nvim',
    config = function() require('coc-cfg') end,
  }
  use {
    'nvim-treesitter/nvim-treesitter',
    config = function()require('treesitter-cfg') end,
  }
  use { 'nvim-treesitter/playground', opt = true, cmd = { 'TSPlaygroundToggle', 'TSNodeUnderCursor' } }
  use {
    'psiska/telescope-hoogle.nvim',
    opt = true,
    ft = { 'haskell' },
    config = function()
      require('telescope').load_extension('hoogle')
      vim.keymap.set('n', '<leader>hg', "<cmd>lua require('telescope').extensions.hoogle.list()<cr>", {})
    end,
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
