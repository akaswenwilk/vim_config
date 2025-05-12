return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  keys = {
    { "<C-p>", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
    { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
    { "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "Git Files" },
    { "<leader>F", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
    {
      "<leader>g",
      function()
        vim.cmd('normal! "zy')
        local text = vim.fn.getreg('z')
        text = vim.fn.escape(text, '\\/.*$^~[]')
        require('telescope.builtin').live_grep({ default_text = text })
      end,
      mode = "x",
    },
  },
  config = function()
    require("telescope").setup({
      defaults = {
        preview = true,
        previewer = true,
        layout_strategy = "horizontal",
        layout_config = {
          preview_width = 0.55,
          prompt_position = "top",
        },
        sorting_strategy = "ascending",
        winblend = 0, -- fully opaque
      },
    })
  end,
  --
  --   -- Disable syntax highlighting in preview buffer
  --   vim.api.nvim_create_autocmd("User", {
  --     pattern = "TelescopePreviewerLoaded",
  --     callback = function(_)
  --       vim.cmd("setlocal syntax=")
  --       vim.cmd("redraw | sleep 10m")
  --     end,
  --   })
  -- end,
}
