local venv_path = os.getenv("VIRTUAL_ENV")

local get_venv = function()
	if vim.bo.filetype ~= "python" then
		return { "" }
	end
	if venv_path == nil then
		return { "" }
	else
		return { vim.fn.fnamemodify(venv_path, ":t") }
	end
end

local get_active_lsp = function()
	local msg = "No LSP"
	-- local buf_ft = vim.api.nvim_get_option_value("filetype")
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if next(clients) == nil then
		return msg
	end

	for _, client in ipairs(clients) do
		---@diagnostic disable-next-line: undefined-field
		local filetypes = client.config.filetypes
		if filetypes and vim.fn.index(filetypes, vim.bo.filetype) ~= -1 then
			return client.name
		end
	end
	return msg
end

local M = { "nvim-lualine/lualine.nvim" }

M.dependencies = {
	"nvim-tree/nvim-web-devicons",
	"Isrothy/lualine-diagnostic-message",
	-- "jim-at-jibba/micropython.nvim",
}

function M.opts()
	return {
		options = {
			theme = "catppuccin",
			icons_enabled = true,
			disabled_filetypes = { statusline = { "dashboard" }, winbar = { "dashboard" } },
		},
		sections = {
			lualine_a = { "mode" },
			lualine_b = {
				"branch",
				{
					"diff",
					source = function()
						local gitsigns = vim.b.gitsigns_status_dict
						if gitsigns then
							return {
								added = gitsigns.added,
								modified = gitsigns.changed,
								removed = gitsigns.removed,
							}
						end
					end,
				},
			},
			lualine_c = {
				{ "diagnostics", sources = { "nvim_diagnostic" } },
				{ "searchcount", maxcount = 999, timeout = 500 },
			},
			lualine_x = {
				"diagnostic-message",
				{ get_active_lsp },
			},
			lualine_y = {
				{ "progress", padding = { left = 1, right = 1 } },
        { 'location' },
			},
			lualine_z = {
				get_venv(),
				function()
					return os.date("%R")
				end,
			},
		},
		winbar = {
			lualine_a = {
				"tabs",
				"hostname",
			},
			lualine_b = {
				{ "fileformat", symbols = { unix = " ", dos = " ", mac = " " } },
				{ "encoding", fmt = string.upper },
				{ "filesize" },
			},
			lualine_c = {
				{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
				{
					"filename",
					padding = { left = 0, right = 1 },
					symbols = { readonly = "[R]", modified = "[~]", unnamed = "[*]", newfile = "[+]" },
				},
			},
			lualine_x = {},
			lualine_y = {},
			lualine_z = {
				{
					"buffers",
					show_filename_only = true,
					mode = 2,
				},
			},
		},
		tabline = {},
		extensions = { "lazy", "mason", "mundo", "nvim-tree", "trouble" },
	}
end

function M.config(_, opts)
	local keymap = vim.keymap

	keymap.set("n", "gb", function()
		vim.cmd("LualineBuffersJump! " .. vim.v.count)
	end, { desc = "Jump to the buffer" })
	keymap.set("n", "gB", "<cmd>LualineBuffersJump $<CR>", { desc = "Jump to the last buffer" })

	local trouble = require("trouble")
	local symbols = trouble.statusline({
		mode = "symbols",
		groups = {},
		title = false,
		filter = { range = true },
		format = "{kind_icon}{symbol.name:Normal}",
		-- The following line is needed to fix the background color
		-- Set it to the lualine section you want to use
		hl_group = "lualine_c_normal",
	})
	table.insert(opts.winbar.lualine_c, {
		symbols.get,
		cond = symbols.has,
	})
	-- table.insert(opts.sections.lualine_c, {
	-- 	require("micropython_nvim").statusline,
	-- 	cond = package.loaded["micropython_nvim"] and require("micropython_nvim").exists,
	-- })

	require("lualine").setup(opts)
end

return M
