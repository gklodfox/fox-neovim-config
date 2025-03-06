local set_global = vim.g
local set_opt = vim.opt
-- Recommended settings
set_opt.showcmd = true -- Display incomplete commands
local set_o = vim.o
-- local set_win = vim.wo

-- GLOBALS
vim.scriptencoding = "UTF-8"
set_o.encoding = "UTF-8"
set_o.fileencoding = "UTF-8"
set_o.syntax = "on"
if os.getenv("USER") == "gklodkox" then
  set_global.python3_host_prog = "/home/gklodkox/.pyenv/versions/neovim/bin/python"
elseif os.getenv("USER") == "fox" then
  set_global.python3_host_prog = "/home/fox/.cache/pypoetry/virtualenvs/neovim-venv-8W5n8m1R-py3.13/bin/python"
  set_global.node_host_prog = "/usr/bin/neovim-node-host"
  set_global.ruby_host_prog = "/home/fox/.local/share/gem/ruby/3.3.0/bin/neovim-ruby-host"
  set_global.perl_host_prog = "/usr/bin/perl"
else
  set_global.python3_host_prog = vim.fn.exepath("python")
end
-- NUMBER LINE
set_o.number = true
set_o.relativenumber = true
set_o.cursorline = true
set_o.cursorlineopt = "both"
set_o.ruler = false
set_o.numberwidth = 2
-- INDENTS
set_opt.breakindent = true
set_o.autoindent = true
set_o.expandtab = true
set_o.shiftwidth = 2
set_o.tabstop = 2
set_o.softtabstop = 2
-- EDITOR
-- set_win.conceallevel = 3
set_opt.list = true
set_opt.listchars = { trail = "·", nbsp = "␣" }

set_opt.ignorecase = true
set_opt.smartcase = true
set_opt.showmode = false
-- set_opt.path = vim.opt.path + "**"
set_o.mouse = "a"
set_o.smoothscroll = true
set_o.title = true
set_o.inccommand = "split"
set_o.ttimeoutlen = 0
set_opt.timeoutlen = 300
set_o.updatetime = 250
set_o.wrap = false
set_o.splitbelow = true
-- set_o.hidden = true
set_o.splitright = true
set_o.winheight = 3
set_o.scrolloff = 8
set_o.sidescrolloff = 4
set_o.signcolumn = "yes"
-- BACKUP
set_o.swapfile = false
set_o.backup = false
set_o.undodir = vim.fn.expand('~') .. "/.nvim/undodir"
set_o.undofile = true
-- MISC
set_opt.autochdir = true
set_opt.cmdheight = 0
-- set_opt.isfname:append({ "@-@" })
