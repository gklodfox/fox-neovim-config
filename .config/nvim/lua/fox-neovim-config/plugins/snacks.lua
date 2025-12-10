local M = { 'folke/snacks.nvim' }

-- M.dependencies = { 'Shatur/neovim-session-manager', }
--
M.priority = 1000
M.event = 'VimEnter'
M.lazy = false

function M.init()
    vim.g.snacks_indent = true
    vim.api.nvim_create_autocmd({ "VimEnter" }, {
        pattern = "*",
        callback = function()
            local curr_dir = vim.fn.expand('%:p')
            local directory = vim.fn.isdirectory(curr_dir) == 1
            if not directory then
                return
            end
            vim.cmd.enew()
            vim.notify(Snacks.git.get_root())
            vim.cmd.bw(curr_dir)
            if Snacks.git.get_root(curr_dir) then
                Snacks.explorer.open()
            end
            Snacks.dashboard()
        end
    })
    vim.api.nvim_set_hl(0, "RainbowRed", {fg = "#E06C75"})
    vim.api.nvim_set_hl(0, "RainbowYellow", {fg = "#E5C07B"})
    vim.api.nvim_set_hl(0, "RainbowBlue", {fg = "#61AFEF"})
    vim.api.nvim_set_hl(0, "RainbowOrange", {fg = "#D19A66"})
    vim.api.nvim_set_hl(0, "RainbowGreen", {fg = "#98C379"})
    vim.api.nvim_set_hl(0, "RainbowViolet", {fg = "#C678DD"})
    vim.api.nvim_set_hl(0, "RainbowCyan", {fg = "#56B6C2"})
end

function M.opts()
    return {
        statuscolumn = {
            left = { "mark", "sign" }, -- priority of signs on the left (high to low)
            right = { "fold", "git" }, -- priority of signs on the right (high to low)
            folds = {
                open = false,          -- show open fold icons
                git_hl = false,        -- use Git Signs hl for fold icons
            },
            git = {
                -- patterns to match Git signs
                patterns = { "GitSign", "MiniDiffSign" },
            },
            refresh = 50, -- refresh at most every 50ms
        },
        image = { enabled = true },
        scroll = { enabled = true },
        words = { enabled = true },
        bufdelete = { enabled = true },
        indent = {
            enabled = true,
            filter = function(buf, win)
                return vim.g.snacks_indent ~= false and vim.b[buf].snacks_indent ~= false and vim.bo[buf].buftype == ""
            end,
            priority = 100,
            only_scope = false,
            only_current = false,
            hl = {
                "RainbowDelimiterRed", "RainbowDelimiterYellow", "RainbowDelimiterBlue", "RainbowDelimiterOrange",
                "RainbowDelimiterGreen", "RainbowDelimiterViolet", "RainbowDelimiterCyan"
            },
        },
        animate = {
            enabled = true,
            style = "out",
            easing = "linear",
            duration = {
                step = 20,       -- ms per step
                total = 300,     -- maximum duration
            },
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
                    { icon = "󰍉  ", key = "f", desc = "Find File", action = ":lua Snacks.picker.files()" },
                    { icon = "󰍉  ", key = "G", desc = "Find Git file", action = ":lua Snacks.picker.git_files()" },
                    { icon = "  ", key = "n", desc = "New File", action = ":ene | startinsert" },
                    { icon = "󰍉  ", key = "g", desc = "Grep Text", action = ":lua Snacks.picker.grep()" },
                    { icon = "󰍉  ", key = "r", desc = "Recent Files", action = ":lua Snacks.picker.recent()" },
                    { icon = "󰍉  ", key = "C", desc = "Browse Config", action = ":lua Snacks.picker.files({cwd = vim.fn.stdpath('config')})" },
                    { icon = "󰍉  ", key = "P", desc = "Browse Projects", action = ":lua Snacks.picker.projects()" },
                    { icon = "   ", key = "p", desc = "Plugin Manager", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
                    { icon = "󰱮   ", key = "q", desc = "Quit", action = ":qa" },
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
                { section = "keys", padding = 1, pane = 2 },
                { icon = " ", title = "Recent Projects", section = "projects", indent = 2 },
                { icon = " ", title = "Recent Files", section = "recent_files", indent = 2 },
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
                            height = 2,
                        },
                        {
                            icon = " ",
                            title = "Git File Diff",
                            cmd = "git --no-pager diff --stat -B -M -C",
                            height = 2,
                        },
                    }
                    return vim.tbl_map(function(cmd)
                        return vim.tbl_extend("force", {
                            pane = 1,
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
            sources = {
                projects = {
                    finder = "recent_projects",
                    format = "file",
                    dev = { "~/.kotfiles", "~/code",
                        "~/repositories",
                        "~/work/DCAP"
                    },
                    confirm = "load_session",
                    patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "package.json", "Makefile" },
                    recent = false,
                    max_depth = 4,
                    matcher = {
                        frecency = true,   -- use frecency boosting
                        sort_empty = true, -- sort even when the filter is empty
                        cwd_bonus = false,
                    },
                    sort = { fields = { "score:desc", "idx" } },
                    win = {
                        preview = { minimal = true },
                        input = {
                            keys = {
                                -- every action will always first change the cwd of the current tabpage to the project
                                ["<c-e>"] = { { "tcd", "picker_explorer" }, mode = { "n", "i" } },
                                ["<c-f>"] = { { "tcd", "picker_files" }, mode = { "n", "i" } },
                                ["<c-g>"] = { { "tcd", "picker_grep" }, mode = { "n", "i" } },
                                ["<c-r>"] = { { "tcd", "picker_recent" }, mode = { "n", "i" } },
                                ["<c-w>"] = { { "tcd" }, mode = { "n", "i" } },
                                ["<c-t>"] = {
                                    function(picker)
                                        vim.cmd("tabnew")
                                        Snacks.notify("New tab opened")
                                        picker:close()
                                        Snacks.picker.projects()
                                    end,
                                    mode = { "n", "i" },
                                },
                            },
                        },
                    },

                }
            }
        },
    }
end

function M.config(_, opts)
    require('snacks').setup(opts)
end

return M
