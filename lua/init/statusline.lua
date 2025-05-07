local function mode()
  local m = vim.api.nvim_get_mode().mode
  local map = {
    n = 'NORMAL', i = 'INSERT', v = 'VISUAL', V = 'V-LINE',
    [''] = 'V-BLOCK', c = 'COMMAND', R = 'REPLACE', t = 'TERMINAL',
  }
  return map[m] or 'OTHER'
end

local function file()
  local name = vim.fn.expand('%')
  if name == '' then return '[No File]' end
  if vim.bo.modified then
    name = name .. ' +'
  end
  return name
end

local function position()
  return string.format('%3d:%-2d', vim.fn.line('.'), vim.fn.col('.'))
end

function StatusLine()
  return table.concat({
    ' ', mode(),
    ' | ', file(),
    ' %= ',  -- align right
    position(), ' '
  })
end

vim.o.statusline = '%!v:lua.StatusLine()'
