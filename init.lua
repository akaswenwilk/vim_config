require('config.01pre')

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    require('config.02post')
  end,
})
