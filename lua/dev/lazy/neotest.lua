return {
	-- Neotest: framework for running and inspecting tests from Neovim
	"nvim-neotest/neotest",

	dependencies = {
		-- Async library required by Neotest
		"nvim-neotest/nvim-nio",

		-- General-purpose Lua utilities
		"nvim-lua/plenary.nvim",

		-- Makes CursorHold events work reliably with Neotest
		"antoinemadec/FixCursorHold.nvim",

		-- Used by Neotest adapters to understand source code structure
		"nvim-treesitter/nvim-treesitter",
	},

	config = function()
		local neotest = require("neotest")

		-- Run the nearest test under the cursor
		vim.keymap.set("n", "<leader>tr", function()
			neotest.run.run({
				suite = false,
			})
		end, { desc = "Test: Run Nearest Test" })

		-- Toggle the Neotest summary window
		vim.keymap.set("n", "<leader>tv", function()
			neotest.summary.toggle()
		end, { desc = "Test: Toggle Summary" })

		-- Run the entire test suite
		vim.keymap.set("n", "<leader>ts", function()
			neotest.run.run({
				suite = true,
			})
		end, { desc = "Test: Run Test Suite" })

		-- Debug the nearest test using nvim-dap
		-- This requires a compatible DAP configuration for your language.
		vim.keymap.set("n", "<leader>td", function()
			neotest.run.run({
				suite = false,
				strategy = "dap",
			})
		end, { desc = "Test: Debug Nearest Test" })

		-- Open the output of the most recently run test
		vim.keymap.set("n", "<leader>to", function()
			neotest.output.open()
		end, { desc = "Test: Open Test Output" })

		-- Run all tests in the current working directory
		vim.keymap.set("n", "<leader>ta", function()
			neotest.run.run(vim.fn.getcwd())
		end, { desc = "Test: Run All Tests" })
	end,
}
