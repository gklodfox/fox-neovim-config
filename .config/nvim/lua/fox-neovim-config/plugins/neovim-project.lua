local M = {"coffebar/neovim-project"}

M.lazy = false
M.priority = 100

M.dependencies = {
    {"nvim-lua/plenary.nvim"},
    {"ibhagwan/fzf-lua"}, {"Shatur/neovim-session-manager"}
}

function M.opts()
    local projects = {}
    if os.getenv("USER") == "gklodkox" then
        projects = {
            "~/.kotfiles/*",
            "~/repositories/*",
            "~/repositories/forks/*",
            "~/work/DCAP/repos/*",
            "~/work/DCAP/repos/new_ci/*",
            "~/work/DCAP/*",
            "~/work/DCAP/code/**/*",
            "~/work/DCAP/docs/**/*",
            "~/work/DCAP/dockerfiles/**/*",
        }
    elseif os.getenv("USER") == "fox" then
        projects = {
            "~/.kotfiles/*", "~/code/*/*", "~/.kotfiles/*/.config/*",
        }
    else
        projects = {}
    end
    return {
        projects = projects,
        datapath = vim.fn.stdpath("data"), -- ~/.local/share/nvim/
        last_session_on_startup = false,
        dashboard_mode = true,
        filetype_autocmd_timeout = 200,
        forget_project_keys = {i = "<C-d>", n = "d"},

        session_manager_opts = {
            autosave_ignore_dirs = {
                vim.fn.expand("~"), -- don't create a session for $HOME/
                "/tmp", "/build", "/.cache", "/.local", "/doc"
            },
            autosave_ignore_filetypes = {
                -- All buffers of these file types will be closed before the session is saved
                "ccc-ui", "gitcommit", "gitrebase", "qf", "toggleterm", "lua"
            }
        },
        picker = {
            -- type = "fzf-lua",
            -- preview = {
            --     enabled = true,
            --     git_status = true,
            --     git_fetch = true,
            --     show_hidden = true
            -- }
        }
    }
end

function M.config(_, opts)
	require('neovim-project').setup(opts)
end

return M
