local M = {"nvim-treesitter/nvim-treesitter"}

M.dependencies = {
    "windwp/nvim-ts-autotag", "nvim-treesitter/nvim-treesitter-textobjects",
    "RRethy/nvim-treesitter-textsubjects", "LiadOz/nvim-dap-repl-highlights"
}
function M.build()
    require("nvim-treesitter.install").update({with_sync = true})()
end

function M.opts()
    return {
        ensure_installed = {
            "vimdoc", "c", "lua", "luadoc", "luap", "printf", "regex", "toml",
            "xml", "rust", "jsonc", "bash", "vim", "query", "markdown",
            "groovy", "markdown_inline", "python", "cpp", "fish",
            "json", "yaml", "gitignore", "bash", "diff", "html"

        }
    }
end
function M.config(_, opts)
    local configs = require("nvim-treesitter.configs")
    configs.setup({
        ensure_installed = opts.ensure_installed,
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<C-S-space>",
                node_incremental = "<C-S-Space>",
                scope_incremental = false,
                node_decremental = "<S-bs>"
            }
        },
        context_commentstring = {enable = true, enable_autocmd = true},
        textobjects = {
            move = {
                enable = true,
                set_jumps = true, -- whether to set jumps in the jumplist
                goto_next_start = {
                    ["]m"] = "@function.outer",
                    ["]]"] = "@class.outer"
                },
                goto_next_end = {
                    ["]M"] = "@function.outer",
                    ["]["] = "@class.outer"
                },
                goto_previous_start = {
                    ["[m"] = "@function.outer",
                    ["[["] = "@class.outer"
                },
                goto_previous_end = {
                    ["[M"] = "@function.outer",
                    ["[]"] = "@class.outer"
                }
            },
            lsp_interop = {
                enable = true,
                border = "none",
                floating_preview_opts = {},
                peek_definition_code = {
                    ["<leader>df"] = "@function.outer",
                    ["<leader>dF"] = "@class.outer"
                }
            },
            swap = {
                enable = true,
                swap_next = {["<leader>a"] = "@parameter.inner"},
                swap_previous = {["<leader>A"] = "@parameter.inner"}
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
                        desc = "Select inner part of a class region"
                    }
                },
                -- You can choose the select mode (default is charwise 'v')
                selection_modes = {
                    ['@parameter.outer'] = 'v', -- charwise
                    ['@function.outer'] = 'V', -- linewise
                    ['@class.outer'] = '<c-v>' -- blockwise
                },

                include_surrounding_whitespace = true
            }
        },
        textsubjects = {
            enable = true,
            prev_selection = ',',
            keymaps = {
                ['.'] = 'textsubjects-smart',
                [';'] = 'textsubjects-container-outer',
                ['i;'] = {
                    'textsubjects-container-inner',
                    desc = "Select inside containers (classes, functions, etc.)"
                }
            }
        }
    })
end

return M
