local opt = vim.opt
local keymap = vim.keymap.set

-- Settings
opt.shiftwidth = 8
opt.softtabstop = 8

opt.foldmethod = "expr"
opt.foldexpr = "v:lua.GoBraceFold(v:lnum)"

_G.GoBraceFold = function(lnum)
  local line = vim.fn.getline(lnum)
  local open = select(2, line:gsub("{", ""))
  local close = select(2, line:gsub("}", ""))

  -- initialize fold level cache
  _G.brace_fold_level = _G.brace_fold_level or {}
  local prev = _G.brace_fold_level[lnum - 1] or 0

  local level = prev + open - close
  if level < 0 then level = 0 end

  _G.brace_fold_level[lnum] = level
  return level
end


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

local test_keys = { 't', 'te', 'T', 'TE', 'Te', 'test' }
for _, key in ipairs(test_keys) do
  keymap('ca', key, 'Test', { desc = "Test" })
end

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
  local file = vim.fn.expand('%:p')
  local cwd = vim.fn.getcwd()
  local relpath = vim.fn.fnamemodify(file, ':.' .. cwd)
  local line = vim.fn.line('.')
  local breakpoint = 'break ' .. relpath .. ':' .. line
  vim.fn.setreg('+', breakpoint)
  vim.notify('Breakpoint copied: ' .. breakpoint)
end, {})

-- open docs in browser
vim.api.nvim_create_user_command("GoDocBrowser", function()
  local params = vim.lsp.util.make_position_params()
  local symbol = vim.fn.expand("<cword>")

  vim.lsp.buf_request(0, "textDocument/hover", params, function(err, result)
    if err then
      vim.notify("GoDocBrowser: LSP request error", vim.log.levels.ERROR)
      return
    end

    if not result or not result.contents or not result.contents.value then
      vim.notify("GoDocBrowser: No hover result or contents", vim.log.levels.WARN)
      return
    end

    local value = result.contents.value
    local url = string.match(value, "%((https://pkg%.go%.dev.-)%)")

    if not url then
      vim.notify("GoDocBrowser: URL not found in hover content", vim.log.levels.WARN)
      return
    end

    local open_cmd = vim.fn.has("mac") == 1 and "open" or "xdg-open"
    vim.fn.jobstart({ open_cmd, url }, { detach = true })
  end)
end, {})

local doc_keys = {'GoDoc', 'godoc' }
for _, key in ipairs(doc_keys) do
  keymap('ca', key, 'GoDocBrowser', { desc = "GoDocBrowser" })
end



keymap('n', '<leader>b', ':GetBreakPoint<CR>', { buffer = true })
