local M = { "stevearc/conform.nvim" }

M.event = "User FilePost"

function M.opts()
	local lua_formatters = { "stylua" }
	local python_formatters = { "isort", "black" }
	local rust_formatters = { "rustfmt" }
	local yaml_formatters = { "yamlfmt" }
	local all_formatters = { "codespell" }
	local on_save_formatters = { "trim_whitespace" }

	return {
		formatters_by_ft = {
			lua = lua_formatters,
			python = python_formatters,
			rust = rust_formatters,
			yaml = yaml_formatters,
			["*"] = all_formatters,
			["_"] = on_save_formatters,
		},
		format_on_save = false,
	}
end

function M.config(_, opts)
	local conform = require("conform")
	conform.setup(opts)

	vim.keymap.set("n", "<leader>F", function()
		conform.format({ bufnr = vim.api.nvim_get_current_buf() })
	end, { desc = "Format current buffer" })
end

return M
