-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap.set

local default_opts = { noremap = true, silent = true }
-- Better Indent
keymap("v", "<S-Tab>", "<gv", default_opts)
keymap("v", "<Tab>", ">gv", default_opts)

-- Paste over currently selected text without yanking it
keymap("v", "p", '"_dP', default_opts)

-- better buffer search

-- tab navigation
keymap("n", "/", "/\\v", {})
keymap("n", "<Leader>tn", ":tabn<CR>", default_opts)
keymap("n", "<Leader>tp", ":tabp<CR>", default_opts)

-- easy quit
keymap("n", "<Leader>q", ":q!<CR>", default_opts)

-- clipboard copy
keymap("v", "<C-c>", '"+y', default_opts)

-- clear search highlights
keymap("n", "<leader>hl", function()
  vim.cmd("noh")
end, default_opts)
--
-- vimmdiff bindings
keymap("n", "<leader>1", ":diffget LOCAL<CR>", default_opts)
keymap("n", "<leader>2", ":diffget BASE<CR>", default_opts)
keymap("n", "<leader>3", ":diffget REMOTE<CR>", default_opts)

-- easy toggle file explorer
-- TODO: decide on this one
-- keymap('n', '<leader>nt', ':NvimTreeToggle<CR>', default_opts)

-- TODO: decide on whether i need search
-- -- buffer text search
-- -- NORMAL mode: operator pending (motion-based search)
-- function _G.SearchOperator(type)
--   require('custom.search').operator(type)
-- end
--
-- keymap('n', '<leader>/', function()
--   vim.o.operatorfunc = "v:lua.SearchOperator"
--   vim.api.nvim_feedkeys('g@', 'n', false)
-- end, default_opts)
--
-- -- VISUAL mode: search selected text
-- keymap('x', '<leader>/', function()
--   local saved_reg = vim.fn.getreg('"')
--   vim.cmd('normal! y')
--   local text = vim.fn.getreg('"')
--   vim.fn.setreg('"', saved_reg)
--   vim.print("Hello")
--   require('custom.search').search_text(text)
-- end, {
--   noremap = true,
--   silent = true,
--   desc = 'Search: visual selection'
-- })
--

-- insert uuid
keymap("i", "<C-u>", function()
  local uuid = string.lower(vim.fn.system("uuidgen"))
  uuid = uuid:gsub("\n", "")
  vim.api.nvim_put({ uuid }, "c", false, true)
end, default_opts)

-- Normal + Visual mode mappings
-- use different register to not interfere with clipboard
-- Yank to register a
keymap({ "n", "v" }, "y", '"ay', { noremap = true, silent = true })
-- Delete to register a
keymap({ "n", "v" }, "d", '"ad', { noremap = true, silent = true })
-- cut to register a
keymap({ "n", "v" }, "c", '"ac', { noremap = true, silent = true })
-- Paste from register a
keymap({ "n", "v" }, "p", '"ap', { noremap = true, silent = true })
-- Paste from register a
keymap({ "n", "v" }, "P", '"aP', { noremap = true, silent = true })

-- diagnostic
local diagnostic_goto = function(next, severity)
  return function()
    vim.diagnostic.jump({
      count = (next and 1 or -1) * vim.v.count1,
      severity = severity and vim.diagnostic.severity[severity] or nil,
      float = true,
    })
  end
end

keymap("n", "[i", diagnostic_goto(false, "INFO"), { desc = "Prev Info" })
keymap("n", "]i", diagnostic_goto(true, "INFO"), { desc = "Next Info" })
