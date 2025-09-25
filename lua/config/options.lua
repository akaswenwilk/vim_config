local opt = vim.opt
local g = vim.g

g.mapleader = " "
g.maplocalleader = " "

opt.formatoptions = "jcroqlnt"
opt.signcolumn = "yes"
opt.clipboard = "unnamedplus"
opt.timeoutlen = 300
opt.compatible = false
opt.expandtab = true
opt.shiftround = true
opt.ignorecase = true
opt.smartcase = true
opt.confirm = true
opt.mouse = 'a'
opt.number = true
opt.relativenumber = true
opt.visualbell = true
opt.breakindent = true
opt.updatetime = 500
opt.swapfile = false
opt.splitbelow = true
opt.splitright = true
opt.hlsearch = true
opt.incsearch = true
opt.autoread = true
opt.shadafile = "NONE"
opt.foldmethod = 'expr'
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99 -- Start with all folds open

vim.diagnostic.enable(true)

opt.shortmess:append("W")

vim.cmd([[
  filetype plugin indent on
  syntax on
  language en_US
]])
