return {
	-- vim-fugitive is a Git integration plugin for Neovim.
	-- It provides access to Git commands and a Git status interface
	-- directly inside Neovim.
	"tpope/vim-fugitive",

	config = function()
		-- Open Fugitive's Git interface.
		--
		-- <leader>gs -> :Git
		--
		-- vim.cmd.Git is Fugitive's :Git command exposed through Lua.
		vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

		-- Create an autocommand group for Fugitive-related autocommands.
		local ThePrimeagen_Fugitive = vim.api.nvim_create_augroup("ThePrimeagen_Fugitive", {})

		-- Create a shorthand for defining autocommands.
		local autocmd = vim.api.nvim_create_autocmd

		-- Run this whenever entering a window.
		autocmd("BufWinEnter", {

			-- Put this autocommand in the Fugitive group.
			group = ThePrimeagen_Fugitive,

			-- Run for every buffer/window.
			pattern = "*",

			callback = function()
				-- Only continue if the current buffer is a Fugitive buffer.
				--
				-- ft = filetype.
				-- Fugitive buffers have the "fugitive" filetype.
				if vim.bo.ft ~= "fugitive" then
					return
				end

				-- Get the number/ID of the current buffer.
				local bufnr = vim.api.nvim_get_current_buf()

				-- Options for the keymaps below.
				--
				-- buffer = bufnr:
				-- These mappings only exist inside this Fugitive buffer.
				--
				-- remap = false:
				-- Don't allow these mappings to trigger other mappings.
				local opts = { buffer = bufnr, remap = false }

				-- Push the current Git branch.
				--
				-- <leader>p -> :Git push
				vim.keymap.set("n", "<leader>p", function()
					vim.cmd.Git("push")
				end, opts)

				-- Pull changes using rebase.
				--
				-- <leader>P -> :Git pull --rebase
				--
				-- Rebase puts your local commits on top of the
				-- commits that were pulled from the remote.
				--
				-- rebase always
				vim.keymap.set("n", "<leader>P", function()
					vim.cmd.Git({ "pull", "--rebase" })
				end, opts)

				-- Push the current branch and establish its upstream/tracking
				-- branch on the remote.
				--
				-- <leader>t gives you:
				--
				-- :Git push -u origin
				--
				-- You can then type the branch name.
				--
				-- For example:
				-- :Git push -u origin main
				vim.keymap.set("n", "<leader>t", ":Git push -u origin ", opts)
			end,
		})

		-- During a Git merge conflict, Fugitive can show multiple versions
		-- of the file in diff windows.
		--
		-- diffget //2:
		-- Take the version from the "other" side of the merge.
		vim.keymap.set("n", "gu", "<cmd>diffget //2<CR>")

		-- diffget //3:
		-- Take the version from the current side of the merge.
		vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>")
	end,
}
