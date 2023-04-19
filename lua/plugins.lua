-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use 'kyazdani42/nvim-tree.lua'
  use 'kyazdani42/nvim-web-devicons'
  use 'brooth/far.vim'
  use 'scrooloose/nerdcommenter'
  use 'mileszs/ack.vim'
  use 'jremmen/vim-ripgrep'
  use 'jiangmiao/auto-pairs'
  use 'chrisbra/csv.vim'
  use 'kana/vim-textobj-user'
  use 'chaoren/vim-wordmotion'
  use 'tpope/vim-surround'
  use 'mattn/emmet-vim'
  use 'kshenoy/vim-signature'
  use 'christoomey/vim-sort-motion'
  use 'yssl/QFEnter'
  use 'SirVer/ultisnips'
  use 'honza/vim-snippets'
  use 'AndrewRadev/splitjoin.vim'
  use 'ludovicchabant/vim-gutentags'
  use 'nvim-lua/plenary.nvim'
  use 'nvim-telescope/telescope.nvim'
  use 'MattesGroeger/vim-bookmarks'
  use 'tom-anders/telescope-vim-bookmarks.nvim'
  use 'AckslD/nvim-neoclip.lua'
  use 'mbbill/undotree'
  use 'jeetsukumaran/vim-indentwise'
  use 'github/copilot.vim'
  use 'andythigpen/nvim-coverage'
  use 'ThePrimeagen/refactoring.nvim'

  -- VCS
  use 'tpope/vim-fugitive'
  use 'airblade/vim-gitgutter'
  use 'kristijanhusak/vim-create-pr'

  -- syntax
  use 'neoclide/coc.nvim' --, {'branch': 'release'}
  use 'nvim-treesitter/nvim-treesitter' --, {'do': ':TSUpdate'}
  use 'nvim-treesitter/playground'
  use 'tweekmonster/django-plus.vim'
  use 'MaxMEllon/vim-jsx-pretty'
  use 'neovimhaskell/haskell-vim'
  use 'psiska/telescope-hoogle.nvim'

  -- aesthetics
  use 'ayu-theme/ayu-vim'
  use 'nvim-lualine/lualine.nvim'

end)

vim.cmd([[ source ~/.config/nvim/plugin/argtextobj.vim ]])

vim.cmd([[
nnoremap <space>p :Copilot panel<cr>
" inoremap <C-j> <Plug>(copilot-dismiss)
" inoremap <C-j> <Plug>(copilot-next)
inoremap <C-k> <Plug>(copilot-previous)
]])
--TODO wtf???
vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.api.nvim_set_keymap("i", "<C-^>", 'copilot#Accept("<CR>")', { silent = true, expr = true })


require("coverage").setup({
  commands = true, -- create commands
  signs = {
    -- use your own highlight groups or text markers
    covered = { hl = "CoverageCovered", text = "▎" },
    uncovered = { hl = "CoverageUncovered", text = "▎" },
  },
  summary = {
    -- customize the summary pop-up
    min_coverage = 80.0,      -- minimum coverage threshold (used for highlighting)
  },
})


require('nvim-tree').setup()

vim.cmd([[ nnoremap <C-n> :NvimTreeToggle<CR> ]])

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
