local opt = vim.opt
local keymap = vim.keymap.set

keymap('n', '<leader>j', [[:%!jq .<CR>]], { noremap = true, silent = true, desc = "Prettify JSON with jq" })

-- Settings
opt.shiftwidth = 2
opt.softtabstop = 2
