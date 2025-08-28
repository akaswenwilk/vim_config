local M = {}

function M.copy_test_cmd(debug, failfast)
  local api = vim.api
  local fn = vim.fn

  local function is_go_test()
    local file = fn.expand('%:t')
    return file:sub(-8) == "_test.go" and fn.expand('%:e') == 'go'
  end

  local function find_test_decl_line()
    local row = api.nvim_win_get_cursor(0)[1]
    for i = row, 1, -1 do
      local l = api.nvim_buf_get_lines(0, i - 1, i, false)[1]
      if l and l:match("^func.*Test") then
        return l
      end
    end
    return nil
  end

  local function parse_test_target(line)
    -- Testify suite method: func (s *MySuite) TestX(...)
    local suite_type, method = line:match("^func%s*%(%s*[%w_]+%s*%*?([%w_]+)%s*%)%s+(Test[%w_]+)%s*%(")
    if suite_type and method then
      return { kind = "suite", suite = suite_type, method = method }
    end
    -- Plain test func: func TestX(t *testing.T)
    local func = line:match("^func%s+(Test[%w_]+)%s*%(")
    if func then
      return { kind = "plain", func = func }
    end
    return nil
  end

  if not is_go_test() then
    vim.notify('Not in a Go test file', vim.log.levels.ERROR)
    return
  end

  local decl = find_test_decl_line()
  if not decl then
    vim.notify('No test declaration found', vim.log.levels.ERROR)
    return
  end

  local target = parse_test_target(decl)
  if not target then
    vim.notify('Unrecognized test declaration', vim.log.levels.ERROR)
    return
  end

  local file = vim.fn.expand('%:p')
  local cwd = vim.fn.getcwd()
  local relpath = vim.fn.fnamemodify(file, ':.' .. cwd)
  local package_path = vim.fn.fnamemodify(relpath, ':h')

  local cmd
  if target.kind == "suite" then
    local expr = string.format("'^%s$'", target.method)
    if debug then
      cmd = "dlv test ./" .. package_path .. " -- -testify.m " .. expr
    else
      cmd = "go test ./" .. package_path .. " -testify.m " .. expr
    end
  else
    local expr = string.format("'^%s$'", target.func)
    if debug then
      cmd = "dlv test ./" .. package_path .. " -- -test.run " .. expr
    else
      cmd = "go test ./" .. package_path .. " -run " .. expr
    end
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
