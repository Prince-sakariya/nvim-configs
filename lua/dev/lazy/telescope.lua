return {
	-- Telescope is a fuzzy finder for Neovim.
	--
	-- It can be used to:
	--   - Find files
	--   - Search Git-tracked files
	--   - Search for text
	--   - Search Neovim help
	--   - Find buffers, commands, diagnostics, etc.
	"nvim-telescope/telescope.nvim",

	-- Pin Telescope to this specific version.
	--
	-- This means lazy.nvim won't automatically move this plugin
	-- to a newer version.
	-- tag = "0.1.5",

	-- Telescope uses plenary.nvim for common Lua utilities.
	dependencies = {
		"nvim-lua/plenary.nvim",
	},

	config = function()
		-- Initialize Telescope with its default configuration.
		require("telescope").setup({})

		-- Load Telescope's built-in pickers.
		--
		-- "builtin" contains functions such as:
		--   find_files
		--   git_files
		--   grep_string
		--   help_tags
		--   buffers
		--   live_grep
		--   etc.
		local builtin = require("telescope.builtin")

		------------------------------------------------------------------------
		-- Find files
		------------------------------------------------------------------------

		-- <leader>pf
		--
		-- Open Telescope's file finder.
		--
		-- This lets you fuzzy-search for files in your project.
		vim.keymap.set("n", "<leader>pf", builtin.find_files, { desc = "Telescope: [Project] [F]iles" })

		------------------------------------------------------------------------
		-- Git files
		------------------------------------------------------------------------

		-- <C-p>
		--
		-- Find files tracked by Git.
		--
		-- This is useful when working inside a Git repository because
		-- Telescope focuses on files known to Git.
		vim.keymap.set("n", "<C-p>", builtin.git_files, { desc = "Telescope: Git files" })

		------------------------------------------------------------------------
		-- Search the word under the cursor
		------------------------------------------------------------------------

		-- <leader>pws
		--
		-- Search for the word under the cursor.
		--
		-- <cword> means the current word under the cursor.
		vim.keymap.set("n", "<leader>pws", function()
			-- Get the word under the cursor.
			local word = vim.fn.expand("<cword>")

			-- Search for that word throughout the project.
			builtin.grep_string({ search = word })
		end, { desc = "Telescope: Search for word under the cursor" })

		------------------------------------------------------------------------
		-- Search the WORD under the cursor
		------------------------------------------------------------------------

		-- <leader>pWs
		--
		-- Similar to <leader>pws>, but uses <cWORD>.
		--
		-- <cword>:
		--   Searches the current "word" according to Vim's word rules.
		--
		-- <cWORD>:
		--   Searches the larger WORD according to Vim's WORD rules.
		--
		-- The difference is mainly how punctuation is treated.
		vim.keymap.set("n", "<leader>pWs", function()
			-- Get the WORD under the cursor.
			local word = vim.fn.expand("<cWORD>")

			-- Search for that WORD throughout the project.
			builtin.grep_string({ search = word })
		end, { desc = "Telescope: Search for WORD under the cursor" })

		------------------------------------------------------------------------
		-- Search for user-provided text
		------------------------------------------------------------------------

		-- <leader>ps
		--
		-- Ask for a search term and search for it throughout the project.
		vim.keymap.set("n", "<leader>ps", function()
			-- Open an input prompt:
			--
			-- Grep >
			--
			-- Whatever you type becomes the search term.
			builtin.grep_string({
				search = vim.fn.input("Grep > "),
			})
		end, { desc = "Telescope: Search for user-provided text" })

		------------------------------------------------------------------------
		-- Search for keymaps
		------------------------------------------------------------------------

		-- <leader>pk
		--
		-- Ask for a search term and search for it throughout the project.
		vim.keymap.set("n", "<leader>pk", function()
			-- Search for that word throughout the project.
			builtin.keymaps()
		end, { desc = "Telescope: Search for keymaps" })

		------------------------------------------------------------------------
		-- Neovim help
		------------------------------------------------------------------------

		-- <leader>vh
		--
		-- Search Neovim's built-in help documentation using Telescope.
		vim.keymap.set(
			"n",
			"<leader>vh",
			builtin.help_tags,
			{ desc = "Telescope: Search nvim's build-in help documentation" }
		)
	end,
}
