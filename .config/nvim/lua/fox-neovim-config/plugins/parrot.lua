local M = { "frankroeder/parrot.nvim"}

M.dependencies = { "ibhagwan/fzf-lua", "nvim-lua/plenary.nvim" }
M.enabled = false

function M.opts()
    return {
        providers = {
            openai = {
                name = "openai",
                api_key = os.getenv "OPENAI_API_KEY",
                endpoint = "https://api.openai.com/v1/chat/cmopletions",
                params = {
                    chat = { temperature = 1.1, top_p = 1 },
                    command = { temperature = 1.1, top_p = 1 },
                },
                topic = {
                    model = "gpt-4.1-nano",
                    params = { max_completion_tokens = 64 },
                },
                models = {
                    "gpt-4o",
                    "o4-mini",
                    "gpt-4.1-nano",
                }
            }
        },
    }
end

function M.config(_, opts)
    local parrot = require("parrot")
    parrot.setup(opts)
end

return M
