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
            panel      = { enabled = false },
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
      -- {
      --   'milanglacier/minuet-ai.nvim',
      --   config = function()
      --     require('minuet').setup {
      --       provider = 'openai_fim_compatible',
      --       n_completions = 1, -- recommend for local model for resource saving
      --       context_window = 1024,
      --       provider_options = {
      --         openai_fim_compatible = {
      --           api_key = 'TERM',
      --           name = 'Ollama',
      --           end_point = 'http://localhost:11434/v1/completions',
      --           model = 'qwen2.5-coder:7b',
      --           optional = {
      --             max_tokens = 56,
      --             top_p = 0.9,
      --           },
      --         },
      --       },
      --     }
      --   end,
      -- },
    },
    config = function()
      local cmp = require("cmp")
      local icons = require("config.icons")
      local copilot_suggest = require("copilot.suggestion")

      vim.lsp.config("*", { capabilities = require("cmp_nvim_lsp").default_capabilities() })

      cmp.setup({
        completion = { completeopt = "menu,menuone,noinsert" },
        mapping = {
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
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<Down>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { "i" }),
          ["<Up>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i" }),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.close(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          -- ["<C-y>"] = require('minuet').make_cmp_map(),
          ["<Esc>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.abort()
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
            else
              fallback()
            end
          end, { "i" }),
        },
        sources = {
          -- { name = 'minuet' },
          { name = "copilot" },
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        },
        performance = {
          -- It is recommended to increase the timeout duration due to
          -- the typically slower response speed of LLMs compared to
          -- other completion sources. This is not needed when you only
          -- need manual completion.
          fetching_timeout = 2000,
        },
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, item)
            item.kind = icons.kind[item.kind]
            item.menu = ({
              -- minuet   = "(Minuet AI)",
              copilot  = "(Copilot)",
              nvim_lsp = "[LSP]",
              buffer   = "[Buffer]",
              path     = "[Path]",
            })[entry.source.name] or ""
            return item
          end,
        },
      })

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = "buffer" } },
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources(
          { { name = "path" } },
          { { name = "cmdline" } }
        ),
      })
    end,
  }
}
