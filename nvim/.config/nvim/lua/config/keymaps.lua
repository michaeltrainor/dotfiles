-- Set leader key to space (common convention)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set  -- Shorthand for cleaner code

-- General
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })  -- Leader + w to save
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })       -- Leader + q to quit
map("n", "<Esc>", "<cmd>:noh<cr>", { desc = "Clear search highlights" })  -- Esc to clear hlsearch

-- Window navigation (split windows easily)
map("n", "<leader>sv", "<cmd>vsplit<cr>", { desc = "Vertical split" })
map("n", "<leader>sh", "<cmd>split<cr>", { desc = "Horizontal split" })
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Buffer management
map("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })

-- Better line navigation (respect wrapping)
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
