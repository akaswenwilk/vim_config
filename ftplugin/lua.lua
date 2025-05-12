-- File: ~/.config/nvim/ftplugin/lua.lua

-- Set tab width and indentation
vim.bo.tabstop = 2        -- Display width of a tab
vim.bo.shiftwidth = 2     -- Indent width
vim.bo.softtabstop = 2    -- Number of spaces per tab in insert mode

-- Recommended for LSP compatibility and formatting
vim.bo.commentstring = "-- %s"
