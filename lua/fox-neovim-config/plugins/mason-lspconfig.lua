local M = {"williamboman/mason-lspconfig.nvim"}

M.dependencies = {
    "hrsh7th/cmp-nvim-lsp", "neovim/nvim-lspconfig", "ray-x/lsp_signature.nvim",
    "simrat39/rust-tools.nvim"
}

function M.init()
    local signs = {
        {name = "DiagnosticSignError", text = "✘'"},
        {name = "DiagnosticSignWarn", text = "▲"},
        {name = "DiagnosticSignHint", text = "⚑"},
        {name = "DiagnosticSignInfo", text = ""}
    }
    vim.diagnostic.config({
        virtual_text = true,
        signs = {active = signs},
        update_in_insert = true,
        underline = true,
        severity_sort = true
    })
    for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name,
                           {texthl = sign.name, text = sign.text, numhl = ""})
    end
    vim.filetype.add({pattern = {['.*/*.asasm'] = "asasm"}})
end
function M.config()
    -- require("neodev").setup({})
    local capabilities = require('lspconfig').util.default_config

    -- Add cmp_nvim_lsp capabilities settings to lspconfig
    -- This should be executed before you configure any language server
    capabilities.capabilities = vim.tbl_deep_extend('force',
                                                    capabilities.capabilities,
                                                    require('cmp_nvim_lsp').default_capabilities())

    -- LspAttach is where you enable features that only work
    -- if there is a language server active in the file
    vim.api.nvim_create_autocmd('LspAttach', {
        desc = 'LSP actions',
        callback = function(event)
            local opts = {buffer = event.buf}

            vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
            vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>',
                           opts)
            vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>',
                           opts)
            vim.keymap.set('n', 'gi',
                           '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
            vim.keymap.set('n', 'go',
                           '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
            vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>',
                           opts)
            vim.keymap.set('n', 'gs',
                           '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
            vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>',
                           opts)
            vim.keymap.set({'n', 'x'}, '<F3>',
                           '<cmd>lua vim.lsp.buf.format({async = true})<cr>',
                           opts)
            vim.keymap.set('n', '<F4>',
                           '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
            local bufnr = event.buf
            local client = vim.lsp.get_client_by_id(event.data.client_id)
            if client and client.supports_method("textDocument/inlayHint") then
                vim.lsp.inlay_hint.enable(true, {bufnr = bufnr})
            end
            require("lsp_signature").on_attach({
                bind = true,
                handler_opts = {border = "rounded"}
            })
        end
    })
    require("mason").setup({})
    require("mason-lspconfig").setup({
        ensure_installed = {
            "textlint", "pydocstyle", "npm-groovy-lint", "vint", "jsonlint",
            "cpplint", "ast_grep", "checkmake", "cmakelint", "codespell",
            "commitlint", "flake8", "gitlint", "htmlhint", "luacheck",
            "markdownlint", "markdownlint-cli2", "mypy", "pyflakes", "pylint",
            "pyproject-flake8", "ruff", "shellcheck", "yamllint", "ast-grep",
            "asm-lsp", "bash-language-server", "cmake-language-server",
            "diagnostic-languageserver", "dockerfile-language-server",
            "eslint-lsp", "gradle-language-server", "lua-language-server",
            "marksman", "pyright", "python-lsp-server", "ruff", "ruff-lsp",
            "rust-analyzer", "vim-language-server", "yaml-language-server",
            "clangd", "django-template-lsp", "grammarly-languageserver",
            "groovy-language-server", "html-lsp", "json-lsp", "taplo",
            "autopep8", "black", "autoflake", "prettierd", "luaformatter",
            "luaformatter", "stylua", "beautysh", "clang_format", "fixjson",
            "htmlbeautifier", "markdown-toc", "mdformat", "xmlformatter", "yamlfix",
            "yamlfmt"
        },
        automatic_installation = true,
        handlers = {
            function(server_name)
                require("lspconfig")[server_name].setup({
                    capabilities = capabilities
                })
            end,
            ["asm_lsp"] = function()
                require("lspconfig").asm_lsp.setup({
                    cmd = {"asm-lsp"},
                    filetypes = {"asm", "s", "S", "vmasm", "asasm", "abc"},
                    capabilities = capabilities
                })
            end,
            ["lua_ls"] = function()
                require("lspconfig").lua_ls.setup({
                  on_init = function(client)
                    if client.workspace_folders then
                        local path = client.workspace_folders[1].name
                        if vim.uv.fs_stat(path .. '/.luarc.json') or
                            vim.uv.fs_stat(path .. '/.luarc.jsonc') then
                            return
                        end
                    end

                    client.config.settings.Lua =
                        vim.tbl_deep_extend('force', client.config.settings.Lua,
                                            {
                            diagnostics = {
                                -- Get the language server to recognize the `vim` global
                                globals = {"vim"}
                            },
                            runtime = {
                                -- Tell the language server which version of Lua you're using
                                -- (most likely LuaJIT in the case of Neovim)
                                version = "5.1", -- ,'LuaJIT',
                                path = {
                                    -- Make the server aware of Neovim runtime files
                                    vim.fn.stdpath("config") .. "/init.lua",
                                    '?.lua', '?/init.lua',
                                    vim.fn
                                        .expand '~/.luarocks/share/lua/5.1/?.lua',
                                    vim.fn
                                        .expand '~/.luarocks/share/lua/5.1/?/init.lua',
                                    '/usr/share/5.1/?.lua',
                                    '/usr/share/lua/5.1/?/init.lua'
                                }
                            },
                            -- Make the server aware of Neovim runtime files
                            workspace = {
                                checkThirdParty = true,
                                library = vim.api
                                    .nvim_get_runtime_file("", true)
                            }
                    })
                  end,
                capabilities = capabilities,
                settings = {Lua = {}}
            })
        end,
        ["pyright"] = function()
            require("lspconfig").pyright.setup({
                capabilities = capabilities,
                settings = {
                    python = {
                        analysis = {
                            autoSearchPaths = true,
                            diagnosticMode = "openFilesOnly",
                            useLibraryCodeForTypes = true
                        }
                    }
                }
            })
        end,
        ["pylsp"] = function()
            local py_path = os.getenv("VIRTUAL_ENV") or vim.g.python3_host_prog
            require("lspconfig").pylsp.setup({
                capabilities = capabilities,
                settings = {
                    pylsp = {
                        plugins = {
                            -- formatter
                            black = {enabled = true},
                            pylint = {
                                enabled = true,
                                -- executable = "pylint",
                                args = {"-d C0114,C0115,C0116"}
                            },
                            pylsp_mypy = {
                                enabled = true,
                                overrides = {
                                    "--python-executable", py_path, true
                                },
                                report_progress = true,
                                live_mode = true
                            },
                            pycodestyle = {
                                ignore = {"W391"},
                                maxLineLength = 100
                            },
                            isort = {enabled = true}
                        }
                    }
                }
            })
        end,
        ["bashls"] = function()
            require("lspconfig").bashls.setup({
                capabilities = capabilities,
                settings = {
                    bashIde = {globPattern = "*@(.sh|.inc|.bash|.command)"}
                }
            })
        end,
        ["gradle_ls"] = function()
            require("lspconfig").gradle_ls.setup({
                capabilities = capabilities,
                cmd = { "java", "-jar", "/home/gklodkox/sources/groovy-language-server/build/libs/groovy-language-server-all.jar"},
                settings = {gradleWrapperEnabled = true},
            })
        end,
        ["rust_analyzer"] = function()
            require("lspconfig").rust_analyzer.setup({
                capabilities = capabilities,
                imports = {granularity = {group = "module"}, prefix = "self"},
                cargo = {buildScripts = {enable = true}},
                procMacro = {enable = true}
            })
        end,
        ["dockerls"] = function()
            require("lspconfig").dockerls.setup({
                capabilities = capabilities,
                settings = {
                    docker = {
                        languageserver = {
                            formatter = {ignoreMultilineInstructions = true}
                        }
                    }
                }
            })
        end,
        ["marksman"] = function()
            require("lspconfig").marksman.setup({
                capabilities = capabilities
            })
        end
    }})
end

return M
