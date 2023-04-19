vim.cmd([[
nmap <space>rn <Plug>(coc-rename)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> ,d <Plug>(coc-definition)
nmap <silent> ,dv :call CocAction('jumpDefinition', 'vsplit')<CR>
nmap <silent> ,ds :call CocAction('jumpDefinition', 'split')<CR>
nmap <silent> ,dt :call CocAction('jumpDefinition', 'tabe')<CR>
nmap <silent> <space>y <Plug>(coc-type-definition)
nmap <silent> <space>i <Plug>(coc-implementation)
nmap <silent> <space>r <Plug>(coc-references)

let g:coc_disable_transparent_cursor = 1

command! OrganizeImports CocCommand pyright.organizeimports

" nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
nnoremap <space>a  :<C-u>CocList diagnostics<cr>


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
