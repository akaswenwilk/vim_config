local keymap = vim.keymap.set
local default_opts = { noremap = true, silent = true }

-- Better Indent
keymap("v", "<S-Tab>", "<gv", default_opts)
keymap("v", "<Tab>", ">gv", default_opts)

-- Paste over currently selected text without yanking it
keymap("v", "p", '"_dP', default_opts)

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
keymap("n", '<Leader>q', ":q!<CR>", default_opts)

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

keymap('n', '<leader>/', function()
  vim.o.operatorfunc = "v:lua.SearchOperator"
  vim.api.nvim_feedkeys('g@', 'n', false)
end, default_opts)

-- VISUAL mode: search selected text
keymap('x', '<leader>/', function()
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
  local path = vim.fn.fnamemodify(vim.fn.expand("%"), ":.")
  vim.fn.setreg("+", path)
end, {})
local file_keys = {'f', 'file', 'F', 'fi', 'FI', 'Fi'}
for _, key in ipairs(file_keys) do
  keymap("ca", key, "File", default_opts)
end

-- use different register to not interfere with clipboard
-- Normal + Visual mode mappings
-- Yank to register a
keymap({'n', 'v'}, 'y', '"ay', { noremap = true, silent = true })
-- Delete to register a
keymap({'n', 'v'}, 'd', '"ad', { noremap = true, silent = true })
-- cut to register a
keymap({'n', 'v'}, 'c', '"ac', { noremap = true, silent = true })
-- Paste from register a
keymap({'n', 'v'}, 'p', '"ap', { noremap = true, silent = true })
-- Paste from register a
keymap({'n', 'v'}, 'P', '"aP', { noremap = true, silent = true })

-- get current space
vim.api.nvim_create_user_command("Space", function()
  local pwd = vim.fn.getcwd()
  vim.fn.setreg('+', pwd)
end, {})
local space_keys = {'s', 'space', 'S', 'sp', 'SP', 'Sp'}
for _, key in ipairs(space_keys) do
  keymap("ca", key, "Space", default_opts)
end

-- telescope mappings
local tb = require("telescope.builtin")

keymap("n", "<C-p>",    tb.find_files, { desc = "Find Files" })
keymap("n", "<leader>ff", tb.find_files, { desc = "Find Files" })
keymap("n", "<leader>fr", tb.oldfiles,   { desc = "Recent" })
keymap("n", "<leader>fb", tb.buffers,    { desc = "Buffers" })
keymap("n", "<leader>fg", tb.git_files,  { desc = "Git Files" })
keymap("n", "<leader>F",  tb.live_grep,  { desc = "Grep" })

-- Visual: grep selection
keymap("x", "<leader>g", function()
  vim.cmd('normal! "zy')
  local text = vim.fn.getreg("z")
  text = vim.fn.escape(text, [[\/.*$^~[]])
  require("telescope.builtin").live_grep({ default_text = text })
end, { desc = "Grep selection" })

-- Go To errors, warnings, hints, info
keymap("n", "<leader>dd", tb.diagnostics, { desc = "Diagnostics (Workspace)" })
keymap("n", "<leader>de", function()
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Diagnostics (Error)" })
keymap("n", "<leader>dh", function()
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.HINT })
end, { desc = "Diagnostics (HINT)" })
keymap("n", "<leader>dw", function()
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })
end, { desc = "Diagnostics (WARN)" })
keymap("n", "<leader>di", function() 
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.INFO })
end, { desc = "Diagnostics (INFO)" })

-- code navigation
keymap("n", "gd", tb.lsp_definitions, { desc = "Goto Definition" })

keymap("n", "<leader>d", tb.lsp_definitions, { desc = "Goto Definition" })

keymap("n", "<leader>dv", function()
    vim.cmd("vsplit")
    tb.lsp_definitions()
end, { desc = "Goto Definition split" })

keymap("n", "<leader>r", function()
  tb.lsp_references({
    show_line = false,
    include_declaration = false,
    jump_type = "never",
  })
end, { desc = "Find references (Telescope → Quickfix)" })

keymap("n", "<leader>i", tb.lsp_implementations, { desc = "Goto Implementation" })

keymap("n", "<leader>t", function()
    vim.cmd("vsplit")
    tb.lsp_type_definitions()
end, { desc = "Goto Type Definition" })

-- vim lsp specific commands
keymap("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })

keymap("n", "K", vim.lsp.buf.hover, { desc = "Hover" })

keymap({ "x", "n"}, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })

keymap("n", "<leader>gb", "<cmd>Git blame<cr>", { desc = "Fugitive Git blame" })
