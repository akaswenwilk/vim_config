local keymap = vim.keymap.set
local default_opts = { noremap = true, silent = true }

vim.api.nvim_create_user_command("W", function()
  vim.lsp.buf.format({ async = false })
  vim.cmd("silent write")
end, {})
vim.cmd.cnoreabbrev("w silent w")

-- copy current file path into clipboard
vim.api.nvim_create_user_command("File", function()
  local path = vim.fn.fnamemodify(vim.fn.expand("%"), ":.")
  vim.fn.setreg("+", path)
end, {})
local file_keys = {'f', 'file', 'F', 'fi', 'FI', 'Fi'}
for _, key in ipairs(file_keys) do
  keymap("ca", key, "File", default_opts)
end

-- get current space
vim.api.nvim_create_user_command("Space", function()
  local pwd = vim.fn.getcwd()
  vim.fn.setreg('+', pwd)
end, {})
local space_keys = {'s', 'space', 'S', 'sp', 'SP', 'Sp'}
for _, key in ipairs(space_keys) do
  keymap("ca", key, "Space", default_opts)
end

-- swap two buffers
vim.api.nvim_create_user_command("Swap", function()
  vim.cmd("wincmd r")
end, { desc = "Rotate windows (like <C-w><C-r>)" })
