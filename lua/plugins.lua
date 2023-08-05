local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    "nvim-lua/plenary.nvim",
    --  LSPs
    {
        "neoclide/coc.nvim",
        build = "npm install",
        enabled = false,
        config = function() require("coc-cfg") end,
    },
    {
        "williamboman/mason.nvim",
        opts = {},
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
        config = function()
            require("mason-lspconfig").setup({
                handlers = {
                    function(server_name)
                        require("lspconfig")[server_name].setup {}
                    end,
                    --["rust_analyzer"] = function()
                    --    require("rust-tools").setup {}
                    --end,
                    ["lua_ls"] = function()
                        require("lspconfig").lua_ls.setup {
                            settings = {
                                Lua = {
                                    diagnostics = {
                                        globals = { "vim" }
                                    }
                                }
                            }
                        }
                    end,
                }
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function() require("user.lsp") end,
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "neovim/nvim-lspconfig",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
        lazy = true,
        event = "InsertEnter",
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'buffer' },
                }),
                mapping = {
                    ["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s" }),
                    ["<CR>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    }),
                },
                confirm_opts = {
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = false,
                },
            })
        end,
    },

    -- Snippets
    {
        "L3MON4D3/LuaSnip",
        build = "make install_jsregexp",
        dependencies = {
            "rafamadriz/friendly-snippets",
            "molleweide/LuaSnip-snippets.nvim",
        },
        lazy = true,
        event = "InsertEnter",
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
            local ls = require "luasnip"

            vim.keymap.set({ "i", "s" }, "<c-s>", function()
                if ls.expand_or_jumpable() then
                    ls.expand_or_jump()
                end
            end, { silent = true })

            vim.keymap.set({ "i", "s" }, "<c-j>", function()
                if ls.expand_or_jumpable() then
                    ls.jump(1)
                end
            end, { silent = true })

            vim.keymap.set({ "i", "s" }, "<c-k>", function()
                if ls.expand_or_jumpable() then
                    ls.jump(-1)
                end
            end, { silent = true })
        end,
    },

    -- AIs
    {
        "zbirenbaum/copilot.lua",
        lazy = true,
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                suggestion = {
                    enabled = true,
                    auto_trigger = true,
                    debounce = 75,
                    keymap = {
                        accept = "<C-^>",
                        accept_word = false,
                        accept_line = false,
                        next = "<C-j>",
                        prev = "<C-k>",
                    },
                },
            })
        end,
    },

    -- treesitters
    {
        "nvim-treesitter/nvim-treesitter",
        enabled = true,
        config = function()
            require("nvim-treesitter.configs").setup({
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                incremental_selection = { enable = false },
                textobjects = { enable = false },
            })
        end,
    },
    {
        'nvim-treesitter/nvim-treesitter-context',
        dependencies = { 'nvim-treesitter' },
        enabled = false,
        config = function()
            require 'treesitter-context'.setup {
                enable = true,           -- Enable this plugin (Can be enabled/disabled later via commands)
                max_lines = 1,           -- How many lines the window should span. Values <= 0 mean no limit.
                min_window_height = 0,   -- Minimum editor window height to enable context. Values <= 0 mean no limit.
                line_numbers = true,
                multiline_threshold = 1, -- Maximum number of lines to collapse for a single context line
                trim_scope = 'outer',    -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
                mode = 'topline',        -- Line used to calculate context. Choices: 'cursor', 'topline'
                -- Separator between context and content. Should be a single character string, like '-'.
                -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
                separator = nil,
                zindex = 20,     -- The Z-index of the context window
                on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
            }
        end
    },
    {
        'windwp/nvim-ts-autotag',
        dependencies = { 'nvim-treesitter' },
        opts = {},
    },

    --telescopes
    {
        "nvim-telescope/telescope.nvim",
        lazy = true,
        cmd = "Telescope",
        keys = {
            { "<leader>g",  "<cmd>Telescope find_files<cr>" },
            -- TODO some of these file specific ones are only relevant in some directories...
            -- and also it seems like it'd be better to take their vals from env var?
            { "<leader>sp", "<cmd>Telescope find_files cwd=~/sp/<cr>" },
            { "<leader>ei", "<cmd>Telescope find_files cwd=~/ei/<cr>" },
            { "<leader>cf", "<cmd>Telescope find_files cwd=~/.config/nvim/<cr>" },
            { "<leader>b",  "<cmd>Telescope buffers" },
            --{ "<leader>t",  "<cmd>lua require('telescope.builtin').tags()<cr>" },
            { "<leader>fg", "<cmd>Telescope live_grep<cr>" },
            { "<leader>fo", "<cmd>lua require('telescope.builtin').oldfiles()<cr>" },
            { "<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<cr>" },
            { "<leader>fc", "<cmd>lua require('telescope.builtin').commands()<cr>" },
            { "<leader>fq", "<cmd>lua require('telescope.builtin').quickfix()<cr>" },
            { "<leader>fr", "<cmd>lua require('telescope.builtin').registers()<cr>" },
            { "<leader>fz", "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>" },
        },
        config = function()
            require('telescope').setup {
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
        end,
    },
    {
        'benfowler/telescope-luasnip.nvim',
        dependencies = { 'nvim-telescope/telescope.nvim', 'L3MON4D3/LuaSnip' },
        lazy = true,
        keys = {
            { "<leader>fs", function() require('telescope').extensions.luasnip.luasnip {} end },
        },
    },

    -- Search
    {
        'jremmen/vim-ripgrep',
        lazy = true,
        keys = {
            { '\\',         ':Rg<SPACE>' },
            { '<leader>fw', ':Rg <cword><CR>' },
        }
    },
    {
        "brooth/far.vim",
        lazy = true,
        cmd = { "Far" },
        config = function()
            vim.g["far#source"] = "rg"
            vim.g["far#default_file_mask"] = "/"
            vim.g["far#window_width"] = 120
        end
    },

    { -- Filetree browser
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
        },
        lazy = true,
        keys = {
            { "<C-n>", "<cmd>Neotree toggle<cr>" },
        }
    },

    {
        "chaoren/vim-wordmotion",
        enabled = false,
        config = function()
            vim.g.wordmotion_prefix = "<leader>"
        end,
    },
    {
        "tpope/vim-surround",
        lazy = true,
        keys = {
            { "S", mode = "v" },
        }
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {}
    },
    {
        "chrisbra/csv.vim",
        lazy = true,
        ft = { "csv" },
    },
    "kshenoy/vim-signature", -- gutter letters when making bookmarks
    "yssl/QFEnter",          -- open quickfix in various panes
    {
        dir = "~/.config/nvim/plugin/argtextobj.vim",
        enabled = false,
    },
    "lukas-reineke/indent-blankline.nvim",

    -- aesthetics
    "ayu-theme/ayu-vim",
    {
        'nvim-lualine/lualine.nvim',
        config = function() require('lualine-cfg') end,
    },

    {
        "scrooloose/nerdcommenter",
        --lazy = true,  TODO dont know how to make it work
        --keys = { "<leader>cc" },
        --cmd = { "NERDCommenterToggle" },
        config = function()
            vim.g.NERDDefaultAlign = "left"
        end,
    },

    -- vcs
    {
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

                    map('n', 'gb', function() gs.blame_line { full = true } end)
                    map('n', 'rh', gs.reset_hunk)

                    -- Navigation
                    map('n', ']c',
                        function()
                            if vim.wo.diff then return ']c' end
                            vim.schedule(function() gs.next_hunk() end)
                            return '<Ignore>'
                        end,
                        { expr = true }
                    )

                    map('n', '[c',
                        function()
                            if vim.wo.diff then return '[c' end
                            vim.schedule(function() gs.prev_hunk() end)
                            return '<Ignore>'
                        end,
                        { expr = true }
                    )
                end
            })
        end,
    },
    {
        'tpope/vim-fugitive',
        lazy = true,
        keys = {
            { 'ga',   ':Git add .<CR>' },
            { 'gs',   ':Git<CR>' },
            { 'gw',   ':Gwrite<CR>' },
            { 'gc',   ':Git commit<CR>' },
            { 'gca',  ':Git commit --amend<CR>' },
            { 'gcne', ':Git commit --amend --no-edit<CR>' },
            { 'gd',   ':Git diff<CR>' },
            { 'gm',   ':GMove ' },
            { 'gco',  ':GBranches<CR>' },
            { 'grid', ':Git rebase -i develop<CR>' },
            { 'gpoh', ':Git push origin head<CR>' },
            { 'gpfoh', ':Git push --force origin head<CR>'
            } },
    },
    {
        'kristijanhusak/vim-create-pr',
        lazy = true,
        cmd = { 'PR' },
    },

    --{
    --    "folke/trouble.nvim",
    --    dependencies = { "nvim-tree/nvim-web-devicons" },
    --    lazy = true,
    --    keys = { "<space>xx", "<cmd>TroubleToggle<cr>" },
    --    cmd = { "TroubleToggle" },
    --    opts = {
    --        mode = "document_diagnostics",
    --    }
    --}
})

--require('packer').startup(function(use)
--  use {
--    'mattn/emmet-vim',
--    ft = { 'html', 'typescriptreact' },
--    opt = true,
--    cmd = { 'EmmetInstall', 'EmmetUpdate', 'EmmetInstall!' },
--  }


--  use {
--    'SirVer/ultisnips',
--    cond = false,
--    config = function()
--      vim.g.UltiSnipsExpandTrigger = "<c-s>"
--      vim.g.UltiSnipsListSnippets = "<c-_>"
--      vim.g.UltiSnipsJumpForwardTrigger = "<c-j>"
--      vim.g.UltiSnipsJumpBackwardTrigger = "<c-k>"
--      vim.cmd([[
--        let g#UltiSnipsSnippetDirectories = [$HOME."/.vim/snippets", $HOME."/.vim/plugged/vim_snippets/snippets"]
--      ]])
--    end,
--  }
--  use 'honza/vim-snippets'

--  use {
--    'Wansmer/treesj',
--    requires = { 'nvim-treesitter' },
--    config = function()
--      require('treesj').setup({
--        use_default_keymaps = false,
--      })
--      vim.keymap.set('n', '<space>m', require('treesj').toggle)
--    end,
--  }
--  -- use 'ludovicchabant/vim-gutentags'
--  use 'nvim-telescope/telescope-fzy-native.nvim'
--  use {
--    'MattesGroeger/vim-bookmarks',
--    opt = false,
--    -- TODO extract some vars for the telescope bindings
--    --keys = { 'n', '<leader>fm' },
--    --config = function()
--      --require('telescope').load_extension('vim_bookmarks')
--      --vim.keymap.set('n', '<leader>fm', "<cmd>lua require('telescope').extensions.vim_bookmarks.all()<cr>", {})
--    --end,
--  }
--  use {
--    'ThePrimeagen/harpoon',
--    requires = { 'nvim-telescope/telescope.nvim' },
--    config = function()
--      require("telescope").load_extension('harpoon')

--      require('harpoon').setup({
--        mark_branch = true,
--        -- enable tabline with harpoon marks
--        tabline = true,
--      })

--      vim.keymap.set('n', 'mm', '<cmd>lua require("harpoon.mark").add_file()<cr>', {})
--      vim.keymap.set('n', 'mx', '<cmd>lua require("harpoon.mark").clear_all()<cr>', {})
--      vim.keymap.set('n', 'm,', '<cmd>lua require("harpoon.ui").nav_prev()<cr>', {})
--      vim.keymap.set('n', 'm.', '<cmd>lua require("harpoon.ui").nav_next()<cr>', {})
--    end
--  }
--  use 'tom-anders/telescope-vim-bookmarks.nvim'
--  use {
--    'AckslD/nvim-neoclip.lua',
--    requires = { 'nvim-telescope/telescope.nvim' },
--    config = function()
--      require('neoclip').setup({
--        keys = {
--          telescope = {
--            i = {
--              paste_behind = '<c-o>',
--            },
--          },
--        },
--      })
--      vim.keymap.set('n', '<leader>fy', "<cmd>lua require('telescope').extensions.neoclip.default()<cr>", {})
--    end,
--  }

--  use 'mbbill/undotree'
--  use 'jeetsukumaran/vim-indentwise'  -- jump by indents
--  --use 'andythigpen/nvim-coverage'
--  use {
--    'ThePrimeagen/refactoring.nvim',
--    opt = true,
--    keys = { 'v', '<leader>rr' },
--    config = function()
--        require('telescope').load_extension('refactoring')
--        -- remap to open the Telescope refactoring menu in visual mode
--        vim.api.nvim_set_keymap(
--          'v',
--          '<leader>rr',
--          "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
--          { noremap = true }
--        )
--    end,
--  }


--  --use {
--  --  "klen/nvim-test",
--  --  requires = { 'nvim-treesitter' },
--  --  config = function()
--  --    require('nvim-test').setup()
--  --    vim.keymap.set('n', '<SPACE>x', ':TestNearest<CR>', {})
--  --  end
--  --}

--  use {
--    'psiska/telescope-hoogle.nvim',
--    opt = true,
--    ft = { 'haskell' },
--    config = function()
--      require('telescope').load_extension('hoogle')
--      vim.keymap.set('n', '<leader>hg', "<cmd>lua require('telescope').extensions.hoogle.list()<cr>", {})
--    end,
--  }

--end)

--vim.g.user_emmet_leader_key = '<C-y>'
--vim.cmd([[
--let g:user_emmet_settings = {
--\  'html' : {
--\    'block_all_childless' : 1,
--\  },
--\}
--]])
