return {
  { "nvim-lua/plenary.nvim"},
  { "nvim-tree/nvim-web-devicons"},
  { 'echasnovski/mini.icons', version = false, lazy=true, config = function() require('mini.icons').setup() require('mini.icons').tweak_lsp_kind() end},
  { "MunifTanjim/nui.nvim"},
}
