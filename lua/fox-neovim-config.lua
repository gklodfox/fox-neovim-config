local FoxNvimConfig = {}
FoxNvimConfig.__index = FoxNvimConfig

setmetatable(FoxNvimConfig, {
  __call = function(cls)
    return cls:new()
  end,
})

function FoxNvimConfig:new()
  local self = setmetatable({}, FoxNvimConfig)
    lazyrepo = "https://github.com/folke/lazy.nvim.git",
    lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim",
  return self
end


function FoxNvimConfig:load_settings()
  require("fox-neovim-config.settings").setup(self.settings)
end

function FoxNvimConfig:load_lazy()
  if not vim.uv.fs_stat(self.lazypath) then
      require("fox-neovim-config.lazy_nvim").setup(self.lazypath, self.lazyrepo)
  end
  vim.opt.rtp:prepend(self.lazypath)
end


function FoxNvimConfig:setup(opts)
  if opts then
    for k, v in pairs(opts) do
      self[k] = v
    end
  end
  self:load_settings()
  self:load_lazy()
end
local lazy_config = require("fox-neovim-config.lazy_nvim")

require("lazy").setup({
    { import = "fox-neovim-config.plugins" },
}, lazy_config)

require("fox-neovim-config.settings")
require("fox-neovim-config.autocmds")
vim.schedule(function()
    require("fox-neovim-config.mappings")
end)
