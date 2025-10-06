local M = { "saghen/blink.cmp" }

M.dependencies = {
	"Kaiser-Yang/blink-cmp-avante",
	"rafamadriz/friendly-snippets",
	'folke/lazydev.nvim',
}
M.version = "1.*"
-- M.build = "cargo build --release"

function M.opts()
	---@module 'blink.cmp'
	---@type blink.cmp.Config
	return {
		keymap = { preset = "super-tab" },
		completion = {documentation = {auto_show = true, auto_show_delay_ms = 500}},
		appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono'
    },
		sources = {
			default = { "avante", "lazydev", "lsp", "path", "snippets", "buffer" },
			providers = {
				avante = {
					module = 'blink-cmp-avante',
					name = 'Avante',
					opts = {},
				},
				lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
			}
		},
		fuzzy = { implementation = "prefer_rust" },
		cmdline = { keymap = { preset = 'inherit' }, completion = { menu = {auto_show = true }, ghost_text = { enabled = true } } },
		signature = { enabled = true },
	}
end
-- M.opts_extend = { "sources.default", "sources.completion.enabled_providers",
--     "sources.compat" }

function M.config(_, opts)
    require('blink.cmp').setup(opts)
end

return M
