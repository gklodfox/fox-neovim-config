local M = { "jackMort/ChatGPT.nvim" }

M.enabled = false

M.dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "folke/trouble.nvim", -- optional
    "nvim-telescope/telescope.nvim",
}

M.event = "VeryLazy"
function M.opts()
    return {
        api_key_cmd = "pass private/openai/api/token",
        openai_params = {
            model = "gpt-4o",
            frequency_penalty = 0,
            presence_penalty = 0,
            max_tokens = 4095,
            temperature = 0.2,
            top_p = 0.1,
            n = 1,
        },
    }
end

function M.config(_, opts)
    require("chatgpt").setup(opts)
end

return M
