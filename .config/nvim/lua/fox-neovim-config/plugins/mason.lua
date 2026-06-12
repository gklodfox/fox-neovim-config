local M = { "mason-org/mason-lspconfig.nvim" }

M.dependencies = {
    {
        "mason-org/mason.nvim",
        opts = {
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗"
                }
            }
        }
    },
    "neovim/nvim-lspconfig",
    "stevearc/conform.nvim",
    "LittleEndianRoot/mason-conform",
    "mfussenegger/nvim-lint",
    "rshkarin/mason-nvim-lint"
}

function M.opts()
    return {
        lsp_servers = { "ast_grep", "bashls", "lua_ls", "markdown_oxide", "clangd", "autotools_ls", "groovyls",
            "yamlls", "docker_language_server", "neocmake", "gh_actions_ls", "cobol_ls", "jsonls", "ltex_plus",
            "html", "cssls", "taplo", "pylsp", "basedpyright" },
        linters     = { "luacheck", "markdownlint", "cpplint", "checkmake", "cmakelint", "yamllint",
            "hadolint", "vint", "actionlint", "jsonlint", "htmlhint", "mypy" },
        formatters  = { "luaformatter", "cbfmt", "mdformat", "clang-format", "gersemi", "autopep8", "autoflake",
            "yamlfmt", "beautysh", "cmakelang", "fixjson", "latexindent", "tex-fmt", "isort", "yapf",
            "bibtex-tidy",
            "htmlbeautifier", "pyproject-fmt" }
    }
end

function M.config(_, opts)
    require("mason").setup()

    require("mason-lspconfig").setup({ ensure_installed = opts.lsp_servers })
    require("mason-conform").setup({ ensure_installed = opts.formatters })
    require("mason-nvim-lint").setup({ ensure_installed = opts.linters, ignore_install = { 'janet', 'ruby', 'inko', 'clj-kondo' } })
end

return M
