return {
  {
    "mason-org/mason-lspconfig.nvim",
    lazy = false,
    config = function()
      local servers = require('plugins.lsp.servers')
      local server_names = {}
      for name, config in pairs(servers) do
        table.insert(server_names, name)
        vim.lsp.config(name, config)
      end

      require("mason-lspconfig").setup({
        ensure_installed =  { unpack(server_names) },
      })
    end,
    dependencies = {
        {
          "mason-org/mason.nvim",
          build = ":MasonUpdate",
          opts = {}
        },
        "neovim/nvim-lspconfig",
    },
  },
  {
    "nvimtools/none-ls.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "jay-babu/mason-null-ls.nvim",
    },
    config = function()
      local formatters = require("plugins.lsp.formatters")
      local sources = {}
      for name, methods in pairs(formatters) do
        for _, method in ipairs(methods) do
          local source = require("null-ls").builtins[method][name]
          if source then
            table.insert(sources, source)
          end
        end
      end
      require("null-ls").setup({
        sources = sources,
      })
    end,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    lazy = false,
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "nvimtools/none-ls.nvim",
    },
  }
}
