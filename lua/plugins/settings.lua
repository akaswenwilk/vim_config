vim.cmd("colorscheme gruvbox")

vim.g.NERDTreeShowHidden = 1
vim.g.NERDTreeGitStatusShowIgnored = 1
vim.g.NERDTreeGitStatusUseNerdFonts = 1
vim.g.NERDTreeGitStatusShowClean = 0
vim.g.NERDTreeGitStatusIndicatorMapCustom = {
	Modified = "✹",
	Staged = "✚",
	Untracked = "✭",
	Renamed = "➜",
	Unmerged = "═",
	Deleted = "✖",
	Dirty = "✗",
	Ignored = "☒",
	Clean = "✔︎",
	Unknown = "?",
}

require("ibl").setup()

--vim.g.ale_completion_enabled = 1
--vim.g.ale_linters = {
        --avdl = { "jsonlint" },
        --go = { "gopls" },
--}
--vim.fn.setenv('GOFLAGS', '-tags=integration,functional')
--vim.g.ale_fixers = {
        --go = { "gofmt", "goimports" }, -- your existing Go fixers
        --lua = { "stylua" }, -- require you have "stylua" in $PATH
--}
--vim.g.ale_go_gopls_options = {}
--
--
--vim.g.ackprg = "rg --vimgrep --smart-case -g '!{**/.git/*}' --hidden"
--vim.opt.rtp:append("/opt/homebrew/bin/fzf")
--
--local cmp = require('cmp')

--cmp.setup({
  --mapping = {
    ---- use Up/Down arrows to navigate the menu
    --['<Up>']   = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    --['<Down>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ---- Enter to confirm
    --['<CR>']   = cmp.mapping.confirm({ select = true }),
    ---- Tab reserved for Copilot accept
    --['<S-Tab>']  = cmp.mapping(function(fallback)
      --local copilot_keys = vim.fn["copilot#Accept"]()
      --if copilot_keys ~= "" then
        --vim.api.nvim_feedkeys(copilot_keys, 'i', true)
      --else
        --fallback()
      --end
    --end, { 'i', 's' }),
  --},
  --sources = {
    --{ name = 'copilot' },
    --{ name = 'nvim_lsp' },
    --{ name = 'buffer'   },
  --},
--})

--vim.g.copilot_no_tab_map = 1
