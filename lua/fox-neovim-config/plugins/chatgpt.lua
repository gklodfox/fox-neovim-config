local M = {"jackMort/ChatGPT.nvim"}

M.event = "VeryLazy"
M.dependencies = {
    "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim", "folke/trouble.nvim", -- optional
    "nvim-telescope/telescope.nvim"
}

function M.opts()
    return {
        openai_params = {
            -- NOTE: model can be a function returning the model name
            -- this is useful if you want to change the model on the fly
            -- using commands
            -- Example:
            -- model = function()
            --     if some_condition() then
            --         return "gpt-4-1106-preview"
            --     else
            --         return "gpt-3.5-turbo"
            --     end
            -- end,
            model = "gpt-4o",
            frequency_penalty = 0,
            presence_penalty = 0,
            max_tokens = 16192,
            temperature = 0.2,
            top_p = 0.1,
            n = 1
        },
        openai_edit_params = {
            model = "gpt-4o",
            frequency_penalty = 0,
            max_tokens = 16192,
            presence_penalty = 0,
            temperature = 0,
            top_p = 1,
            n = 1
        }
    }
end

function M.config(_, opts) require("chatgpt").setup(opts) end

return M
