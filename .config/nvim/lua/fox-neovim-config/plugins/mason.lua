local M = { "mason-org/mason-lspconfig.nvim" }

M.dependencies = {
	{ "mason-org/mason.nvim",    opts = {} },
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"saghen/blink.cmp",
		},
	},
	{ "mfussenegger/nvim-lint" },
	{ "rshkarin/mason-nvim-lint" },
	{
		"stevearc/conform.nvim",
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>F",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {},
	},
	{ "LittleEndianRoot/mason-conform" },
}
function M.init()
	vim.diagnostic.config({
		virtual_text = { severity = { vim.diagnostic.severity.WARN, vim.diagnostic.severity.ERROR } },
		virtual_lines = { severity = { vim.diagnostic.severity.HINT, vim.diagnostic.severity.INFO } },
		float = { border = "rounded", source = "if_many" },
		update_in_insert = true,
		underline = { severity = vim.diagnostic.severity.ERROR },
		severity_sort = true,
	})
end

M.lsp_servers = { "lua_ls", "markdown_oxide", "clangd", "autotools_ls", "cmake", "pyright", "groovyls", "yamlls" }
M.formatters  = { "luaformatter", "cbfmt", "mdformat", "clang-format", "gersemi", "autoflake", "blue",
	"reorder-python-imports", "yamlfmt" }
M.linters     = { "luacheck", "markdownlint", "cpplint", "checkmake", "cmakelint", "flake8", "mypy", "yamllint"}

function M.config()
	require("mason-lspconfig").setup({ ensure_installed = M.lsp_servers })
	require("mason-conform").setup({ ensure_installed = M.formatters })
	require("mason-nvim-lint").setup({ ensure_installed = M.linters })
end

return M
