local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { import = "fox-neovim-config.plugins" },
  },
  install = { colorscheme = { "flow", priority = 1000 } },
ui = {
    browser = "qutebrowser", ---@type string?
    border = "double",
    size = {
      width = 0.8,
      height = 0.8,
    },
  },
    performance = {
    cache = { enabled = true },
    reset_packpath = true,
    rtp = {
      reset = true,
      paths = { vim.fn.expand("~") .. "/.local/share/nvim/mason/bin" },
      disabled_plugins = {
        "tohtml",
        "gzip",
        "netrw",
        "netrwPlugin",
        "matchit",
        "tarPlugin",
        "zipPlugin",
        "tutor",
      },
    },
  },
  checker = { enabled = true, concurrency = nil }
})
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#6e253e", bold = true })
