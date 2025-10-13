local M = { 'folke/snacks.nvim' }

M.dependencies = { {
    'Shatur/neovim-session-manager',
    config = function() require('session_manager').setup({}) end
} }

M.priority = 1000
function M.opts()
    ---@type snacks.Config
    return {
        bigfile = { enabled = true },
        image = { enabled = true },
        scope = {
            enabled = true,
            priority = 200,
            underline = true,
            only_current = true,
            hl = {
                "RainbowRed", "RainbowYellow", "RainbowBlue", "RainbowOrange",
                "RainbowGreen", "RainbowViolet", "RainbowCyan"
            },
        },
        indent = {
            enabled = true,
            only_scope = true,
            only_current = true,
            scope = {
                enabled = true,
                priority = 200,
                underline = true,
                only_current = true,
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
                only_current = true,
                priority = 200,
                hl = {
                    "RainbowRed", "RainbowYellow", "RainbowBlue", "RainbowOrange",
                    "RainbowGreen", "RainbowViolet", "RainbowCyan"
                    -- "RainbowRed", "RainbowYellow", "RainbowBlue", "RainbowOrange",
                    -- "RainbowGreen", "RainbowViolet", "RainbowCyan"
                },
                char = {
                    corner_top = "┌",
                    corner_bottom = "└",
                    -- corner_top = "╭",
                    -- corner_bottom = "╰",
                    horizontal = "─",
                    vertical = "│",
                    arrow = ">",
                },
            },
            hl = {
                "RainbowRed", "RainbowYellow", "RainbowBlue", "RainbowOrange",
                "RainbowGreen", "RainbowViolet", "RainbowCyan"
                -- "RainbowRed", "RainbowYellow", "RainbowBlue", "RainbowOrange",
                -- "RainbowGreen", "RainbowViolet", "RainbowCyan"
            },
        },
        dim = { enabled = false },
        input = { enabled = true },
        notifier = { enabled = false },
        explorer = { enabled = true },
        dashboard = {
            enabled = true,
            preset = {
                ---@type fun(cmd:string, opts:table)|nil
                pick = nil,
                ---@type snacks.dashboard.Item[]
                keys = {
                    { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
                    { icon = " ", key = "G", desc = "Find Git file", action = ":lua Snacks.dashboard.pick('oldfiles')" },
                    { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                    { icon = " ", key = "g", desc = "Grep Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
                    { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
                    { icon = " ", key = "c", desc = "Browse Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
                    { icon = " ", key = "P", desc = "Browse Prcjects", action = ":lua Snacks.picker.projects()" },
                    { icon = "󰒲 ", key = "p", desc = "Plugin Manager", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
                    { icon = " ", key = "q", desc = "Quit", action = ":qa" },
                },
                header = [[
╔════════════════════════════════════════════════════════════╗
║                    ／＞-- フ               GRZECZNE        ║
║                   | 　_　_|  miau.         LISKI...        ║
║                 ／` ミ＿xノ                                ║
║               /　 　　 |                                   ║
║              /　  ヽ　|                                    ║
║              │　　 | ||                                    ║
║          ／￣|　　 | ||               MIAU   ╱|、          ║
║         ( ￣ ヽ＿_ヽ_)__)                  (˚ˎ 。7         ║
║          ＼二)                              |、˜ |         ║
║             ...JEDZĄ Z MISKI                じしˍ,)ノ      ║
╚════════════════════════════════════════════════════════════╝]]
            },
            formats = {
                footer = { "%s", align = "left" },
                header = { "%s", align = "left" },
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
                { section = "header" },
                {
                    pane = 2,
                    icon = " ",
                    desc = "Browse Repo",
                    padding = 1,
                    key = "b",
                    action = function()
                        Snacks.gitbrowse()
                    end,
                },
                function()
                    local in_git = Snacks.git.get_root() ~= nil
                    local cmds = {
                        {
                            title = "Notifications\n",
                            cmd = "gh notify -s -a -n5",
                            action = function()
                                vim.ui.open("https://github.com/notifications")
                            end,
                            key = "n",
                            icon = " ",
                            height = 5,
                            enabled = true,
                        },
                        {
                            title = "Open Issues\n",
                            cmd = "gh issue list -L 3",
                            key = "i",
                            action = function()
                                vim.fn.jobstart("gh issue list --web", { detach = true })
                            end,
                            icon = " ",
                            height = 7,
                        },
                        {
                            icon = " ",
                            title = "Open PRs\n",
                            cmd = "gh pr list -L 3",
                            key = "P",
                            action = function()
                                vim.fn.jobstart("gh pr list --web", { detach = true })
                            end,
                            height = 7,
                        },
                        {
                            icon = " ",
                            title = "Git Status\n",
                            cmd = "git --no-pager diff --stat -B -M -C",
                            height = 10,
                        },
                    }
                    return vim.tbl_map(function(cmd)
                        return vim.tbl_extend("force", {
                            pane = 2,
                            section = "terminal",
                            enabled = in_git,
                            padding = 1,
                            ttl = 5 * 60,
                            indent = 3,
                        }, cmd)
                    end, cmds)
                end,
                { section = "keys", padding = 1 },
                { icon = " ", title = "Recent Files", section = "recent_files", indent = 2 },
                { icon = " ", title = "Recent Projects", section = "projects", indent = 2 },
                { section = "startup", padding = { 0, 1 } },
            },
        },
        picker = {
            actions = {
                trouble_open = function(...)
                    return require("trouble.sources.snacks").actions.trouble_open.action(...)
                end,
                ---@param p snacks.Picker
                toggle_cwd = function(p)
                    local root = Snacks.picker.pick({ source = "files", buf = p.input.filter.current_buf, normalize = true })
                    local cwd = vim.fs.normalize((vim.uv or vim.loop).cwd() or ".")
                    local current = p:cwd()
                    p:set_cwd(current == root and cwd or root)
                    p:find()
                end,
            },
            win = {
                input = {
                    keys = {
                        ["<a-c>"] = {
                            "toggle_cwd",
                            mode = { "n", "i" },
                        },
                    },
                },
            },
            sources = {
                projects = {
                    dev = { "~/.kotfiles", "~/code" },
                }
            }
        },

        quickfile = { enabled = true },
        scroll = { enabled = true },
        statuscolumn = { enabled = true },
        words = { enabled = true },
    }
end

function M.config(_, opts)
    require('snacks').setup(opts)
end

return M
