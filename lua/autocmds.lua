vim.api.nvim_create_autocmd({"BufLeave", "InsertLeave", "CursorHold"}, {
  callback = function()
    if not vim.o.readonly then
      vim.cmd('silent! update')
    end
  end
})

vim.api.nvim_create_autocmd({"FocusGained", "BufEnter"}, {
  callback = function()
    vim.cmd('checktime')
  end
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.bufname('') == '' then
      vim.cmd('NERDTreeToggle')
    end
  end
})

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*.lua" },
  callback = function()
    local file = vim.fn.expand('%')
    if file:find(vim.fn.stdpath('config'), 1, true) then
      vim.cmd('source ' .. file)
      vim.notify('Reloaded ' .. file, vim.log.levels.INFO)
    end
  end
})
