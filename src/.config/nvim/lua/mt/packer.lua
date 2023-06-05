vim.cmd.packadd('packer.nvim')

return require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'

	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.1',
		requires = { {'nvim-lua/plenary.nvim'} }
	}

	use 'navarasu/onedark.nvim'

	use({"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"})

	use 'nvim-tree/nvim-tree.lua'
	use 'nvim-tree/nvim-web-devicons'

	use 'williamboman/mason.nvim'
	use 'williamboman/mason-lspconfig.nvim'
end)

