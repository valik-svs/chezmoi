local js_like = {
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
  "vue",
}

return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "debugpy",
        "eslint_d",
        "js-debug-adapter",
        "json-lsp",
        "markdownlint-cli2",
        "prettier",
        "pyright",
        "ruff",
        "shellcheck",
        "shfmt",
        "stylua",
        "taplo",
        "vtsls",
        "yaml-language-server",
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.format_on_save = {
        timeout_ms = 3000,
        lsp_format = "fallback",
      }
      opts.formatters_by_ft = vim.tbl_deep_extend("force", opts.formatters_by_ft or {}, {
        python = { "ruff_organize_imports", "ruff_format" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        markdown = { "prettier" },
        yaml = { "prettier" },
        toml = { "taplo" },
      })
    end,
  },
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.python = { "ruff" }
      opts.linters_by_ft.markdown = { "markdownlint-cli2" }
      for _, ft in ipairs(js_like) do
        opts.linters_by_ft[ft] = { "eslint_d" }
      end
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "bash",
        "css",
        "dockerfile",
        "html",
        "http",
        "javascript",
        "json",
        "jsonc",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "regex",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      })
    end,
  },
}
