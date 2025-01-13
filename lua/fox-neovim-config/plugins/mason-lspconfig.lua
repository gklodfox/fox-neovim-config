local M = {"williamboman/mason-lspconfig.nvim"}

M.dependencies = {"hrsh7th/cmp-nvim-lsp", "neovim/nvim-lspconfig", "ray-x/lsp_signature.nvim"}
M.event = "VimEnter"

local on_attach = function(client, bufnr)
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

  require("lsp_signature").on_attach()
end

function M.init()
  local signs = {
    {name = "DiagnosticSignError", text = "✘'"},
    {name = "DiagnosticSignWarn", text = "▲"},
    {name = "DiagnosticSignHint", text = "⚑"},
    {name = "DiagnosticSignInfo", text = ""}
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name,
      {texthl = sign.name, text = sign.text, numhl = ""})
  end

  vim.diagnostic.config({
    virtual_text = true,
    signs = {active = signs},
    update_in_insert = false,
    underline = true,
    severity_sort = true
  })
  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
    vim.lsp.handlers.hover,
    {border = 'rounded'}
  )

  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    {border = 'rounded'}
  )
  local group_name = "vimrc_mason_lspconfig"
  vim.api.nvim_create_augroup(group_name, {clear = true})

  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client.supports_method("textDocument/inlayHint") then
        vim.lsp.inlay_hint.enable(true, {bufnr = bufnr})
      end
    end, group = group_name})
end

function M.config(_, opts)
  require("mason-lspconfig").setup(opts)
  local capabilities = vim.tbl_deep_extend("force", vim.lsp.protocol
    .make_client_capabilities(),
    require('cmp_nvim_lsp').default_capabilities())
  require("mason-lspconfig").setup_handlers({
    ["lua_ls"] = function()
      require("lspconfig")["lua_ls"].setup({
        on_attach = on_attach,
        capabilities = capabilities,
        on_init = function(client)
          if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if vim.uv.fs_stat(path .. '/.luarc.json') or
              vim.uv.fs_stat(path .. '/.luarc.jsonc') then
              return
            end
          end
          client.config.settings.Lua =
          vim.tbl_deep_extend("force", client.config.settings.Lua,
            {
              runtime = {version = "LuaJIT"},
              -- diagnostics = {globals = {"vim"}},
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
              }
            }
          )
        end,
        settings = {Lua = {}}
      })
    end,
    ["pyright"] = function()
      require("lspconfig")["pyright"].setup({
        on_attach = on_attach,
        capabilities = capabilities
      })
    end,
    ["pylsp"] = function()
      local py_path = os.getenv("VIRTUAL_ENV") or vim.g.python3_host_prog
      require("lspconfig")["pylsp"].setup({
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
    -- ["groovyls"] = function()
    --   lspconfig["groovyls"].setup({
    --     filetypes = { "groovy" },
    --     cmd = {
    --       "java",
    --       "-jar",
    --       "/home/gklodkox/sources/groovy-language-server/build/libs/groovy-language-server-all.jar",
    --     },
    --     on_attach = on_attach,
    --     capabilities = capabilities,
    --     settings = {
    --       groovy = {
    --         classpath = {
    --           vim.fn.expand("%"),
    --           string.gsub(vim.fn.system("git rev-parse --show-toplevel"), "\n", ""),
    --         },
    --       },
    --     },
    --   })
    -- end,
    ["rust_analyzer"] = function()
      require("lspconfig")["rust_analyzer"].setup({
        filetypes = {"c", "cpp", "cc", "rust"},
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {diagnostics = {enable = true}}
      })
    end,
    ["dockerls"] = function()
      require("lspconfig")["dockerls"].setup({
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
    function(server_name)
      require("lspconfig")[server_name].setup({
        capabilities = capabilities,
        on_attach = on_attach
      })
    end
  })
end

return M
