-- Build the path where lazy.nvim will be installed.
--
-- vim.fn.stdpath("data") usually points to Neovim's data directory.
-- lazy.nvim will be stored inside a "lazy/lazy.nvim" directory there.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Check whether lazy.nvim already exists.
--
-- vim.loop.fs_stat() checks whether the given path exists.
-- If it doesn't exist, we need to install lazy.nvim.
if not vim.loop.fs_stat(lazypath) then
	-- Run a shell command from inside Neovim.
	-- Here we are using Git to clone lazy.nvim.
	vim.fn.system({
		"git",

		-- Clone a repository.
		"clone",

		-- Only download the Git objects needed initially.
		-- This keeps the clone smaller.
		"--filter=blob:none",

		-- The official lazy.nvim repository.
		"https://github.com/folke/lazy.nvim.git",

		-- Use the stable branch instead of the development version.
		"--branch=stable", -- latest stable release

		-- Directory where lazy.nvim should be installed.
		lazypath,
	})
end

-- Add lazy.nvim to Neovim's runtime path.
--
-- This makes lazy.nvim available to Neovim so that
-- require("lazy") can find and load it.
vim.opt.rtp:prepend(lazypath)

-- Initialize lazy.nvim.
--
-- "dev.lazy" tells lazy.nvim where to find the plugin
-- specifications for this configuration.
--
-- change_detection.notify = false disables notifications
-- when lazy.nvim detects configuration changes.
require("lazy").setup({
	spec = "dev.lazy",
	change_detection = { notify = false },
})
