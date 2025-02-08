local M = {'Exafunction/codeium.nvim'}

M.dependencies = {'nvim-lua/plenary.nvim', "hrsh7th/nvim-cmp"}

function M.opts()
  return {
    config_path = "/home/fox/Dotfiles/.config/codeium.token",
    workspace_root = {
      use_lsp = true,
      find_root = nil,
      paths = {
        ".bzr",
        ".git",
        ".hg",
        ".svn",
        "_FOSSIL_",
        "package.json",
      }
    },
    enable_cmp_source = true,
    virtual_text = {
      enabled = false,
      text = "",
      highlight = "Comment",
      manual = false,
      filetypes = {},
      -- Whether to enable virtual text of not for filetypes not specifically listed above.
      default_filetype_enabled = true,
      -- How long to wait (in ms) before requesting completions after typing stops.
      idle_delay = 75,
      -- Priority of the virtual text. This usually ensures that the completions appear on top of
      -- other plugins that also add virtual text, such as LSP inlay hints, but can be modified if
      -- desired.
      virtual_text_priority = 65535,
      -- Set to false to disable all key bindings for managing completions.
      map_keys = false,
      -- The key to press when hitting the accept keybinding but no completion is showing.
      -- Defaults to \t normally or <c-n> when a popup is showing.
      accept_fallback = nil,
      -- Key bindings for managing completions in virtual text mode.
      key_bindings = {
          -- Accept the current completion.
          accept = "<Tab>",
          -- Accept the next word.
          accept_word = "<M-Tab>",
          -- Accept the next line.
          accept_line = "<C-Tab",
          -- Clear the virtual text.
          clear = false,
          -- Cycle to the next completion.
          next = "<M-]>",
          -- Cycle to the previous completion.
          prev = "<M-[>",
      }
    }
  }
end

function M.config(_, opts)
  require('codeium.virtual_text').set_statusbar_refresh(function()
    require('lualine').refresh()
  end)
  require("codeium").setup(opts)
end

return M
