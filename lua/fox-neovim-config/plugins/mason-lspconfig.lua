local M = { "williamboman/mason-lspconfig.nvim" }

M.dependencies = {
  "stevearc/conform.nvim",
  "hrsh7th/cmp-nvim-lsp",
  "neovim/nvim-lspconfig",
  "ray-x/lsp_signature.nvim",
  "simrat39/rust-tools.nvim",
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  "rshkarin/mason-nvim-lint",
  "zapling/mason-conform.nvim",
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
}

function M.init()
  local signs = {
    { name = "DiagnosticSignError", text = "✘'" },
    { name = "DiagnosticSignWarn", text = "▲" },
    { name = "DiagnosticSignHint", text = "⚑" },
    { name = "DiagnosticSignInfo", text = "" },
  }
  vim.diagnostic.config({
    virtual_text = true,
    signs = { active = signs },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
  })
  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end
  vim.filetype.add({ pattern = { [".*/*.asasm"] = "asasm" } })
end

function M.config(_, opts)
  -- require("neodev").setup({})
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  -- Add cmp_nvim_lsp capabilities settings to lspconfig
  -- This should be executed before you configure any language server
  capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

  local servers = {
    asm_lsp = {},
    lua_ls = {
      settings = {
        Lua = {
          completion = {
            callSnippet = "Replace",
          },
          diagnostics = { disable = { "missing-fields" } },
        },
      },
    },
    pylsp = {
      settings = {
        pylsp = {
          plugins = {
            -- formatter
            black = { enabled = true },
            pylint = {
              enabled = true,
              -- executable = "pylint",
              args = { "-d C0114,C0115,C0116" },
            },
            pylsp_mypy = {
              enabled = true,
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
    },
    bashls = {
      settings = {
        bashIde = { globPattern = "*@(.sh|.inc|.bash|.command)" },
      },
    },
    gradle_ls = {},
    rust_analyzer = {},
    marksman = {},
    clangd = {},
    cmake = {},
    diagnosticls = {},
    dockerls = {},
    html = {},
    grammarly = {},
    jsonls = {},
    yamlls = {},
    markdown_oxide = {},
    ruff = {},
    taplo = {},
    textlsp = {},
    vimls = {},
  }
  vim.api.nvim_create_autocmd("LspAttach", {
    desc = "LSP actions",
    callback = function(event)
      local opts = { buffer = event.buf }

      vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
      vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
      vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
      vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
      vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
      vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
      vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
      vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
      vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
      vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
      local bufnr = event.buf
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client.supports_method("textDocument/inlayHint") then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      end
      require("lsp_signature").on_attach({
        bind = true,
        handler_opts = { border = "rounded" },
      })
    end,
  })
  require("mason-tool-installer").setup({
    auto_update = true,
    run_on_start = true,
    start_delay = 3000,
    integrations = {
      ["mason-lspconfig"] = true,
      ["mason-null-ls"] = false,
      ["mason-nvim-dap"] = true,
    },
    ensure_installed = {
      "ast_grep",
      "asm_lsp",
      "bashls",
      "cmake",
      "diagnosticls",
      "dockerls",
      "gradle_ls",
      "lua_ls",
      "pylsp",
      "marksman",
      -- "pyright",
      "rust_analyzer",
      "vimls",
      "yamlls",
      "clangd",
      "grammarly",
      -- "groovyls",
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
      "textlsp",
    },
  })
  require("mason").setup({})
  require("mason-lspconfig").setup({
    handlers = {
      function(server_name)
        local server = servers[server_name] or {}
        server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
        require("lspconfig")[server_name].setup(server)
      end,
    },
  })
  require("mason-conform").setup({
    ensure_installed = {
      "autoflake",
      "autopep8",
      "black",
      "isort",
      "cmake_format",
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
    ensure_installed = {
      "ast-grep",
      "checkmake",
      "cmakelang",
      "cmakelint",
      "codespell",
      "cpplint",
      "editorconfig-checker",
      "eslint_d",
      "flake8",
      "htmlhint",
      "jsonlint",
      "luacheck",
      "markdownlint",
      "markdownlint-cli2",
      "misspell",
      "mypy",
      "pydocstyle",
      "pyflakes",
      "pylint",
      "pyproject-flake8",
      "revive",
      "ruff",
      "shellcheck",
      "staticcheck",
      "systemdlint",
      "vint",
      "yamllint",
      "npm-groovy-lint",
      "bacon",
      "commitlint",
      "textlint",
    },
    automatic_installation = true,
    quiet_mode = false,
  })
end

return M
