local M = { "folke/which-key.nvim" }

-- M.event = "VeryLazy"
--
function M.opts()
  return {
    delay = 0,
    preset = "helix",
    icons = {
      mappings = vim.g.have_nerd_font,
      keys = vim.g.have_nerd_font and {}
    },
    spec = {
      { '<leader>c', group = '[c]ode', icon = "",  mode = { 'n', 'x' } },
      { '<leader>p', group = 'ChatG[p]T', icon = "󱙺",  mode = { 'n', 'v' } },
      { '<leader>d', group = '[D]elete' },
      { '<leader>r', group = '[R]ename' },
      { '<leader>f', group = '[F]ind', icon = "󰍉"},
      { '<leader>w', group = '[W]orkspace' },
      { '<leader>t', group = '[T]oggle' },
      { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
    },
    plugins = {
      marks = true,
      registers = true,
      spelling = {
        enable = true,
        suggestions = 20,
      },
      presets = {
        operators = true,
        motions = true,
        text_objects = true,
        windows = true,
        nav = true,
        z = true,
        g = true,
      },
    },
  }
end

function M.config(_, opts)
  require("which-key").setup(opts)
end

return M
