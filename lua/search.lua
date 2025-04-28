local M = {}

local function delete_search_matches()
  local matches = vim.fn.getmatches()
  for _, match in ipairs(matches) do
    if match.group == 'Search' then
      vim.fn.matchdelete(match.id)
    end
  end
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

function M.ack_visual()
  local saved = vim.fn.getreg('"')
  vim.cmd('normal! `<v`>y')
  local search = vim.fn.getreg('"')
  vim.fn.setreg('"', saved)
  vim.cmd('silent Ack! ' .. vim.fn.shellescape(search) .. ' .')
  vim.cmd('copen')
end

function M.ack_full_text_search(value, directory)
  vim.cmd('silent Ack! ' .. vim.fn.shellescape(value) .. ' ' .. vim.fn.shellescape(directory))
  vim.fn.matchadd('Search', value)
end

return M
