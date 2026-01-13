local M = {"j-hui/fidget.nvim"}

function M.opts()
    return {
        progress = {
            display = { done_ttl = math.huge}
        },
        notification = {
            poll_rate = 500,
            override_vim_notify = true,
        }
    }
end

function M.config(_, opts)
	require('fidget').setup(opts)
end

return M
