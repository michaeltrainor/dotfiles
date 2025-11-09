-- Basic editor options
vim.opt.number = true          -- Show line numbers
vim.opt.relativenumber = true  -- Relative line numbers for easier navigation

-- Indentation
vim.opt.tabstop = 2            -- Number of spaces for tabs
vim.opt.softtabstop = 2        -- Number of spaces for soft tabs
vim.opt.shiftwidth = 2         -- Number of spaces for indentation
vim.opt.expandtab = true       -- Convert tabs to spaces
vim.opt.smartindent = true     -- Smart auto-indent on new lines

-- Search
vim.opt.hlsearch = true        -- Highlight search matches
vim.opt.incsearch = true       -- Incremental search (live as you type)
vim.opt.ignorecase = true      -- Case-insensitive search
vim.opt.smartcase = true       -- Case-sensitive if uppercase in query

-- UI/Behavior
vim.opt.termguicolors = true   -- Enable 24-bit RGB colors
vim.opt.signcolumn = "yes"     -- Always show sign column (for LSP errors)
vim.opt.wrap = false           -- No line wrapping
vim.opt.swapfile = false       -- Disable swap files
vim.opt.backup = false         -- Disable backups
vim.opt.undofile = true        -- Enable persistent undo
vim.opt.scrolloff = 8          -- Keep 8 lines above/below cursor

-- Performance
vim.opt.updatetime = 50        -- Faster completion (ms)
vim.opt.timeoutlen = 300       -- Time to wait for key sequence (ms)
