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

vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(args)
    vim.lsp.buf.format({ async = false, bufnr = args.buf })
  end,
})


vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.keymap.set("n", "t", "<C-W><CR><C-W>T", { buffer = true, noremap = true, silent = true })
  end,
})
