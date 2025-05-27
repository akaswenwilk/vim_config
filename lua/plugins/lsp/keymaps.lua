local M = {}

function M.on_attach()
  local keymap = vim.keymap.set
  local builtin = require("telescope.builtin")

  keymap("n", "<leader>er", M.diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
  keymap("n", "<leader>h", M.diagnostic_goto(true, "HINT"), { desc = "Next Error" })
  keymap("n", "<leader>w", M.diagnostic_goto(true, "WARN"), { desc = "Next Error" })

  keymap("n", "gd", builtin.lsp_definitions, { desc = "Goto Definition" })
  
  keymap("n", "<leader>d", builtin.lsp_definitions, { desc = "Goto Definition" })
  
  keymap("n", "<leader>dv", function()
      vim.cmd("vsplit")
      builtin.lsp_definitions()
  end, { desc = "Goto Definition" })

  keymap("n", "<leader>r", function()
    builtin.lsp_references({
      show_line = false,
      include_declaration = false,
      jump_type = "never",
    })
  end, { desc = "Find references (Telescope → Quickfix)" })

  keymap("n", "<leader>i", builtin.lsp_implementations, { desc = "Goto Implementation" })

  keymap("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })

  keymap("n", "<leader>t", function()
      vim.cmd("vsplit")
      require("telescope.builtin").lsp_type_definitions()
  end, { desc = "Goto Type Definition" })

  keymap("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
  keymap({ "x", "n"}, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
  vim.api.nvim_create_user_command("Errors", function()
    local diagnostics = vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    print("Error count:", #diagnostics)
  end, {})
  local errors_keys = { 'e', 'er', 'error', 'errors' }
  for _, key in ipairs(errors_keys) do
    keymap('ca', key, 'Errors', { desc = "Errors" })
  end
end

function M.diagnostic_goto(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go { severity = severity }
  end
end

return M
