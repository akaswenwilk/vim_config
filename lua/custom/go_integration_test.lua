local M = {}

function M.copy_test_cmd(debug, failfast)
  local api = vim.api
  local fn = vim.fn

  local function get_current_func()
    local row = api.nvim_win_get_cursor(0)[1]
    for i = row, 1, -1 do
      local l = api.nvim_buf_get_lines(0, i-1, i, false)[1]
      local func = string.match(l, "^func.+ (Test[%w_]+)")
      if func then return func end
    end
    return nil
  end

  local function is_go_test()
    local file = fn.expand('%:t')
    return file:sub(-8) == "_test.go" and fn.expand('%:e') == 'go'
  end

  if not is_go_test() then
    vim.notify('Not in a Go test file', vim.log.levels.ERROR)
    return
  end

  local func = get_current_func()
  if not func then
    vim.notify('No test function found', vim.log.levels.ERROR)
    return
  end

  local package_name = vim.fn.fnamemodify(vim.fn.expand('%:h'), ':t')

  local cmd
  if debug then
    cmd = "make debug-integration-test detached=1 testcase=" .. func .. " package=" .. package_name
  else
    cmd = "make integration-test detached=1 testcase=" .. func .. " package=" .. package_name
  end

  if failfast then
    cmd = cmd .. " ff=1"
  else
    cmd = cmd .. " ff=0"
  end

  fn.setreg('+', cmd)
end

return M
