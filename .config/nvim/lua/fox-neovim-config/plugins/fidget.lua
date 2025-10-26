local M = {"j-hui/fidget.nvim"}

function M.opts()
    return {
	progress = {
		display = { done_ttl = math.huge}
		},
        notification = {
	    poll_rate = 500,
	    filter = vim.log.levels.INFO,
            override_vim_notify = true,
            window = { avoid = {"NvimTree"} },
        }
    }
end

function M.config(_, opts)
	require('fidget').setup(opts)
end

return M
