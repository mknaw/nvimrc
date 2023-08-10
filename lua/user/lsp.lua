vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Show all diagnostics on current line in floating window
        vim.cmd('autocmd CursorHold * Lspsaga show_line_diagnostics ++unfocus')
        vim.o.updatetime = 400
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
        vim.keymap.set('n', '<leader>D', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', '<leader>d', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', '<leader>dd', '<cmd>Lspsaga peek_definition ++unfocus<cr>', opts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
        -- TODO doesnt work for whatever reason
        -- vim.keymap.set('n', '<space>rn', '<CMD>Lspsaga lsp_rename ++project<CR>', opts)
        vim.keymap.set({ 'n', 'v' }, '<leader>a', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '<space>r', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<space>f', function()
            vim.lsp.buf.format { async = true }
        end, opts)
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
    end,
})

vim.diagnostic.config({
    virtual_text = false, -- Turn off inline diagnostics
    -- TODO
    --signs = {
    --    { name = "DiagnosticSignError", text = "" },
    --    { name = "DiagnosticSignWarn", text = "" },
    --    { name = "DiagnosticSignHint", text = "" },
    --    { name = "DiagnosticSignInfo", text = " " },
    --},
})

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
