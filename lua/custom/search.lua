local M = {}

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

function M.search_text(text)
  if not text or text == '' then return end
  local pattern = vim.fn.escape(text, '\\/')
  local keys = '/\\v' .. pattern .. '<CR>N'
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), 'n', false)
end

function M.operator(type)
  local saved_reg = vim.fn.getreg('"')
  if type == 'char' or type == 'line' then
    vim.cmd('normal! `[v`]y')
  elseif type == 'block' then
    vim.notify("Block selection not supported", vim.log.levels.WARN)
    return
  end
  local text = vim.fn.getreg('"')
  vim.fn.setreg('"', saved_reg)
  M.search_text(text)
end

return M
