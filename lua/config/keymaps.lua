local keymap = vim.api.nvim_set_keymap
local default_opts = { noremap = true, silent = true }
local expr_opts = { noremap = true, expr = true, silent = true }

vim.g.mapleader = ' '

-- Visual line wraps
keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", expr_opts)
keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", expr_opts)

-- Better Indent
keymap("v", "<S-Tab>", "<gv", default_opts)
keymap("v", "<Tab>", ">gv", default_opts)

-- Paste over currently selected text without yanking it
keymap("v", "p", '"_dP', default_opts)

-- Move selected line /block of text in visual mode
keymap("x", "K", ":move '<-2<CR>gv-gv", default_opts)
keymap("x", "J", ":move '>+1<CR>gv-gv", default_opts)

-- Resizing panes
keymap("n", "<Left>", ":vertical resize +1<CR>", default_opts)
keymap("n", "<Right>", ":vertical resize -1<CR>", default_opts)
keymap("n", "<Up>", ":resize -1<CR>", default_opts)
keymap("n", "<Down>", ":resize +1<CR>", default_opts)

-- better buffer search
keymap("n", "/", "/\\v", {})

-- tab navigation
keymap("n", '<Leader>tn', ":tabn<CR>", default_opts)
keymap("n", '<Leader>tp', ":tabp<CR>", default_opts)

-- easy quit
keymap("n", '<Leader>q', ":bdelete!<CR>", default_opts)

-- easy buffer navigation
keymap("n", "<C-h>", "<C-w>h", default_opts)
keymap("n", "<C-j>", "<C-w>j", default_opts)
keymap("n", "<C-k>", "<C-w>k", default_opts)
keymap("n", "<C-l>", "<C-w>l", default_opts)

-- clipboard copy
keymap('v', '<C-c>', '"+y', default_opts)

-- clear search highlights
keymap('n', '<leader>hl', ':noh<CR>:lua require("custom.search").delete_searches()<CR>', default_opts)

-- vimmdiff bindings
keymap('n', '<leader>1', ':diffget LOCAL<CR>', default_opts)
keymap('n', '<leader>2', ':diffget BASE<CR>', default_opts)
keymap('n', '<leader>3', ':diffget REMOTE<CR>', default_opts)

-- easy toggle file explorer
keymap('n', '<leader>nt', ':NvimTreeToggle<CR>', default_opts)

-- buffer text search
-- NORMAL mode: operator pending (motion-based search)
function _G.SearchOperator(type)
  require('custom.search').operator(type)
end

vim.keymap.set('n', '<leader>/', function()
  vim.o.operatorfunc = "v:lua.SearchOperator"
  vim.api.nvim_feedkeys('g@', 'n', false)
end, default_opts)

-- VISUAL mode: search selected text
vim.keymap.set('x', '<leader>/', function()
  local saved_reg = vim.fn.getreg('"')
  vim.cmd('normal! y')
  local text = vim.fn.getreg('"')
  vim.fn.setreg('"', saved_reg)
  vim.print("Hello")
  require('custom.search').search_text(text)
end, {
  noremap = true,
  silent = true,
  desc = 'Search: visual selection'
})

-- insert uuid
keymap('i', '<C-u>', '<C-o>:lua require("custom.insert_uuid").insert_uuid()<CR>', default_opts)

-- copy current file path into clipboard
vim.api.nvim_create_user_command("File", function()
  local path = vim.fn.expand("%")
  vim.fn.setreg("+", path)
end, {})

-- use different register to not interfere with clipboard
-- Normal + Visual mode mappings
-- Yank to register a
vim.keymap.set({'n', 'v'}, 'y', '"ay', { noremap = true, silent = true })
-- Delete to register a
vim.keymap.set({'n', 'v'}, 'd', '"ad', { noremap = true, silent = true })
-- cut to register a
vim.keymap.set({'n', 'v'}, 'c', '"ac', { noremap = true, silent = true })
-- Paste from register a
vim.keymap.set({'n', 'v'}, 'p', '"ap', { noremap = true, silent = true })

-- get current space
vim.api.nvim_create_user_command("Space", function()
  local pwd = vim.fn.getcwd()
  vim.fn.setreg('+', pwd)
end, {})

-- easy surround
