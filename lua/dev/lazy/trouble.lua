return {
    -- Trouble is a diagnostics and location list UI for Neovim.
    --
    -- It gives you a more convenient way to view things such as:
    --   - LSP errors
    --   - LSP warnings
    --   - References
    --   - Quickfix entries
    --   - Locations
    --
    -- Instead of having diagnostics scattered throughout the editor,
    -- Trouble can collect them into a dedicated window.
    "folke/trouble.nvim",

    config = function()

        -- Initialize Trouble with its default configuration.
        require("trouble").setup({})


        ----------------------------------------------------------------
        -- Toggle Trouble
        ----------------------------------------------------------------

        -- <leader>tt
        --
        -- Open or close the Trouble window.
        vim.keymap.set("n", "<leader>tt", function()
            require("trouble").toggle()
        end)


        ----------------------------------------------------------------
        -- Next diagnostic
        ----------------------------------------------------------------

        -- [t
        --
        -- Move to the next Trouble item.
        vim.keymap.set("n", "[t", function()

            -- skip_groups = true:
            -- Don't stop on group headings in the Trouble list.
            --
            -- jump = true:
            -- Move the cursor to the location of the selected item.
            require("trouble").next({
                skip_groups = true,
                jump = true
            });
        end)


        ----------------------------------------------------------------
        -- Previous diagnostic
        ----------------------------------------------------------------

        -- ]t
        --
        -- Move to the previous Trouble item.
        vim.keymap.set("n", "]t", function()

            -- skip_groups = true:
            -- Skip group headings.
            --
            -- jump = true:
            -- Jump the cursor to the selected item's location.
            require("trouble").previous({
                skip_groups = true,
                jump = true
            });
        end)

    end
}
