local M = { "folke/which-key.nvim" }

M.event = "VeryLazy"

function M.opts()
	return {
		preset = "helix",
		icons = { mappings = false },
	}
end

return M
