return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"rouge8/neotest-rust",
		"nvim-neotest/neotest-python",
	},
	config = function()
		local neotest = require("neotest")

		neotest.setup({
			adapters = {
				require("neotest-rust"),
				require("neotest-python"),
			},
		})

		vim.keymap.set("n", "<leader>tr", function()
			require("neotest").run.run({
				suite = false,
			})
		end, { desc = "Debug: [T]est - [R]un Nearest " })

		vim.keymap.set("n", "<leader>tv", function()
			require("neotest.consumers.summary").toggle()
		end, { desc = "Debug: [T]oogle [V]iew Summary" })

		vim.keymap.set("n", "<leader>ts", function()
			require("neotest").run.run({
				suite = true,
			})
		end, { desc = "Debug: Running [T]est [S]uite" })

		vim.keymap.set("n", "<leader>td", function()
			require("neotest").run.run({
				suite = false,
				strategy = "dap",
			})
		end, { desc = "Debug: [D]ebug Nearest [T]est" })

		vim.keymap.set("n", "<leader>to", function()
			require("neotest").output.open()
		end, { desc = "Debug: Open [T]est [O]utput" })

		vim.keymap.set("n", "<leader>ta", function()
			require("neotest").run.run(vim.fn.getcwd())
		end, { desc = "Debug: Open test output" })
	end,
}
