return {
    -- Harpoon lets you quickly mark files and jump between them.
    -- It is useful when you are working on a small set of files
    -- repeatedly and don't want to search for them each time.
    "theprimeagen/harpoon",

    -- Use Harpoon version 2.
    branch = "harpoon2",

    -- Harpoon uses plenary.nvim as a dependency.
    dependencies = { "nvim-lua/plenary.nvim" },

    config = function()

        -- Load Harpoon.
        local harpoon = require("harpoon")

        -- Initialize Harpoon with its default configuration.
        harpoon:setup()


        -- Add the current file to Harpoon's list.
        vim.keymap.set("n", "<leader>a", function()
            harpoon:list():prepend()
        end)


        -- Add the current file to Harpoon's list.
        vim.keymap.set("n", "<leader>a", function()
            harpoon:list():add()
        end)


        -- Open/close Harpoon's quick menu.
        --
        -- This gives you a small menu showing the files
        -- currently stored in your Harpoon list.
        vim.keymap.set("n", "<c-e>", function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end)


        -- Jump directly to the first file in the Harpoon list.
        vim.keymap.set("n", "<m-1>", function()
            harpoon:list():select(1)
        end)

        -- Jump directly to the second file in the Harpoon list.
        vim.keymap.set("n", "<m-2>", function()
            harpoon:list():select(2)
        end)

        -- Jump directly to the third file in the Harpoon list.
        vim.keymap.set("n", "<m-3>", function()
            harpoon:list():select(3)
        end)

        -- Jump directly to the fourth file in the Harpoon list.
        vim.keymap.set("n", "<m-4>", function()
            harpoon:list():select(4)
        end)
    end,
}
