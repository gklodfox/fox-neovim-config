local M = { "neovim/nvim-lspconfig" }

M.event = "User FilePost"
M.dependencies = {
	"williamboman/mason-lspconfig.nvim",
	"williamboman/mason.nvim",
	"hrsh7th/cmp-nvim-lsp",
	"jubnzv/virtual-types.nvim",
	{
		"folke/neodev.nvim",
		opts = {
			library = { plugins = { "nvim-dap-ui" }, types = true },
		},
	},
}

function M.config()
	local on_attach = function(_, bufnr)
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "[LSP] Go to declaration" })
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "[LSP] Go to definition" })
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr, desc = "[LSP] Go to implementation" })
		vim.keymap.set("n",	"<leader>sh",	vim.lsp.buf.signature_help, { buffer = bufnr, desc = "[LSP] Show signature help" })
		vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder,	{ buffer = bufnr, desc = "[LSP] Add workspace folder" })
		vim.keymap.set("n",	"<leader>wr",	vim.lsp.buf.remove_workspace_folder, { buffer = bufnr, desc = "[LSP] Remove workspace folder" })
		vim.keymap.set("n", "<leader>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, { buffer = bufnr, desc = "[LSP] List workspace folders" })
		vim.keymap.set("n",	"<leader>D", vim.lsp.buf.type_definition,	{ buffer = bufnr, desc = "[LSP] Go to type definition" })
		vim.keymap.set("n", "<leader>ra", vim.lsp.buf.rename, { buffer = bufnr, desc = "[LSP] Rename " })
		vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action,	{ buffer = bufnr, desc = "[LSP] Code action" })
		vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr, desc = "[LSP] Show references" })
	end

	local lspconfig = require("lspconfig")
	local mason_lspconfig = require("mason-lspconfig")
	local cmp_nvim_lsp = require("cmp_nvim_lsp")
	local protocol = require("vim.lsp.protocol")

	local capabilities = vim.tbl_deep_extend(
		"force",
		protocol.make_client_capabilities(),
		cmp_nvim_lsp.default_capabilities()
	)

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
