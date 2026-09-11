return {
	{
		"stevearc/oil.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			keymaps = {
				["<C-p>"] = false,
				["<C-;>"] = "actions.preview",
			},
			view_options = {
				show_hidden = true,
			},
		},
	},
}
