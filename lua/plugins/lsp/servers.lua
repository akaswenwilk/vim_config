local M = {}

local servers = {
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
        diagnostics = {
          globals = { 'vim' },
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

local function lsp_attach(on_attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, bufnr)
    end,
  })
end

function M.setup()
  lsp_attach(function(client, buffer)
    require("plugins.lsp.format").on_attach(client, buffer)
    require("plugins.lsp.keymaps").on_attach(client, buffer)
  end)

  local lspconfig = require("lspconfig")

  for server, config in pairs(servers) do
    lspconfig[server].setup(config)
  end
end

return M
