local M = { "nvim-treesitter/nvim-treesitter" }

M.build = ":TSUpdate"
M.dependencies = {
  "windwp/nvim-ts-autotag",
  "nvim-treesitter/nvim-treesitter-textobjects",
  "RRethy/nvim-treesitter-textsubjects",
  "LiadOz/nvim-dap-repl-highlights"
}

function M.opts()
  return {
    ensure_installed = {
      "vimdoc", "c", "lua", "rust",
      "jsdoc", "bash", "vim", "query", "markdown", "groovy",
      "markdown_inline", "python", "cpp", "fish", "dap_repl"
    },
    sync_install = false,
    ignore_install = {""},
    highlight = { enable =  true, additional_vim_regex_highlighting = false },
    indent = { enable = true },
    autotag = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-space>",
        node_incremental = "<C-space>",
        scope_incremental = false,
        node_decremental = "<bs>",
      },
    },
    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },
    textobjects = { enable = true },
    textsubjects = { enable = true, prev_selection = ',', keymaps = {
          ['.'] = 'textsubjects-smart',
          [';'] = 'textsubjects-container-outer',
          ['i;'] = { 'textsubjects-container-inner', desc = "Select inside containers (classes, functions, etc.)" },
      }
    }
  }
end
function M.config(_, opts)
  require("nvim-dap-repl-highlights").setup()
  require("nvim-treesitter.configs").setup(opts)
end

return M
