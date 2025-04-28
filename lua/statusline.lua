local function mode()
  local m = vim.api.nvim_get_mode().mode
  local map = {
    n = 'NORMAL', i = 'INSERT', v = 'VISUAL', V = 'V-LINE',
    [''] = 'V-BLOCK', c = 'COMMAND', R = 'REPLACE', t = 'TERMINAL',
  }
  return map[m] or 'OTHER'
end

local function file()
  local name = vim.fn.expand('%:t')
  if name == '' then return '[No File]' end
  return name
end

local function position()
  return string.format('%3d:%-2d', vim.fn.line('.'), vim.fn.col('.'))
end

local function branch()
  local b = vim.fn.systemlist('git branch --show-current')[1] or ''
  if b ~= '' then
    return '? ' .. b
  else
    return ''
  end
end

function StatusLine()
  return table.concat({
    ' ', mode(),
    ' | ', file(),
    ' | ', branch(),
    ' %= ',  -- align right
    position(), ' '
  })
end

vim.o.statusline = '%!v:lua.StatusLine()'
