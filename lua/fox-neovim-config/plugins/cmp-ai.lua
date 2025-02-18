local M = { "tzachar/cmp-ai" }

M.dependencies = { 'nvim-lua/plenary.nvim' }
M.enabled = false
-- M.event = "InsertEnter"

function M.opts()
  return {
    max_lines = 10000,
    provider = 'OpenAI',
    provider_options = {
      model = 'gpt-4',
    },
    notify = true,
    notify_callback = function(msg)
      vim.notify(msg)
    end,
    run_on_every_keystroke = true,
    ignored_file_types = {
      -- default is not to ignore
      -- uncomment to ignore in lua:
      -- lua = true
    },
  }
end

function M.config(_, opts)
  local cmp_ai = require("cmp_ai.config")

  cmp_ai:setup(opts)
end

return M
