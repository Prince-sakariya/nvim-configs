vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- In visual mode, move line Up and Down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.api.nvim_set_keymap("n", "<leader>tf", "<Plug>PlenaryTestFile", { noremap = false, silent = false })

-- Join the current line with the next one, then restore the cursor position
vim.keymap.set("n", "J", "mzJ`z")
-- Scroll down half a page and keep the cursor centered
vim.keymap.set("n", "<C-d>", "<C-d>zz")
-- Scroll up half a page and keep the cursor centered
vim.keymap.set("n", "<C-u>", "<C-u>zz")
-- Go to the next search match and keep it centered
vim.keymap.set("n", "n", "nzzzv")
-- Go to the previous search match and keep it centered
vim.keymap.set("n", "N", "Nzzzv")
-- Re-indent the current paragraph, then restore the cursor position
vim.keymap.set("n", "=ap", "ma=ap'a")
-- Restart the LSP
vim.keymap.set("n", "<leader>zig", "<cmd>LspRestart<cr>")

-- VIM with me :)
vim.keymap.set("n", "<leader>vwm", function()
	require("vim-with-me").StartVimWithMe()
end)
vim.keymap.set("n", "<leader>svwm", function()
	require("vim-with-me").StopVimWithMe()
end)
vim.keymap.set("n", "<leader>lt", function()
	vim.cmd([[ PlenaryBustedFile % ]])
end)

-- greatest remap ever
-- Paste over the selected text without replacing your yank/register contents
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
-- Yank selected text or the current line to the system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
-- Yank from the cursor to the end of the current line to the system clipboard
vim.keymap.set("n", "<leader>Y", [["+Y"]])
-- Delete text without overwriting the default register
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d')

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

-- Disable the `Q` command in Normal mode
-- (Vim's default `Q` enters Ex mode)
vim.keymap.set("n", "Q", "<nop>")
-- Open tmux-sessionizer in a new tmux window
-- <C-f> = Ctrl+f
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
-- Open tmux-sessionizer in a vertical split
-- <M-h> = Alt+h
vim.keymap.set("n", "<M-h>", "<cmd>silent !tmux-sessionizer -s 0 --vsplit<CR>")
-- Open tmux-sessionizer in a new tmux window
-- <M-H> = Alt+Shift+h
vim.keymap.set("n", "<M-H>", "<cmd>silent !tmux neww tmux-sessionizer -s 0<CR>")

-- Go to the next item in the quickfix list and center the screen
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
-- Go to the previous item in the quickfix list and center the screen
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
-- Go to the next item in the location list and center the screen
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
-- Go to the previous item in the location list and center the screen
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Search and replace the word under the cursor throughout the current file
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- Make the current file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
-- Remove executable permission from the current file
vim.keymap.set("n", "<leader>X", "<cmd>!chmod -x %<CR>", { silent = true })

-- Start the "make_it_rain" Cellular Automaton animation
vim.keymap.set("n", "<leader>ca", function()
	require("cellular-automaton").start_animation("make_it_rain")
end)

-- Reload (source) the current Neovim config file
vim.keymap.set("n", "<leader><leader>", function()
	vim.cmd("so")
end)

-- Latex
vim.keymap.set("n", "<leader>ll", function()
	local file = vim.fn.expand("%:p")
	local target = vim.fn.expand("%:t:r")
	local root = vim.fn.fnamemodify(file, ":h:h")
	local pdf = root .. "/output/" .. target .. ".pdf"

	print("Building " .. target)
	print("Root " .. root)

	vim.fn.jobstart({ "make", target }, {
		cwd = root,

		-- on_exit = function(_, code)
		--     vim.schedule(function()
		--         print("Exit code:", code)

		--         if code == 0 then
		--             vim.fn.jobstart({
		--                 "open",
		--                 "-a",
		--                 "Skim",
		--                 pdf,
		--             })
		--         end
		--     end)
		-- end,

		on_exit = function(_, code)
			vim.schedule(function()
				if code == 0 then
					vim.fn.jobstart({
						"osascript",
						"-e",
						[[tell application "Skim"
                            if (count of documents) > 0 then
                                revert documents
                            else
                                open POSIX file "]] .. pdf .. [["
                            end if
                        end tell]],
					})
				else
					print("Build failed")
				end
			end)
		end,
	})
end, { desc = "Compile LaTeX" })
