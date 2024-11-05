local M = { "folke/trouble.nvim" }

M.cmd = "Trouble"
M.keys = {
	{ "<leader>tt", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
	{ "<leader>tT", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
	{
		"<leader>tl",
		"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
		desc = "LSP Definitions / references / ... (Trouble)",
	},
	{ "<leader>tL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
	{ "<leader>tq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
	{ "<leader>[d", "<cmd>Trouble diagnostics next<cr>", desc = "Next diagnostic (Trouble)" },
	{ "<leader>]d", "<cmd>Trouble diagnostics previous<cr>", desc = "Previous diagnostic (Trouble)" },
}

function M.opts()
	return {
		modes = {
			diagnostics_buffer = {
				mode = "diagnostics", -- inherit from diagnostics mode
				filter = { buf = 0 }, -- filter diagnostics to the current buffer
				auto_close = false,
				auto_open = false,
				open_no_results = false,
			},
		},
	}
end

return M
