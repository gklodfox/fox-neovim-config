local M = { "mason-org/mason-lspconfig.nvim" }

M.dependencies = {
    { "mason-org/mason.nvim",    opts = {} },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "saghen/blink.cmp",
        },
    },
    { "mfussenegger/nvim-lint" },
    { "rshkarin/mason-nvim-lint" },
    {
        "stevearc/conform.nvim",
        cmd = { "ConformInfo" },
        keys = {
            {
                "<leader>F",
                function()
                    require("conform").format({ async = true, lsp_format = "fallback" })
                end,
                mode = "",
                desc = "[F]ormat buffer",
            },
        },
        opts = {},
    },
    { "LittleEndianRoot/mason-conform" },
}
function M.init()
    vim.diagnostic.config({
        virtual_text = { enabled = false, severity = { vim.diagnostic.severity.WARN, vim.diagnostic.severity.ERROR } },
        virtual_lines = { severity = { vim.diagnostic.severity.HINT, vim.diagnostic.severity.INFO } },
        float = {
            source = true,
            header = "Diagnostics:",
            prefix = " ",
            border = "single",
            max_height = 10,
            max_width = 130,
            close_events = { "CursorMoved", "BufLeave", "WinLeave" },
        },
        update_in_insert = true,
        underline = { severity = { vim.diagnostic.severity.WARN, vim.diagnostic.severity.ERROR, vim.diagnostic.severity.HINT, vim.diagnostic.severity.INFO } },
        severity_sort = true,
    })
    vim.api.nvim_create_autocmd("CursorHold", {
        pattern = "*",
        callback = function()
            if #vim.diagnostic.get(0) == 0 then
                return
            end

            if not vim.b.diagnostics_pos then
                vim.b.diagnostics_pos = { nil, nil }
            end

            local cursor_pos = vim.api.nvim_win_get_cursor(0)

            if not vim.deep_equal(cursor_pos, vim.b.diagnostics_pos) then
                vim.diagnostic.open_float {}
            end

            vim.b.diagnostics_pos = cursor_pos
        end,
    })
end

M.lsp_servers = { "ast_grep", "bashls", "lua_ls", "markdown_oxide", "clangd", "autotools_ls", "pyright", "groovyls", "yamlls",
    "docker_language_server", "neocmake" , "cmake", "gh_actions_ls", "cobol_ls"}
M.linters     = { "luacheck", "markdownlint", "cpplint", "checkmake", "cmakelint", "flake8", "mypy", "yamllint",
    "hadolint", "vint", "actionlint" }
M.formatters  = { "luaformatter", "cbfmt", "mdformat", "clang-format", "gersemi", "autoflake", "blue",
    "reorder-python-imports", "yamlfmt", "beautysh", "cmakelang" }

function M.config()
    require("mason-lspconfig").setup({ ensure_installed = M.lsp_servers })
    require("mason-conform").setup({ ensure_installed = M.formatters })
    require("mason-nvim-lint").setup({ ensure_installed = M.linters })
end

return M
