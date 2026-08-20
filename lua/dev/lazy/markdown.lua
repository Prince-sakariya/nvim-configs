return {
    "OXY2DEV/markview.nvim",
    lazy = false,

    config = function()
        vim.keymap.set("n", "<leader>m", "<cmd>Markview<CR>", {
            desc = "Markdown: Toggle preview",
        })
    end,
}
