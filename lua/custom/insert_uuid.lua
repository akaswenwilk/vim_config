local M = {}

function M.insert_uuid()
  local uuid = string.lower(vim.fn.system('uuidgen'))
  uuid = uuid:gsub('\n', '')
  vim.api.nvim_put({ uuid }, 'c', true, true)
end

return M
