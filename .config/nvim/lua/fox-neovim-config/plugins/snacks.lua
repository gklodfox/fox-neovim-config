local M = { 'folke/snacks.nvim' }

M.dependencies = { 'Shatur/neovim-session-manager' }

M.priority = 1000
function M.opts()
	---@type snacks.Config
	return {
		bigfile = {},
		image = {},
		scope = {
			-- enabled = true,
			-- priority = 200,
			-- underline = true,
			-- only_current = true,
			-- hl = {
			-- 	"RainbowRed", "RainbowYellow", "RainbowBlue", "RainbowOrange",
			-- 	"RainbowGreen", "RainbowViolet", "RainbowCyan"
			-- },
		},
		indent = {
			-- only_scope = true,
			-- only_current = true,
			-- sources = {
			-- 	chunk = {
			-- 		-- when enabled, scopes will be rendered as chunks, except for the
			-- 		-- top-level scope which will be rendered as a scope.
			-- 		enabled = true,
			-- 		-- only show chunk scopes in the current window
			-- 		only_current = true,
			-- 		priority = 200,
			-- 		hl = {
			-- 			"RainbowRed", "RainbowYellow", "RainbowBlue", "RainbowOrange",
			-- 			"RainbowGreen", "RainbowViolet", "RainbowCyan"
			-- 			-- "RainbowRed", "RainbowYellow", "RainbowBlue", "RainbowOrange",
			-- 			-- "RainbowGreen", "RainbowViolet", "RainbowCyan"
			-- 		},
			-- 		char = {
			-- 			corner_top = "┌",
			-- 			corner_bottom = "└",
			-- 			-- corner_top = "╭",
			-- 			-- corner_bottom = "╰",
			-- 			horizontal = "─",
			-- 			vertical = "│",
			-- 			arrow = ">",
			-- 		},
			-- 	},
			--
			-- },
			-- hl = {
			-- 	"RainbowRed", "RainbowYellow", "RainbowBlue", "RainbowOrange",
			-- 	"RainbowGreen", "RainbowViolet", "RainbowCyan"
			-- 	-- "RainbowRed", "RainbowYellow", "RainbowBlue", "RainbowOrange",
			-- 	-- "RainbowGreen", "RainbowViolet", "RainbowCyan"
			-- },
		},
		dim = {},
		input = {},
		notifier = { enabled = false },
		explorer = {},
		dashboard = { enabled = false },
		picker = {
			-- win = {
			-- 	input = {
			-- 		keys = {
			-- 			["<a-c>"] = {
			-- 				"toggle_cwd",
			-- 				mode = { "n", "i" },
			-- 			},
			-- 		},
			-- 	},
			-- },
			-- sources = {
			-- 	projects = {
			-- 		dev = { "~/.kotfiles", "~/code" },
			-- 	}
			-- }
		},
		quickfile = {},
		scroll = {},
		statuscolumn = {},
		words = {},
		styles = {
			notification = {

			},
		},
	}
end

--
-- function M.config(_, opts)
-- 	require('snacks')
-- end

return M
