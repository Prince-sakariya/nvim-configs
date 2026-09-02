return {
	{
		-- Treesitter provides syntax parsing for Neovim.
		--
		-- Unlike traditional syntax highlighting, Treesitter understands
		-- the structure of the code.
		--
		-- It can be used for:
		--   - Syntax highlighting
		--   - Indentation
		--   - Code-aware plugins
		--   - Text objects
		--   - Folding
		--   - Parsing source code
		"nvim-treesitter/nvim-treesitter",

		-- Use the main branch.
		branch = "main",

		-- Load Treesitter immediately rather than lazily.
		lazy = false,

		-- Update installed Treesitter parsers when the plugin updates.
		build = ":TSUpdate",

		config = function()
			-- Initialize the new nvim-treesitter configuration.
			require("nvim-treesitter").setup()

			----------------------------------------------------------------
			-- Install Treesitter parsers
			----------------------------------------------------------------

			-- Treesitter itself is not the parser for every language.
			--
			-- Each language has its own parser, which is installed here.
			require("nvim-treesitter").install({
				"vimdoc",
				"c",
				"lua",
				"rust",
				"bash",
				"python",
				"latex",
				"bibtex",
			})

			----------------------------------------------------------------
			-- Treesitter highlighting
			----------------------------------------------------------------

			-- Enable Treesitter highlighting for the listed filetypes.
			--
			-- When one of these filetypes is opened, Neovim starts the
			-- Treesitter parser for that buffer.
			--
			-- For example:
			--
			--   foo.rs  -> Rust Treesitter parser
			--   foo.py  -> Python Treesitter parser
			--   foo.lua -> Lua Treesitter parser
			vim.api.nvim_create_autocmd("FileType", {
				pattern = {
					"vim",
					"lua",
					"rust",
					"bash",
					"python",
					"tex",
					"bib",
					"c",
				},

				callback = function(args)
					-- Start Treesitter for the current buffer.
					vim.treesitter.start(args.buf)
				end,
			})

			----------------------------------------------------------------
			-- Treesitter indentation
			----------------------------------------------------------------

			-- Tell Neovim to use Treesitter for indentation for these
			-- filetypes.
			vim.api.nvim_create_autocmd("FileType", {
				pattern = {
					"vim",
					"lua",
					"rust",
					"bash",
					"python",
					"tex",
					"bib",
					"c",
				},

				callback = function()
					-- Use Treesitter's indentation expression.
					--
					-- This lets indentation be based on the parsed
					-- structure of the source code.
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})

			----------------------------------------------------------------
			-- Custom Templ parser
			----------------------------------------------------------------

			-- Templ is not one of the standard parsers installed above.
			--
			-- This autocommand registers the custom Templ parser whenever
			-- Treesitter updates its parser information.
			vim.api.nvim_create_autocmd("User", {
				pattern = "TSUpdate",

				callback = function()
					-- Tell Treesitter how to obtain the Templ parser.
					require("nvim-treesitter.parsers").templ = {

						install_info = {

							-- Git repository containing the Templ parser.
							url = "https://github.com/vrischmann/tree-sitter-templ.git",

							-- Parser source files that need to be compiled.
							files = {
								"src/parser.c",
								"src/scanner.c",
							},

							-- Branch containing the parser source.
							branch = "master",
						},
					}
				end,
			})

			-- Tell Neovim that the "templ" language should be associated
			-- with the "templ" filetype.
			--
			-- This allows Neovim/Treesitter to use the Templ parser when
			-- opening Templ files.
			vim.treesitter.language.register("templ", "templ")
		end,
	},

	{
		-- Treesitter Context shows the current code context at the top
		-- of the window.
		--
		-- For example, when you're deep inside:
		--
		--   function
		--     if
		--       for
		--         ...
		--
		-- it can keep the surrounding function/struct/class visible
		-- while you scroll through the file.
		"nvim-treesitter/nvim-treesitter-context",

		-- This plugin requires Treesitter.
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},

		config = function()
			-- Configure Treesitter Context.
			require("treesitter-context").setup({

				-- Enable the plugin.
				enable = true,

				-- Don't show context separately in every window.
				multiwindow = false,

				-- Maximum number of context lines.
				--
				-- 0 means no explicit maximum here.
				max_lines = 0,

				-- Minimum window height required before showing context.
				min_window_height = 0,

				-- Show line numbers in the context.
				line_numbers = true,

				-- Maximum number of lines allowed for a single
				-- multiline context node.
				multiline_threshold = 20,

				-- Remove outer scopes when determining what context
				-- should be displayed.
				trim_scope = "outer",

				-- Determine context based on the cursor position.
				mode = "cursor",

				-- Don't draw a separator between context and the rest
				-- of the buffer.
				separator = nil,

				-- Z-index controls how the floating context appears
				-- relative to other UI elements.
				zindex = 20,

				-- No custom on_attach function.
				on_attach = nil,
			})
		end,
	},
}
