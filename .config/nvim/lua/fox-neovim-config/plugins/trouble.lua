local M = { "folke/trouble.nvim" }

M.cmd = "Trouble"
M.keys = {
}

function M.opts()
  return {
    -- modes = {
    -- },
    modes = {
      diagnostics_buffer = {
        mode = "diagnostics", -- inherit from diagnostics mode
        filter = { buf = 0 }, -- filter diagnostics to the current buffer
        auto_close = false,
        auto_open = false,
        pinned = true,
        warn_no_results = false,
        open_no_results = true,
      },
      mydiags = {
        auto_open = false,
        auto_preview = true,
        pinned = true,
        warn_no_results = false,
        open_no_results = false,
        mode = "diagnostics", -- inherit from diagnostics mode
        filter = {
          any = {
            buf = 0, -- current buffer
            {
              severity = vim.diagnostic.severity.ERROR, -- errors only
              -- limit to files in the current project
              function(item)
                return item.filename:find((vim.loop or vim.uv).cwd(), 1, true)
              end,
            },
          },
        },
      },
      test = {
        mode = "diagnostics",
        preview = {
          type = "split",
          relative = "win",
          position = "right",
          size = 0.3,
        },
      },
    },
  }
end

function M.config(_, opts)
  require("trouble").setup(opts)
end

return M
