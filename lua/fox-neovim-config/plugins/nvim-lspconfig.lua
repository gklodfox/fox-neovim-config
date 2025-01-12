local M = { "neovim/nvim-lspconfig" }

M.event = { "BufReadPre", "BufNewFile" }
M.dependencies = { "hrsh7th/cmp-nvim-lsp" }--, "folke/neodev.nvim" }

function M.config(_, opts)
  local lspconfig = require("lspconfig")
  local mason_lspconfig = require("mason-lspconfig")

  local on_attach = function(_, bufnr)
    local opts = { noremap = true, silent = true }

    vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n",	"<leader>sh",	"<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>",	opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n",	"<leader>wr",	"<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>wl", "<cmd>lua function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n",	"<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>",	opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ra", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>",	opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  end

  local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

  local signs = {
    { name = "DiagnosticSignError", text = "✘'" },
    { name = "DiagnosticSignWarn", text = "▲" },
    { name = "DiagnosticSignHint", text = "⚑" },
    { name = "DiagnosticSignInfo", text = "" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  vim.diagnostic.config({
    virtual_text = true,
    signs = { active = signs },
    update_in_insert = false,
    underline = true,
    severity_sort = true,
  })

  mason_lspconfig.setup_handlers({
    function(server_name)
      lspconfig[server_name].setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })
    end,
    ["lua_ls"] = function()
      lspconfig["lua_ls"].setup({
        -- on_init = function(client)
        --   if client.workspace_folders then
        --     local path = client.workspace_folders[1].name
        --     if vim.uv.fs_stat(path..'/.luarc.json') or vim.uv.fs_stat(path..'/.luarc.jsonc') then
        --       return
        --     end
        --   end
        -- end,
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = {
                vim.fn.expand("$VIMRUNTIME/lua"),
                vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
                vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy",
                "${3rd}/luv/library",
              },
            },
          },
        },
      })
    end,
    ["pylsp"] = function()
      local py_path = os.getenv("VIRTUAL_ENV") or vim.g.python3_host_prog
      lspconfig["pylsp"].setup({
        on_attach = on_attach,
        settings = {
          pylsp = {
            plugins = {
              -- formatter
              black = { enabled = true },
              pylint = { enabled = true, executable = "pylint", args = { "-d C0114,C0115,C0116" } },
              pylsp_mypy = {
                enabled = true,
                overrides = { "--python-executable", py_path, true },
                report_progress = true,
                live_mode = true,
              },
              pycodestyle = {
                ignore = { "W391" },
                maxLineLength = 100,
              },
              isort = { enabled = true },
            },
          },
        },
        capabilities = capabilities,
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
      lspconfig["rust_analyzer"].setup({
        filetypes = { "c", "cpp", "cc" },
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          diagnostics = {
            enable = false,
          },
        },
      })
    end,
    ["clangd"] = function()
      lspconfig["clangd"].setup({
        filetypes = { "c", "cpp", "cc" },
        on_attach = on_attach,
        capabilities = capabilities,
      })
    end,
    ["bashls"] = function()
      lspconfig["bashls"].setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })
    end,
    ["vimls"] = function()
      lspconfig["vimls"].setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })
    end,
    ["dockerls"] = function()
      lspconfig["dockerls"].setup({
        on_attach = on_attach,
        settings = {
          docker = {
            languageserver = {
              formatter = {
                ignoreMultilineInstructions = true,
              },
            },
          },
        },
        capabilities = capabilities,
      })
    end
  })
end

return M
