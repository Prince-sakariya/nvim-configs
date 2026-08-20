-- Create an autocommand group for all DAP-related autocommands.
--
-- clear = true means that if this group already exists,
-- its previous autocommands will be removed first.
vim.api.nvim_create_augroup("DapGroup", { clear = true })


-- Move focus to the window containing the buffer associated with an event.
--
-- This is useful for DAP windows such as the REPL and Watches window,
-- where we want Neovim to automatically navigate to the correct window.
local function navigate(args)
    -- Get the buffer associated with the event.
    local buffer = args.buf

    -- This will eventually contain the window ID that displays the buffer.
    local wid = nil

    -- Get a list of all currently open Neovim windows.
    local win_ids = vim.api.nvim_list_wins() -- Get all window IDs

    -- Look through every open window.
    for _, win_id in ipairs(win_ids) do

        -- Find out which buffer is currently displayed in this window.
        local win_bufnr = vim.api.nvim_win_get_buf(win_id)

        -- If this window contains the buffer we're looking for,
        -- remember its window ID.
        if win_bufnr == buffer then
            wid = win_id
        end
    end

    -- If we couldn't find a window containing the buffer,
    -- there is nothing more to do.
    if wid == nil then
        return
    end

    -- Schedule the window change to happen after the current event finishes.
    vim.schedule(function()

        -- Make sure the window still exists before trying to use it.
        if vim.api.nvim_win_is_valid(wid) then
            -- Make the DAP window the currently focused window.
            vim.api.nvim_set_current_win(wid)
        end
    end)
end


-- Create the options used by the DAP navigation autocommands.
--
-- "name" is used to build a pattern that identifies the buffer/window
-- we want to react to.
local function create_nav_options(name)
    return {
        group = "DapGroup",

        -- Match buffers whose name contains the supplied name.
        pattern = string.format("*%s*", name),

        -- Run navigate() when the event occurs.
        callback = navigate
    }
end


-- Return the plugin specifications for lazy.nvim.
return {

    --------------------------------------------------------------------------
    -- nvim-dap
    --------------------------------------------------------------------------

    {
        -- Main Debug Adapter Protocol plugin for Neovim.
        "mfussenegger/nvim-dap",

        -- Load this plugin immediately rather than lazily.
        lazy = false,

        config = function()
            -- Load the DAP module.
            local dap = require("dap")

            -- Enable detailed DAP logging.
            -- Useful when debugging the debugger itself.
            dap.set_log_level("DEBUG")


            -- Continue execution / start debugging.
            vim.keymap.set("n", "<F8>", dap.continue, { desc = "Debug: Continue" })

            -- Execute the next line without stepping into a function.
            vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debug: Step Over" })

            -- Step into the function being called.
            vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debug: Step Into" })

            -- Step out of the current function.
            vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Debug: Step Out" })

            -- Toggle a breakpoint on the current line.
            vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })

            -- Create a conditional breakpoint.
            --
            -- vim.fn.input() asks for the breakpoint condition.
            vim.keymap.set("n", "<leader>B", function()
                dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
            end, { desc = "Debug: Set Conditional Breakpoint" })
        end
    },


    --------------------------------------------------------------------------
    -- nvim-dap-ui
    --------------------------------------------------------------------------

    {
        -- UI components for nvim-dap.
        "rcarriga/nvim-dap-ui",

        -- Plugins that nvim-dap-ui requires.
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio"
        },

        config = function()
            -- Load nvim-dap.
            local dap = require("dap")

            -- Load the DAP UI module.
            local dapui = require("dapui")


            -- Create a layout configuration for a single DAP UI element.
            local function layout(name)
                return {
                    -- Only display the requested UI element.
                    elements = {
                        { id = name },
                    },

                    -- Enter/focus the UI when it is opened.
                    enter = true,

                    -- Default size of the UI.
                    size = 40,

                    -- Place the UI on the right side.
                    position = "right",
                }
            end


            -- Define the available DAP UI layouts.
            --
            -- Each name corresponds to one of the DAP UI components.
            local name_to_layout = {
                repl = { layout = layout("repl"), index = 0 },
                stacks = { layout = layout("stacks"), index = 0 },
                scopes = { layout = layout("scopes"), index = 0 },
                console = { layout = layout("console"), index = 0 },
                watches = { layout = layout("watches"), index = 0 },
                breakpoints = { layout = layout("breakpoints"), index = 0 },
            }


            -- This table will contain the final list of layouts
            -- passed to dapui.setup().
            local layouts = {}


            -- Iterate through every named layout.
            for name, config in pairs(name_to_layout) do

                -- Add the layout to the list of layouts.
                table.insert(layouts, config.layout)

                -- Store the position/index of this layout in the list.
                --
                -- #layouts gives us the current number of layouts.
                name_to_layout[name].index = #layouts
            end


            -- Open or toggle one specific DAP UI component.
            local function toggle_debug_ui(name)

                -- Close the currently open DAP UI first.
                dapui.close()

                -- Find the layout associated with the requested name.
                local layout_config = name_to_layout[name]

                -- If the requested layout doesn't exist,
                -- stop with an error.
                if layout_config == nil then
                    error(string.format("bad name: %s", name))
                end


                -- Get information about the current Neovim UI.
                local uis = vim.api.nvim_list_uis()[1]

                -- If UI information exists, use its width as the layout size.
                if uis ~= nil then
                    layout_config.size = uis.width
                end


                -- Toggle the requested DAP UI layout.
                pcall(dapui.toggle, layout_config.index)
            end


            -- Toggle the DAP REPL.
            vim.keymap.set("n", "<leader>dr", function() toggle_debug_ui("repl") end, { desc = "Debug: toggle repl ui" })

            -- Toggle the stack frames view.
            vim.keymap.set("n", "<leader>ds", function() toggle_debug_ui("stacks") end,
                { desc = "Debug: toggle stacks ui" })

            -- Toggle the watches view.
            vim.keymap.set("n", "<leader>dw", function() toggle_debug_ui("watches") end,
                { desc = "Debug: toggle watches ui" })

            -- Toggle the breakpoints view.
            vim.keymap.set("n", "<leader>db", function() toggle_debug_ui("breakpoints") end,
                { desc = "Debug: toggle breakpoints ui" })

            -- Toggle the scopes view.
            vim.keymap.set("n", "<leader>dS", function() toggle_debug_ui("scopes") end,
                { desc = "Debug: toggle scopes ui" })

            -- Toggle the console view.
            vim.keymap.set("n", "<leader>dc", function() toggle_debug_ui("console") end,
                { desc = "Debug: toggle console ui" })


            -- When entering the DAP REPL buffer,
            -- allow the output to wrap across multiple lines.
            vim.api.nvim_create_autocmd("BufEnter", {
                group = "DapGroup",
                pattern = "*dap-repl*",
                callback = function()
                    vim.wo.wrap = true
                end,
            })


            -- When entering a DAP REPL window,
            -- automatically navigate/focus that window.
            vim.api.nvim_create_autocmd("BufWinEnter", create_nav_options("dap-repl"))

            -- When entering the DAP Watches window,
            -- automatically navigate/focus that window.
            vim.api.nvim_create_autocmd("BufWinEnter", create_nav_options("DAP Watches"))


            -- Initialize nvim-dap-ui with the layouts created above.
            dapui.setup({
                layouts = layouts,

                -- Focus the UI when it opens.
                enter = true,
            })


            -- Automatically close the DAP UI when a debugging session terminates.
            dap.listeners.before.event_terminated.dapui_config = function()
                dapui.close()
            end

            -- Automatically close the DAP UI when the debugged program exits.
            dap.listeners.before.event_exited.dapui_config = function()
                dapui.close()
            end


            -- Handle output produced by the debugged program.
            dap.listeners.after.event_output.dapui_config = function(_, body)

                -- If the output is console output,
                -- send it to the DAP UI console.
                if body.category == "console" then
                    dapui.eval(body.output) -- Sends stdout/stderr to Console
                end
            end
        end,
    },


    --------------------------------------------------------------------------
    -- mason-nvim-dap
    --------------------------------------------------------------------------

    {
        -- Connect Mason with nvim-dap.
        --
        -- Mason handles installing and managing debug adapters.
        "jay-babu/mason-nvim-dap.nvim",

        -- Plugins required by mason-nvim-dap.
        dependencies = {
            "williamboman/mason.nvim",
            "mfussenegger/nvim-dap",
            "neovim/nvim-lspconfig",
        },

        config = function()

            -- Configure mason-nvim-dap.
            require("mason-nvim-dap").setup({

                -- Debug adapters that should be installed automatically.
                ensure_installed = {
                    "delve",
                },

                -- Automatically install missing debug adapters.
                automatic_installation = true,


                -- Configure how debug adapters are set up.
                handlers = {

                    -- Default handler.
                    --
                    -- Any adapter without a custom configuration will
                    -- use Mason's default setup.
                    function(config)
                        require("mason-nvim-dap").default_setup(config)
                    end,


                    -- Custom configuration specifically for Delve.
                    --
                    -- Delve is the debugger used for Go.
                    delve = function(config)

                        -- Add a configuration for debugging the current file.
                        table.insert(config.configurations, 1, {
                            -- Ask for command-line arguments.
                            args = function()
                                return vim.split(vim.fn.input("args> "), " ")
                            end,

                            -- Tell nvim-dap which debugger type to use.
                            type = "delve",

                            -- Name shown when selecting a debug configuration.
                            name = "file",

                            -- Launch a new debugging session.
                            request = "launch",

                            -- Debug the currently open file.
                            program = "${file}",

                            -- Use remote output mode.
                            outputMode = "remote",
                        })


                        -- Add another configuration for debugging the current
                        -- file with arguments.
                        table.insert(config.configurations, 1, {
                            -- Ask for command-line arguments.
                            args = function()
                                return vim.split(vim.fn.input("args> "), " ")
                            end,

                            -- Tell nvim-dap to use Delve.
                            type = "delve",

                            -- Name shown in the debug configuration selector.
                            name = "file args",

                            -- Launch a new debugging session.
                            request = "launch",

                            -- Debug the currently open file.
                            program = "${file}",

                            -- Use remote output mode.
                            outputMode = "remote",
                        })


                        -- Finish configuring Delve using Mason's
                        -- default setup.
                        require("mason-nvim-dap").default_setup(config)
                    end,
                },
            })
        end,
    },
}
