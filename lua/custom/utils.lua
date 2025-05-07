local M = {}

function M.copy_pwd()
  local pwd = vim.fn.getcwd()
  vim.fn.setreg('+', pwd)
end

function M.insert_uuid()
  local uuid = string.lower(vim.fn.system('uuidgen'))
  uuid = uuid:gsub('\n', '')
  vim.api.nvim_put({ uuid }, 'c', true, true)
end

function M.copy_current_file()
  local file = vim.fn.expand('%')
  vim.fn.setreg('+', file)
end

function M.git_branch()
  local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD 2>/dev/null")
  return branch:gsub('\n', '')
end

function M.git_push()
  local branch = M.git_branch()
  vim.cmd('Git push -u origin ' .. branch)
end

function M.git_force_push()
  local branch = M.git_branch()
  vim.cmd('Git push --force -u origin ' .. branch)
end

function M.list_error_count()
  vim.api.nvim_echo({{vim.fn['ale#statusline#Count'](vim.fn.bufnr('%')), 'Normal'}}, false, {})
end

function M.diff_buffers()
  if #vim.fn.tabpagebuflist() ~= 2 then
    vim.notify('Exactly two buffers must be open.', vim.log.levels.ERROR)
    return
  end
  vim.cmd('windo diffthis')
end

local function delete_search_matches()
  local matches = vim.fn.getmatches()
  for _, match in ipairs(matches) do
    if match.group == 'Search' then
      vim.fn.matchdelete(match.id)
    end
  end
end

function M.delete_searches()
  delete_search_matches()
end

function M.search_operator(type)
  local saved = vim.fn.getreg('"')
  if type == 'v' then
    vim.cmd('normal! `<v`>y')
  elseif type == 'char' then
    vim.cmd('normal! `[v`]y')
  else
    return
  end
  delete_search_matches()
  local text = vim.fn.getreg('"')
  vim.fn.setreg('/', text)
  vim.fn.matchadd('Search', text)
  vim.fn.setreg('"', saved)
end

return M
