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
                    ["rust_analyzer"] = function()
                        require("rust-tools").setup {}
                        require("lspconfig").rust_analyzer.setup {
                            settings = {
                                ["rust-analyzer"] = {
                                    checkOnSave = {
                                        command = "clippy",
                                    },
                                },
                            },
                        }
                    end,
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
                    ["pyright"] = function()
                        require("lspconfig").pyright.setup {
                            -- TODO probably want our own root_dir instead of hacking the default_config
                            -- or just take an env var...
                            settings = {
                                python = {
                                    analysis = {
                                        autoSearchPaths = true,
                                        useLibraryCodeForTypes = true,
                                        diagnosticMode = 'openFilesOnly',
                                        -- diagnosticMode = 'workspace',
                                    },
                                },
                            },
                        }
                    end,
                    ["hls"] = function()
                        require('lspconfig')['hls'].setup {
                            filetypes = { 'haskell', 'lhaskell', 'cabal' },
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
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
            local null_ls = require("null-ls")
            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.prettier,
                    -- null_ls.builtins.diagnostics.eslint,
                    -- null_ls.builtins.completion.spell,
                    null_ls.builtins.formatting.black.with({
                        extra_args = { "-S", "-l", "120" },
                    }),
                }
            })
        end
    },
    {
        'nvimdev/lspsaga.nvim',
        enabled = false, -- Seems buggy?
        opts = {
            lightbulb = {
                enable = false,
            },
            symbol_in_winbar = {
                enable = false,
            },
        },
        event = 'LspAttach',
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'nvim-tree/nvim-web-devicons',
        }
    },
    {
        'simrat39/rust-tools.nvim',
        dependencies = {
            'neovim/nvim-lspconfig',
        }
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
            "onsails/lspkind.nvim",
        },
        lazy = true,
        event = "InsertEnter",
        config = function()
            local cmp = require("cmp")
            local lspkind = require("lspkind")
            cmp.setup({
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
                sources = cmp.config.sources({
                    {
                        name = 'nvim_lsp',
                        entry_filter = function(entry, ctx)
                            local types = require('cmp.types')
                            local kind = types.lsp.CompletionItemKind[entry:get_kind()]
                            if kind == "Text" then return false end
                            return true
                        end
                    },
                    { name = 'luasnip' },
                    { name = 'buffer' },
                    { name = 'path' },
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
                formatting = {
                    format = lspkind.cmp_format({
                        mode = 'symbol',       -- show only symbol annotations
                        maxwidth = 50,         -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                        ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
                    })
                }
            })
            cmp.setup.cmdline({ '/', '?' }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = 'buffer' }
                }
            })

            -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = 'path' }
                }, {
                    { name = 'cmdline' }
                })
            })
        end,
    },

    -- Snippets
    {
        "L3MON4D3/LuaSnip",
        build = "make install_jsregexp",
        dependencies = {
            "rafamadriz/friendly-snippets",
            --"molleweide/LuaSnip-snippets.nvim",
        },
        lazy = true,
        event = "InsertEnter",
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
            require("user.snippets")
            local ls = require "luasnip"
            --ls.snippets = require("luasnip_snippets").load_snippets()

            vim.keymap.set({ "i", "s" }, "<c-s>", function()
                if ls.expand_or_jumpable() then
                    ls.expand_or_jump()
                end
            end, { silent = true })

            ls.config.set_config({
                store_selection_keys = '<c-s>',
            })

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
                        -- next = "<C-j>",
                        -- prev = "<C-k>",
                    },
                },
            })
        end,
    },
    {
        "jackMort/ChatGPT.nvim",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim"
        },
        event = "VeryLazy",
        -- TODO replace me with gpt-4, eventually
        config = function()
            require("chatgpt").setup({
                yank_register = "",
                actions_paths = {
                    "~/.config/nvim/chatgpt_run_actions.json",
                },
                chat = {
                    -- apparently not fucking usable!
                    keymaps = {
                        close = { "<C-c>" },
                        yank_last = "<C-a>",
                        -- yank_last_code = "<C-k>",
                        scroll_up = "<C-u>",
                        scroll_down = "<C-d>",
                        new_session = "<C-n>",
                        cycle_windows = "<Tab>",
                        cycle_modes = "<C-f>",
                        select_session = "<Space>",
                        rename_session = "r",
                        delete_session = "d",
                        -- draft_message = "<C-d>",
                        toggle_settings = "<C-d>",
                        toggle_message_role = "<C-r>",
                        toggle_system_role_open = "<C-s>",
                        stop_generating = "<C-x>",
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
                textobjects = {
                    select = {
                        enable = true
                    },
                    move = {
                        enable = true,
                        set_jumps = true, -- whether to set jumps in the jumplist
                        goto_next_start = {
                            ["]m"] = "@function.outer",
                            -- ["]]"] = { query = "@class.outer", desc = "Next class start" },
                            --
                            -- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queires.
                            -- ["]o"] = "@loop.*",
                            -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
                            --
                            -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
                            -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
                            ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
                            ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
                        },
                        goto_next_end = {
                            ["]M"] = "@function.outer",
                            ["]["] = "@class.outer",
                        },
                        goto_previous_start = {
                            ["[m"] = "@function.outer",
                            -- ["[["] = "@class.outer",
                        },
                        goto_previous_end = {
                            ["[M"] = "@function.outer",
                            ["[]"] = "@class.outer",
                        },
                        -- Below will go to either the start or the end, whichever is closer.
                        -- Use if you want more granular movements
                        -- Make it even more gradual by adding multiple queries and regex.
                        -- goto_next = {
                        --     ["]d"] = "@conditional.outer",
                        -- },
                        -- goto_previous = {
                        --     ["[d"] = "@conditional.outer",
                        -- }
                    },
                    swap = {
                        enable = true
                    },
                },
                use_languagetree = false,
                additional_vim_regex_highlighting = false,
                indent = {
                    enable = false
                },
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
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
        "windwp/nvim-ts-autotag",
        dependencies = { "nvim-treesitter" },
        lazy = true,
        event = "InsertEnter",
        opts = {},
    },
    {
        "nvim-treesitter/playground",
        dependencies = { "nvim-treesitter" },
        lazy = true,
        cmd = { "TSPlaygroundToggle", "TSNodeUnderCursor" },
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
            { "<leader>nv", "<cmd>Telescope find_files cwd=~/.local/share/nvim/lazy/<cr>" },
            -- { "<leader>b",  "<cmd>Telescope buffers" },
            --{ "<leader>t",  "<cmd>lua require('telescope.builtin').tags()<cr>" },
            { "<leader>fg", "<cmd>Telescope live_grep<cr>" },
            { "<leader>fo", "<cmd>lua require('telescope.builtin').oldfiles()<cr>" },
            { "<leader>fj", "<cmd>lua require('telescope.builtin').jumplist()<cr>" },
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
        event = "VeryLazy",
        keys = {
            { "<C-n>", "<cmd>Neotree toggle<cr>" },
        },
        opts = {
            hijack_netrw_behavior = "open_default",
        },
    },

    {
        "tpope/vim-surround",
        lazy = false,
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
    {
        "chentoast/marks.nvim", -- gutter letters when making bookmarks
        opts = {
            refresh_interval = 500,
        }
    },
    "yssl/QFEnter", -- open quickfix in various panes
    {
        dir = "~/.config/nvim/plugin/argtextobj.vim",
        enabled = false,
    },

    -- nav
    {
        "ggandor/leap.nvim",
        lazy = true,
        keys = { "s", "S" },
        config = function()
            require('leap').add_default_mappings()
            vim.keymap.del('v', 'x')
        end
    },
    {
        "ThePrimeagen/harpoon",
        dependencies = { 'nvim-telescope/telescope.nvim' },
        lazy = true,
        keys = {
            { 'mm',         '<cmd>lua require("harpoon.mark").add_file()<cr>' },
            { 'mx',         '<cmd>lua require("harpoon.mark").clear_all()<cr>' },
            { 'm,',         '<cmd>lua require("harpoon.ui").nav_prev()<cr>' },
            { 'm.',         '<cmd>lua require("harpoon.ui").nav_next()<cr>' },
            { '<leader>fm', '<cmd>Telescope harpoon marks<cr>' },
        },
        opts = {
            mark_branch = true,
        },
        config = function()
            require("telescope").load_extension("harpoon")
        end
    },
    -- motions
    {
        "chaoren/vim-wordmotion",
        init = function()
            vim.g.wordmotion_prefix = "<leader>"
        end,
    },
    {
        "kana/vim-smartword",
        keys = {
            { "w",  "<Plug>(smartword-w)" },
            { "e",  "<Plug>(smartword-e)" },
            { "b",  "<Plug>(smartword-b)" },
            { "ge", "<Plug>(smartword-ge)" },
        }
    },
    {
        "chrisgrieser/nvim-various-textobjs",
        lazy = false,
        config = function()
            require("various-textobjs").setup({ useDefaultKeymaps = true })
            vim.keymap.set("n", "dsi", function()
                -- select inner indentation
                require("various-textobjs").indentation(true, true)

                -- plugin only switches to visual mode when a textobj has been found
                local notOnIndentedLine = vim.fn.mode():find("V") == nil
                if notOnIndentedLine then return end

                -- dedent indentation
                vim.cmd.normal { "<", bang = true }

                -- delete surrounding lines
                local endBorderLn = vim.api.nvim_buf_get_mark(0, ">")[1] + 1
                local startBorderLn = vim.api.nvim_buf_get_mark(0, "<")[1] - 1
                vim.cmd(tostring(endBorderLn) .. " delete") -- delete end first so line index is not shifted
                vim.cmd(tostring(startBorderLn) .. " delete")
            end, { desc = "Delete surrounding indentation" })
        end
    },
    {
        "drybalka/tree-climber.nvim",
        keys = {
            { "gh",         "<cmd>lua require('tree-climber').goto_parent()<cr>", mode = { "n", "v", "o" }, silent = true },
            { "gl",         "<cmd>lua require('tree-climber').goto_child()<cr>",  mode = { "n", "v", "o" }, silent = true },
            { "gj",         "<cmd>lua require('tree-climber').goto_next()<cr>",   mode = { "n", "v", "o" }, silent = true },
            { "gk",         "<cmd>lua require('tree-climber').goto_prev()<cr>",   mode = { "n", "v", "o" }, silent = true },
            -- TODO not sure if these keymaps are great
            { "<C-k><C-k>", "<cmd>lua require('tree-climber').swap_prev()<cr>",   mode = "n",               silent = true },
            { "<C-j><C-j>", "<cmd>lua require('tree-climber').swap_next()<cr>",   mode = "n",               silent = true },
        }
    },
    {
        'RRethy/nvim-treesitter-textsubjects',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        -- TODO actually specify `keys`?
        event = "VeryLazy",
        config = function()
            require("nvim-treesitter.configs").setup {
                textsubjects = {
                    enable = true,
                    prev_selection = "", -- (Optional) keymap to select the previous selection
                    keymaps = {
                        ["."] = "textsubjects-smart",
                    },
                },
            }
        end
    },
    {
        'numToStr/Comment.nvim',
        lazy = false,
        config = function()
            require('Comment').setup({
                toggler = {
                    ---Line-comment toggle keymap
                    line = '<leader>cc',
                    ---Block-comment toggle keymap
                    block = '<leader>cb',
                },
                opleader = {
                    ---Line-comment toggle keymap
                    line = '<leader>cc',
                    ---Block-comment toggle keymap
                    block = '<leader>cb',
                },
                extra = {
                    ---Add comment on the line above
                    above = '<leader>ck',
                    ---Add comment on the line below
                    below = '<leader>cj',
                    ---Add comment at the end of line
                    eol = '<leader>cA',
                },
            })
            local ft = require('Comment.ft')
            ft.htmldjango = '{# %s #}'
        end
    },

    -- aesthetics
    "ayu-theme/ayu-vim",
    {
        'nvim-lualine/lualine.nvim',
        config = function() require('lualine-cfg') end,
    },
    "lukas-reineke/indent-blankline.nvim",
    "tpope/vim-sleuth", -- detect tabstop automatically
    {
        "stevearc/dressing.nvim",
        event = "VeryLazy"
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
        "tpope/vim-fugitive",
        lazy = true,
        keys = {
            { "ga",   ":Git add .<CR>" },
            { "gs",   ":Git<CR>" },
            { "gw",   ":Gwrite<CR>" },
            { "gc",   ":Git commit<CR>" },
            { "gca",  ":Git commit --amend<CR>" },
            { "gcne", ":Git commit --amend --no-edit<CR>" },
            { "gd",   ":Git diff<CR>" },
            { "gm",   ":GMove " },
            { "gco",  ":GBranches<CR>" },
            { "grid", ":Git rebase -i develop<CR>" },
            { "gpoh", ":Git push origin head<CR>" },
            { "gpfoh", ":Git push --force origin head<CR>"
            }
        },
    },
    {
        "kristijanhusak/vim-create-pr",
        lazy = true,
        cmd = { "PR" },
    },

    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            { "<space>d", "<cmd>TroubleToggle<cr>" },
        },
        cmd = { "TroubleToggle" },
        opts = {
            mode = "document_diagnostics",
        }
    },

    {
        "folke/which-key.nvim",
        enabled = false,
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {}
    },

    {
        "klen/nvim-test",
        dependencies = { 'nvim-treesitter' },
        keys = {
            { '<space>tt', ':TestNearest<CR>' },
        },
        opts = {},
        -- config = function()
        --     require('nvim-test').setup()
        --     require('nvim-test.runners.pytest'):setup {
        --         command = { (vim.env.VIRTUAL_ENV or "venv") .. "/bin/pytest", "pytest -s" },
        --         file_pattern = "\\v(test_[^.]+|[^.]+_test|tests)\\.py$",
        --         find_files = { "test_{name}.py", "{name}_test.py", "tests.py" },
        --     }
        -- end
    },

    {
        "kevinhwang91/nvim-bqf"
    },
    {
        "rcarriga/nvim-notify",
        event = "VeryLazy",
        init = function()
            vim.notify = require("notify")
        end,
    },
})

-- maybe interesting list:
-- 'ThePrimeagen/refactoring.nvim',
-- genghis

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
--  --use 'andythigpen/nvim-coverage'



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
