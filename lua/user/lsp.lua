vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Show all diagnostics on current line in floating window
        -- TODO this is nicer because of the unfocus, but otherwise doesn't look better
        -- than the built-in. but it looks worse than the `diagnostic_jump_next`.
        -- so try to hack it to make it like `diagnostic_jump_next`.
        -- vim.cmd('autocmd CursorHold * Lspsaga show_line_diagnostics ++unfocus')
        -- vim.cmd('autocmd CursorHold * <cmd>lua vim.diagnostic.open_float()<CR>')
        -- vim.api.nvim_create_autocmd('CursorHold', {
        --     callback = function()
                -- for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
                --     if vim.api.nvim_win_get_config(winid).zindex then
                --         return
                --     end
                -- end
                -- vim.diagnostic.open_float { focusable = false }
        --     end,
        -- })
        -- vim.o.updatetime = 400
        -- vim.api.nvim_set_keymap(
        --  'n', '<Leader>x', ':lua vim.diagnostic.open_float()<CR>',
        --  { noremap = true, silent = true }
        -- )

        -- Enable completion triggered by <c-x><c-o>
        -- vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        -- TODO this seems to look worse than the standard one, not sure why
        -- vim.keymap.set('n', '<leader>D', '<cmd>Lspsaga hover_doc<CR>', opts)
        vim.keymap.set('n', '<leader>D', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<leader>d', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', '<leader>vd', ':vsplit | lua vim.lsp.buf.definition()<CR>')
        -- vim.keymap.set('n', '<leader>dd', '<cmd>Lspsaga peek_definition ++unfocus<cr>', opts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
        -- TODO doesnt work for whatever reason
        -- vim.keymap.set('n', '<space>rn', '<CMD>Lspsaga lsp_rename ++project<CR>', opts)
        vim.keymap.set({ 'n', 'v' }, '<leader>a', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '<space>r', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<space>f', function()
            vim.lsp.buf.format({
                async = true,
                filter = function(client)
                    return client.name ~= "ruff_lsp"
                end
            })
        end, opts)
        vim.keymap.set('n', '<space>d', function()
                vim.diagnostic.open_float { focusable = false }
        end, opts)
        -- vim.keymap.set({ 'v', 'V' }, '<space>f', vim.lsp.buf.range_formatting)
        vim.api.nvim_set_keymap(
        -- TODO not sure why only `diagnostic_jump_next` has more opts like codeactions
        -- 'n', ']d', '<cmd>Lspsaga diagnostic_jump_next<CR>',
            'n', ']d', ':lua vim.diagnostic.goto_next()<CR>',
            { noremap = true, silent = true }
        )
        vim.api.nvim_set_keymap(
            'n', '[d', ':lua vim.diagnostic.goto_prev()<CR>',
            { noremap = true, silent = true }
        )

        -- function FormatFunction()
        --     vim.lsp.buf.format({
        --         async = true,
        --         range = {
        --             ["start"] = vim.api.nvim_buf_get_mark(0, "<"),
        --             ["end"] = vim.api.nvim_buf_get_mark(0, ">"),
        --         }
        --     })
        -- end
        --
        -- vim.api.nvim_set_keymap("v", "<space>f", "<Esc><cmd>lua FormatFunction()<CR>", { noremap = true })
    end,
})

vim.diagnostic.config({
    virtual_text = false, -- Turn off inline diagnostics
})

vim.cmd([[
    sign define DiagnosticSignError text= texthl=DiagnosticError linehl= numhl=
    sign define DiagnosticSignWarn  text= texthl=DiagnosticWarn  linehl= numhl=
    sign define DiagnosticSignInfo  text=  texthl=DiagnosticInfo  linehl= numhl=
    sign define DiagnosticSignHint  text= texthl=DiagnosticHint  linehl= numhl=
]])

-- Use this if you want it to automatically show all diagnostics on the
-- current line in a floating window. Personally, I find this a bit
-- distracting and prefer to manually trigger it (see below). The
-- CursorHold event happens when after `updatetime` milliseconds. The
-- default is 4000 which is much too long

-- Go to next diagnostic (if there are multiple on the same line, only shows
-- one at a time in the floating window)
--vim.api.nvim_set_keymap(
--  'n', '<Leader>n', ':lua vim.diagnostic.goto_next()<CR>',
--  { noremap = true, silent = true }
--)
-- Go to prev diagnostic (if there are multiple on the same line, only shows
-- one at a time in the floating window)
--vim.api.nvim_set_keymap(
--  'n', '<Leader>p', ':lua vim.diagnostic.goto_prev()<CR>',
--  { noremap = true, silent = true }
--)
