vim.opt.updatetime = 3000
vim.g.coc_disable_transparent_cursor = 1

vim.keymap.set('n', '<space>rn', '<Plug>(coc-rename)')
vim.keymap.set('n', '[d', '<Plug>(coc-diagnostic-prev)', { silent = true })
vim.keymap.set('n', ']d', '<Plug>(coc-diagnostic-next)', { silent = true })
vim.keymap.set('n', ',d', '<Plug>(coc-definition)', { silent = true })
vim.keymap.set('n', ',dv', ":call CocAction('jumpDefinition', 'vsplit')<CR>")
vim.keymap.set('n', ',ds', ":call CocAction('jumpDefinition', 'split')<CR>")
vim.keymap.set('n', ',dt', ":call CocAction('jumpDefinition', 'tabe')<CR>")
vim.keymap.set('n', '<space>y', '<Plug>(coc-type-definition)', { silent = true })
vim.keymap.set('n', '<space>r', '<Plug>(coc-references)', { silent = true })
vim.keymap.set('n', '<space>a', ':<C-u>CocList diagnostics<cr>')

vim.cmd([[
" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')



function! g:ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction
nnoremap <silent> ,D :call ShowDocumentation()<CR>

xmap <leader>a  <Plug>(coc-codeaction)
vnoremap <leader>a <Plug>(coc-codeaction-selected)<C-C>
" nmap <leader>a v<Plug>(coc-codeaction-selected)

inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm()
      \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

inoremap <expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr> <Tab> coc#pum#visible() ? coc#pum#next(1) : "\<Tab>"
inoremap <expr> <S-Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<S-Tab>"
]])
