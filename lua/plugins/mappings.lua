local keymap = vim.keymap.set
vim.cmd([[
  cnoreabbrev gp lua require('custom.utils').git_push()
  cnoreabbrev ggfl lua require('custom.utils').git_force_push()
  cnoreabbrev gup Git pull --rebase
  cnoreabbrev space lua require('custom.utils').copy_pwd()
  cnoreabbrev ff lua require('custom.utils').copy_current_file()
  cnoreabbrev errcount lua require('custom.utils').list_error_count()
  cnoreabbrev diffbuff lua require('custom.utils').diff_buffers()
]])

keymap('n', '<leader>nt', ':NERDTreeToggle<CR>')

local builtin = require('telescope.builtin')
keymap('n', '<C-p>', builtin.find_files)
keymap('n', '<leader>F', builtin.live_grep)
keymap('v', '<leader>g', function()
  -- Yank the selected text into the "z" register
  vim.cmd('normal! "zy')
  -- Retrieve the text from the "z" register
  local text = vim.fn.getreg('z')
  -- Escape special characters in the text
  text = vim.fn.escape(text, '\\/.*$^~[]')
  -- Call Telescope's grep_string with the escaped text
  builtin.live_grep({ default_text = text })
end, { noremap = true, silent = true })
--keymap('n', '<leader>er', '<Plug>(ale_next_wrap)')

-- Copilot remaps
--keymap('i', '<C-j>', '<Plug>(copilot-next)', { silent = true })
--keymap('i', '<C-k>', '<Plug>(copilot-previous)', { silent = true })

-- Other mappings (FZF, NerdTree, etc.)
--keymap('n', '<C-p>', ':FZF<CR>')
--keymap('n', '<leader>d', '<Plug>(ale_go_to_definition)')
--keymap('n', '<leader>dv', ':vsplit<CR><Plug>(ale_go_to_definition)')
--keymap('n', '<leader>t', ':vsplit<CR><Plug>(ale_go_to_type_definition)')
--keymap('n', '<leader>i', ':vsplit<CR><Plug>(go_to_implementation)')
--keymap('n', '<leader>r', ':ALEFindReferences -relative<CR>')
--keymap('n', '<leader>rn', '<Plug>(ale_rename)')
--keymap('n', 'K', '<Plug>(ale_hover)', { silent = true })
