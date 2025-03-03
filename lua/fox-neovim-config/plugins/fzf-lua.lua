local M = { "ibhagwan/fzf-lua" }

M.dependencies = { "echasnovski/mini.icons" }

function M.config()
  require("fzf-lua").setup({
    {"telescope","fzf-native"},
    defaults = { file_icons = "mini" },
    winopts = { row = 1, col = 0, preview = { default = "bat", wrap = true, hidden = false } },
    files = {
      previewer = "bat", 
      cmd = "rg --files",
      find_opts = [[-type f -not -path '*/\.git/*']],
      rg_opts = [[--color=always --hidden --files --line-number --column -g "!.git"]],
      fd_opts = [[--color=always --hidden --type f --type l --exclude .git]],
      dir_opts = [[/s/b/a:-d]],
    },
    grep = {
      git_icons = true,
      file_icons = "mini",
      cmd = "rg --vimgrep",
      grep_opts = "--binary-files=without-match --line-number --recursive --color=auto --perl-regexp -e",
      rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e",
      hidden = true, -- disable hidden files by default
      follow = false, -- do not follow symlinks by default
      no_ignore = false, -- respect ".gitignore"  by default
    },
    fzf_opts = {
      ["--ansi"]           = true,
      ["--info"]       = "inline-right",
      ["--height"] = "40%",
      ["--width"] = "40%",
      ["--layout"] = "reverse",
      ["--border"] = "none",
      ["--highlight-line"] = true,
      ["--tmux"] = "center,80%,60%",
    },
    fzf_colors = true,
  })
  require("fzf-lua").register_ui_select()
end

return M
