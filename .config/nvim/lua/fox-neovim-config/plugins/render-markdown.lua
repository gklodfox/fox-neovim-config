local M = { "MeanderingProgrammer/render-markdown.nvim" }

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

function M.config(_, opts)
	require('render-markdown').setup(opts)
end

return M
