require("dev.remap")
require("dev.lazy_init")
require("dev.set")

-- ============================================================================
-- Helper functions
-- ============================================================================

-- Shorthand for creating autocommand groups.
local augroup = vim.api.nvim_create_augroup

-- Group for general-purpose autocommands.
local ThePrimeagenGroup = augroup("ThePrimeagen", {})

-- Shorthand for creating autocommands.
local autocmd = vim.api.nvim_create_autocmd

-- Group specifically for the yank highlight autocommand.
local yank_group = augroup("HighlightYank", {})

-- Reload a Lua module without restarting Neovim.
--
-- Example:
--     :lua R("dev.remap")
--
-- Useful when developing/editing your own Lua configuration.
function R(name)
	require("plenary.reload").reload_module(name)
end

-- ============================================================================
-- File types
-- ============================================================================

-- Tell Neovim that files ending in ".templ" use the "templ" filetype.
vim.filetype.add({
	extension = {
		templ = "templ",
	},
})

-- ============================================================================
-- Autocommands
-- ============================================================================

-- Briefly highlight text after yanking/copying it.
--
-- Example:
--     yy     -> yank the current line
--     y$     -> yank from cursor to end of line
--
-- The yanked text flashes briefly so you can see what was copied.
autocmd("TextYankPost", {
	group = yank_group,
	pattern = "*",
	callback = function()
		vim.hl.on_yank({
			higroup = "IncSearch",
			timeout = 40,
		})
	end,
})

-- Remove trailing whitespace whenever a file is saved.
--
-- Example:
--     "hello world    "
--
-- becomes:
--     "hello world"
autocmd("BufWritePre", {
	group = ThePrimeagenGroup,
	pattern = "*",
	command = [[%s/\s\+$//e]],
})

-- ============================================================================
-- LSP
-- ============================================================================

-- Run whenever an LSP server attaches to a buffer.
--
-- Because these mappings use "buffer = e.buf", they only exist in buffers
-- where an LSP is active.
autocmd("LspAttach", {
	group = ThePrimeagenGroup,
	callback = function(e)
		local opts = { buffer = e.buf }

		-- gd = Go to Definition
		--
		-- Put the cursor on a function/variable/class and press "gd"
		-- to jump to where it is defined.
		vim.keymap.set(
			"n",
			"gd",
			function()
				vim.lsp.buf.definition()
			end,
			vim.tbl_extend("force", opts, {
				desc = "[G]o to [D]efinition",
			})
		)

		-- K = Show documentation/type information
		--
		-- Put the cursor over a symbol and press "K" to open
		-- the LSP hover documentation.
		vim.keymap.set(
			"n",
			"K",
			function()
				vim.lsp.buf.hover()
			end,
			vim.tbl_extend("force", opts, {
				desc = "Show Documentation / Type Information",
			})
		)

		-- <leader>vws = Workspace Symbol
		--
		-- Search for functions, classes, variables, etc. across
		-- the entire project/workspace.
		vim.keymap.set(
			"n",
			"<leader>vws",
			function()
				vim.lsp.buf.workspace_symbol()
			end,
			vim.tbl_extend("force", opts, {
				desc = "[V]iew [W]orkspace [S]ymbols",
			})
		)

		-- <leader>vd = View Diagnostic
		--
		-- Show detailed information about the diagnostic under
		-- the cursor in a floating window.
		vim.keymap.set(
			"n",
			"<leader>vd",
			function()
				vim.diagnostic.open_float()
			end,
			vim.tbl_extend("force", opts, {
				desc = "[V]iew [D]iagnostic",
			})
		)

		-- <leader>vca = View Code Actions
		--
		-- Show fixes/refactorings provided by the LSP.
		--
		-- Examples:
		--     Add missing include/import
		--     Fix an error
		--     Refactor code
		vim.keymap.set(
			"n",
			"<leader>vca",
			function()
				vim.lsp.buf.code_action()
			end,
			vim.tbl_extend("force", opts, {
				desc = "[V]iew [C]ode [A]ctions",
			})
		)

		-- <leader>vrr = View References
		--
		-- Find everywhere the symbol under the cursor is used.
		vim.keymap.set(
			"n",
			"<leader>vrr",
			function()
				vim.lsp.buf.references()
			end,
			vim.tbl_extend("force", opts, {
				desc = "[V]iew [R]eferences",
			})
		)

		-- <leader>vrn = Rename
		--
		-- Rename the symbol under the cursor and update its references
		-- throughout the project when supported by the LSP.
		vim.keymap.set(
			"n",
			"<leader>vrn",
			function()
				vim.lsp.buf.rename()
			end,
			vim.tbl_extend("force", opts, {
				desc = "[V]iew [R]e[n]ame",
			})
		)

		-- Ctrl-h in Insert mode = Signature Help
		--
		-- While typing a function call, show its parameters/types.
		--
		-- Example:
		--     printf(
		--           ^
		--
		-- Ctrl-h can show the function signature.
		vim.keymap.set(
			"i",
			"<C-h>",
			function()
				vim.lsp.buf.signature_help()
			end,
			vim.tbl_extend("force", opts, {
				desc = "[C]trl-[H] = Signature Help",
			})
		)

		-- ]d = Next Diagnostic
		--
		-- Diagnostics are errors, warnings, hints, etc. reported by
		-- your LSP.
		--
		-- Press ]d to jump to the next diagnostic in the file.
		vim.keymap.set(
			"n",
			"]d",
			function()
				vim.diagnostic.jump({ count = 1 })
			end,
			vim.tbl_extend("force", opts, {
				desc = "Next [D]iagnostic",
			})
		)

		-- [d = Previous Diagnostic
		--
		-- Press [d to jump to the previous diagnostic in the file.
		vim.keymap.set(
			"n",
			"[d",
			function()
				vim.diagnostic.jump({ count = -1 })
			end,
			vim.tbl_extend("force", opts, {
				desc = "Previous [D]iagnostic",
			})
		)
	end,
})

-- ============================================================================
-- netrw
-- ============================================================================

-- Open netrw in the current window instead of a split.
vim.g.netrw_browse_split = 0

-- Hide the netrw banner.
vim.g.netrw_banner = 0

-- Set netrw's window width to 25%.
vim.g.netrw_winsize = 25
