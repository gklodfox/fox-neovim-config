local M = {"williamboman/mason-lspconfig.nvim"}

M.dependencies = {
    "hrsh7th/cmp-nvim-lsp", "neovim/nvim-lspconfig", "ray-x/lsp_signature.nvim",
    "simrat39/rust-tools.nvim"
}

local on_attach = function(_, bufnr)
    require("lsp_signature").on_attach({
        bind = true,
        handler_opts = {border = "rounded"}
    })

    local opts = {noremap = true, silent = true}

    vim.api.nvim_buf_set_keymap(bufnr, "n", "gD",
                                "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gd",
                                "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gi",
                                "<cmd>lua vim.lsp.buf.implementation()<CR>",
                                opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>sh",
                                "<cmd>lua vim.lsp.buf.signature_help()<CR>",
                                opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>wa",
                                "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>",
                                opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>wr",
                                "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>",
                                opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>wl",
                                "<cmd>lua function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end()<CR>",
                                opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>D",
                                "<cmd>lua vim.lsp.buf.type_definition()<CR>",
                                opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ra",
                                "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ca",
                                "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gr",
                                "<cmd>lua vim.lsp.buf.references()<CR>", opts)
end

function M.init()
    local group_name = "vimrc_mason_lspconfig"
    vim.filetype.add({pattern = {['.*/*.asasm'] = "asasm"}})
    vim.api.nvim_create_augroup(group_name, {clear = true})

    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local bufnr = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client and client.supports_method("textDocument/inlayHint") then
                vim.lsp.inlay_hint.enable(true, {bufnr = bufnr})
            end
        end,
        group = group_name
    })
end
function M.config(_, opts)
    -- vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
    --                                              vim.lsp.handlers.hover,
    --                                              {border = 'rounded'})
    -- vim.lsp.handlers['textDocument/signatureHelp'] =
    --     vim.lsp.with(vim.lsp.handlers.signature_help, {border = 'rounded'})
    local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp
                                                                          .protocol
                                                                          .make_client_capabilities())
    -- require("mason-lspconfig").setup(opts)
    --
    local configs = require("lspconfig.configs")
    local lspconfig = require("lspconfig")
    if not configs.fish_lsp then
        configs.fish_lsp = {
            default_config = {
                cmd = {"fish-lsp", "start"},
                filetypes = {"fish"},
                root_dir = lspconfig.util.root_pattern(".git", vim.fn.getcwd()),
                settings = {}
            }
        }
    end
    lspconfig.fish_lsp.setup({
        on_attach = function(client, bufnr)
            client.server_capabilities.signatureHelpProvider = false
            if on_attach(client, bufnr) then on_attach(client, bufnr) end
        end,
        capabilities = capabilities
    })
    require("mason-lspconfig").setup({
        handlers = {
            function(server_name)
                if server_name ~= "fish_lsp" then
                    lspconfig[server_name].setup({
                        capabilities = capabilities,
                        on_attach = on_attach
                    })
                end
            end,
            ["lua_ls"] = function()
                require("lspconfig").lua_ls.setup({
                    settings = {
                        Lua = {
                            runtime = {
                                -- Tell the language server which version of Lua you're using
                                -- (most likely LuaJIT in the case of Neovim)
                                version = 'LuaJIT'
                            },
                            diagnostics = {globals = {'vim', 'require'}},
                            workspace = {
                                checkThirdParty = false,
                                library = {
                                    vim.env.VIMRUNTIME, "${3rd}/luv/library",
                                    "${3rd}/busted/library"
                                },
                                telemetry = {enable = false}
                            }
                        }
                    }
                })
            end,
            ["pyright"] = function()
                require("lspconfig").pyright.setup({
                    on_attach = on_attach,
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
                local py_path = os.getenv("VIRTUAL_ENV") or
                                    vim.g.python3_host_prog
                require("lspconfig").pylsp.setup({
                    capabilities = capabilities,
                    on_attach = on_attach,
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
                    on_attach = on_attach,
                    capabilities = capabilities,
                    settings = {
                        bashIde = {globPattern = "*@(.sh|.inc|.bash|.command)"}
                    }
                })
            end,
            ["gradle_ls"] = function()
                require("lspconfig").gradle_ls.setup({
                    on_attach = on_attach,
                    capabilities = capabilities,
                    settings = {gradleWrapperEnabled = true}
                })
            end,
            ["rust_analyzer"] = function()
                require("lspconfig").rust_analyzer.setup({
                    on_attach = on_attach,
                    capabilities = capabilities,
                    imports = {
                        granularity = {group = "module"},
                        prefix = "self"
                    },
                    cargo = {buildScripts = {enable = true}},
                    procMacro = {enable = true}
                })
            end,
            ["dockerls"] = function()
                require("lspconfig").dockerls.setup({
                    capabilities = capabilities,
                    on_attach = on_attach,
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
                    on_attach = on_attach,
                    capabilities = capabilities
                })
            end,
            ["asm_lsp"] = function()
                require("lspconfig").asm_lsp.setup({
                    cmd = {"asm-lsp"},
                    filetypes = {"asm", "s", "S", "vmasm", "asasm", "abc"},
                    on_attach = on_attach,
                    capabilities = capabilities
                })
            end
        }
    })
end

return M
