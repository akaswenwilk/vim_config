local M = {}

function M.insert_uuid()
  local uuid = string.lower(vim.fn.system('uuidgen'))
  uuid = uuid:gsub('\n', '')
  vim.api.nvim_put({ uuid }, 'c', false, true)
end

return M
