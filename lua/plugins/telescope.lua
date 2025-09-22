return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  config = function()
    require("telescope").setup({
      defaults = {
        preview = true,
        previewer = true,
        layout_strategy = "horizontal",
        layout_config = { preview_width = 0.55, prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
      },
    })
  end
}
