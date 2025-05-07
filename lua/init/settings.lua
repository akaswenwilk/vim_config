local opt = vim.opt
local g = vim.g

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
opt.foldlevel = 99
opt.autoread = true
opt.completeopt = { "menu", "menuone", "preview", "noselect", "noinsert" }

vim.cmd([[
  filetype plugin indent on
  syntax enable
  language en_US
]])

g.mapleader = ' '
