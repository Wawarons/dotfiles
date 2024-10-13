-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

--vsplit
--floatterm
map("n", "<F6>", ":FloatermNew<CR>")
map("n", "<F7>", ":FloatermNext<CR>")
map("n", "<F5>", ":FloatermPrev<CR>")
map("n", "<A-S-f>", ":FloatermToggle<CR>")
--close tab
--switch tab
