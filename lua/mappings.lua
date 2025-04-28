local keymap = vim.keymap.set

-- Normal Mode
keymap('n', '<leader>ev', ':vsplit $MYVIMRC<CR>')
keymap('n', '<leader>sv', ':source $MYVIMRC<CR>')
keymap('n', '/', '/\\v', { noremap = true })
keymap('n', '<leader>hl', ':noh<CR>')
keymap('n', '<leader>tn', ':tabn<CR>')
keymap('n', '<leader>tp', ':tabp<CR>')
keymap('n', '<leader>q', ':q!<CR>')
keymap('n', '<C-h>', '<C-w>h')
keymap('n', '<C-j>', '<C-w>j')
keymap('n', '<C-k>', '<C-w>k')
keymap('n', '<C-l>', '<C-w>l')
keymap('n', '<leader><Up>', ':resize +5<CR>')
keymap('n', '<leader><Down>', ':resize -5<CR>')
keymap('n', '<leader><Left>', ':vertical resize -5<CR>')
keymap('n', '<leader><Right>', ':vertical resize +5<CR>')

-- Visual Mode
keymap('v', '<C-c>', '"+y')
keymap('v', '<leader>g', ":<C-u>lua require('search').ack_visual()<CR>")

-- Insert Mode
keymap('i', '<C-h>', '<Esc><C-w>h')
keymap('i', '<C-l>', '<Esc><C-w>l')
keymap('i', '<C-u>', '<C-o>:lua require("utils").insert_uuid()<CR>')

-- Copilot remaps
keymap('i', '<C-j>', '<Plug>(copilot-next)', { silent = true })
keymap('i', '<C-k>', '<Plug>(copilot-previous)', { silent = true })

-- Other mappings (FZF, NerdTree, etc.)
keymap('n', '<C-p>', ':FZF<CR>')
keymap('n', '<leader>nt', ':NERDTreeToggle<CR>')
keymap('n', '<leader>er', '<Plug>(ale_next_wrap)')
keymap('n', '<leader>d', '<Plug>(ale_go_to_definition)')
keymap('n', '<leader>dv', ':vsplit<CR><Plug>(ale_go_to_definition)')
keymap('n', '<leader>t', ':vsplit<CR><Plug>(ale_go_to_type_definition)')
keymap('n', '<leader>i', ':vsplit<CR><Plug>(go_to_implementation)')
keymap('n', '<leader>r', ':ALEFindReferences -relative<CR>')
keymap('n', '<leader>rn', '<Plug>(ale_rename)')
keymap('n', 'K', '<Plug>(ale_hover)', { silent = true })
keymap('n', '<leader>F', ":call AckOperatorFullTextSearch('', '.')<Left><Left><Left><Left><Left><Left><Left>")

-- Diff
keymap('n', '<leader>1', ':diffget LOCAL<CR>')
keymap('n', '<leader>2', ':diffget BASE<CR>')
keymap('n', '<leader>3', ':diffget REMOTE<CR>')
