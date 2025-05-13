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
  dockerls = {},
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
