local M = {'WhoIsSethDaniel/mason-tool-installer.nvim'}

M.dependencies = {"williamboman/mason-lspconfig.nvim"}
M.event = "VimEnter"

function M.opts()
    return {
        start_delay = 2000, -- 3 second delay
        debounce_hours = nil,
        integrations = {
            ['mason-lspconfig'] = true,
            ['mason-null-ls'] = true,
            ['mason-nvim-dap'] = true
        },
        ensure_installed = {
            "lua-language-server", "pyright", "python-lsp-server", "gradle_ls",
            "rust_analyzer", "dockerls",
            "bash-language-server", 'stylua',
            'shellcheck', 'editorconfig-checker', 'impl', 'json-to-struct',
            'luacheck', 'misspell', 'revive', 'shellcheck', 'shfmt',
            'staticcheck', 'vint', "marksman", "markdownlint"
        },
        run_on_start = true,
        auto_update = true
    }
end

return M
