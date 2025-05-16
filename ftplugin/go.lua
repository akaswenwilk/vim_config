local opt = vim.opt
local opt_local = vim.opt_local
local keymap = vim.keymap.set

-- Settings
opt_local.foldmethod = "syntax"
opt.shiftwidth = 8
opt.softtabstop = 8


vim.api.nvim_create_user_command('Test', function(opts)
    local args = vim.split(opts.args or "", " ")
    local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]
    local cmd_args = table.concat(args, " ")

    if first_line:match("integration") then
        vim.cmd("Integration " .. cmd_args)
    elseif first_line:match("functional") then
        vim.cmd("Functional " .. cmd_args)
    else
        vim.cmd("Unit " .. cmd_args)
    end
end, {
    nargs = '?',
})

-- Unit Test Helper
local function parse_args(arg_str)
    local args = vim.split(arg_str or "", " ")
    local debug = false
    local failfast = true

    for _, arg in ipairs(args) do
        local lower = arg:lower()
        if lower == "debug" or lower == "d" or lower == "dbg" then
            debug = true
        elseif lower == "ff" or lower == "failfast" or lower == "f" then
            failfast = false
        end
    end

    return debug, failfast
end

vim.api.nvim_create_user_command('Unit', function(opts)
    local debug, failfast = parse_args(opts.args)
    require('custom.go_unit_test').copy_test_cmd(debug, failfast)
end, { nargs = '*' })

vim.api.nvim_create_user_command('Functional', function(opts)
    local debug, failfast = parse_args(opts.args)
    require('custom.go_functional_test').copy_test_cmd(debug, failfast)
end, { nargs = '*' })

vim.api.nvim_create_user_command('Integration', function(opts)
    local debug, failfast = parse_args(opts.args)
    require('custom.go_integration_test').copy_test_cmd(debug, failfast)
end, { nargs = '*' })

-- Breakpoint helper
vim.api.nvim_create_user_command('GetBreakPoint', function()
        local file = vim.fn.expand('%')
        local line = vim.fn.line('.')
        vim.fn.setreg('+', 'break ' .. file .. ':' .. line)
        vim.notify('Breakpoint copied: break ' .. file .. ':' .. line)
end, {})

keymap('n', '<leader>b', ':GetBreakPoint<CR>', { buffer = true })
