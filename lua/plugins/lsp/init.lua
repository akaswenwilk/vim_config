return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("plugins.lsp.servers").setup()
    end,
  },
}

