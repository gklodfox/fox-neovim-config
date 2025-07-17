local M = { "0xstepit/flow.nvim" }
M.lazy = false
M.priority = 1000
M.tag = "v2.0.2"
function M.opts()
	return {
		theme = { contrast = "high" },
	}
end

function M.config(_, opts)
    require("flow").setup(opts)
    vim.cmd("colorscheme flow")
end

return M
