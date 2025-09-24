local function tableHasKey(table, key)
    return table[key] ~= nil
end

local M = { "williamboman/mason-lspconfig.nvim" }

M.dependencies = {
    { "williamboman/mason.nvim", opts = {} },
    "stevearc/conform.nvim",
    { "williamboman/mason.nvim", opts = { ui = { border = "rounded" }, max_concurrent_installers = 8 } },
    { "neovim/nvim-lspconfig", dependencies = { "williamboman/mason-lspconfig.nvim" } },
    "saghen/blink.cmp",
    "ray-x/lsp_signature.nvim",
    "simrat39/rust-tools.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "rshkarin/mason-nvim-lint",
    "zapling/mason-conform.nvim",
}

function M.init()
    vim.opt.rtp:prepend(vim.fn.expand("~") .. "/.local/share/nvim/mason")

    vim.diagnostic.config({
        virtual_text = false,
        virtual_lines = false,
        update_in_insert = true,
        underline = true,
        severity_sort = true,
    })

    vim.lsp.config("*", {
        capabilities = {
            textDocument = {
                semanticTokens = {
                    multilineTokenSupport = true,
                },
                foldingRange = {
                    dynamicRegistration = false,
                    lineFoldingOnly = true,
                },
            },
        },
        root_markers = { ".git" },
    })
end

function M.config()
    require("mason").setup()
    require("mason-lspconfig").setup()
    require("mason-tool-installer").setup({
        auto_update = true,
        run_on_start = true,
        start_delay = 3000,
        integrations = {
            ["mason-lspconfig"] = true,
            ["mason-null-ls"] = false,
            ["mason-nvim-dap"] = false,
        },
        ensure_installed = {
            "asm_lsp",
            "fish_lsp",
            "bashls",
            "neocmake",
            "diagnosticls",
            "dockerls",
            -- "digestif",
            "texlab",
            "gradle_ls",
            "lua_ls",
            "pylsp",
            "marksman",
            -- "basedpyright",
            "rust_analyzer",
            "vimls",
            "yamlls",
            "clangd",
            -- "groovyls",
            "html",
            "jsonls",
            "taplo",
            "markdown_oxide",
            "autopep8",
            "black",
            "autoflake",
            "luaformatter",
            "stylua",
            "beautysh",
            "fixjson",
            "htmlbeautifier",
            "mdformat",
            "xmlformatter",
            "yamlfix",
            "yamlfmt",
        },
    })

    require("mason-conform").setup({
        ensure_installed = {
            "bibtex-tidy",
            "tex_fmt",
            "autoflake",
            "autopep8",
            "black",
            "ruff_format",
            "isort",
            "cmake_format",
            "clang-format",
            "shellcheck",
            "shfmt",
            "stylua",
            "yamlfix",
            "fixjson",
            "rustfmt",
            "yamlfmt",
        },
    })
    require("mason-nvim-lint").setup({
        quiet_mode = false,
        automatic_installation = true,
        ensure_installed = {
            "rstcheck",
            "luacheck",
            "checkmake",
            "cmakelint",
            "cpplint",
            "vint",
            "editorconfig-checker",
            "eslint_d",
            "jsonlint",
            -- "pylint",
            -- "flake8",
            "ruff",
            "mypy",
            "htmlhint",
            "markdownlint",
            "pydocstyle",
            "shellcheck",
            "yamllint",
            "codespell",
            "buf_lint",
        },
    })
end

return M
