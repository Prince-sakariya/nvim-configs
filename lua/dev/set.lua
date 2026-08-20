-- Hide the cursor when using a graphical cursor style.
-- An empty string lets the terminal/editor use its default cursor.
vim.opt.guicursor = ""


-- Show absolute line numbers.
vim.opt.nu = true

-- Show relative line numbers for all lines except the current line.
-- This makes commands like "5j" easier to use because you can
-- see how many lines away the target is.
vim.opt.relativenumber = true


-- Number of spaces that a <Tab> character represents.
vim.opt.tabstop = 4

-- Number of spaces inserted when pressing <Tab> in Insert mode.
vim.opt.softtabstop = 4

-- Number of spaces used for each indentation level.
vim.opt.shiftwidth = 4

-- Insert spaces instead of actual tab characters.
vim.opt.expandtab = true


-- Enable smart indentation based on the current file's syntax.
vim.opt.smartindent = true


-- Don't wrap long lines onto the next screen line.
vim.opt.wrap = false


-- Don't create swap files.
vim.opt.swapfile = false

-- Don't create backup files.
vim.opt.backup = false

-- Store undo history in this directory.
--
-- os.getenv("HOME") gets your home directory.
-- This results in something like:
-- ~/.vim/undodir
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- Save undo history to disk so it survives between Neovim sessions.
vim.opt.undofile = true


-- Don't keep search matches highlighted after the search is finished.
vim.opt.hlsearch = false

-- Highlight search matches while you are typing the search.
vim.opt.incsearch = true


-- Enable 24-bit RGB colors in the terminal.
vim.opt.termguicolors = true


-- Keep 8 lines visible above/below the cursor when scrolling.
vim.opt.scrolloff = 8

-- Always reserve a column on the left for signs such as:
-- diagnostics, Git changes, breakpoints, etc.
vim.opt.signcolumn = "yes"

-- Allow certain characters, including @, -, and @-@,
-- to be treated as part of a filename.
vim.opt.isfname:append("@-@")


-- Time in milliseconds before certain events are triggered.
-- A low value makes things such as diagnostics and CursorHold
-- respond more quickly.
vim.opt.updatetime = 50


-- Draw a vertical guide at column 80.
-- This is useful as a visual indication of the preferred line length.
vim.opt.colorcolumn = "80"
