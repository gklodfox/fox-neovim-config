local M = { "williamboman/mason-lspconfig.nvim" }

M.dependencies = {
  "stevearc/conform.nvim",
  "hrsh7th/cmp-nvim-lsp",
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({
        install_root_dir = vim.fn.stdpath("data") .. "/mason",
        PATH = "prepend",
        ui = {
          border = "rounded",
          icons = {
            package_installed = "✓",
            package_pending = "~",
            package_uninstalled = "✗",
          },
        },
        registries = {
          "github:mason-org/mason-registry",
        },
        providers = {
          "mason.providers.registry-api",
          "mason.providers.client",
        },
        log_level = vim.log.levels.INFO,
        max_concurrent_installers = 8,
      })
    end,
  },
  { "neovim/nvim-lspconfig", lazy = true, dependencies = { "williamboman/mason-lspconfig.nvim" } },
  "ray-x/lsp_signature.nvim",
  "simrat39/rust-tools.nvim",
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  "rshkarin/mason-nvim-lint",
  "zapling/mason-conform.nvim",
}

function M.init()
  local sign = function(opts)
    vim.fn.sign_define(opts.name, {
      texthl = opts.name,
      text = opts.text,
      numhl = "",
    })
  end
  vim.opt.rtp:prepend(vim.fn.expand('~') .. "/.local/share/nvim/mason")

  sign({ name = "DiagnosticSignError", text = "✘" })
  sign({ name = "DiagnosticSignWarn", text = "▲" })
  sign({ name = "DiagnosticSignHint", text = "⚑" })
  sign({ name = "DiagnosticSignInfo", text = "" })

  vim.diagnostic.config({
    virtual_text = true,
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      border = "rounded",
    },
  })
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
  vim.filetype.add({ pattern = { [".*/*.asasm"] = "asasm" } })
  vim.api.nvim_create_autocmd("LspAttach", {
    desc = "LSP actions",
    callback = function()
      local bufmap = function(mode, lhs, rhs)
        local opts = { buffer = true }
        vim.keymap.set(mode, lhs, rhs, opts)
      end
      bufmap("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>")
      bufmap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>")
      bufmap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>")
      bufmap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>")
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
  -- require("neodev").setup({})
  local lspconfig = require("lspconfig")
  local lsp_capabilities = vim.tbl_deep_extend(
    "force",
    vim.lsp.protocol.make_client_capabilities(),
    require("cmp_nvim_lsp").default_capabilities()
  )
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
      "basedpyright",
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
  lspconfig.asm_lsp.setup({ capabilities = lsp_capabilities })
  local neocmake_cap = lsp_capabilities
  neocmake_cap.textDocument.completion.completionItem.snippetSupport = true
  lspconfig.diagnosticls.setup({ capabilities = lsp_capabilities })
  lspconfig.dockerls.setup({ capabilities = lsp_capabilities })
  lspconfig.marksman.setup({ capabilities = lsp_capabilities })
  lspconfig.rust_analyzer.setup({ capabilities = lsp_capabilities })
  lspconfig.vimls.setup({ capabilities = lsp_capabilities })
  lspconfig.yamlls.setup({ capabilities = lsp_capabilities })
  lspconfig.html.setup({ capabilities = lsp_capabilities })
  lspconfig.jsonls.setup({ capabilities = lsp_capabilities })
  lspconfig.taplo.setup({ capabilities = lsp_capabilities })
  lspconfig.markdown_oxide.setup({ capabilities = lsp_capabilities })
  lspconfig.gradle_ls.setup({ capabilities = lsp_capabilities })
  lspconfig.fish_lsp.setup({
    cmd = {"fish-lsp", "start", "--disable", "signature"},
    cmd_env = {
      fish_lsp_show_client_popups = false
    },
    filetypes = {"fish"},
    capabilities = lsp_capabilities,
  })
  lspconfig.groovyls.setup({
    cmd = {"java", "-jar", "/home/fox/Sources/groovy-language-server/build/libs/groovy-language-server-all.jar"},
    capabilities = lsp_capabilities
  })
  lspconfig.lua_ls.setup({
    settings = {
      Lua = {
        runtime = {
          version = "Lua5.1",
        },
        diagnostics = { globals = { "vim" } },
        -- Make the server aware of Neovim runtime files
        workspace = {
          checkThirdParty = true,
          library = {
            vim.env.VIMRUNTIME,
            "${3rd}/luv/library",
            "${3rd}/busted/library",
            vim.api.nvim_get_runtime_file("", true),
          },
        },
        capabilities = lsp_capabilities,
      },
    },
  })
  lspconfig.basedpyright.setup({
    settings = {
      basedpyright = {
        analysis = {
          autoSearchPaths = true,
          diagnosticMode = "openFilesOnly",
          useLibraryCodeForTypes = true,
        },
      },
    },
    capabilities = lsp_capabilities,
  })
  lspconfig.pylsp.setup({
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
    capabilities = lsp_capabilities,
  })
  lspconfig.bashls.setup({
    settings = {
      bashIde = { globPattern = "*@(.sh|.inc|.bash|.command)" },
    },
    capabilities = lsp_capabilities,
  })
  local temp_cap = {
    offsetEncoding = { "utf-16" },
    textDocument = {
      completion = {
        editsNearCursor = true,
      },
    },
  }
  lspconfig.clangd.setup({
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
    cmd = { "clangd" },
    capabilities = vim.tbl_deep_extend("force", lsp_capabilities, temp_cap),
    init_options = {
      fallbackFlags = { "-std=c++17" },
    },
  })
  lspconfig.neocmake.setup({
    cmd = { "neocmakelsp", "--stdio" },
    filetypes = { "cmake" },
    root_dir = function(fname)
      return require("lspconfig").util.find_git_ancestor(fname)
    end,
    single_file_support = true,     -- suggested
    capabilities = lsp_capabilities,
    init_options = {
      format = {
        enable = true,
      },
      lint = {
        enable = true,
      },
      scan_cmake_in_package = true,     -- default is true
    },
  })
  lspconfig.texlab.setup({
    capabilities = lsp_capabilities,
    settings = {
      texlab = {
        bibtexFormatter = "texlab",
        build = {
          args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
          executable = "latexmk",
          forwardSearchAfter = false,
          onSave = true,
        },
        chktex = {
          onEdit = true,
          onOpenAndSave = true,
        },
        diagnosticsDelay = 300,
        formatterLineLength = 80,
        forwardSearch = {
          args = {},
        },
        latexFormatter = "tex-fmt",
        latexindent = {
          modifyLineBreaks = false,
        },
      },
    },
  })
  require("mason-conform").setup({
    ensure_installed = {
      -- "latexindent",
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
    ensure_installed = {
      -- "ast-grep",
      "checkmake",
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
      "commitlint",
      "misspell",
      "mypy",
      "pydocstyle",
      "pyflakes",
      "pylint",
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
    },
    automatic_installation = true,
    quiet_mode = false,
  })
end

return M
