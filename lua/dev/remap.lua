vim.g.mapleader = " "

-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, {
-- 	desc = "Open File Explorer",
-- })

vim.keymap.set("n", "<leader>pv", "<cmd>Oil<CR>", {
	desc = "Open File Explorer",
})

-- In visual mode, move line Up and Down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", {
	desc = "Move Selection Down",
})
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", {
	desc = "Move Selection Up",
})

-- ----------------------------------------------------------------------
-- ONLY for testing nvim/lua pluging
vim.api.nvim_set_keymap(
	"n",
	"<leader>tf",
	"<Plug>PlenaryTestFile",
	{ noremap = false, silent = false, desc = "Run Plenary Test File" }
)
-- ----------------------------------------------------------------------

vim.keymap.set("n", "J", "mzJ`z", {
	desc = "Join Lines",
})

vim.keymap.set("n", "<C-d>", "<C-d>zz", {
	desc = "Scroll Down",
})

vim.keymap.set("n", "<C-u>", "<C-u>zz", {
	desc = "Scroll Up",
})

vim.keymap.set("n", "n", "nzzzv", {
	desc = "Next Search Result",
})

vim.keymap.set("n", "N", "Nzzzv", {
	desc = "Previous Search Result",
})

vim.keymap.set("n", "=ap", "ma=ap'a", {
	desc = "Re-indent Paragraph",
})

vim.keymap.set("n", "<leader>zig", "<cmd>lsp restart<cr>", {
	desc = "LSP: Restart",
})

-- greatest remap ever
-- Paste over the selected text without replacing your yank/register contents
vim.keymap.set("x", "<leader>p", [["_dP]], {
	desc = "[P]aste Without Overwriting Register",
})

-- next greatest remap ever : asbjornHaland
-- Yank selected text or the current line to the system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], {
	desc = "Yank to System Clipboard",
})
-- Yank from the cursor to the end of the current line to the system clipboard
vim.keymap.set("n", "<leader>Y", [["+Y"]], {
	desc = "Yank Line to System Clipboard",
})
-- Delete text without overwriting the default register
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d', {
	desc = "[D]elete Without Register",
})

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

-- Disable the `Q` command in Normal mode
-- (Vim's default `Q` enters Ex mode)
vim.keymap.set("n", "Q", "<nop>")

-- Tmux sessionizer
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>", {
	desc = "Tmux Sessionizer: New Window",
})

vim.keymap.set("n", "<M-h>", "<cmd>silent !tmux neww tmux-sessionizer -s 0 --vsplit<CR>", {
	desc = "Tmux Sessionizer: Vertical Split",
})

vim.keymap.set("n", "<M-H>", "<cmd>silent !tmux neww tmux-sessionizer -s 0<CR>", {
	desc = "Tmux Sessionizer: New Window",
})

-- Quickfix list
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz", {
	desc = "Quickfix: Next Item",
})

vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz", {
	desc = "Quickfix: Previous Item",
})

-- Location list
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz", {
	desc = "Location List: Next Item",
})

vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz", {
	desc = "Location List: Previous Item",
})

-- Search and replace the word under the cursor throughout the current file
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], {
	desc = "Search and Replace Word",
})

-- Make the current file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", {
	silent = true,
	desc = "Make File Executable",
})

-- Remove executable permission from the current file
vim.keymap.set("n", "<leader>X", "<cmd>!chmod -x %<CR>", {
	silent = true,
	desc = "Remove Executable Permission",
})

-- Reload the main Neovim configuration.
--
-- <leader><leader> = reload init.lua
--
-- Unlike vim.cmd("so"), this explicitly loads init.lua instead of
-- accidentally trying to execute whatever file is currently open.
vim.keymap.set("n", "<leader><leader>", function()
	dofile(vim.fn.stdpath("config") .. "/init.lua")
end, {
	desc = "Reload Neovim Config",
})
