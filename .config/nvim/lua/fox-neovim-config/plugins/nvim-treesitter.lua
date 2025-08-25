local M = { "nvim-treesitter/nvim-treesitter" }

M.dependencies = {
	"windwp/nvim-ts-autotag",
	"nvim-treesitter/nvim-treesitter-textobjects",
	"RRethy/nvim-treesitter-textsubjects",
	{
		"LiadOz/nvim-dap-repl-highlights",
		config = function()
			require("nvim-dap-repl-highlights").setup()
		end,
	},
}
M.event = { "BufReadPost", "BufWritePost", "BufNewFile", "VeryLazy" }
M.cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" }
M.keys = {
	{ "<c-space>", desc = "Increment Selection" },
	{ "<bs>", desc = "Decrement Selection", mode = "x" },
}
M.opts_extend = { "ensure_installed" }
M.lazy = vim.fn.argc(-1) == 0

function M.build()
	require("nvim-treesitter.install").update({ with_sync = true })()
end

function M.init(plugin)
	vim.opt.foldmethod = "expr"
	vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
	vim.o.foldlevel = 2

	require("lazy.core.loader").add_to_rtp(plugin)
	require("nvim-treesitter.query_predicates")
end

function M.opts()
	return {
		ensure_installed = {
                        "dap_repl",
			"vimdoc",
			"c",
			"lua",
			"luadoc",
			"luap",
			"printf",
			"regex",
			"toml",
			"xml",
			"latex",
			"rust",
			"jsonc",
			"bash",
			"vim",
			"query",
			"markdown",
			"groovy",
			"markdown_inline",
			"python",
			"cpp",
			"fish",
			"json",
			"yaml",
			"gitignore",
			"bash",
			"diff",
			"html",
		},
		autotag = { enable = true },
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "<C-space>",
				node_incremental = "<C-Space>",
				scope_incremental = false,
				node_decremental = "<bs>",
			},
		},
		context_commentstring = { enable = true, enable_autocmd = true },
		textobjects = {
			move = {
				enable = true,
				set_jumps = true, -- whether to set jumps in the jumplist
				goto_next_start = {
					["]m"] = "@function.outer",
					["]]"] = "@class.outer",
				},
				goto_next_end = {
					["]M"] = "@function.outer",
					["]["] = "@class.outer",
				},
				goto_previous_start = {
					["[m"] = "@function.outer",
					["[["] = "@class.outer",
				},
				goto_previous_end = {
					["[M"] = "@function.outer",
					["[]"] = "@class.outer",
				},
			},
			lsp_interop = {
				enable = true,
				border = "none",
				floating_preview_opts = {},
				peek_definition_code = {
					["<leader>df"] = "@function.outer",
					["<leader>dF"] = "@class.outer",
				},
			},
			swap = {
				enable = true,
				swap_next = { ["<leader>a"] = "@parameter.inner" },
				swap_previous = { ["<leader>A"] = "@parameter.inner" },
			},
			select = {
				enable = true,
				lookahead = true,

				keymaps = {
					-- You can use the capture groups defined in textobjects.scm
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ac"] = "@class.outer",
					-- you can optionally set descriptions to the mappings (used in the desc parameter of nvim_buf_set_keymap
					["ic"] = {
						query = "@class.inner",
						desc = "Select inner part of a class region",
					},
				},
				-- You can choose the select mode (default is charwise 'v')
				selection_modes = {
					["@parameter.outer"] = "v", -- charwise
					["@function.outer"] = "V", -- linewise
					["@class.outer"] = "<c-v>", -- blockwise
				},

				include_surrounding_whitespace = true,
			},
		},
		textsubjects = {
			enable = true,
			prev_selection = ",",
			keymaps = {
				["."] = "textsubjects-smart",
				[";"] = "textsubjects-container-outer",
				["i;"] = {
					"textsubjects-container-inner",
					desc = "Select inside containers (classes, functions, etc.)",
				},
			},
		},
		highlight = {
			enable = true,
			disable = { "latex" },
			-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
			-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
			-- Using this option may slow down your editor, and you may see some duplicate highlights.
			-- Instead of true it can also be a list of languages
			additional_vim_regex_highlighting = true,
		},
		indent = {
			enable = true,
		},
	}
end
function M.config(_, opts)
	require("nvim-treesitter.configs").setup(opts)
end

return M
