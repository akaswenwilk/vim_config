return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "b0o/schemastore.nvim",
    },
    config = function()
      require("plugins.lsp.servers").setup()
    end,
  },
}

