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
      capabilities.capabilities = vim.tbl_deep_extend(
        'force',
        capabilities.capabilities,
        require('cmp_nvim_lsp').default_capabilities()
      )

      -- LspAttach is where you enable features that only work
      -- if there is a language server active in the file
      vim.api.nvim_create_autocmd('LspAttach', {
        desc = 'LSP actions',
        callback = function(event)
          local opts = {buffer = event.buf}

          vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
          vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
          vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
          vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
          vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
          vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
          vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
          vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
          vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
          vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
          local bufnr = event.buf
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method("textDocument/inlayHint") then
              vim.lsp.inlay_hint.enable(true, {bufnr = bufnr})
          end
          require("lsp_signature").on_attach({
              bind = true,
              handler_opts = {border = "rounded"}
          })
      end,
    })
    -- local configs = require("lspconfig.configs")
    -- local lspconfig = require("lspconfig")
    -- if not configs.fish_lsp then
    --     configs.fish_lsp = {
    --         default_config = {
    --             cmd = {"fish-lsp", "start"},
    --             filetypes = {"fish"},
    --             root_dir = lspconfig.util.root_pattern(".git", vim.fn.getcwd()),
    --             settings = {}
    --         }
    --     }
    -- end
    -- lspconfig.fish_lsp.setup({
    --     on_attach = function(client, bufnr)
    --         client.server_capabilities.signatureHelpProvider = false
    --         if on_attach(client, bufnr) then on_attach(client, bufnr) end
    --     end,
    --     capabilities = capabilities
    -- })
    require("mason").setup({})
    require("mason-lspconfig").setup({
        handlers = {
            function(server_name)
                require("lspconfig")[server_name].setup({
                    capabilities = capabilities,
                })
            end,
            ["lua_ls"] = function()
                require("lspconfig").lua_ls.setup({
                    settings = {Lua = {telemetry = {enable = false}}},
                    on_init = function(client)
                        local join = vim.fs.joinpath
                        local path = client.workspace_folders[1].name

                        -- Don't do anything if there is project local config
                        if vim.uv.fs_stat(join(path, '.luarc.json')) or
                            vim.uv.fs_stat(join(path, '.luarc.jsonc')) then
                            return
                        end

                        -- Apply neovim specific settings
                        local runtime_path = vim.split(package.path, ';')
                        table.insert(runtime_path, join('lua', '?.lua'))
                        table.insert(runtime_path, join('lua', '?', 'init.lua'))

                        local nvim_settings = {
                            runtime = {
                                -- Tell the language server which version of Lua you're using
                                version = 'LuaJIT',
                                path = runtime_path
                            },
                            diagnostics = {
                                -- Get the language server to recognize the `vim` global
                                globals = {'vim'}
                            },
                            workspace = {
                                checkThirdParty = true,
                                library = {
                                    -- Make the server aware of Neovim runtime files
                                    vim.env.VIMRUNTIME, vim.fn.stdpath('config'), "${3rd}/luv/library"
                                }
                            }
                        }
                        client.config.settings.Lua =
                            vim.tbl_deep_extend('force',
                                                client.config.settings.Lua,
                                                nvim_settings)
                    end
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
                local py_path = os.getenv("VIRTUAL_ENV") or
                                    vim.g.python3_host_prog
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
                    settings = {gradleWrapperEnabled = true}
                })
            end,
            ["rust_analyzer"] = function()
                require("lspconfig").rust_analyzer.setup({
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
                    settings = {
                        docker = {
                            languageserver = {
                                formatter = {ignoreMultilineInstructions = true}
                            }
                        }
                    }
                })
            end,
            ["asm_lsp"] = function()
                require("lspconfig").asm_lsp.setup({
                    cmd = {"asm-lsp"},
                    filetypes = {"asm", "s", "S", "vmasm", "asasm", "abc"},
                    capabilities = capabilities
                })
            end
        }
    })
end

return M
