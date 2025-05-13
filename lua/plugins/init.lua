return {
  -- { "mfussenegger/nvim-lint", enabled = false },
  -- { "stevearc/conform.nvim", enabled = false },
  -- "nvim-lua/plenary.nvim",
  -- "MunifTanjim/nui.nvim",
  -- "echasnovski/mini.icons",
  {
    "nvim-tree/nvim-web-devicons",
    opts = { default = true },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
  },
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true
    -- use opts = {} for passing setup options
    -- this is equivalent to setup({}) function
  },
  -- {
  --   "folke/snacks.nvim",
  --   priority = 1000,
  --   event = "VeryLazy",
  --   opts = {},
  -- },
  -- {
  --   "rcarriga/nvim-notify",
  --   event = "VeryLazy",
  --   enabled = true,
  --   opts = {},
  -- },
  -- {
  --   "sindrets/diffview.nvim",
  --   cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
  --   opts = {},
  -- },
  {
    "TimUntersberger/neogit",
    cmd = "Neogit",
    opts = {
      integrations = { diffview = true },
    },
    keys = {
      { "<leader>gs", "<cmd>Neogit kind=floating<cr>", desc = "Status" },
    },
  },
  {
    "kylechui/nvim-surround",
    version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end,
  },
}
