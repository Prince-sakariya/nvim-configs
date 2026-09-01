return {
	-- Provides LSP server configurations for Neovim's built-in LSP client.
	"neovim/nvim-lspconfig",

	dependencies = {
		-- Installs and manages external developer tools such as LSP servers.
		"williamboman/mason.nvim",

		-- Integrates Mason with Neovim's LSP configuration.
		"williamboman/mason-lspconfig.nvim",

		-- Adds nvim-cmp completion capabilities to LSP clients.
		"hrsh7th/cmp-nvim-lsp",

		-- Main completion engine.
		"hrsh7th/nvim-cmp",

		-- Completion source for snippets.
		"saadparwaiz1/cmp_luasnip",

		-- Snippet engine.
		{
			"L3MON4D3/LuaSnip",

			-- Build the optional jsregexp library.
			-- Required for LSP snippet variable/placeholder transformations.
			build = "make install_jsregexp",
		},

		-- Completion source for words from the current buffer.
		"hrsh7th/cmp-buffer",

		-- Completion source for filesystem paths.
		"hrsh7th/cmp-path",

		-- Completion source for the command line.
		"hrsh7th/cmp-cmdline",

		-- Displays LSP progress notifications.
		"j-hui/fidget.nvim",
	},

	config = function()
		------------------------------------------------------------------------
		-- LSP capabilities
		------------------------------------------------------------------------

		-- Start with Neovim's default LSP capabilities and add the
		-- completion capabilities provided by nvim-cmp.
		local capabilities = vim.tbl_deep_extend(
			"force",
			{},
			vim.lsp.protocol.make_client_capabilities(),
			require("cmp_nvim_lsp").default_capabilities()
		)

		------------------------------------------------------------------------
		-- Mason
		------------------------------------------------------------------------

		-- Initialize Mason.
		require("mason").setup()

		-- Tell Mason which language servers should be installed.
		--
		-- mason-lspconfig also integrates these servers with Neovim's
		-- built-in vim.lsp configuration system.
		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				"rust_analyzer",
			},
		})

		------------------------------------------------------------------------
		-- Lua
		------------------------------------------------------------------------

		-- Configure lua-language-server using Neovim 0.11's modern
		-- vim.lsp.config() API.
		vim.lsp.config("lua_ls", {
			capabilities = capabilities,

			settings = {
				Lua = {
					-- Neovim uses LuaJIT for its Lua runtime.
					runtime = {
						version = "LuaJIT",
					},

					-- Tell LuaLS that "vim" is a valid global provided
					-- by Neovim.
					diagnostics = {
						globals = {
							"vim",
						},
					},

					-- Add Neovim's runtime files to LuaLS's workspace so
					-- it understands the vim.* API.
					workspace = {
						library = vim.api.nvim_get_runtime_file("", true),

						-- Don't ask about third-party libraries.
						checkThirdParty = false,
					},

					-- Use LuaLS formatting.
					format = {
						enable = true,

						-- Formatting style used by LuaLS.
						defaultConfig = {
							indent_style = "space",
							indent_size = "2",
						},
					},

					-- Disable telemetry.
					telemetry = {
						enable = false,
					},
				},
			},
		})

		------------------------------------------------------------------------
		-- Rust
		------------------------------------------------------------------------

		-- Configure rust-analyzer.
		vim.lsp.config("rust_analyzer", {
			capabilities = capabilities,
		})

		------------------------------------------------------------------------
		-- nvim-cmp
		------------------------------------------------------------------------

		-- Configure how completion items are selected.
		local cmp_select = {
			behavior = require("cmp").SelectBehavior.Select,
		}

		local cmp = require("cmp")

		cmp.setup({
			-- Use LuaSnip to expand snippets provided by LSP/completion
			-- sources.
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},

			-- Completion keymaps.
			mapping = cmp.mapping.preset.insert({
				-- Select the previous completion item.
				["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),

				-- Select the next completion item.
				["<C-n>"] = cmp.mapping.select_next_item(cmp_select),

				-- Accept the selected completion item.
				["<C-y>"] = cmp.mapping.confirm({
					select = true,
				}),

				-- Open the completion menu manually.
				["<C-Space>"] = cmp.mapping.complete(),
			}),

			-- Completion sources.
			sources = cmp.config.sources({
				-- LSP completion.
				{ name = "nvim_lsp" },

				-- LuaSnip snippets.
				{ name = "luasnip" },
			}, {
				-- Words from the current buffer.
				{ name = "buffer" },
			}),
		})

		------------------------------------------------------------------------
		-- Fidget
		------------------------------------------------------------------------

		-- Display LSP progress notifications.
		require("fidget").setup({})

		------------------------------------------------------------------------
		-- Diagnostics
		------------------------------------------------------------------------

		-- Configure how LSP diagnostics are displayed.
		vim.diagnostic.config({
			-- Display diagnostics as virtual text inside the buffer.
			virtual_text = true,

			-- Underline code associated with diagnostics.
			underline = true,

			-- Configure diagnostic floating windows.
			float = {
				-- Don't allow the floating window to receive focus.
				focusable = false,

				-- Use a minimal visual style.
				style = "minimal",

				-- Rounded borders.
				border = "rounded",

				-- Always show the diagnostic source.
				source = "always",

				-- Don't show a header.
				header = "",

				-- Don't show a prefix before each diagnostic.
				prefix = "",
			},
		})
	end,
}
