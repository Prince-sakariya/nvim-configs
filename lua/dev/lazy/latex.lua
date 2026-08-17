-- return {
--     "lervag/vimtex",
--     lazy = false,
--     init = function()
--         -- VimTeX configuration goes here, e.g.
--         vim.g.vimtex_view_method = "skim"
--         vim.g.vimtex_compiler_output_directory = "../output"
--
--         vim.g.vimtex_compiler_latexmk = {
--             options = {
--                 "-lualatex",
--                 "-synctex=1",
--                 "-interaction=nonstopmode",
--                 "-file-line-error",
--             },
--         }
--     end,
-- }


return {
  "lervag/vimtex",
  lazy = false,
  init = function()
    vim.g.vimtex_view_method = "skim"

    vim.g.vimtex_compiler_method = "latexmk"

    vim.g.vimtex_compiler_latexmk = {
      build_dir = "../output",
      options = {
        "-synctex=1",
        "-interaction=nonstopmode",
        "-file-line-error",
      },
    }

    vim.g.vimtex_compiler_latexmk_engines = {
      _ = "-lualatex",
    }
  end,
}
