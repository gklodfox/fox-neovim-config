local M = {"stevearc/conform.nvim"}

function M.opts()
    local lua_formatters = {"stylua"}
    local python_formatters = {"isort", "black", "autopep8", "autoflake"}
    local rust_formatters = {"rustfmt"}
    local yaml_formatters = {"yamlfmt", "yamlfix"}
    local json_formatters = {"fixjson"}
    local sh_formatters = {"shellcheck", "shfmt"}
    local all_formatters = {"codespell"}
    local on_save_formatters = {}

    return {
        formatters_by_ft = {
            lua = lua_formatters,
            python = python_formatters,
            rust = rust_formatters,
            yaml = yaml_formatters,
            json = json_formatters,
            sh = sh_formatters,
            ["*"] = all_formatters,
            ["_"] = on_save_formatters
        },
        format_on_save = false
    }
end

function M.config(_, opts)
    local conform = require("conform")
    conform.setup(opts)

    vim.keymap.set("n", "<leader>F", function()
        conform.format({bufnr = vim.api.nvim_get_current_buf()})
    end, {desc = "Format current buffer"})
end

return M
