local M = {"ibhagwan/fzf-lua"}

M.dependencies = {"nvim-tree/nvim-web-devicons", "echasnovski/mini.icons"}

M.lazy = false

function M.init()
    vim.api.nvim_create_autocmd("VimResized", {
        pattern = "*",
        command = 'lua require("fzf-lua").redraw()'
    })
end

function M.config(_, opts)
    opts = opts or {}
    local fzf = require("fzf-lua")

    fzf.setup({
        help_open_win = vim.api.nvim_open_win,
        previewers = {
            cat = {cmd = "cat", args = "-n"},
            bat = {cmd = "bat", args = "--color=always --style=numbers,changes"},
            head = {cmd = "head", args = nil},
            git_diff = {
                cmd_deleted = "git diff --color HEAD --",
                cmd_modified = "git diff --color HEAD",
                cmd_untracked = "git diff --color --no-index /dev/null"
            },
            man = {
                -- NOTE: remove the `-c` flag when using man-db
                -- replace with `man -P cat %s | col -bx` on OSX
                cmd = "man %s | col -bx"
            },
            builtin = {
                syntax = true, -- preview syntax highlight?
                syntax_limit_l = 0, -- syntax limit (lines), 0=nolimit
                syntax_limit_b = 1024 * 1024, -- syntax limit (bytes), 0=nolimit
                limit_b = 1024 * 1024 * 10, -- preview limit (bytes), 0=nolimit
                toggle_behavior = "default",
                extensions = {
                    ["png"] = {"viu", "-b"},
                    ["svg"] = {"chafa", "{file}"},
                    ["jpg"] = {"ueberzug"}
                },
                ueberzug_scaler = "cover",
                render_markdown = {
                    enabled = true,
                    filetypes = {["markdown"] = true}
                }
            }
        },
        fzf_colors = false,
        fzf_tmux_opts = {["-p"] = "80%,80%", ["--margin"] = "0,0"},
        -- defaults = { formatter = "path" },
        winopts = {
            height = 0.85,
            width = 0.80,
            col = 0.50,
            row = 0.50,
            backdrop = 10,
            border = "rounded",
            preview = {
                default = "bat", -- override the default previewer?
                -- default uses the 'builtin' previewer
                border = "rounded", -- preview border: accepts both `nvim_open_win`
                -- and fzf values (e.g. "border-top", "none")
                -- native fzf previewers (bat/cat/git/etc)
                -- can also be set to `fun(winopts, metadata)`
                scrollbar = false,
                title = true,
                title_pos = "center",
                wrap = false, -- preview line wrap (fzf's 'wrap|nowrap')
                hidden = false, -- start preview hidden
                vertical = "down:65%", -- up|down:size
                horizontal = "right:60%", -- right|left:size
                layout = "flex", -- horizontal|vertical|flex
                flip_columns = 100, -- #cols to switch to horizontal on flex
                winopts = { -- builtin previewer window options
                    number = true,
                    relativenumber = false,
                    cursorline = true,
                    cursorlineopt = "both",
                    cursorcolumn = false,
                    signcolumn = "no",
                    list = false,
                    foldenable = true,
                    foldmethod = "manual"
                }
            }
        },
        files = {
            previewer = "bat",
            prompt = "Files> ",
            file_ignore_patterns = {".*/readme.*", "%.*/doc.*", ".*/.local/.*"},
            actions = {
                ["alt-i"] = {require("fzf-lua").toggle_ignore},
                ["alt-h"] = {require("fzf-lua").toggle_hidden}
            }
        },
        grep = {
            git_icons = true,
            actions = {
                ["alt-i"] = {require("fzf-lua").toggle_ignore},
                ["alt-h"] = {require("fzf-lua").toggle_hidden}
            },
            lsp = {
                symbols = {
                    symbol_hl = function(s)
                        return "TroubleIcon" .. s
                    end,
                    symbol_fmt = function(s)
                        return s:lower() .. "\t"
                    end,
                    child_prefix = false
                },
                code_actions = {
                    previewer = vim.fn.executable("delta") == 1 and
                        "codeaction_native" or nil
                }
            }
        }
    })
    fzf.register_ui_select()
end

return M
