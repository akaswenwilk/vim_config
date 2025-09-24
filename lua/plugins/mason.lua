return {
  {
    "mason-org/mason.nvim",
    build = ":MasonUpdate",
    lazy = false,
    opts = {}
  },
  {
    "mason-org/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      ensure_installed = { 
        "lua_ls", 
        "rust_analyzer",
        "gopls",
        "ts_ls",
        "eslint",
        "pyright",
        "ruby_lsp",
        "solargraph"
      },
    },
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
    },
  }
}
