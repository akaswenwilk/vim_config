local keymap = vim.keymap.set

-- Normal Mode
keymap('n', '<leader>ev', ':vsplit $MYVIMRC<CR>')
keymap('n', '<leader>sv', ':source $MYVIMRC<CR>')
keymap('n', '/', '/\\v', { noremap = true })
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
--keymap('v', '<leader>g', ":<C-u>lua require('custom.search').ack_visual()<CR>")

-- Insert Mode
keymap('i', '<C-h>', '<Esc><C-w>h')
keymap('i', '<C-l>', '<Esc><C-w>l')
keymap('i', '<C-u>', '<C-o>:lua require("custom.utils").insert_uuid()<CR>')

-- expose a global operatorfunc wrapper
function _G.SearchOp(type)
  require('custom.utils').search_operator(type)
end

-- map <leader>/ to call the operator
keymap('n', '<leader>/', '<cmd>set operatorfunc=v:lua.SearchOp<CR>g@', {
  noremap = true,
  silent = true,
  desc = 'Operator: highlight motion and search buffer'
})
keymap('n', '<leader>hl', ':noh<CR>:lua require("custom.utils").delete_searches()<CR>')





-- keymap('n', '<leader>F', function()
--   local query = vim.fn.input('Search for: ')
--   if query == '' then return end
--   local dir   = vim.fn.input('Directory: ', '.', 'dir')
--   require('search').ack_full_text_search(query, dir)
--   vim.cmd('copen')
-- end, { noremap = true, silent = true, desc = 'Full-text search (Ack)' })
--

-- Diff
keymap('n', '<leader>1', ':diffget LOCAL<CR>')
keymap('n', '<leader>2', ':diffget BASE<CR>')
keymap('n', '<leader>3', ':diffget REMOTE<CR>')


keymap("n", "<leader>er", function()
  vim.diagnostic.goto_next({ severity = nil })
end)

vim.api.nvim_create_user_command("File", function()
  local path = vim.fn.expand("%")
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path)
end, {})
