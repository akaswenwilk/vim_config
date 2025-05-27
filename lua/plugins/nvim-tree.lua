return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local icons = require("config.icons")
    local api   = require("nvim-tree.api")

    local function on_attach(bufnr)
      api.config.mappings.default_on_attach(bufnr)  -- load defaults  [oai_citation:0‡GitHub](https://github.com/nvim-tree/nvim-tree.lua)

      local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      vim.keymap.set('n', '<C-e>', '<C-e>', opts('Scroll window down'))
      vim.keymap.set('n', '<C-y>', '<C-y>', opts('Scroll window up'))
    end

    require("nvim-tree").setup {
      on_attach = on_attach,
      git = {
        enable = true,
        ignore = false,
        timeout = 400,
      },
      diagnostics = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = true,
        debounce_delay = 50,
        icons = {
          hint = icons.diagnostics.Hint,
          info = icons.diagnostics.Information,
          warning = icons.diagnostics.Warning,
          error = icons.diagnostics.BoldError,
        },
      },
    }
  end,
}
