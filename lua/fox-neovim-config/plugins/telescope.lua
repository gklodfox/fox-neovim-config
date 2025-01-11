local M = { "nvim-telescope/telescope.nvim" }

M.branch = "0.1.x"
M.cmd = "Telescope"
-- M.event = "VimEnter"
M.dependencies = {
  "nvim-treesitter/nvim-treesitter",
  "nvim-telescope/telescope-file-browser.nvim",
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  "nvim-telescope/telescope-project.nvim",
  "nvim-telescope/telescope-live-grep-args.nvim",
  "nvim-telescope/telescope-frecency.nvim",
  "nvim-telescope/telescope-dap.nvim",
  "debugloop/telescope-undo.nvim",
}

function M.opts()
  return {
    defaults = {
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
      mappings = {
        n = {
          ["q"] = require("telescope.actions").close,
        },
      },
    },
    extensions_list = { "frecency", "project", "live_grep_args", "dap", "fzf" },
    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case",
      }
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

  telescope.setup(opts)

  for _, extension in ipairs(opts.extensions_list) do
    telescope.load_extension(extension)
  end
end

return M
