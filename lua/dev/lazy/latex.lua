return {
	"lervag/vimtex",
	lazy = false,
	init = function()
		vim.g.vimtex_view_method = "zathura"

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

	config = function()
		-- Latex
		vim.keymap.set("n", "<leader>ll", function()
			local file = vim.fn.expand("%:p")
			local target = vim.fn.expand("%:t:r")
			local root = vim.fn.fnamemodify(file, ":h:h")
			local pdf = root .. "/output/" .. target .. ".pdf"

			print("Building " .. target)
			print("Root " .. root)

			vim.fn.jobstart({ "make", target }, {
				cwd = root,

				on_exit = function(_, code)
					vim.schedule(function()
						if code == 0 then
							vim.fn.jobstart({
								"osascript",
								"-e",
								[[tell application "Skim"
                            if (count of documents) > 0 then
                                revert documents
                            else
                                open POSIX file "]] .. pdf .. [["
                            end if
                        end tell]],
							})
						else
							print("Build failed")
						end
					end)
				end,
			})
		end, {
			desc = "Compile LaTeX",
		})
	end,
}
