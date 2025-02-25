local M = { "nvim-telescope/telescope.nvim" }

M.cmd = "Telescope"
-- M.event = "VimEnter"

M.dependencies = {
  "nvim-lua/plenary.nvim",
  "nvim-treesitter/nvim-treesitter",
  "jonarrien/telescope-cmdline.nvim",
  "nvim-telescope/telescope-live-grep-args.nvim",
  "nvim-telescope/telescope-file-browser.nvim",
  "nvim-telescope/telescope-ui-select.nvim",
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  "MunifTanjim/nui.nvim",
  -- {"HPRIOR/telescope-gpt", dependencies = {"jackMort/ChatGPT.nvim"}},
  "nvim-telescope/telescope-project.nvim",
  "nvim-telescope/telescope-frecency.nvim",
  "smilovanovic/telescope-search-dir-picker.nvim",
  "nvim-telescope/telescope-dap.nvim",
  "debugloop/telescope-undo.nvim",
  { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
}

function M.opts()
  local actions = require("telescope.actions")
  local project_actions = require("telescope._extensions.project.actions")
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
          require("telescope.themes").get_dropdown(),
        },
        cmdline = {
          -- Adjust telescope picker size and layout
          picker = { layout_config = { width = 120, height = 25 } },
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
        project = {
          base_dirs = {
            "$HOME/.config",
            { path = "$HOME/Code", max_depth = 3 },
          },
          project = { display_type = "full" },
          hidden_files = true, -- default: false
          sync_with_nvim_tree = true, -- default false
          theme = "dropdown",
          on_project_selected = function(prompt_bufnr)
            project_actions.change_working_directory(prompt_bufnr, false)
            require("harpoon.extensions").builtins.navigate_with_number(1)
            vim.cmd(":NvimTreeToggle<CR>")
          end,
        },
        frecency = {
          auto_validate = true,
          matcher = "fuzzy",
          path_display = { "filename_first" },
          ignore_patterns = {
            "*/.git/*",
            "*/.git",
            "*/tmp/*",
            "*/node_modules/*",
            "term://*",
            "*/doc/*",
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
    },
  }
end

function M.config(_, opts)
  local enabled_extensions =
    { "fzf", "ui-select", "frecency", "project", "live_grep_args", "search_dir_picker", "cmdline" }

  require("telescope").setup(opts)

  for _, extension in ipairs(enabled_extensions) do
    pcall(require("telescope").load_extension, extension)
  end
end

return M
