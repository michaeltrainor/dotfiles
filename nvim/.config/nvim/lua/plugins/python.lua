return {
  -- Treesitter for syntax
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "python", "lua", "vim" },  -- Python parser
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
  -- Telescope for fuzzy finding
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Grep" })
      vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Document Symbols" })  -- Python funcs/classes
    end,
  },
  -- Mason + LSPConfig
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "pyright" },  -- Python LSP
      })
      local lspconfig = require("lspconfig")
      lspconfig.pyright.setup({})

      -- Global LSP keymaps (auto-attach on Python files)
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local opts = { buffer = args.buf }
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)  -- Hover docs
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)  -- Go to def
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)  -- Find refs
          vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)  -- Rename
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)  -- Code actions
        end,
      })
    end,
  },
}
