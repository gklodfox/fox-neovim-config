local M = { "nvim-telescope/telescope.nvim" }

M.cmd = "Telescope"
M.enabled = false
-- M.event = "VimEnter"

M.dependencies = {
  "nvim-lua/plenary.nvim",
  { "andrew-george/telescope-themes" },
  "nvim-treesitter/nvim-treesitter",
  "jonarrien/telescope-cmdline.nvim",
  "nvim-telescope/telescope-live-grep-args.nvim",
  "nvim-telescope/telescope-file-browser.nvim",
  "nvim-telescope/telescope-ui-select.nvim",
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
  },
  "MunifTanjim/nui.nvim",
  -- {"HPRIOR/telescope-gpt", dependencies = {"jackMort/ChatGPT.nvim"}},
  -- "nvim-telescope/telescope-project.nvim",
  "aaditeynair/conduct.nvim",
  "nvim-telescope/telescope-frecency.nvim",
  "smilovanovic/telescope-search-dir-picker.nvim",
  "nvim-telescope/telescope-dap.nvim",
  "debugloop/telescope-undo.nvim",
  { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
}

function M.opts()
  local actions = require("telescope.actions")
  -- local project_actions = require("telescope._extensions.project.actions")
  local lga_actions = require("telescope-live-grep-args.actions")
  return {
    pickers = {
      find_files = {
        find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
        mappings = {
          n = {
            ["cd"] = function(prompt_bufnr)
              local selection = require("telescope.actions.state").get_selected_entry()
              local dir = vim.fn.fnamemodify(selection.path, ":p:h")
              require("telescope.actions").close(prompt_bufnr)
              -- Depending on what you want put `cd`, `lcd`, `tcd`
              vim.cmd(string.format("silent lcd %s", dir))
            end,
          },
        },
      },
      buffers = {
        mappings = {
          i = {
            ["<c-d>"] = actions.delete_buffer + actions.move_to_top,
          },
        },
      },
    },
    defaults = {
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--hidden",
        "--glob",
        "!**/.git/*",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--trim", -- add this value
      },
    },
    extensions = {
      themes = {
        -- you can add regular telescope config
        -- that you want to apply on this picker only
        layout_config = {
          horizontal = {
            width = 0.8,
            height = 0.7,
          },
        },

        -- extension specific config

        -- (boolean) -> show/hide previewer window
        enable_previewer = true,

        -- (boolean) -> enable/disable live preview
        enable_live_preview = false,

        -- (table)
        -- (boolean) ignore -> toggle ignore light themes
        -- (list) keywords -> list of keywords that would identify as light theme
        light_themes = {
          ignore = true,
          keywords = { "light", "day", "frappe" },
        },

        -- (table)
        -- (boolean) ignore -> toggle ignore dark themes
        -- (list) keywords -> list of keywords that would identify as dark theme
        dark_themes = {
          ignore = false,
          keywords = { "dark", "night", "black" },
        },

        persist = {
          -- enable persisting last theme choice
          enabled = true,

          -- override path to file that execute colorscheme command
          path = vim.fn.stdpath("config") .. "/lua/colorscheme.lua",
        },
        mappings = {
          -- for people used to other mappings
          down = "<C-n>",
          up = "<C-p>",
          accept = "<C-y>",
        },
      },
      live_grep_args = {
        auto_quoting = true,
        mappings = { -- extend mappings
          i = {
            ["<C-k>"] = lga_actions.quote_prompt(),
            ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
            ["<C-space>"] = actions.to_fuzzy_refine,
          },
        },
        theme = "dropdown", -- use dropdown theme
      },
      ["ui-select"] = {
        require("telescope.themes").get_dropdown({}),
      },
      cmdline = {
        -- Adjust telescope picker size and layout
        picker = { layout_config = { width = 120, height = 25 } },
        overseer = { enabled = true },
        mappings = {
          complete = "<Tab>",
          run_selection = "<C-CR>",
          run_input = "<CR>",
        },
      },
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case",
      },
      frecency = {
        auto_validate = true,
        matcher = "fuzzy",
        path_display = { "filename_first" },
        ignore_patterns = {
          "*/.git",
          "*/.git/*",
          "*/tmp",
          "*/tmp/*",
          "term://*",
          "*/doc",
          "*/doc/*",
        },
        file_ignore_patterns = {
          ".git/",
          ".cache",
          "%.o",
          "%.a",
          "%.out",
          "%.class",
          "%.pdf",
          "%.mkv",
          "%.mp4",
          "%.zip",
        },
      },
      -- gpt = {
      --     title = "Gpt Actions",
      --     commands = {
      --         "add_tests", "chat", "docstring", "explain_code",
      --         "fix_bugs", "grammar_correction", "interactive",
      --         "optimize_code", "summarize", "translate"
      --     },
      --     theme = require("telescope.themes").get_dropdown {}
      -- }
    },
  }
end

function M.config(_, opts)
  require("telescope").setup(opts)

  local enabled_extensions =
    { "themes", "fzf", "ui-select", "frecency", "conduct", "live_grep_args", "search_dir_picker", "cmdline" }

  for _, extension in ipairs(enabled_extensions) do
    pcall(require("telescope").load_extension, extension)
  end
end

return M
