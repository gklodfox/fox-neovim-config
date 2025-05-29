local function tableHasKey(table, key)
    return table[key] ~= nil
end

local M = { "williamboman/mason-lspconfig.nvim" }

M.dependencies = {
    "stevearc/conform.nvim",
    { "williamboman/mason.nvim", opts = { ui = { border = "rounded" }, max_concurrent_installers = 8 } },
    {
        "neovim/nvim-lspconfig",
        lazy = true,
        dependencies = { "williamboman/mason-lspconfig.nvim" },
    },
    "saghen/blink.cmp",
    -- "ray-x/lsp_signature.nvim",
    "simrat39/rust-tools.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "rshkarin/mason-nvim-lint",
    "zapling/mason-conform.nvim",
}

function M.init()
    vim.opt.rtp:prepend(vim.fn.expand("~") .. "/.local/share/nvim/mason")

    vim.keymap.set("n", "gK", function()
        local new_config = not vim.diagnostic.config().virtual_lines
        vim.diagnostic.config({ virtual_lines = new_config })
    end, { desc = "Toggle diagnostic virtual_lines" })
    vim.keymap.set("n", "gk", function()
        local new_config = not vim.diagnostic.config().virtual_text
        vim.diagnostic.config({ virtual_lines = new_config })
    end, { desc = "Toggle diagnostic virtual_lines" })

    vim.diagnostic.config({
        virtual_text = false,
        virtual_lines = { current_line = false },
        update_in_insert = false,
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
    vim.filetype.add({ pattern = { [".*/*.asasm"] = "asasm" } })
    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("my.lsp", {}),
        desc = "LSP actions",
        callback = function(args)
            local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
            local bufmap = function(mode, lhs, rhs)
                local opts = { buffer = true }
                vim.keymap.set(mode, lhs, rhs, opts)
            end
            if client:supports_method("textDocument/implementation") then
                bufmap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>")
            end
            if client:supports_method("textDocument/completion") then
                local chars = {}
                for i = 32, 126 do
                    table.insert(chars, string.char(i))
                end
                client.server_capabilities.completionProvider.triggerCharacters = chars
                vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
            end
            if
                not client:supports_method("textDocument/willSaveWaitUntil")
                and client:supports_method("textDocument/formatting")
            then
                vim.api.nvim_create_autocmd("BufWritePre", {
                    group = vim.api.nvim_create_augroup("my.lsp", { clear = false }),
                    buffer = args.buf,
                    callback = function()
                        vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
                    end,
                })
            end

            bufmap("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>")
            bufmap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>")
            bufmap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>")
            bufmap("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>")
            bufmap("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>")
            bufmap("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>")
            bufmap("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>")
            bufmap("n", "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>")
            bufmap("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>")
            bufmap("n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>")
            bufmap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>")
            bufmap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>")
        end,
    })
end

function M.config(_, _)
    -- servers = {
    --     asm_lsp = { capabilities = capabilities },
    --     diagnosticls = { capabilities = capabilities },
    --     dockerls = { capabilities = capabilities },
    --     marksman = { capabilities = capabilities },
    --     rust_analyzer = { capabilities = capabilities },
    --     vimls = { capabilities = capabilities },
    --     yamlls = { capabilities = capabilities },
    --     html = { capabilities = capabilities },
    --     jsonls = { capabilities = capabilities },
    --     taplo = { capabilities = capabilities },
    --     markdown_oxide = { capabilities = capabilities },
    --     gradle_ls = { capabilities = capabilities },
    --     fish_lsp = {
    --         cmd = { "fish-lsp", "start" },
    --         cmd_env = {
    --             fish_lsp_show_client_popups = true,
    --         },
    --         filetypes = { "fish" },
    --         root_dir = function(fname)
    --             return vim.fs.dirname(vim.fs.find(".git", { path = fname, upward = true })[1])
    --         end,
    --         single_file_support = true,
    --         capabilities = capabilities,
    --     },
    --     groovyls = {
    --         cmd = {
    --             "java",
    --             "-jar",
    --             "/home/gklodkox/.local/share/nvim/mason/packages/groovy-language-server/build/libs/groovy-language-server-all.jar",
    --         },
    --         filetypes = {
    --             "groovy",
    --             "Jenkinsfile",
    --         },
    --         capabilities = capabilities,
    --     },
    --     lua_ls = { capabilities = capabilities },
    --     basedpyright = {
    --         settings = {
    --             basedpyright = {
    --                 analysis = {
    --                     autoSearchPaths = true,
    --                     diagnosticMode = "openFilesOnly",
    --                     useLibraryCodeForTypes = true,
    --                 },
    --             },
    --         },
    --         capabilities = capabilities,
    --     },
    --     pylsp = {
    --         settings = {
    --             pylsp = {
    --                 plugins = {
    --                     -- formatter
    --                     black = { enabled = true },
    --                     pylint = {
    --                         enabled = true,
    --                         -- executable = "pylint",
    --                         args = { "-d C0114,C0115,C0116" },
    --                     },
    --                     pylsp_mypy = {
    --                         enabled = true,
    --                         report_progress = true,
    --                         live_mode = true,
    --                     },
    --                     pycodestyle = {
    --                         ignore = { "W391" },
    --                         maxLineLength = 100,
    --                     },
    --                     isort = { enabled = true },
    --                 },
    --             },
    --         },
    --         capabilities = capabilities,
    --     },
    --     bashls = {
    --         settings = {
    --             bashIde = { globPattern = "*@(.sh|.inc|.bash|.command)" },
    --         },
    --         capabilities = capabilities,
    --     },
    --     clangd = {
    --         filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
    --         cmd = { "clangd" },
    --         capabilities = function()
    --             local cap = {
    --                 offsetEncoding = { "utf-16" },
    --                 textDocument = {
    --                     completion = {
    --                         editsNearCursor = true,
    --                     },
    --                 },
    --             }
    --             return vim.tbl_deep_extend("force", cap, capabilities)
    --         end,
    --         init_options = { fallbackFlags = { "-std=c++17" } },
    --     },
    --     neocmake = {
    --         cmd = { "neocmakelsp", "--stdio" },
    --         filetypes = { "cmake" },
    --         root_dir = function(fname)
    --             return require("lspconfig").util.find_git_ancestor(fname)
    --         end,
    --         single_file_support = true, -- suggested
    --         init_options = {
    --             format = {
    --                 enable = true,
    --             },
    --             lint = {
    --                 enable = true,
    --             },
    --             scan_cmake_in_package = true, -- default is true
    --         },
    --         capabilities = capabilities,
    --     },
    --     texlab = {
    --         settings = {
    --             texlab = {
    --                 bibtexFormatter = "texlab",
    --                 build = {
    --                     args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
    --                     executable = "latexmk",
    --                     forwardSearchAfter = false,
    --                     onSave = true,
    --                 },
    --                 chktex = {
    --                     onEdit = true,
    --                     onOpenAndSave = true,
    --                 },
    --                 diagnosticsDelay = 300,
    --                 formatterLineLength = 80,
    --                 forwardSearch = {
    --                     args = {},
    --                 },
    --                 latexFormatter = "tex-fmt",
    --                 latexindent = {
    --                     modifyLineBreaks = false,
    --                 },
    --             },
    --         },
    --         capabilities = capabilities,
    --     },
    -- }
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
            "groovyls",
            "html",
            "jsonls",
            "taplo",
            "markdown_oxide",
            "autopep8",
            "black",
            "autoflake",
            "prettierd",
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
            "prettier",
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
