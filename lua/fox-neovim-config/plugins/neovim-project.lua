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
    -- Path to store history and sessions
    datapath = vim.fn.stdpath("data"), -- ~/.local/share/nvim/
    -- Load the most recent session on startup if not in the project directory
    last_session_on_startup = false,
    -- Dashboard mode prevent session autoload on startup
    dashboard_mode = true,
    -- Timeout in milliseconds before trigger FileType autocmd after session load
    -- to make sure lsp servers are attached to the current buffer.
    -- Set to 0 to disable triggering FileType autocmd
    filetype_autocmd_timeout = 200,
    -- Keymap to delete project from history in Telescope picker
    forget_project_keys = {
      -- insert mode: Ctrl+d
      i = "<C-d>",
      -- normal mode: d
      n = "d",
    },

    -- Overwrite some of Session Manager options
    session_manager_opts = {
      autosave_ignore_dirs = {
        vim.fn.expand("~"), -- don't create a session for $HOME/
        "/tmp",
        "/.cache",
        "/.local",
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
  local nproject = require("neovim-project")
  vim.opt.sessionoptions:append("globals") -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
  nproject.setup(opts)
  nproject.register_ui_select()
end
return M
