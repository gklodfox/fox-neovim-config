local M = {"nvimdev/dashboard-nvim"}

M.event = "VimEnter"

function M.opts()
    local ascii_art = {
        "╔════════════════════════════════════╗",
        "║             ／＞-- フ              ║",
        "║            | 　_　_|  miau.        ║",
        "║          ／` ミ＿xノ               ║",
        "║        /　 　　 |                  ║",
        "║       /　  ヽ　|                   ║",
        "║       │　　 | ||   MIAU   ╱|、     ║",
        "║   ／￣|　　 | ||        (˚ˎ 。7    ║",
        "║  ( ￣ ヽ＿_ヽ_)__)       |、˜ |    ║",
        "║   ＼二)                  じしˍ,)ノ ║",
        "╚════════════════════════════════════╝"
    }
    return {
        theme = "hyper",
        disable_move = true,
        hide = {"statusline", "tabline", "winbar"},
        config = {
            packages = {enable = true}, -- show how many plugins neovim loaded
            -- limit how many projects list, action when you press key or enter it will run this action.
            -- action can be a function type, e.g.
            project = {
                enable = true,
                limit = 12,
                icon = "your icon",
                label = "",
                action = "FzfLua files cwd="
            },
            mru = {
                enable = true,
                limit = 15,
                icon = "your icon",
                label = "",
                action = "FzfLua oldfiles",
                cwd_only = false
            },
            footer = {}, -- footer
            header = ascii_art,
            shortcut = {
                {
                    desc = "Plugins",
                    group = "@property",
                    action = "Lazy",
                    key = "p"
                },
                {
                    desc = " Files",
                    group = "Label",
                    action = "FzfLua files",
                    key = "F"
                }, {
                    desc = " File history",
                    group = "Label",
                    action = "FzfLua oldfiles",
                    key = "H"
                },
                {
                    desc = " Grep",
                    group = "Label",
                    action = "FzfLua live_grep",
                    key = "g"
                }, {
                    desc = " Git files",
                    group = "Label",
                    action = "FzfLua git_files",
                    key = "G"
                }, {
                    desc = " Projects",
                    group = "Label",
                    action = "NeovimProjectDiscover",
                    key = "P"
                }
            }
        }
    }
end

return M
