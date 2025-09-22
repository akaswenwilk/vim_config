local M = {}

function M.on_attach(client, bufnr)
  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function()
        -- Organize imports first if supported
        local params = vim.lsp.util.make_range_params()
        params.context = { only = { "source.organizeImports" } }

        local result = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 1000)
        if result then
          for _, res in pairs(result) do
            for _, action in pairs(res.result or {}) do
              if action.edit then
                vim.lsp.util.apply_workspace_edit(action.edit, "utf-8")
              elseif action.command then
                vim.lsp.buf.execute_command(action.command)
              end
            end
          end
        end

        -- Then format
        vim.lsp.buf.format({ bufnr = bufnr })
      end,
    })
  end
end

return M
