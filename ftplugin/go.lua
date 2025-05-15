local opt = vim.opt
local opt_local = vim.opt_local
local keymap = vim.keymap.set

-- Settings
opt_local.foldmethod = "syntax"
opt.shiftwidth = 8
opt.softtabstop = 8


vim.api.nvim_create_user_command('Test', function(opts)
    local arg = opts.args
    local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]

    if first_line:match("integration") then
        vim.cmd("Integration " .. (arg or ""))
    elseif first_line:match("functional") then
        vim.cmd("Functional " .. (arg or ""))
    else
        vim.cmd("Unit " .. (arg or ""))
    end
end, {
    nargs = '?',
})

-- Unit Test Helper
vim.api.nvim_create_user_command('Unit', function(opts)
        local arg = opts.args
        local debug = (arg == "debug") or (arg == "d") or (arg == "dbg") or (arg == "Debug")
        require('custom.go_unit_test').copy_test_cmd(debug)
end, {
        nargs = '?', -- allow optional argument
})

vim.api.nvim_create_user_command('Functional', function(opts)
        local arg = opts.args
        local debug = (arg == "debug") or (arg == "d") or (arg == "dbg") or (arg == "Debug")
        require('custom.go_functional_test').copy_test_cmd(debug)
end, {
        nargs = '?', -- allow optional argument
})

vim.api.nvim_create_user_command('Integration', function(opts)
        local arg = opts.args
        local debug = (arg == "debug") or (arg == "d") or (arg == "dbg") or (arg == "Debug")
        require('custom.go_integration_test').copy_test_cmd(debug)
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
