return {
    "akinsho/nvim-bufferline.lua",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require("bufferline").setup {
        options = {
          numbers = "ordinal",
          diagnostics = "nvim_lsp",
          separator_style = "slant" or "padded_slant",
          show_tab_indicators = true,
          show_buffer_close_icons = false,
          show_close_icon = false,
          middle_mouse_command = "bdelete! %d",
        },
      }
    end,
}
