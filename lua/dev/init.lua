-- Load the keymap/remapping configuration.
require("dev.remap")

-- Load and initialize lazy.nvim and the plugins managed by it.
require("dev.lazy_init")

-- Load general Neovim settings/options.
require("dev.set")


-- DO.not
-- DO NOT INCLUDE THIS

-- If i want to keep doing lsp debugging
-- function restart_htmx_lsp()
--     require("lsp-debug-tools").restart({ expected = {}, name = "htmx-lsp", cmd = { "htmx-lsp", "--level", "DEBUG" }, root_dir = vim.loop.cwd(), });
-- end

-- DO NOT INCLUDE THIS
-- DO.not


-- Create a shorthand for creating an autocommand group.
-- Autocommand groups let us organize related autocommands together.
local augroup = vim.api.nvim_create_augroup

-- Create a group for the general autocommands in this file.
local ThePrimeagenGroup = augroup('ThePrimeagen', {})

-- Create a shorthand for defining an autocommand.
local autocmd = vim.api.nvim_create_autocmd

-- Create a separate group specifically for the yank highlighting autocommand.
local yank_group = augroup('HighlightYank', {})


-- Helper function for reloading a Lua module.
-- Useful when experimenting with or developing Neovim configuration.
function R(name)
    require("plenary.reload").reload_module(name)
end


-- Tell Neovim about additional filetype associations.
-- Files ending in .templ will be recognized as the "templ" filetype.
vim.filetype.add({
    extension = {
        templ = 'templ',
    }
})


-- Highlight the text that was just yanked.
--
-- TextYankPost runs after text has been copied/yanked.
-- The highlight disappears automatically after 40ms.
autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})


-- Before saving a file, remove trailing whitespace.
--
-- %        = operate on the entire file
-- s/       = substitute
-- \s\+$    = whitespace at the end of a line
-- //       = replace it with nothing
-- e        = don't report an error if there is nothing to replace
autocmd({"BufWritePre"}, {
    group = ThePrimeagenGroup,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})


-- Change the colorscheme whenever entering a buffer.
--
-- Zig files use "tokyonight-night".
-- Every other filetype uses "rose-pine-moon".
--
-- pcall() prevents an error from stopping the autocommand if
-- the requested colorscheme cannot be loaded.
autocmd('BufEnter', {
    group = ThePrimeagenGroup,
    callback = function()
        if vim.bo.filetype == "zig" then
            pcall(vim.cmd.colorscheme, "tokyonight-night")
        else
            pcall(vim.cmd.colorscheme, "rose-pine-moon")
        end
    end
})


-- Set up LSP-related keymaps whenever an LSP attaches to a buffer.
--
-- e.buf is the buffer that the LSP attached to.
-- Using { buffer = e.buf } means these keymaps only apply to that buffer.
autocmd('LspAttach', {
    group = ThePrimeagenGroup,
    callback = function(e)
        local opts = { buffer = e.buf }

        -- Go to the definition of the symbol under the cursor.
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)

        -- Show documentation/hover information for the symbol under the cursor.
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)

        -- Search for a symbol across the current workspace.
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)

        -- Show the diagnostic message for the current line in a floating window.
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)

        -- Show available code actions.
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)

        -- Show references to the symbol under the cursor.
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)

        -- Rename the symbol under the cursor.
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)

        -- Show function/method signature information while in insert mode.
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)

        -- Jump to the next diagnostic.
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)

        -- Jump to the previous diagnostic.
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    end
})


-- Configure Neovim's built-in netrw file browser.

-- Open files in the current window rather than creating a split.
vim.g.netrw_browse_split = 0

-- Hide the netrw startup banner.
vim.g.netrw_banner = 0

-- Set the netrw window size to 25%.
vim.g.netrw_winsize = 50
