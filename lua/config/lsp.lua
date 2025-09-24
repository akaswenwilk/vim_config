local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.offsetEncoding = { "utf-16" }
capabilities.textDocument.completion.completionItem.snippetSupport = true

local servers = {
  jsonls = {
    filetypes = { "json", "jsonc", "avsc" },
    root_dir = require("lspconfig").util.root_pattern(".git", "."),
    settings = {
      json = {
        validate = { enable = true },
      },
    },
    capabilities = capabilities,
  },
  ts_ls = {
    filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
    root_dir = require("lspconfig").util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
    capabilities = capabilities,
  },
  eslint = {
    cmd = { "vscode-eslint-language-server", "--stdio" },
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    root_dir = require("lspconfig").util.root_pattern(".eslintrc", ".eslintrc.js", "package.json", ".git"),
    settings = {
      format = true,
    },
    capabilities = capabilities,
  },
  zls = {
    cmd = { "zls" },
    filetypes = { "zig" },
    root_dir = require("lspconfig").util.root_pattern("build.zig", ".git"),
    capabilities = capabilities,
  },
  solargraph = {
    cmd = { "solargraph", "stdio" },
    filetypes = { "ruby" },
    root_dir = require("lspconfig").util.root_pattern("Gemfile", ".git"),
    settings = {
      solargraph = {
        diagnostics = true,
        formatting = true,
      },
    },
    capabilities = capabilities,
  },
  rust_analyzer = {
    settings = {
      ["rust-analyzer"] = {
        cargo = {
          allFeatures = true,
        },
        checkOnSave = {
          command = "clippy",
        },
      },
    },
    capabilities = capabilities,
    root_dir = require("lspconfig").util.root_pattern("Cargo.toml", ".git"),
  },
  gopls = {
    settings = {
      gopls = {
        buildFlags = { "-tags=integration,functional" },
        usePlaceholders = true,
        completeUnimported = true,
        staticcheck = true,
        analyses = {
          unusedparams = true,
          unreachable = true,
          nilness = true,
          shadow = true,
        },
        codelenses = {
          test = true,
          tidy = true,
          upgrade_dependency = true,
          vendor = false,
        },
      },
    },
  },
  lua_ls = {
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        diagnostics = {
          globals = { "vim", "require", "LazyVim" },
        },
        workspace = {
          checkThirdParty = false,
        },
        completion = { callSnippet = "Replace" },
        telemetry = { enable = false },
        hint = {
          enable = false,
        },
      },
    },
  },
  gh_actions_ls = {
    default_config = {
      cmd = { 'gh-actions-language-server', '--stdio' },
      filetypes = { 'yaml.github' },
      root_dir = require('lspconfig').util.root_pattern('.github'),
      single_file_support = true,
    },
  },
  dockerls = {},
  buf_ls = {
    cmd = { "bufls", "serve" },
    filetypes = { "proto" },
    root_dir = require("lspconfig").util.root_pattern("buf.yaml", ".git"),
  },
  vimls = {
    cmd = { "vim-language-server", "--stdio" },
    filetypes = { "vim" },
    root_dir = require("lspconfig").util.find_git_ancestor,
    single_file_support = true,
    init_options = {
      isNeovim = true,
      vimruntime = vim.env.VIMRUNTIME,
      runtimepath = vim.o.runtimepath,
      diagnostic = { enable = true },
      indexes = {
        runtimepath = true,
        gap = 100,
        count = 3,
        projectRootPatterns = { "runtime", "nvim", ".git", "autoload", "plugin" },
      },
      suggest = { fromVimruntime = true, fromRuntimepath = true },
    },
  },
}


for name, config in pairs(servers) do
  vim.lsp.config(name, config)
  require("mason").setup()
  -- Note: `nvim-lspconfig` needs to be in 'runtimepath' by the time you set up mason-lspconfig.nvim
  require("mason-lspconfig").setup {
    ensure_installed = { "lua_ls" }
  }
end

-- lint/format on autosave
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', {}),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

    -- Auto-format ("lint") on save.
    -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
    if not client:supports_method('textDocument/willSaveWaitUntil')
        and client:supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
        end,
      })
    end
  end,
})
