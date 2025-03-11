local M = { "ibhagwan/fzf-lua" }

M.dependencies = { "nvim-tree/nvim-web-devicons", "echasnovski/mini.icons" }

M.lazy = false

function M.config(_, _)
  local fzf = require("fzf-lua")

  fzf.setup({
    help_open_win = vim.api.nvim_open_win,
    previewers = {
      cat = {
        cmd = "cat",
        args = "-n",
      },
      bat = {
        cmd = "bat",
        args = "--color=always --style=numbers,changes",
      },
      head = {
        cmd = "head",
        args = nil,
      },
      git_diff = {
        -- if required, use `{file}` for argument positioning
        -- e.g. `cmd_modified = "git diff --color HEAD {file} | cut -c -30"`
        cmd_deleted = "git diff --color HEAD --",
        cmd_modified = "git diff --color HEAD",
        cmd_untracked = "git diff --color --no-index /dev/null",
        -- git-delta is automatically detected as pager, set `pager=false`
        -- to disable, can also be set under 'git.status.preview_pager'
      },
      man = {
        -- NOTE: remove the `-c` flag when using man-db
        -- replace with `man -P cat %s | col -bx` on OSX
        cmd = "man -c %s | col -bx",
      },
      builtin = {
        syntax = true, -- preview syntax highlight?
        syntax_limit_l = 0, -- syntax limit (lines), 0=nolimit
        syntax_limit_b = 1024 * 1024, -- syntax limit (bytes), 0=nolimit
        limit_b = 1024 * 1024 * 10, -- preview limit (bytes), 0=nolimit
        -- previewer treesitter options:
        -- enable specific filetypes with: `{ enabled = { "lua" } }
        -- exclude specific filetypes with: `{ disabled = { "lua" } }
        -- disable `nvim-treesitter-context` with `context = false`
        -- disable fully with: `treesitter = false` or `{ enabled = false }`
        treesitter = {
          enabled = true,
          disabled = {},
          -- nvim-treesitter-context config options
          context = { max_lines = 3, trim_scope = "inner" },
        },
        -- By default, the main window dimensions are calculated as if the
        -- preview is visible, when hidden the main window will extend to
        -- full size. Set the below to "extend" to prevent the main window
        -- from being modified when toggling the preview.
        toggle_behavior = "default",
        -- Title transform function, by default only displays the tail
        -- title_fnamemodify = function(s) vim.fn.fnamemodify(s, ":t") end,
        -- preview extensions using a custom shell command:
        -- for example, use `viu` for image previews
        -- will do nothing if `viu` isn't executable
        extensions = {
          -- neovim terminal only supports `viu` block output
          ["png"] = { "viu", "-b" },
          -- by default the filename is added as last argument
          -- if required, use `{file}` for argument positioning
          ["svg"] = { "chafa", "{file}" },
          ["jpg"] = { "ueberzug" },
        },
        -- if using `ueberzug` in the above extensions map
        -- set the default image scaler, possible scalers:
        --   false (none), "crop", "distort", "fit_contain",
        --   "contain", "forced_cover", "cover"
        -- https://github.com/seebye/ueberzug
        ueberzug_scaler = "cover",
        -- Custom filetype autocmds aren't triggered on
        -- the preview buffer, define them here instead
        -- ext_ft_override = { ["ksql"] = "sql", ... },
        -- render_markdown.nvim integration, enabled by default for markdown
        render_markdown = { enabled = true, filetypes = { ["markdown"] = true } },
      },
      -- Code Action previewers, default is "codeaction" (set via `lsp.code_actions.previewer`)
      -- "codeaction_native" uses fzf's native previewer, recommended when combined with git-delta
      codeaction = {
        -- options for vim.diff(): https://neovim.io/doc/user/lua.html#vim.diff()
        diff_opts = { ctxlen = 3 },
      },
      codeaction_native = {
        diff_opts = { ctxlen = 3 },
        -- git-delta is automatically detected as pager, set `pager=false`
        -- to disable, can also be set under 'lsp.code_actions.preview_pager'
        -- recommended styling for delta
        --pager = [[delta --width=$COLUMNS --hunk-header-style="omit" --file-style="omit"]],
      },
      fzf_colors = false,
      fzf_tmux_opts = { ["-p"] = "80%,80%", ["--margin"] = "0,0" },
      -- defaults = { formatter = "path" },
      winopts = {
        height = 0.85,
        width = 0.80,
        col = 0.50,
        row = 0.50,
        border = "rounded",
        treesitter = {
          enabled = true,
          fzf_colors = { ["hl"] = "-1:reverse", ["hl+"] = "-1:reverse" },
        },
        preview = {
          default = "bat", -- override the default previewer?
          -- default uses the 'builtin' previewer
          border = "rounded", -- preview border: accepts both `nvim_open_win`
          -- and fzf values (e.g. "border-top", "none")
          -- native fzf previewers (bat/cat/git/etc)
          -- can also be set to `fun(winopts, metadata)`
          wrap = false, -- preview line wrap (fzf's 'wrap|nowrap')
          hidden = false, -- start preview hidden
          vertical = "down:45%", -- up|down:size
          horizontal = "right:60%", -- right|left:size
          layout = "flex", -- horizontal|vertical|flex
          flip_columns = 100, -- #cols to switch to horizontal on flex
          -- Only used with the builtin previewer:
          title = true, -- preview border title (file/buf)?
          title_pos = "center", -- left|center|right, title alignment
          scrollbar = "float", -- `false` or string:'float|border'
          -- float:  in-window floating border
          -- border: in-border "block" marker
          scrolloff = -1, -- float scrollbar offset from right
          -- applies only when scrollbar = 'float'
          delay = 20, -- delay(ms) displaying the preview
          -- prevents lag on fast scrolling
          winopts = { -- builtin previewer window options
            number = true,
            relativenumber = false,
            cursorline = true,
            cursorlineopt = "both",
            cursorcolumn = false,
            signcolumn = "no",
            list = false,
            foldenable = true,
            foldmethod = "manual",
          },
        },
      },
      files = {
        previewer = "bat",
        cwd_prompt = false,
        actions = {
          ["alt-i"] = { require("fzf-lua").toggle_ignore },
          ["alt-h"] = { require("fzf-lua").toggle_hidden },
        },
      },
      grep = {
        git_icons = true,
        actions = {
          ["alt-i"] = { require("fzf-lua").toggle_ignore },
          ["alt-h"] = { require("fzf-lua").toggle_hidden },
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
    },
  })
  fzf.register_ui_select()
end

return M
