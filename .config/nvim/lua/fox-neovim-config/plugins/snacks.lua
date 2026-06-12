---@type LazyPluginSpec
local M = { 'folke/snacks.nvim', }

M.priority = 1000
M.lazy = false


M.opts = {
    quickfile = { enabled = true },
    input = { enabled = true },
    statuscolumn = {
        enabled = true,
        left = { "mark", "sign" }, -- priority of signs on the left (high to low)
        right = { "fold", "git" }, -- priority of signs on the right (high to low)
        folds = {
            open = true,           -- show open fold icons
            git_hl = true,         -- use Git Signs hl for fold icons
        },
        git = {
            -- patterns to match Git signs
            patterns = { "GitSign", "MiniDiffSign" },
        },
        refresh = 50, -- refresh at most every 50ms
    },
    bigfile = { enabled = true },
    image = { enabled = true },
    scroll = { enabled = true },
    words = { enabled = true },
    bufdelete = { enabled = true },
    indent = {
        priority = 1,
        enabled = true,
        filter = function(buf, win)
            return vim.g.snacks_indent ~= false and vim.b[buf].snacks_indent ~= false and vim.bo[buf].buftype == ""
        end,
        only_scope = true,
        only_current = true,
        hl = {
            "RainbowRed", "RainbowYellow", "RainbowBlue", "RainbowOrange",
            "RainbowGreen", "RainbowViolet", "RainbowCyan"
        },
    },
    animate = {
        enabled = true,
        fps = 120,
        easing = "linear",
        duration = 20,
    },
    scope = {
        enabled = true,
        priority = 200,
        underline = true,
        only_current = false,
        hl = {
            "RainbowRed", "RainbowYellow", "RainbowBlue", "RainbowOrange",
            "RainbowGreen", "RainbowViolet", "RainbowCyan"
        },
    },
    chunk = {
        -- when enabled, scopes will be rendered as chunks, except for the
        -- top-level scope which will be rendered as a scope.
        enabled = true,
        -- only show chunk scopes in the current window
        only_current = false,
        priority = 200,
        hl = {
            "RainbowRed", "RainbowYellow", "RainbowBlue", "RainbowOrange",
            "RainbowGreen", "RainbowViolet", "RainbowCyan"
        },
        char = {
            corner_top = "╭",
            corner_bottom = "╰",
            horizontal = "─",
            vertical = "│",
            arrow = ">",
        },
    },
    notifier = { enabled = false },
    dashboard = {
        enabled = true,
        preset = {
            keys = {
                { icon = "󰍉  ", key = "P", desc = "Browse Projects", action = ":lua Snacks.picker.projects()" },
                { icon = "   ", key = "p", desc = "Plugin Manager", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
            },
            header = [[
╔════════════════════════════════════════════════╗
║             ／＞-- フ               GRZECZNE   ║
║            | 　_　_|  miau.         LISKI...   ║
║          ／` ミ＿xノ                           ║
║        /　 　　 |                              ║
║       /　  ヽ　|                               ║
║       │　　 | ||                               ║
║   ／￣|　　 | ||               MIAU   ╱|、     ║
║  ( ￣ ヽ＿_ヽ_)__)                  (˚ˎ 。7    ║
║   ＼二)                              |、˜ |    ║
║      ...JEDZĄ Z MISKI                じしˍ,)ノ ║
╚════════════════════════════════════════════════╝]]
        },
        formats = {
            footer = { "%s", align = "left" },
            header = { "%s", align = "center" },
            file = function(item, ctx)
                local fname = vim.fn.fnamemodify(item.file, ":~")
                fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
                if #fname > ctx.width then
                    local dir = vim.fn.fnamemodify(fname, ":h")
                    local file = vim.fn.fnamemodify(fname, ":t")
                    if dir and file then
                        file = file:sub(-(ctx.width - #dir - 2))
                        fname = dir .. "/…" .. file
                    end
                end
                local dir, file = fname:match("^(.*)/(.+)$")
                return dir and { { dir .. "/", hl = "dir" }, { file, hl = "file" } } or { { fname, hl = "file" } }
            end,
        },
        sections = {
            { section = "header", pane = 2 },
            { section = "keys", padding = 1, pane = 1 },
            { icon = " ", title = "Recent Projects", section = "projects", indent = 2, limit = 5 },
            { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, limit = 10 },
            { section = "startup", padding = 1 },
            {
                icon = " ",
                desc = "Browse Repo",
                -- padding = 1,
                key = "b",
                action = function()
                    Snacks.gitbrowse()
                end,
            },
            function()
                local in_git = Snacks.git.get_root() ~= nil
                local cmds = {
                    {
                        title = "Branches",
                        cmd = "git branch -la",
                        action = function()
                            Snacks.picker.git_branches()
                        end,
                        key = "B",
                        icon = "󰘬 ",
                        height = 2,
                        pane = 2,
                        enabled = true,
                    },
                    {
                        title = "Local changes",
                        cmd = "git diff --minimal --color",
                        key = "c",
                        action = function()
                            Snacks.picker.git_diff()
                        end,
                        icon = " ",
                        pane = 2,
                        height = 2,
                    },
                    {
                        icon = " ",
                        title = "Open PRs",
                        cmd = "gh pr list -L 3",
                        key = "R",
                        action = function()
                            vim.fn.jobstart("gh pr list --web", { detach = true })
                        end,
                        pane = 2,
                        height = 2,
                    },
                    {
                        icon = " ",
                        pane = 2,
                        title = "Git File Diff",
                        cmd = "git --no-pager diff --stat -B -M -C",
                        height = 2,
                    },
                }
                return vim.tbl_map(function(cmd)
                    return vim.tbl_extend("force", {
                        pane = 2,
                        section = "terminal",
                        enabled = in_git,
                        padding = 0,
                        ttl = 5 * 60,
                        indent = 3,
                    }, cmd)
                end, cmds)
            end,
        },
    },
    picker = {
        enabled = true,
        actions = {
            ---@param picker snacks.Picker
            opencode_send = function(picker)
                local items = vim.tbl_map(function(item) ---@param item snacks.picker.Item
                    return item.file
                        and require("opencode").format({ path = item.file, from = item.pos, to = item.end_pos })
                        or item.text
                end, picker:selected({ fallback = true }))

                require("opencode").prompt(table.concat(items, ", ") .. " ")
            end,
        },
        focus = 'input',
        show_delay = 5000,
        limit_live = 10000,
        layout = {
            cycle = true,
            --- Use the default layout or vertical if the window is too narrow
            preset = function()
                return vim.o.columns >= 120 and "default" or "vertical"
            end,
        },
        matcher = {
            fuzzy = true,          -- use fuzzy matching
            smartcase = true,      -- use smartcase
            ignorecase = true,     -- use ignorecase
            sort_empty = false,    -- sort results when the search string is empty
            filename_bonus = true, -- give bonus for matching file names (last part of the path)
            file_pos = true,       -- support patterns like `file:line:col` and `file:line`
            -- the bonusses below, possibly require string concatenation and path normalization,
            -- so this can have a performance impact for large lists and increase memory usage
            cwd_bonus = true,      -- give bonus for matching files in the cwd
            frecency = true,       -- frecency bonus
            history_bonus = false, -- give more weight to chronological order
        },
        sort = {
            -- default sort is by score, text length and index
            fields = { "score:desc", "#text", "idx" },
        },
        ui_select = true, -- replace `vim.ui.select` with the snacks picker
        formatters = {
            text = {
                ft = nil, ---@type string? filetype for highlighting
            },
            file = {
                filename_first = false, -- display filename before the file path
                --- * left: truncate the beginning of the path
                --- * center: truncate the middle of the path
                --- * right: truncate the end of the path
                ---@type "left"|"center"|"right"
                truncate = "center",
                min_width = 40,        -- minimum length of the truncated path
                filename_only = false, -- only show the filename
                icon_width = 2,        -- width of the icon (in characters)
                git_status_hl = true,  -- use the git status highlight group for the filename
            },
            selected = {
                show_always = false, -- only show the selected column when there are multiple selections
                unselected = true,   -- use the unselected icon for unselected items
            },
            severity = {
                icons = true,  -- show severity icons
                level = false, -- show severity level
                ---@type "left"|"right"
                pos = "left",  -- position of the diagnostics
            },
        },
        previewers = {
            diff = {
                -- fancy: Snacks fancy diff (borders, multi-column line numbers, syntax highlighting)
                -- syntax: Neovim's built-in diff syntax highlighting
                -- terminal: external command (git's pager for git commands, `cmd` for other diffs)
                style = "fancy", ---@type "fancy"|"syntax"|"terminal"
                cmd = { "delta" }, -- example for using `delta` as the external diff command
                ---@type vim.wo?|{} window options for the fancy diff preview window
                wo = {
                    breakindent = true,
                    wrap = true,
                    linebreak = true,
                    showbreak = "",
                },
            },
            git = {
                args = {}, -- additional arguments passed to the git command. Useful to set pager options usin `-c ...`
            },
            file = {
                max_size = 1024 * 1024, -- 1MB
                max_line_length = 500,  -- max line length
                ft = nil, ---@type string? filetype for highlighting. Use `nil` for auto detect
            },
            man_pager = nil, ---@type string? MANPAGER env to use for `man` preview
        },
        jump = {
            jumplist = true,   -- save the current position in the jumplist
            tagstack = false,  -- save the current position in the tagstack
            reuse_win = false, -- reuse an existing window if the buffer is already open
            close = true,      -- close the picker when jumping/editing to a location (defaults to true)
            match = false,     -- jump to the first match position. (useful for `lines`)
        },
        toggles = {
            follow = "f",
            hidden = "h",
            ignored = "i",
            modified = "m",
            regex = { icon = "R", value = false },
        },
        win = {
            -- input window
            input = {
                keys = {
                    -- to close the picker on ESC instead of going to normal mode,
                    -- add the following keymap to your config
                    -- ["<Esc>"] = { "close", mode = { "n", "i" } },
                    ["/"] = "toggle_focus",
                    ["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
                    ["<C-Down>"] = { "history_forward", mode = { "i", "n" } },
                    ["<C-Up>"] = { "history_back", mode = { "i", "n" } },
                    ["<C-c>"] = { "cancel", mode = "i" },
                    ["<C-w>"] = { "<c-s-w>", mode = { "i" }, expr = true, desc = "delete word" },
                    ["<CR>"] = { "confirm", mode = { "n", "i" } },
                    ["<Down>"] = { "list_down", mode = { "i", "n" } },
                    ["<Esc>"] = "cancel",
                    ["<S-CR>"] = { { "pick_win", "jump" }, mode = { "n", "i" } },
                    ["<S-Tab>"] = { "select_and_prev", mode = { "i", "n" } },
                    ["<Tab>"] = { "select_and_next", mode = { "i", "n" } },
                    ["<Up>"] = { "list_up", mode = { "i", "n" } },
                    ["<a-d>"] = { "inspect", mode = { "n", "i" } },
                    ["<a-f>"] = { "toggle_follow", mode = { "i", "n" } },
                    ["<a-h>"] = { "toggle_hidden", mode = { "i", "n" } },
                    ["<a-i>"] = { "toggle_ignored", mode = { "i", "n" } },
                    ["<a-r>"] = { "toggle_regex", mode = { "i", "n" } },
                    ["<a-m>"] = { "toggle_maximize", mode = { "i", "n" } },
                    ["<a-p>"] = { "toggle_preview", mode = { "i", "n" } },
                    ["<a-w>"] = { "cycle_win", mode = { "i", "n" } },
                    ["<c-a>"] = { "select_all", mode = { "n", "i" } },
                    ["<c-b>"] = { "preview_scroll_up", mode = { "i", "n" } },
                    ["<c-d>"] = { "list_scroll_down", mode = { "i", "n" } },
                    ["<c-f>"] = { "preview_scroll_down", mode = { "i", "n" } },
                    ["<c-g>"] = { "toggle_live", mode = { "i", "n" } },
                    ["<c-j>"] = { "list_down", mode = { "i", "n" } },
                    ["<c-k>"] = { "list_up", mode = { "i", "n" } },
                    ["<c-n>"] = { "list_down", mode = { "i", "n" } },
                    ["<c-p>"] = { "list_up", mode = { "i", "n" } },
                    ["<c-q>"] = { "qflist", mode = { "i", "n" } },
                    ["<c-s>"] = { "edit_split", mode = { "i", "n" } },
                    ["<c-t>"] = { "tab", mode = { "n", "i" } },
                    ["<c-u>"] = { "list_scroll_up", mode = { "i", "n" } },
                    ["<c-v>"] = { "edit_vsplit", mode = { "i", "n" } },
                    ["<c-r>#"] = { "insert_alt", mode = "i" },
                    ["<c-r>%"] = { "insert_filename", mode = "i" },
                    ["<c-r><c-a>"] = { "insert_cWORD", mode = "i" },
                    ["<c-r><c-f>"] = { "insert_file", mode = "i" },
                    ["<c-r><c-l>"] = { "insert_line", mode = "i" },
                    ["<c-r><c-p>"] = { "insert_file_full", mode = "i" },
                    ["<c-r><c-w>"] = { "insert_cword", mode = "i" },
                    ["<c-w>H"] = "layout_left",
                    ["<c-w>J"] = "layout_bottom",
                    ["<c-w>K"] = "layout_top",
                    ["<c-w>L"] = "layout_right",
                    ["?"] = "toggle_help_input",
                    ["G"] = "list_bottom",
                    ["gg"] = "list_top",
                    ["j"] = "list_down",
                    ["k"] = "list_up",
                    ["q"] = "cancel",
                },
                b = {
                    minipairs_disable = true,
                },
            },
            list = {
                keys = {
                    ["/"] = "toggle_focus",
                    ["<2-LeftMouse>"] = "confirm",
                    ["<CR>"] = "confirm",
                    ["<Down>"] = "list_down",
                    ["<Esc>"] = "cancel",
                    ["<S-CR>"] = { { "pick_win", "jump" } },
                    ["<S-Tab>"] = { "select_and_prev", mode = { "n", "x" } },
                    ["<Tab>"] = { "select_and_next", mode = { "n", "x" } },
                    ["<Up>"] = "list_up",
                    ["<a-d>"] = "inspect",
                    ["<a-f>"] = "toggle_follow",
                    ["<a-h>"] = "toggle_hidden",
                    ["<a-i>"] = "toggle_ignored",
                    ["<a-m>"] = "toggle_maximize",
                    ["<a-p>"] = "toggle_preview",
                    ["<a-w>"] = "cycle_win",
                    ["<c-a>"] = "select_all",
                    ["<c-b>"] = "preview_scroll_up",
                    ["<c-d>"] = "list_scroll_down",
                    ["<c-f>"] = "preview_scroll_down",
                    ["<c-j>"] = "list_down",
                    ["<c-k>"] = "list_up",
                    ["<c-n>"] = "list_down",
                    ["<c-p>"] = "list_up",
                    ["<c-q>"] = "qflist",
                    ["<c-g>"] = "print_path",
                    ["<c-s>"] = "edit_split",
                    ["<c-t>"] = "tab",
                    ["<c-u>"] = "list_scroll_up",
                    ["<c-v>"] = "edit_vsplit",
                    ["<c-w>H"] = "layout_left",
                    ["<c-w>J"] = "layout_bottom",
                    ["<c-w>K"] = "layout_top",
                    ["<c-w>L"] = "layout_right",
                    ["?"] = "toggle_help_list",
                    ["G"] = "list_bottom",
                    ["gg"] = "list_top",
                    ["i"] = "focus_input",
                    ["j"] = "list_down",
                    ["k"] = "list_up",
                    ["q"] = "cancel",
                    ["zb"] = "list_scroll_bottom",
                    ["zt"] = "list_scroll_top",
                    ["zz"] = "list_scroll_center",
                },
                wo = {
                    conceallevel = 2,
                    concealcursor = "nvc",
                },
            },
            -- preview window
            preview = {
                keys = {
                    ["<Esc>"] = "cancel",
                    ["q"] = "cancel",
                    ["i"] = "focus_input",
                    ["<a-w>"] = "cycle_win",
                },
            },
        },
        icons = {
            files = {
                enabled = true, -- show file icons
                dir = "󰉋 ",
                dir_open = "󰝰 ",
                file = "󰈔 "
            },
            keymaps = {
                nowait = "󰓅 "
            },
            tree = {
                vertical = "│ ",
                middle   = "├╴",
                last     = "└╴",
            },
            undo = {
                saved = " ",
            },
            ui = {
                live       = "󰐰 ",
                hidden     = "h",
                ignored    = "i",
                follow     = "f",
                selected   = "● ",
                unselected = "○ ",
                -- selected = " ",
            },
            git = {
                enabled   = true, -- show git icons
                commit    = "󰜘 ", -- used by git log
                staged    = "●", -- staged changes. always overrides the type icons
                added     = "",
                deleted   = "",
                ignored   = " ",
                modified  = "○",
                renamed   = "",
                unmerged  = " ",
                untracked = "?",
            },
            diagnostics = {
                Error = " ",
                Warn  = " ",
                Hint  = " ",
                Info  = " ",
            },
            lsp = {
                unavailable = "",
                enabled = " ",
                disabled = " ",
                attached = "󰖩 "
            },
            kinds = {
                Array         = " ",
                Boolean       = "󰨙 ",
                Class         = " ",
                Color         = " ",
                Control       = " ",
                Collapsed     = " ",
                Constant      = "󰏿 ",
                Constructor   = " ",
                Copilot       = " ",
                Enum          = " ",
                EnumMember    = " ",
                Event         = " ",
                Field         = " ",
                File          = " ",
                Folder        = " ",
                Function      = "󰊕 ",
                Interface     = " ",
                Key           = " ",
                Keyword       = " ",
                Method        = "󰊕 ",
                Module        = " ",
                Namespace     = "󰦮 ",
                Null          = " ",
                Number        = "󰎠 ",
                Object        = " ",
                Operator      = " ",
                Package       = " ",
                Property      = " ",
                Reference     = " ",
                Snippet       = "󱄽 ",
                String        = " ",
                Struct        = "󰆼 ",
                Text          = " ",
                TypeParameter = " ",
                Unit          = " ",
                Unknown       = " ",
                Value         = " ",
                Variable      = "󰀫 ",
            },
        },
        sources = {
            projects = {
                finder = "recent_projects",
                format = "file",
                dev = { "~/.kotfiles", "~/code", "~/repositories", "~/work/DCAP", "~/Code", "~/.docs" },
                confirm = "load_session",
                patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "package.json", "Makefile" },
                max_depth = 3,
                matcher = {
                    frecency = true,   -- use frecency boosting
                    sort_empty = true, -- sort even when the filter is empty
                    cwd_bonus = true,
                },
                sort = { fields = { "score:desc", "idx" } },

            }
        }
    },
}

-- M.dependencies = { 'Shatur/neovim-session-manager', }
--
function M.init()
    vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
    vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
    vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
    vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
    vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
            -- Setup some globals for debugging (lazy-loaded)
            _G.dd = function(...)
                ---@module 'snacks'
                Snacks.debug.inspect(...)
            end
            _G.bt = function()
                Snacks.debug.backtrace()
            end

            -- Override print to use snacks for `:=` command
            if vim.fn.has("nvim-0.11") == 1 then
                vim._print = function(_, ...)
                    dd(...)
                end
            else
                vim.print = _G.dd
            end

            -- Create some toggle mappings
            Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
            Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
            Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
            Snacks.toggle.diagnostics():map("<leader>ud")
            Snacks.toggle.line_number():map("<leader>ul")
            Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
                :map("<leader>uc")
            Snacks.toggle.treesitter():map("<leader>uT")
            Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map(
                "<leader>ub")
            Snacks.toggle.inlay_hints():map("<leader>uh")
            Snacks.toggle.indent():map("<leader>ug")
            Snacks.toggle.dim():map("<leader>uD")
        end,
    })
end

return M
