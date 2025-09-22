-- nvim 0.11+-ready lsp setup (no root_pattern nil, no 0.11 warnings)

local M = {}

local lsp = require('lspconfig')
local util = require('lspconfig.util')

-- capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.offsetEncoding = { "utf-16" }
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- servers
local servers = {
  jsonls = {
    filetypes = { "json", "jsonc", "avsc" },
    root_dir = util.root_pattern(".git", "."),
    settings = { json = { validate = { enable = true } } },
    capabilities = capabilities,
  },

  ts_ls = {
    filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
    root_dir = util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
    capabilities = capabilities,
  },

  eslint = {
    cmd = { "vscode-eslint-language-server", "--stdio" },
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    root_dir = util.root_pattern(
      ".eslintrc",
      ".eslintrc.cjs",
      ".eslintrc.js",
      ".eslintrc.json",
      "package.json",
      ".git"
    ),
    settings = { format = true },
    capabilities = capabilities,
  },

  zls = {
    cmd = { "zls" },
    filetypes = { "zig" },
    root_dir = util.root_pattern("build.zig", ".git"),
    capabilities = capabilities,
  },

  solargraph = {
    cmd = { "solargraph", "stdio" },
    filetypes = { "ruby" },
    root_dir = util.root_pattern("Gemfile", ".git"),
    settings = {
      solargraph = {
        diagnostics = true,
        formatting = true,
      },
    },
    capabilities = capabilities,
  },

  rust_analyzer = {
    root_dir = util.root_pattern("Cargo.toml", ".git"),
    settings = {
      ["rust-analyzer"] = {
        cargo = { allFeatures = true },
        checkOnSave = { command = "clippy" },
      },
    },
    capabilities = capabilities,
  },

  gopls = {
    root_dir = util.root_pattern("go.work", "go.mod", ".git"),
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
    capabilities = capabilities,
  },

  lua_ls = {
    root_dir = util.root_pattern(".luarc.json", ".luarc.jsonc", ".git"),
    settings = {
      Lua = {
        diagnostics = { globals = { 'vim' } },
        workspace = { checkThirdParty = false },
        completion = { callSnippet = "Replace" },
        telemetry = { enable = false },
        hint = { enable = false },
      },
    },
    capabilities = capabilities,
  },

  gh_actions_ls = {
    default_config = {
      cmd = { 'gh-actions-language-server', '--stdio' },
      filetypes = { 'yaml.github' },
      root_dir = util.root_pattern('.github'),
      single_file_support = true,
    },
  },

  dockerls = {
    root_dir = util.root_pattern("Dockerfile", ".git"),
    capabilities = capabilities,
  },

  -- note: bufls deprecated → buf_ls (server name below)
  buf_ls = {
    cmd = { "bufls", "serve" },
    filetypes = { "proto" },
    root_dir = util.root_pattern("buf.yaml", ".git"),
    capabilities = capabilities,
  },

  vimls = {
    cmd = { "vim-language-server", "--stdio" },
    filetypes = { "vim" },
    root_dir = util.find_git_ancestor,
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
    capabilities = capabilities,
  },
}

-- LspAttach helper
local function lsp_attach(on_attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if not client then return end
      on_attach(client, bufnr)
    end,
  })
end

function M.setup()
  require("nvim-treesitter.configs").setup {
    ensure_installed = {
      "json", "javascript", "typescript", "tsx", "zig", "ruby", "rust", "go", "lua", "yaml", "dockerfile", "proto", "vim",
    },
    highlight = { enable = true, additional_vim_regex_highlighting = false },
    sync_install = false,
    auto_install = true,
  }
  vim.g.polyglot_disabled = { "json" }

  lsp_attach(function(client, buffer)
    require("plugins.lsp.format").on_attach(client, buffer)
    require("plugins.lsp.keymaps").on_attach()
  end)

  -- nvim 0.11+: lspconfig still supports setup(); no deprecation warnings when used this way
  for server, config in pairs(servers) do
    vim.lsp.config(server, config)
    vim.lsp.enable(server)
  end
end

return M
