local set_global = vim.g
local set_opt = vim.opt
-- Recommended settings
set_opt.lazyredraw = true -- Redraw only when needed
set_opt.showcmd = true -- Display incomplete commands
local set_o = vim.o

-- GLOBALS
set_global.loaded_perl_provider = 0
set_global.loaded_ruby_provider = 0
set_global.python3_host_prog = '/home/fox/.config/nvim/venv/bin/python3'
set_global.node_host_prog = '/usr/bin/neovim-node-host'
set_global.have_nerd_font = true
-- NUMBER LINE
set_o.number = true
set_o.relativenumber = true
set_o.cursorline = true
set_o.cursorlineopt = "both"
set_o.ruler = false
set_o.numberwidth = 2
-- INDENTS
set_o.expandtab = true
set_o.shiftwidth = 2
set_o.tabstop = 2
set_o.softtabstop = 2
set_o.smartindent = true
set_opt.breakindent = true
-- EDITOR
set_opt.list = true
set_opt.listchars = { trail = '·', nbsp = '␣' }
set_opt.ignorecase = true
set_opt.smartcase = true
set_opt.showmode = false
set_opt.path = vim.opt.path + "**"
set_o.mouse = "a"
set_o.smoothscroll = true
set_o.clipboard = "unnamedplus"
set_o.title = true
set_o.inccommand = "split"
set_o.ttimeoutlen = 0
set_opt.timeoutlen = 300
set_o.updatetime = 250
set_o.wrap = false
set_opt.whichwrap:append "<>[hl]"
set_opt.shortmess:append "sI"
set_o.splitbelow = true
set_o.splitright = true
set_o.winheight = 3
set_o.scrolloff = 8
set_o.sidescrolloff = 2
set_o.signcolumn = "yes"
set_o.colorcolumn = "80"
-- BACKUP
set_o.swapfile = false
set_o.backup = false
set_o.undodir = "/home/fox/.nvim/undodir"
set_o.undofile = true
-- MISC
set_opt.autochdir = true
set_opt.cmdheight = 0
set_opt.isfname:append { '@-@' }
set_o.termguicolors = true
-- set_opt.guicursor = {
--   "n-v:block",
--   "i-c-ci-ve:ver25",
--   "r-cr:hor20",
--   "o:hor50",
--   "i:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor",
--   "sm:block-blinkwait175-blinkoff150-blinkon175",
-- }
-- Local window opt

vim.env.PATH = table.concat({ vim.fn.stdpath "data", "mason", "bin" }, "/") .. ":" .. vim.env.PATH
