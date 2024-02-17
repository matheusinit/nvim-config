local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins-setup.lua source <afile> | PackerSync
  augroup end
]])

local status, packer = pcall(require, "packer")

if not status then
	return
end

return packer.startup(function(use)
	use("wbthomason/packer.nvim")

	-- colorschemes
	use({ "bluz71/vim-nightfly-colors", as = "nightfly" })
	use({ "bluz71/vim-moonfly-colors", as = "moonfly" })
	use({ "ellisonleao/gruvbox.nvim" })
	use({ "catppuccin/nvim", as = "catppuccin" })
	use("folke/tokyonight.nvim")
	-- tmux and split window navigation
	use("christoomey/vim-tmux-navigator")
	-- maximizes and restores current window
	use("szw/vim-maximizer")

	-- essential plugins
	use("tpope/vim-surround")

	-- Insert: y s w (because we want a word) " (what we want to surround)
	-- Remove: d s " (what is surrounded)
	-- Change what surrounds: c s " (what is surrounded) ' (what we want to replace to)

	use("vim-scripts/ReplaceWithRegister")
	-- Replace: g r w

	use("numToStr/Comment.nvim")
	-- Comment: g c c
	-- Comment two lines below: g c 2 j

	use("nvim-tree/nvim-tree.lua")
	-- Toggle: <leader> e

	use("kyazdani42/nvim-web-devicons")

	use("nvim-lualine/lualine.nvim")

	use("nvim-lua/plenary.nvim")
	use("ThePrimeagen/harpoon")

	-- fuzzy finding w/ telescope
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" }) -- dependency for better sorting performance
	use({ "nvim-telescope/telescope.nvim", branch = "0.1.x" }) -- fuzzy finder

	-- autocompletion
	use("hrsh7th/nvim-cmp")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-path")

	-- snippets
	use("L3MON4D3/LuaSnip") -- snippet engine
	use("saadparwaiz1/cmp_luasnip") -- for autocompletion
	use("rafamadriz/friendly-snippets") -- useful snippets

	-- managing & installing lsp servers
	use("williamboman/mason.nvim")
	use("williamboman/mason-lspconfig.nvim")

	-- configuring lsp servers
	use("neovim/nvim-lspconfig")
	use("hrsh7th/cmp-nvim-lsp")
	use({ "glepnir/lspsaga.nvim", branch = "main" })
	use("jose-elias-alvarez/typescript.nvim")
	use("onsails/lspkind.nvim")

	-- Rename: <leader> r n
	-- Code actions: <leader> c a

	-- formatting and linting
	use("jose-elias-alvarez/null-ls.nvim")
	use("jayp0521/mason-null-ls.nvim")

	-- treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
			ts_update()
		end,
	})

	-- auto closing
	use("windwp/nvim-autopairs") -- autoclose parens, brackets, quotes, etc...
	use({ "windwp/nvim-ts-autotag", after = "nvim-treesitter" }) -- autoclose tags

	-- git integration
	use("lewis6991/gitsigns.nvim") -- show line modifications on left hand side

	-- codium (ai code suggestion)
	use("Exafunction/codeium.vim")

	use({ "stevearc/dressing.nvim" })

	use("rcarriga/nvim-notify")

	if packer_bootstrap then
		require("packer").sync()
	end
end)
