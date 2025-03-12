local M = { "coffebar/neovim-project" }

M.dependencies = {
  { "nvim-lua/plenary.nvim" },
  -- optional picker
  -- { "nvim-telescope/telescope.nvim", tag = "0.1.4" },
  -- optional picker
  { "ibhagwan/fzf-lua" },
  { "Shatur/neovim-session-manager" },
}
M.lazy = false
M.priority = 100

function M.opts()
  local projects = {}
  if os.getenv("USER") == "gklodkox" then
    projects = {
      "~/.config/*",
      "~/repositories/*",
      "~/repositories/forks/*",
      "~/work/DCAP/repos/*",
      "~/work/DCAP/*",
    }
  elseif os.getenv("USER") == "fox" then
    projects = {
      "~/.config/*",
      "~/Sources/*",
      "~/Code/**/*",
    }
  else
    projects = { "~/.config/*" }
  end
  return {
    projects = projects,
    datapath = vim.fn.stdpath("data"), -- ~/.local/share/nvim/
    last_session_on_startup = false,
    dashboard_mode = true,
    filetype_autocmd_timeout = 200,
    forget_project_keys = {
      i = "<C-d>",
      n = "d",
    },

    session_manager_opts = {
      autosave_ignore_dirs = {
        vim.fn.expand("~"), -- don't create a session for $HOME/
        "tmp",
        ".cache",
        ".local",
        "doc",
      },
      autosave_ignore_filetypes = {
        -- All buffers of these file types will be closed before the session is saved
        "ccc-ui",
        "gitcommit",
        "gitrebase",
        "qf",
        "toggleterm",
      },
    },
    picker = {
      type = "fzf-lua",
    },
  }
end

function M.config(_, opts)
  vim.opt.sessionoptions:append("globals") -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
  require("neovim-project").setup(opts)
end
return M
