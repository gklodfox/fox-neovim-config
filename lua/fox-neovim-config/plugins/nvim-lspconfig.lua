local M = { "neovim/nvim-lspconfig" }

M.event = { "BufReadPre", "BufNewFile" }
M.dependencies = { "hrsh7th/cmp-nvim-lsp", "folke/neodev.nvim" }

function M.config()
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

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

  local signs = {
    { name = "DiagnosticSignError", text = "✘'" },
    { name = "DiagnosticSignWarn", text = "▲" },
    { name = "DiagnosticSignHint", text = "⚑" },
    { name = "DiagnosticSignInfo", text = "" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  local config = {
    virtual_text = true,
    signs = { active = signs },
    update_in_insert = false,
    underline = true,
    severity_sort = true,

  }
  vim.diagnostic.config(config)

  mason_lspconfig.setup_handlers({
    function(server_name)
      lspconfig[server_name].setup({
        capabilities = capabilities,
      })
    end,
    ["lua_ls"] = function()
      lspconfig["lua_ls"].setup({
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
      local venv_path = os.getenv("VIRTUAL_ENV")
      local py_path = nil
      if venv_path ~= nil then
        py_path = venv_path .. "/bin/python3"
      else
        py_path = vim.g.python3_host_prog
      end
      lspconfig["pylsp"].setup({
        on_attach = on_attach,
        settings = {
          pylsp = {
            plugins = {
              -- formatter
              black = { enabled = true },
              pylint = { enabled = false, executable = "pylint", args = { "-d C0114,C0115,C0116" } },
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
    ["groovyls"] = function()
      lspconfig["groovyls"].setup({
        filetypes = { "groovy" },
        cmd = {
          "java",
          "-jar",
          "/home/gklodkox/sources/groovy-language-server/build/libs/groovy-language-server-all.jar",
        },
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          groovy = {
            classpath = {
              vim.fn.expand("%"),
              string.gsub(vim.fn.system("git rev-parse --show-toplevel"), "\n", ""),
            },
          },
        },
      })
    end,
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
-- local M = {}
-- M.capabilities = vim.lsp.protocol.make_client_capabilities()
--
-- M.capabilities.textDocument.completion.completionItem.snippetSupport = true
-- M.capabilities = require("cmp_nvim_lsp").default_capabilities(M.capabilities)
--
-- local function set_lsp_keymaps(bufnr)
--   local opts = { noremap = true, silent = true }
--
--   vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
--   vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
--   vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
--   vim.api.nvim_buf_set_keymap(bufnr, "n",	"<leader>sh",	"<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
--   vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>",	opts)
--   vim.api.nvim_buf_set_keymap(bufnr, "n",	"<leader>wr",	"<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
--   vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>wl", "<cmd>lua function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end()<CR>", opts)
--   vim.api.nvim_buf_set_keymap(bufnr, "n",	"<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>",	opts)
--   vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ra", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
--   vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>",	opts)
--   vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
-- end
--
-- function M.on_attach(client, bufnr)
--   set_lsp_keymaps(bufnr)
-- end
--
-- function M.setup(_, opts)
--   local signs = {
--     { name = "DiagnosticSignError", text = "✘'" },
--     { name = "DiagnosticSignWarn", text = "▲" },
--     { name = "DiagnosticSignHint", text = "⚑" },
--     { name = "DiagnosticSignInfo", text = "" },
--   }
--
--   for _, sign in ipairs(signs) do
--     vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
--   end
--
--   local config = {
--     virtual_text = true,
--     signs = { active = signs },
--     update_in_insert = false,
--     underline = true,
--     severity_sort = true,
--
--   }
--   vim.diagnostic.config(config)
-- end
--
-- return M
-- local M = { "neovim/nvim-lspconfig" }
--
-- M.event = "User FilePost"
-- M.dependencies = {
-- 	"williamboman/mason-lspconfig.nvim",
-- 	"williamboman/mason.nvim",
-- 	"hrsh7th/cmp-nvim-lsp",
-- 	"jubnzv/virtual-types.nvim",
-- 	{
-- 		"folke/neodev.nvim",
-- 		opts = {
-- 			library = { plugins = { "nvim-dap-ui" }, types = true },
-- 		},
-- 	},
-- }
--
-- function M.config()
-- 	local on_attach = function(_, bufnr)
-- 		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "[LSP] Go to declaration" })
-- 		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "[LSP] Go to definition" })
-- 		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr, desc = "[LSP] Go to implementation" })
-- 		vim.keymap.set("n",	"<leader>sh",	vim.lsp.buf.signature_help, { buffer = bufnr, desc = "[LSP] Show signature help" })
-- 		vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder,	{ buffer = bufnr, desc = "[LSP] Add workspace folder" })
-- 		vim.keymap.set("n",	"<leader>wr",	vim.lsp.buf.remove_workspace_folder, { buffer = bufnr, desc = "[LSP] Remove workspace folder" })
-- 		vim.keymap.set("n", "<leader>wl", function()
-- 			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
-- 		end, { buffer = bufnr, desc = "[LSP] List workspace folders" })
-- 		vim.keymap.set("n",	"<leader>D", vim.lsp.buf.type_definition,	{ buffer = bufnr, desc = "[LSP] Go to type definition" })
-- 		vim.keymap.set("n", "<leader>ra", vim.lsp.buf.rename, { buffer = bufnr, desc = "[LSP] Rename " })
-- 		vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action,	{ buffer = bufnr, desc = "[LSP] Code action" })
-- 		vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr, desc = "[LSP] Show references" })
-- 	end
--
-- 	local lspconfig = require("lspconfig")
-- 	local mason_lspconfig = require("mason-lspconfig")
-- 	local cmp_nvim_lsp = require("cmp_nvim_lsp")
-- 	local protocol = require("vim.lsp.protocol")
--
-- 	local capabilities = vim.tbl_deep_extend(
-- 		"force",
-- 		protocol.make_client_capabilities(),
-- 		cmp_nvim_lsp.default_capabilities()
-- 	)
--
--   mason_lspconfig.setup_handlers({
--     function(server_name)
--       lspconfig[server_name].setup({
--         capabilities = capabilities,
--       })
--     end,
--     ["lua_ls"] = function()
--       lspconfig["lua_ls"].setup({
--         on_attach = on_attach,
--         capabilities = capabilities,
--         settings = {
--           Lua = {
--             runtime = { version = "LuaJIT" },
--             diagnostics = {
--               globals = { "vim" },
--             },
--             workspace = {
--               library = {
--                 vim.fn.expand("$VIMRUNTIME/lua"),
--                 vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
--                 vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy",
--                 "${3rd}/luv/library",
--               },
--             },
--           },
--         },
--       })
--     end,
--     ["pylsp"] = function()
--       local venv_path = os.getenv("VIRTUAL_ENV")
--       local py_path = nil
--       if venv_path ~= nil then
--         py_path = venv_path .. "/bin/python3"
--       else
--         py_path = vim.g.python3_host_prog
--       end
--       lspconfig["pylsp"].setup({
--         on_attach = on_attach,
--         settings = {
--           pylsp = {
--             plugins = {
--               -- formatter
--               black = { enabled = true },
--               pylint = { enabled = false, executable = "pylint", args = { "-d C0114,C0115,C0116" } },
--               pylsp_mypy = {
--                 enabled = true,
--                 overrides = { "--python-executable", py_path, true },
--                 report_progress = true,
--                 live_mode = true,
--               },
--               pycodestyle = {
--                 ignore = { "W391" },
--                 maxLineLength = 100,
--               },
--               isort = { enabled = true },
--             },
--           },
--         },
--         capabilities = capabilities,
--       })
--     end,
--     ["groovyls"] = function()
--       lspconfig["groovyls"].setup({
--         filetypes = { "groovy" },
--         cmd = {
--           "java",
--           "-jar",
--           "/home/gklodkox/sources/groovy-language-server/build/libs/groovy-language-server-all.jar",
--         },
--         on_attach = on_attach,
--         capabilities = capabilities,
--         settings = {
--           groovy = {
--             classpath = {
--               vim.fn.expand("%"),
--               string.gsub(vim.fn.system("git rev-parse --show-toplevel"), "\n", ""),
--             },
--           },
--         },
--       })
--     end,
--     ["rust_analyzer"] = function()
--       lspconfig["rust_analyzer"].setup({
--         filetypes = { "c", "cpp", "cc" },
--         on_attach = on_attach,
--         capabilities = capabilities,
--         settings = {
--           diagnostics = {
--             enable = false,
--           },
--         },
--       })
--     end,
--     ["clangd"] = function()
--       lspconfig["clangd"].setup({
--         filetypes = { "c", "cpp", "cc" },
--         on_attach = on_attach,
--         capabilities = capabilities,
--       })
--     end,
--     ["bashls"] = function()
--       lspconfig["bashls"].setup({
--         on_attach = on_attach,
--         capabilities = capabilities,
--       })
--     end,
--     ["vimls"] = function()
--       lspconfig["vimls"].setup({
--         on_attach = on_attach,
--         capabilities = capabilities,
--       })
--     end,
--     ["dockerls"] = function()
--       lspconfig["dockerls"].setup({
--         on_attach = on_attach,
--         settings = {
--           docker = {
--             languageserver = {
--               formatter = {
--                 ignoreMultilineInstructions = true,
--               },
--             },
--           },
--         },
--         capabilities = capabilities,
--       })
--     end
--   })
-- end
--
-- return M
