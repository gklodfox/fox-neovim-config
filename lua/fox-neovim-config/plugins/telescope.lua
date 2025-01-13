local M = { "nvim-telescope/telescope.nvim" }

M.branch = "0.1.x"
M.cmd = "Telescope"
M.event = "VimEnter"

M.dependencies = {
  "nvim-treesitter/nvim-treesitter",
  "nvim-telescope/telescope-file-browser.nvim",
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  -- { "HPRIOR/telescope-gpt", dependencies = {"nvim-telescope/telescope.nvim", "jackMort/ChatGPT.nvim"} },
  "nvim-telescope/telescope-project.nvim",
  "nvim-telescope/telescope-live-grep-args.nvim",
  "nvim-telescope/telescope-frecency.nvim",
  "nvim-telescope/telescope-dap.nvim",
  "debugloop/telescope-undo.nvim",
}

function M.opts()
  local project_actions = require("telescope._extensions.project.actions")
  return {
    prompt_prefix = "   ",
    selection_caret = " ",
    entry_prefix = " ",
    sorting_strategy = "ascending",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
      },
      width = 0.87,
      height = 0.80,
    },
    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case",
      },
      project = {
        base_dirs = {
          '~/Dotfiles',
          '~/Code',
        },
        hidden_files = false, -- default: false
        theme = "dropdown",
        order_by = "asc",
        search_by = "title",
        sync_with_nvim_tree = true, -- default false
        -- default for on_project_selected = find project files
        mappings = {
          n = {
            ['d'] = project_actions.delete_project,
            ['r'] = project_actions.rename_project,
            ['c'] = project_actions.add_project,
            ['C'] = project_actions.add_project_cwd,
            ['f'] = project_actions.find_project_files,
            ['b'] = project_actions.browse_project_files,
            ['s'] = project_actions.search_in_project_files,
            ['R'] = project_actions.recent_project_files,
            ['w'] = project_actions.change_working_directory,
            ['o'] = project_actions.next_cd_scope,
          },
          i = {
            ['<c-d>'] = project_actions.delete_project,
            ['<c-v>'] = project_actions.rename_project,
            ['<c-a>'] = project_actions.add_project,
            ['<c-A>'] = project_actions.add_project_cwd,
            ['<c-f>'] = project_actions.find_project_files,
            ['<c-b>'] = project_actions.browse_project_files,
            ['<c-s>'] = project_actions.search_in_project_files,
            ['<c-r>'] = project_actions.recent_project_files,
            ['<c-l>'] = project_actions.change_working_directory,
            ['<c-o>'] = project_actions.next_cd_scope,
            ['<c-w>'] = project_actions.change_workspace,
          }
        },
      },
      frecency = {
        db_root = vim.fn.stdpath("state"),
        ignore_patterns = { "*.git/*", "*/tmp/*", "*/node_modules/*", "term://*" },
      },
      -- gpt = {
      --   title = "Gpt Actions",
      --   commands = {
      --     "add_tests",
      --     "chat",
      --     "docstring",
      --     "explain_code",
      --     "fix_bugs",
      --     "grammar_correction",
      --     "interactive",
      --     "optimize_code",
      --     "summarize",
      --     "translate"
      --   },
      --   theme = require("telescope.themes").get_dropdown{}
      -- },
    },
  }
end

function M.init()
  vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files, { desc = "Find files" })
  vim.keymap.set("n", "<leader>fg",  require("telescope").extensions.live_grep_args.live_grep_args, { desc = "Grep files" } )
  vim.keymap.set("n", "<leader>fb", require("telescope.builtin").buffers, { desc = "Search buffers" })
  vim.keymap.set("n", "<leader>fh", require("telescope.builtin").help_tags, { desc = "Search help tags" })
end

function M.config(_, opts)
  local telescope = require("telescope")

  telescope.load_extension("frecency")
  telescope.load_extension("project")
  telescope.load_extension("live_grep_args")
  telescope.load_extension("dap")
  telescope.load_extension("fzf")
  telescope.setup(opts)
end

return M
