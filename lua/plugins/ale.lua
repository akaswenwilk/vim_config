return {
  {
    "dense-analysis/ale",
    init = function()
      -- ALE Linters and Fixers
      vim.g.ale_linters = {
        go = { "gopls", "golangci-lint" },
        avdl = { "jsonlint" },
        lua = { "luacheck" },
      }
      vim.g.ale_fixers = {
        go = { "gofmt", "goimports" },
      }
      vim.g.ale_fix_on_save = 1

      -- gopls Configuration with Build Tags
      vim.g.ale_go_gopls_options = "--remote=auto"
      vim.g.ale_go_gopls_init_options = {
        buildFlags = { "-tags=integration,functional" },
      }

      -- Additional Go Settings
      vim.g.go_fmt_fail_silently = 1
      vim.g.go_build_tags = "integration,functional"

      -- Key Mappings
      vim.api.nvim_set_keymap("n", "<leader>er", "<Plug>(ale_next_wrap)", {})
      vim.api.nvim_set_keymap("n", "<leader>d", "<Plug>(ale_go_to_definition)", {})
      vim.api.nvim_set_keymap("n", "<leader>dv", ":vsplit<CR><Plug>(ale_go_to_definition)", {})
      vim.api.nvim_set_keymap("n", "<leader>t", ":vsplit<CR><Plug>(ale_go_to_type_definition)", {})
      vim.api.nvim_set_keymap("n", "<leader>i", ":vsplit<CR><Plug>(go_to_implementation)", {})
      vim.api.nvim_set_keymap("n", "<leader>r", ":ALEFindReferences -relative<CR>", {})
      vim.api.nvim_set_keymap("n", "<leader>rn", "<Plug>(ale_rename)", {})
      vim.api.nvim_set_keymap("n", "K", ":<Plug>(ale_hover)<CR>", { silent = true })
    end,
  },
}
