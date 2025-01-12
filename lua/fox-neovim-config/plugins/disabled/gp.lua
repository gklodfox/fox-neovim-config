local M = { "robitx/gp.nvim" }

M.enabled = false

function M.opts()
  local api_key_path = "/home/fox/.config/openai.token"

  return { openai_api_key = { "cat",  api_key_path} }
end

return M
