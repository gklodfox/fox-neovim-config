local M = {"nvimdev/dashboard-nvim"}

M.event = "VimEnter"
M.dependencies = {'nvim-tree/nvim-web-devicons', {'Shatur/neovim-session-manager', opts = {},dependencies = {"nvim-lua/plenary.nvim", { "stevearc/dressing.nvim", opts = {} }}}}

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
    local repo_dirs = { "~/.kotfiles", "~/code" }
    return {
        theme = "hyper",
        disable_move = true,
        hide = {"statusline", "tabline", "winbar"},
	shortcut_type = "number",
	change_to_vcs_root = true,
        config = {
            packages = {enable = true}, -- show how many plugins neovim loaded
            -- limit how many projects list, action when you press key or enter it will run this action.
            -- action can be a function type, e.g.
            project = {
                enable = true,
                limit = 3,
                icon = "  ",
                label = "Recent projects",
                action = function ()
			local opts = {
				dev = repo_dirs,
			}
			vim.cmd("tabnew")
			Snacks.picker.projects({dev = repo_dirs}) 
		end
            },
            mru = {
                enable = true,
                limit = 7,
                icon = "  ",
                label = "Recent files",
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
                    action = "Snacks.picker.projects()",
                    key = "P"
                }
            }
        }
    }
end

function M.config(_, opts)
	require('dashboard').setup(opts)	
end

return M
