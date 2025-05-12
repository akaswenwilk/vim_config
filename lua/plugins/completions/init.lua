return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
          require("copilot").setup({
            suggestion = { enabled = true, auto_trigger = true },
            panel       = { enabled = false },
          })
        end,
      },
      {
        "zbirenbaum/copilot-cmp",
        after = "copilot.lua",
        config = function()
          require("copilot_cmp").setup()
        end,
      },
    },
    config = function()
      local cmp            = require("cmp")
      local icons          = require("config.icons")
      local copilot_suggest = require("copilot.suggestion")

      cmp.setup {
        completion = { completeopt = "menu,menuone,noinsert" },
        mapping = cmp.mapping.preset.insert {
          ["<Tab>"] = cmp.mapping(function(fallback)
            if copilot_suggest.is_visible() then
              copilot_suggest.accept()
            elseif cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { "i" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i" }),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm { select = true },
        },
        sources = cmp.config.sources {
          { name = "copilot" },
          { name = "nvim_lsp_signature_help" },
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        },
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, item)
            local source_names = {
              copilot                 = "(Copilot)",
              nvim_lsp_signature_help = "(Sig)",
              nvim_lsp                = "(LSP)",
              buffer                  = "(Buf)",
              path                    = "(Path)",
            }
            item.kind = icons.kind[item.kind]
            item.menu = source_names[entry.source.name] or ""
            return item
          end,
        },
      }

      -- buffer source for `/` and `?`
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = "buffer" } },
      })

      -- cmdline & path for `:`
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources(
          { { name = "path" } },
          { { name = "cmdline" } }
        ),
      })
    end,
  },
}
