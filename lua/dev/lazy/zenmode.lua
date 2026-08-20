return {
    -- Zen Mode creates a distraction-free editing environment.
    --
    -- It can make the current buffer wider/centered and hide some of
    -- the normal Neovim UI around it.
    "folke/zen-mode.nvim",

    config = function()

        ----------------------------------------------------------------
        -- Normal Zen Mode
        ----------------------------------------------------------------

        -- <leader>zz
        --
        -- Enter/exit Zen Mode with:
        --
        --     <leader>zz
        --
        -- This version keeps line numbers visible.
        vim.keymap.set("n", "<leader>zz", function()

            -- Configure the Zen Mode window.
            require("zen-mode").setup {

                window = {

                    -- Set the width of the editing area to 90 columns.
                    width = 90,

                    -- Additional window options.
                    options = { }
                },
            }


            -- Toggle Zen Mode.
            --
            -- If Zen Mode is closed, open it.
            -- If Zen Mode is already open, close it.
            require("zen-mode").toggle()


            -- Don't wrap long lines.
            vim.wo.wrap = false

            -- Show absolute line numbers.
            vim.wo.number = true

            -- Show relative line numbers.
            vim.wo.rnu = true

            -- Reapply your colorscheme/colors.
            ColorMyPencils()
        end)


        ----------------------------------------------------------------
        -- Minimal Zen Mode
        ----------------------------------------------------------------

        -- <leader>zZ
        --
        -- Enter/exit an even more minimal Zen Mode.
        --
        -- This version hides line numbers and the color column.
        vim.keymap.set("n", "<leader>zZ", function()

            -- Configure a narrower Zen Mode window.
            require("zen-mode").setup {

                window = {

                    -- Set the editing area to 80 columns.
                    width = 80,

                    -- Additional window options.
                    options = { }
                },
            }


            -- Toggle Zen Mode.
            require("zen-mode").toggle()


            -- Don't wrap long lines.
            vim.wo.wrap = false

            -- Hide absolute line numbers.
            vim.wo.number = false

            -- Hide relative line numbers.
            vim.wo.rnu = false

            -- Hide the 80-column guide.
            vim.opt.colorcolumn = "0"

            -- Reapply your colorscheme/colors.
            ColorMyPencils()
        end)
    end
}
