local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
                "git",
                "clone",
                "--filter=blob:none",
                "https://github.com/folke/lazy.nvim.git",
                lazypath,
        })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
        -- List of plugins
	--{ "mileszs/ack.vim" },
	--{ "dense-analysis/ale" },
	--{ "junegunn/fzf" },
        { "neovim/nvim-lspconfig" },
        { "morhetz/gruvbox" },
        { "preservim/nerdtree" },
	--{ "graywh/vim-colorindent" },
        { "preservim/nerdcommenter" },
        { "tpope/vim-fugitive" },
        --{ "fatih/vim-go", ft = { "go" } },
	{ "tpope/vim-surround" },
	{ "Xuyuanp/nerdtree-git-plugin" },
	--{ "rust-lang/rust.vim", ft = { "rust" } },
	--{ "powerman/vim-plugin-AnsiEsc", ft = { "text" } },
	--{ "github/copilot.vim" },
	--{ "hashivim/vim-terraform", ft = { "tf" } },
	--{ "rhysd/rust-doc.vim", ft = { "rust" } },
	--{ "junegunn/vim-easy-align" },
	--{ "gurpreetatwal/vim-avro" },
	{ "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
        { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
	--{ "nvim-telescope/telescope-fzf-native.nvim", build = "make", cond = vim.fn.executable("make") == 1 },
	--{
		--"hrsh7th/nvim-cmp",
		--dependencies = {
			--"hrsh7th/cmp-nvim-lsp",
			--"hrsh7th/cmp-buffer",
			--"zbirenbaum/copilot-cmp",
		--},
	--},
})
