return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.config").setup({ -- Changed from .configs to .config
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
}