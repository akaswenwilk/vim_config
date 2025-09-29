return {
  {
    "nvim-tree/nvim-web-devicons",
    opts = { default = true },
  },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    opts = {
      options = {
        mode = "tabs",           -- show buffers, not tabs
        numbers = "buffer_id",           -- no buffer numbers
        diagnostics = "nvim_lsp",   -- show LSP diagnostics
        separator_style = "slant",  -- "slant", "padded_slant", "thick", "thin"
        always_show_bufferline = true,
      },
    },
  },
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
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
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
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gdiffsplit", "Gvdiffsplit" }, -- lazy-load on git commands
  },
  {
    "MagicDuck/grug-far.nvim",
    cmd = { "GrugFar" }, -- lazy-load on command
  },
}
