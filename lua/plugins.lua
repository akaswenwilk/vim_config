local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git', 'clone', '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git', lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  -- List of plugins
  { 'mileszs/ack.vim' },
  { 'dense-analysis/ale' },
  { 'junegunn/fzf' },
  { 'morhetz/gruvbox' },
  { 'preservim/nerdtree' },
  { 'graywh/vim-colorindent' },
  { 'preservim/nerdcommenter' },
  { 'tpope/vim-fugitive' },
  { 'fatih/vim-go', ft = {'go'} },
  { 'tpope/vim-surround' },
  { 'rust-lang/rust.vim', ft = {'rust'} },
  { 'powerman/vim-plugin-AnsiEsc', ft = {'text'} },
  { 'github/copilot.vim' },
  { 'hashivim/vim-terraform', ft = {'tf'} },
  { 'rhysd/rust-doc.vim', ft = {'rust'} },
  { 'junegunn/vim-easy-align' },
  { 'gurpreetatwal/vim-avro' },
  { 'Xuyuanp/nerdtree-git-plugin' },
  { 'nvim-telescope/telescope.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make', cond = vim.fn.executable('make') == 1 },
})

vim.cmd('colorscheme gruvbox')

vim.g.ale_completion_enabled = 1
vim.g.ale_linters = { avdl = {'jsonlint'} }
vim.g.NERDTreeShowHidden = 1
vim.g.NERDTreeGitStatusShowIgnored = 1
vim.g.NERDTreeGitStatusUseNerdFonts = 1
vim.g.NERDTreeGitStatusShowClean = 0
vim.g.NERDTreeGitStatusIndicatorMapCustom = {
  Modified  = '✹',
  Staged    = '✚',
  Untracked = '✭',
  Renamed   = '➜',
  Unmerged  = '═',
  Deleted   = '✖',
  Dirty     = '✗',
  Ignored   = '☒',
  Clean     = '✔︎',
  Unknown   = '?',
}

vim.g.ackprg = "rg --vimgrep --smart-case -g '!{**/.git/*}' --hidden"
vim.opt.rtp:append('/opt/homebrew/bin/fzf')

vim.cmd([[
  cnoreabbrev gp lua require('utils').git_push()
  cnoreabbrev ggfl lua require('utils').git_force_push()
  cnoreabbrev gup Git pull --rebase
  cnoreabbrev space lua require('utils').copy_pwd()
  cnoreabbrev ff lua require('utils').copy_current_file()
  cnoreabbrev errcount lua require('utils').list_error_count()
  cnoreabbrev diffbuff lua require('utils').diff_buffers()
]])
