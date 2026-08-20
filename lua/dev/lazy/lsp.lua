return {
    -- nvim-lspconfig provides configuration helpers for Neovim's built-in LSP client.
    --
    -- The LSP gives Neovim features such as:
    --   - Go to definition
    --   - Hover documentation
    --   - Diagnostics
    --   - Rename
    --   - Code actions
    --   - Completion
    "neovim/nvim-lspconfig",

    -- Plugins required by this LSP/completion setup.
    dependencies = {

        -- Used for formatting files.
        "stevearc/conform.nvim",

        -- Installs external tools such as language servers.
        "williamboman/mason.nvim",

        -- Connects Mason with lspconfig and manages LSP servers.
        "williamboman/mason-lspconfig.nvim",

        -- Provides LSP capabilities to nvim-cmp.
        "hrsh7th/cmp-nvim-lsp",

        -- Completion source for words from the current buffer.
        "hrsh7th/cmp-buffer",

        -- Completion source for filesystem paths.
        "hrsh7th/cmp-path",

        -- Completion source for the command line.
        "hrsh7th/cmp-cmdline",

        -- Main completion engine.
        "hrsh7th/nvim-cmp",

        -- Snippet engine.
        "L3MON4D3/LuaSnip",

        -- Allows LuaSnip to work as a completion source for nvim-cmp.
        "saadparwaiz1/cmp_luasnip",

        -- Displays LSP progress notifications.
        "j-hui/fidget.nvim",
    },


    config = function()

        -- Configure conform.nvim.
        --
        -- formatters_by_ft maps filetypes to formatters.
        --
        -- It is currently empty here, so this setup does not add
        -- any formatters through this particular configuration.
        require("conform").setup({
            formatters_by_ft = {
            }
        })


        -- Load nvim-cmp.
        local cmp = require('cmp')

        -- Load the nvim-cmp integration for LSP capabilities.
        local cmp_lsp = require("cmp_nvim_lsp")


        -- Create the capabilities that will be advertised to LSP servers.
        --
        -- This starts with Neovim's default LSP capabilities and then
        -- adds the completion capabilities provided by nvim-cmp.
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())


        -- Initialize Fidget.
        --
        -- Fidget displays progress information from LSP servers.
        require("fidget").setup({})


        -- Initialize Mason.
        --
        -- Mason manages external developer tools, including LSP servers.
        require("mason").setup()


        -- Configure mason-lspconfig.
        --
        -- This connects Mason's installed language servers with lspconfig.
        require("mason-lspconfig").setup({

            -- LSP servers that Mason should make sure are installed.
            ensure_installed = {
                "lua_ls",
                "rust_analyzer",
            },


            -- Handlers control how each language server is configured.
            handlers = {

                -- Default handler.
                --
                -- Any server without its own custom handler will use
                -- this configuration.
                function(server_name)

                    -- Configure the LSP server using the shared capabilities.
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,


                ----------------------------------------------------------------
                -- Zig
                ----------------------------------------------------------------

                -- Custom configuration for the Zig language server.
                zls = function()

                    -- Load lspconfig.
                    local lspconfig = require("lspconfig")

                    -- Configure ZLS.
                    lspconfig.zls.setup({

                        -- Look for one of these files/directories to determine
                        -- the root directory of the Zig project.
                        root_dir = lspconfig.util.root_pattern(
                            ".git",
                            "build.zig",
                            "zls.json"
                        ),

                        -- ZLS-specific settings.
                        settings = {
                            zls = {

                                -- Show inferred types and other information
                                -- directly in the source code.
                                enable_inlay_hints = true,

                                -- Enable snippet support.
                                enable_snippets = true,

                                -- Enable style warnings.
                                warn_style = true,
                            },
                        },
                    })


                    -- Disable Zig's formatter error parsing.
                    vim.g.zig_fmt_parse_errors = 0

                    -- Disable Zig's automatic formatting on save.
                    vim.g.zig_fmt_autosave = 0
                end,


                ----------------------------------------------------------------
                -- Lua
                ----------------------------------------------------------------

                -- Custom configuration for lua-language-server.
                ["lua_ls"] = function()

                    -- Load lspconfig.
                    local lspconfig = require("lspconfig")


                    -- Configure lua-language-server.
                    lspconfig.lua_ls.setup {

                        -- Give the Lua LSP the completion capabilities
                        -- provided by nvim-cmp.
                        capabilities = capabilities,

                        -- Lua-language-server settings.
                        settings = {
                            Lua = {

                                -- Tell the language server which Lua runtime
                                -- is being used.
                                runtime = {
                                    version = 'LuaJIT',
                                },


                                -- Configure Lua diagnostics.
                                diagnostics = {

                                    -- Tell the language server that "vim"
                                    -- is a valid global variable.
                                    --
                                    -- Without this, the LSP would complain
                                    -- about things such as vim.api and vim.opt.
                                    globals = { 'vim' },
                                },


                                -- Configure the Lua workspace.
                                workspace = {

                                    -- Add Neovim's runtime files to the
                                    -- language server's known Lua library.
                                    library = vim.api.nvim_get_runtime_file("", true),

                                    -- Don't ask about third-party libraries.
                                    checkThirdParty = false,
                                },


                                -- Lua language-server formatting settings.
                                format = {
                                    enable = true,

                                    -- Formatting options.
                                    --
                                    -- NOTE: defaultConfig values must be strings.
                                    defaultConfig = {
                                        indent_style = "space",
                                        indent_size = "2",
                                    }
                                },
                            }
                        }
                    }
                end,
           }
        })


        ------------------------------------------------------------------------
        -- nvim-cmp
        ------------------------------------------------------------------------

        -- Configure how completion items are selected.
        --
        -- Select means that moving through the completion list also
        -- selects the highlighted item.
        local cmp_select = { behavior = cmp.SelectBehavior.Select }


        -- Configure nvim-cmp.
        cmp.setup({

            -- Tell nvim-cmp how to expand snippets.
            snippet = {
                expand = function(args)

                    -- Use LuaSnip to expand the snippet received from
                    -- the completion source/LSP.
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },


            -- Configure completion keymaps.
            mapping = cmp.mapping.preset.insert({

                -- Move to the previous completion item.
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),

                -- Move to the next completion item.
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),

                -- Accept the currently selected completion.
                --
                -- select = true means that if nothing is explicitly
                -- selected, the first completion item can be accepted.
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),

                -- Manually open the completion menu.
                ["<C-Space>"] = cmp.mapping.complete(),
            }),


            -- Configure where completion suggestions come from.
            sources = cmp.config.sources({

                -- Copilot completion source.
                --
                -- group_index = 2 puts it in a separate completion group.
                { name = "copilot", group_index = 2 },

                -- Completion suggestions provided by the LSP.
                { name = 'nvim_lsp' },

                -- Completion suggestions from LuaSnip snippets.
                { name = 'luasnip' }, -- For luasnip users.

            }, {

                -- Completion suggestions based on words already
                -- present in the current buffer.
                { name = 'buffer' },
            })
        })


        ------------------------------------------------------------------------
        -- Diagnostics
        ------------------------------------------------------------------------

        -- Configure how LSP diagnostics are displayed.
        vim.diagnostic.config({

            -- update_in_insert = true,
            --
            -- If enabled, diagnostics would update while typing.
            -- It is currently commented out, so the default behavior applies.

            float = {

                -- Don't allow the floating diagnostic window
                -- to receive focus.
                focusable = false,

                -- Use a minimal floating-window style.
                style = "minimal",

                -- Give diagnostic floating windows rounded borders.
                border = "rounded",

                -- Always show which source produced the diagnostic.
                source = "always",

                -- Don't display a header.
                header = "",

                -- Don't display a prefix before each diagnostic.
                prefix = "",
            },

            -- Show diagnostics as virtual text directly inside the buffer.
            virtual_text = true,

            -- Underline code associated with diagnostics.
            underline = true,
        })
    end
}
