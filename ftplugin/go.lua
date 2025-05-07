local opt = vim.opt
local opt_local = vim.opt_local
local keymap = vim.keymap.set

-- Settings
opt_local.foldmethod = "syntax"
opt.shiftwidth = 8
opt.softtabstop = 8


-- Unit Test Helper
vim.api.nvim_create_user_command('Unit', function(opts)
        local arg = opts.args
        local debug = (arg == "debug") or (arg == "d") or (arg == "dbg") or (arg == "Debug")
        require('custom.go_unit_test').copy_test_cmd(debug)
end, {
        nargs = '?', -- allow optional argument
})

-- Breakpoint helper
vim.api.nvim_create_user_command('GetBreakPoint', function()
        local file = vim.fn.expand('%')
        local line = vim.fn.line('.')
        vim.fn.setreg('+', 'break ' .. file .. ':' .. line)
        vim.notify('Breakpoint copied: break ' .. file .. ':' .. line)
end, {})

keymap('n', '<leader>b', ':GetBreakPoint<CR>', { buffer = true })
