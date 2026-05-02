return {
  -- Debug adapter executables installed by Mason.
  -- Go/Rust/Python extras configure their language-specific DAP integrations when nvim-dap is enabled.
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "debugpy",
        "delve",
        "codelldb",
        "js-debug-adapter",
      })
    end,
  },

  -- JavaScript/TypeScript debugging via vscode-js-debug's js-debug-adapter.
  {
    "mfussenegger/nvim-dap",
    optional = true,
    opts = function()
      local dap = require("dap")

      for _, adapter_type in ipairs({ "node", "chrome", "msedge" }) do
        local pwa_type = "pwa-" .. adapter_type

        if not dap.adapters[pwa_type] then
          dap.adapters[pwa_type] = {
            type = "server",
            host = "localhost",
            port = "${port}",
            executable = {
              command = "js-debug-adapter",
              args = { "${port}" },
            },
          }
        end

        -- VS Code launch.json compatibility for type = "node" / "chrome" / "msedge".
        if not dap.adapters[adapter_type] then
          dap.adapters[adapter_type] = function(callback, config)
            config.type = pwa_type
            local native_adapter = dap.adapters[pwa_type]
            if type(native_adapter) == "function" then
              native_adapter(callback, config)
            else
              callback(native_adapter)
            end
          end
        end
      end

      local js_filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" }
      local vscode = require("dap.ext.vscode")
      vscode.type_to_filetypes["node"] = js_filetypes
      vscode.type_to_filetypes["pwa-node"] = js_filetypes

      for _, language in ipairs(js_filetypes) do
        dap.configurations[language] = dap.configurations[language] or {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch current file",
            program = "${file}",
            cwd = "${workspaceFolder}",
            sourceMaps = true,
            runtimeExecutable = language:find("typescript") and (vim.fn.executable("tsx") == 1 and "tsx" or "ts-node")
              or nil,
            skipFiles = { "<node_internals>/**", "node_modules/**" },
            resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach to process",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
            sourceMaps = true,
            skipFiles = { "<node_internals>/**", "node_modules/**" },
            resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
          },
        }
      end
    end,
  },

  -- Ruby debugging is provided by LazyVim's ruby extra through suketa/nvim-dap-ruby.
  -- You may still need the Ruby debug gems in projects that use it:
  --   gem install debug
}
