local M = { "MeanderingProgrammer/render-markdown.nvim" }

M.enabled = false
M.lazy = true
M.dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }
M.ft = { 'markdown', 'Avante' }

function M.opts()
	return {
		completions = {
			lsp = { enabled = true },
			blink = { enabled = true },
		},
		file_types = { 'markdown', 'Avante'},
	}
end

return M
