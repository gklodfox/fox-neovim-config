local M = { "ibhagwan/fzf-lua" }

M.dependencies = { "echasnovski/mini.icons" }

function M.opts()
  local fzf = require("fzf-lua")
  local config = fzf.config
  local actions = fzf.actions

  config.defaults.keymap.fzf["ctrl-q"] = "select-all+accept"
  config.defaults.keymap.fzf["ctrl-u"] = "half-page-up"
  config.defaults.keymap.fzf["ctrl-d"] = "half-page-down"
  config.defaults.keymap.fzf["ctrl-x"] = "jump"
  config.defaults.keymap.fzf["ctrl-f"] = "preview-page-down"
  config.defaults.keymap.fzf["ctrl-b"] = "preview-page-up"
  config.defaults.keymap.builtin["<c-f>"] = "preview-page-down"
  config.defaults.keymap.builtin["<c-b>"] = "preview-page-up"

  -- Trouble
  config.defaults.actions.files["ctrl-t"] = require("trouble.sources.fzf").actions.open

  return {
    "default-title",
    fzf_colors = true,
    fzf_opts = {
      ["--border"] = true,
      ["--style"] = "full",
      ["--height"] = "40%",
      ["--tmux"] = "down",
      ["--layout"] = "reverse",
      ["--info"] = "inline-right",
    },
    keymap = {
      fzf = {
        ["ctrl-q"] = "select-all+accept",
      },
    },
    defaults = { formatter = "path.dirname_first" },
    winopts = {
      width = 0.8,
      preview = { scrollchars = { "┃", "" }, default = "bat", wrap = false, hidden = false },
    },
    files = {
      previewer = "bat",
      cwd_prompt = false,
      actions = {
        ["alt-i"] = { actions.toggle_ignore },
        ["alt-h"] = { actions.toggle_hidden },
      },
    },
    grep = {
      git_icons = true,
      actions = {
        ["alt-i"] = { actions.toggle_ignore },
        ["alt-h"] = { actions.toggle_hidden },
      },
      lsp = {
      symbols = {
        symbol_hl = function(s)
          return "TroubleIcon" .. s
        end,
        symbol_fmt = function(s)
          return s:lower() .. "\t"
        end,
        child_prefix = false,
      },
      code_actions = {
        previewer = vim.fn.executable("delta") == 1 and "codeaction_native" or nil,
      },
    },
    },
  }
end

function M.config(_, opts)
  local fzf = require("fzf-lua")
  fzf.setup(opts)
  fzf.register_ui_select()
end

return M
