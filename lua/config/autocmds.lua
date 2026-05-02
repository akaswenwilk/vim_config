-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- autosave
vim.api.nvim_create_autocmd({ "BufLeave", "InsertLeave", "CursorHold" }, {
  callback = function()
    if not vim.o.readonly then
      vim.cmd("silent! update")
    end
  end,
})

-- user commands
--
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
local file_keys = { "f", "file", "F", "fi", "FI", "Fi" }
for _, key in ipairs(file_keys) do
  keymap("ca", key, "File", default_opts)
end

-- get current space
vim.api.nvim_create_user_command("Space", function()
  local pwd = vim.fn.getcwd()
  vim.fn.setreg("+", pwd)
end, {})
local space_keys = { "s", "space", "S", "sp", "SP", "Sp" }
for _, key in ipairs(space_keys) do
  keymap("ca", key, "Space", default_opts)
end

