local M = { "fei6409/log-highlight.nvim" }

function M.opts()
  return {
    extension = { "log", "txt" },
    -- The file names or the full file paths.
    filename = {
      "messages",
    },
    -- The file path glob patterns, e.g. `.*%.lg`, `/var/log/.*`.
    -- Note: `%.` is to match a literal dot (`.`) in a pattern in Lua, but most
    -- of the time `.` and `%.` here make no observable difference.
    pattern = {
      "/var/log/.*",
      "messages%..*",
      ".*/logs/.*",
      ".*/log/.*",
    },
  }
end

function M.config(_, opts)
  require("log-highlight").setup(opts)
end

return M
