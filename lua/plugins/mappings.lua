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

vim.api.nvim_create_autocmd("User", {
  pattern = "FugitiveIndex",
  callback = function()
    vim.keymap.set("n", "t", function()
      local file = vim.fn.expand("<cfile>")
      vim.cmd("tabedit " .. file)
    end, { buffer = true, silent = true })

    vim.keymap.set("n", "v", function()
      local file = vim.fn.expand("<cfile>")
      vim.cmd("vsplit " .. file)
    end, { buffer = true, silent = true })
  end,
})
