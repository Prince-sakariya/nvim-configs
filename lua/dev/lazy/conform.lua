return {
    -- conform.nvim is a formatter plugin for Neovim.
    -- It allows different filetypes to use different formatters.
    "stevearc/conform.nvim",

    -- Plugin options.
    -- Currently empty because the configuration is handled below
    -- inside the config function.
    opts = {},

    config = function()

        -- Initialize conform.nvim.
        require("conform").setup({

            -- Automatically format the file before it is saved.
            format_on_save = {

                -- Give the formatter up to 5 seconds to finish.
                timeout_ms = 5000,

                -- Use the configured formatter first.
                -- If no formatter is available, fall back to the LSP.
                lsp_format = "fallback",
            },


            -- Define which formatter should be used for each filetype.
            formatters_by_ft = {

                -- C files use clang-format.
                c = { "clang-format" },

                -- C++ files use clang-format.
                cpp = { "clang-format" },

                -- Lua files use stylua.
                lua = { "stylua" },

                -- JavaScript files use Prettier.
                javascript = { "prettier" },

                -- TypeScript files use Prettier.
                typescript = { "prettier" },

                -- Elixir files use Mix's formatter.
                elixir = { "mix" },

                -- python files use prettier.
                python = { "prettier" },
            },


            -- Configure individual formatters.
            formatters = {

                -- Custom configuration for clang-format.
                ["clang-format"] = {

                    -- Arguments passed to clang-format.
                    --
                    -- -style=file:
                    -- Look for formatting rules in a .clang-format file.
                    --
                    -- -fallback-style=LLVM:
                    -- If no .clang-format file is found, use LLVM style.
                    prepend_args = {
                        "-style=file",
                        "-fallback-style=LLVM"
                    },
                },
            },
        })


        -- Create a keymap for manually formatting the current buffer.
        --
        -- <leader>f triggers conform.nvim's format function.
        vim.keymap.set("n", "<leader>f", function()

            -- bufnr = 0 means the current buffer.
            require("conform").format({ bufnr = 0 })
        end)
    end,
}
