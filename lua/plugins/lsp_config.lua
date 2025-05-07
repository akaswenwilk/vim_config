-- LSP setup for Go
local lspconfig = require("lspconfig")

lspconfig.gopls.setup({
        cmd = { "gopls" },
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        root_dir = lspconfig.util.root_pattern("go.work", "go.mod", ".git"),
        settings = {
                gopls = {
                        gofumpt = true,
                        usePlaceholders = true,
                        analyses = {
                                unusedparams = true,
                                shadow = true,
                        },
                        staticcheck = true,
                        buildFlags = { "-tags=integration,functional" },
                },
        },
})

vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
                local buf = args.buf
                local map = function(mode, lhs, rhs)
                        vim.keymap.set(mode, lhs, rhs, { buffer = buf })
                end

                map("n", "<leader>d", vim.lsp.buf.definition)
                map("n", "gd", vim.lsp.buf.definition)
                map("n", "<leader>dv", function()
                        vim.cmd("vsplit")
                        vim.lsp.buf.definition()
                end)
                map("n", "<leader>rn", vim.lsp.buf.rename)
                map("n", "<leader>ca", vim.lsp.buf.code_action)
                map("n", "<leader>r", function()
                        vim.lsp.buf.references(nil, {
                                on_list = function(opts)
                                        vim.fn.setqflist({}, " ", opts)
                                        vim.cmd("copen")
                                end,
                        })
                end)
                map("n", "<leader>i", function()
                        vim.lsp.buf.implementation({
                                on_list = function(opts)
                                        vim.fn.setqflist({}, " ", opts)
                                        vim.cmd("copen")
                                end,
                        })
                end)
                map("n", "<leader>t", function()
                        vim.cmd("vsplit")
                        vim.lsp.buf.type_definition()
                end)
                map("n", "K", function()
                        if vim.bo.filetype ~= "go" then return end

                        local cword = vim.fn.expand("<cword>")
                        local url = "https://pkg.go.dev/search?q=" .. vim.fn.escape(cword, " ")
                        vim.fn.jobstart({ "open", url }, { detach = true })
                end)
                map("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end)
        end,
})
