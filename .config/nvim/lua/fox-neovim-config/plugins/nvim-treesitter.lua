local M = { "nvim-treesitter/nvim-treesitter" }

M.dependencies = {
	"windwp/nvim-ts-autotag",
	"nvim-treesitter/nvim-treesitter-textobjects",
	"RRethy/nvim-treesitter-textsubjects",
    "LiadOz/nvim-dap-repl-highlights",
}

M.cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" }
M.keys = {
	{ "<c-space>", desc = "Increment Selection" },
	{ "<bs>", desc = "Decrement Selection", mode = "x" },
}
M.opts_extend = { "ensure_installed" }
M.build = ":TSUpdateSync"
M.lazy = false

-- function M.init()
-- 	vim.opt.foldmethod = "expr"
-- 	vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- 	vim.o.foldlevel = 2
-- end

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
			enable = true,
			move = {
				enable = true,
				set_jumps = true, -- whether to set jumps in the jumplist
				goto_next_start = {
					["]f"] = { query = "@call.outer", desc = "Next function def start" },
					["]m"] = { query = "@function.outer", desc = "Next method/function def start" },
					["]c"] = { query = "@class.outer", desc = "Next class def start" },
					["]i"] = { query = "@conditional.outer", desc = "Next conditional start" },
					["]l"] = { query = "@loop.outer", desc = "Next loop start" },
					["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
					["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
				},
				goto_next_end = {
					["]F"] = { query = "@call.outer", desc = "Next function def end" },
					["]M"] = { query = "@function.outer", desc = "Next method/function def end" },
					["]C"] = { query = "@class.outer", desc = "Next class def start" },
					["]I"] = { query = "@conditional.outer", desc = "Next conditional end" },
					["]L"] = { query = "@loop.outer", desc = "Next loop end" },
				},
				goto_previous_start = {
					["[f"] = { query = "@call.outer", desc = "Previous function def start" },
					["[m"] = { query = "@function.outer", desc = "Previous method/function def start" },
					["[c"] = { query = "@class.outer", desc = "Previous class def start" },
					["[i"] = { query = "@conditional.outer", desc = "Previous conditional start" },
					["[l"] = { query = "@loop.outer", desc = "Previous loop start" },
					["[s"] = { query = "@scope", query_group = "locals", desc = "Previous scope" },
					["[z"] = { query = "@fold", query_group = "folds", desc = "Previous fold" },
				},
				goto_previous_end = {
					["]F"] = { query = "@call.outer", desc = "Previous function def end" },
					["]M"] = { query = "@function.outer", desc = "Previous method/function def end" },
					["]C"] = { query = "@class.outer", desc = "Previous class def start" },
					["]I"] = { query = "@conditional.outer", desc = "Previous conditional end" },
					["]L"] = { query = "@loop.outer", desc = "Previous loop end" },
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
				swap_next = {
					["<leader>na"] = "@parameter.inner",
					["<leader>nm"] = "@function.outer",
				},
				swap_previous = {
					["<leader>pa"] = "@parameter.inner",
					["<leader>pm"] = "@function.outer",
				},
			},
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					["<leader>va"] = {
						query = "@assignment.inner",
						desc = "Select inner part of an assignment",
					},
					["<leader>vA"] = {
						query = "@assignment.outer",
						desc = "Select outer part of an assignment",
					},
					["<leader>vl"] = {
						query = "@assignment.lhs",
						desc = "Select left hand side of an assignment",
					},
					["<leader>vr"] = {
						query = "@assignment.rhs",
						desc = "Select right hand side of an assignment",
					},
					["<leader>vP"] = {
						query = "@parameter.outer",
						desc = "Select outer part of a parameter/argument",
					},
					["<leader>vp"] = {
						query = "@parameter.inner",
						desc = "Select inner part of a parameter/argument",
					},
					["<leader>vI"] = {
						query = "@conditional.outer",
						desc = "Select outer part of a conditional",
					},
					["<leader>vi"] = {
						query = "@conditional.inner",
						desc = "Select inner part of a conditional",
					},
					["<leader>vL"] = {
						query = "@loop.outer",
						desc = "Select outer part of a loop",
					},
					["<leader>vl"] = {
						query = "@loop.inner",
						desc = "Select inner part of a loop",
					},
					["<leader>vF"] = {
						query = "@call.outer",
						desc = "Select outer part of a function/method call",
					},
					["<leader>vf"] = {
						query = "@call.inner",
						desc = "Select inner part of a function/method call",
					},
					["<leader>vM"] = {
						query = "@function.outer",
						desc = "Select outer part of a function call",
					},
					["<leader>vm"] = {
						query = "@function.inner",
						desc = "Select inner part of a function call",
					},
					["<leader>vC"] = {
						query = "@class.outer",
						desc = "Select outer part of a class region",
					},
					["<leader>vc"] = {
						query = "@class.inner",
						desc = "Select inner part of a class region",
					},
				},
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
function M.config(Plugin, opts)
    require("nvim-dap-repl-highlights").setup()
	require("lazy.core.loader").add_to_rtp(Plugin)
	require("nvim-treesitter.query_predicates")
	require("nvim-treesitter.configs").setup(opts)
end

return M
