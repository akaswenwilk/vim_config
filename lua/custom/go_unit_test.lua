local M = {}

function M.copy_test_cmd(debug, failfast)
  local api = vim.api
  local fn = vim.fn

  local function get_current_func()
    local row = api.nvim_win_get_cursor(0)[1]
    for i = row, 1, -1 do
      local l = api.nvim_buf_get_lines(0, i - 1, i, false)[1]
      local func = string.match(l, "^func%s+(Test[%w_]+)")
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

  local file = vim.fn.expand('%:p')
  local cwd = vim.fn.getcwd()
  local relpath = vim.fn.fnamemodify(file, ':.' .. cwd)
  local package_path = vim.fn.fnamemodify(relpath, ':h')

  local cmd
  if debug then
    cmd = "dlv test ./" .. package_path .. " -- -test.run ^" .. func .. "$"
  else
    cmd = "go test ./" .. package_path .. " -run ^" .. func .. "$"
  end

  if failfast then
    cmd = cmd .. " ff=1"
  else
    cmd = cmd .. " ff=0"
  end

  fn.setreg('+', cmd)
  vim.notify('Copied: ' .. cmd)
end

return M
