local M = {}

function M.setup()
-- Recommended settings
  vim.opt.lazyredraw = true -- Redraw only when needed
  vim.opt.showcmd = true -- Display incomplete commands
  -- GLOBALS
  vim.g.loaded_perl_provider = 0
  vim.g.loaded_ruby_provider = 0
  -- vim.g.python3_host_prog = '/home/fox/.config/nvim/venv/bin/python3'
  -- vim.g.node_host_prog = '/usr/bin/neovim-node-host'
  vim.g.have_nerd_font = true
  -- NUMBER LINE
  vim.o.number = true
  vim.o.relativenumber = true
  vim.o.cursorline = true
  vim.o.cursorlineopt = "both"
  vim.o.ruler = false
  vim.o.numberwidth = 2
  -- INDENTS
  vim.o.expandtab = true
  vim.o.shiftwidth = 2
  vim.o.tabstop = 2
  vim.o.softtabstop = 4
  vim.o.smartindent = true
  vim.opt.breakindent = true
  -- EDITOR
  vim.opt.wildignore = { "*.o", "*~", "*.pyc", "*/.git/*", "*/.hg/*", "*/.svn/*", "__pycache__", "*.log", "*.aux", "*.out", "*.toc" }
  vim.opt.list = true
  vim.opt.listchars = { trail = '·', nbsp = '␣' }
  vim.opt.ignorecase = true
  vim.opt.smartcase = true
  vim.opt.showmode = false
  vim.opt.path = vim.opt.path + "**"
  vim.o.mouse = "a"
  vim.o.smoothscroll = true
  vim.o.clipboard = "unnamedplus"
  vim.o.title = true
  vim.o.inccommand = "split"
  vim.o.ttimeoutlen = 0
  vim.opt.timeoutlen = 300
  vim.o.updatetime = 250
  vim.o.wrap = false
  vim.opt.whichwrap:append "<>[hl]"
  vim.opt.shortmess:append "sI"
  vim.o.splitbelow = true
  vim.o.splitright = true
  vim.o.winheight = 3
  vim.o.scrolloff = 8
  vim.o.sidescrolloff = 2
  vim.o.signcolumn = "yes"
  vim.o.colorcolumn = "80"
  -- BACKUP
  vim.o.swapfile = false
  vim.o.backup = false
  vim.o.undodir = "/home/fox/.nvim/undodir"
  vim.o.undofile = true
  -- MISC
  vim.opt.autochdir = true
  vim.opt.cmdheight = 0
  vim.opt.isfname:append { '@-@' }
  vim.o.termguicolors = true
  vim.opt.guicursor = {
    "n-v:block",
    "i-c-ci-ve:ver25",
    "r-cr:hor20",
    "o:hor50",
    "i:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor",
    "sm:block-blinkwait175-blinkoff150-blinkon175",
  }
  end

return M
