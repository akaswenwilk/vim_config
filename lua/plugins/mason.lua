return {
  { "neovim/nvim-lspconfig", lazy = false },
  {
    "mason-org/mason.nvim",
    build = ":MasonUpdate",
    lazy = false,
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
        border = "rounded",
      },
    },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "neovim/nvim-lspconfig", "mason-org/mason.nvim" },
    lazy = false,
    opts = {
      automatic_installation = true,
      ensure_installed = {
        "gopls",
        "ts_ls",
        "eslint",
        "lua_ls",
        "pyright",
        "rust_analyzer",
        "ruby_lsp",
        "solargraph",
      },
      handlers = {
       -- default for all servers
       function(server)
         vim.lsp.config[server].setup({})
       end,

       -- ruby_lsp (disable LSP formatting if you use none-ls)
       ruby_lsp = function()
         vim.lsp.config.ruby_lsp.setup({
           on_attach = function(client) client.server_capabilities.documentFormattingProvider = false end,
         })
       end,

       -- optional: solargraph
       solargraph = function()
         vim.lsp.config.solargraph.setup({
           on_attach = function(client) client.server_capabilities.documentFormattingProvider = false end,
           settings = { solargraph = { diagnostics = true } },
         })
       end,
      },
    },
  },

  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "jay-babu/mason-null-ls.nvim",
    },
    lazy = false,
    config = function()
      require("mason-null-ls").setup({
        automatic_installation = true,
        ensure_installed = {
          "stylua",
          "prettier", "eslint_d",
          "black", "isort", "ruff",
          "shfmt", "shellcheck",
          "gofumpt", "golangci-lint", "golines",
          "rubocop", "standardrb", "erb-lint",
        },
      })

      local null_ls = require("null-ls")
      local ruby_formatter = null_ls.builtins.formatting.standardrb
      -- local ruby_formatter = null_ls.builtins.formatting.rubocop

      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.prettier,
          null_ls.builtins.diagnostics.eslint_d,
          null_ls.builtins.code_actions.eslint_d,
          null_ls.builtins.formatting.black,
          null_ls.builtins.formatting.isort,
          null_ls.builtins.diagnostics.ruff,
          null_ls.builtins.formatting.shfmt.with({ extra_args = { "-i", "2" } }),
          null_ls.builtins.diagnostics.shellcheck,
          null_ls.builtins.formatting.gofumpt,
          null_ls.builtins.formatting.golines,
          null_ls.builtins.diagnostics.golangci_lint,
          ruby_formatter,
          null_ls.builtins.diagnostics.rubocop,
          null_ls.builtins.diagnostics.erb_lint,
        },
      })

      local prefer_null = {
        lua = true, javascript = true, typescript = true, javascriptreact = true,
        typescriptreact = true, json = true, yaml = true, markdown = true,
        sh = true, bash = true, python = true, ruby = true, eruby = true,
      }
      local aug = vim.api.nvim_create_augroup("FormatOnSave", { clear = true })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = aug,
        callback = function(args)
          local ft = vim.bo[args.buf].filetype
          vim.lsp.buf.format({
            bufnr = args.buf,
            timeout_ms = 3000,
            filter = function(client)
              if prefer_null[ft] then return client.name == "null-ls" end
              return true
            end,
          })
        end,
      })
    end,
  },
}
