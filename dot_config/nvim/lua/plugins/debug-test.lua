return {
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "marilari88/neotest-vitest",
      "nvim-neotest/neotest-jest",
      "thenbe/neotest-playwright",
    },
    opts = function(_, opts)
      opts.adapters = opts.adapters or {}
      opts.adapters["neotest-vitest"] = {}
      opts.adapters["neotest-jest"] = {
        jestCommand = "npm test --",
        jestConfigFile = function(file)
          local root = LazyVim.root.get({ normalize = true })
          local configs = {
            "jest.config.ts",
            "jest.config.js",
            "jest.config.mjs",
            "jest.config.cjs",
          }
          for _, config in ipairs(configs) do
            local path = root .. "/" .. config
            if vim.uv.fs_stat(path) then
              return path
            end
          end
          return vim.fn.fnamemodify(file, ":p:h")
        end,
        cwd = function()
          return LazyVim.root.get({ normalize = true })
        end,
      }
      opts.adapters["neotest-playwright"] = {
        options = {
          persist_project_selection = true,
          enable_dynamic_test_discovery = true,
        },
      }
    end,
  },
  {
    "mfussenegger/nvim-dap-python",
    optional = true,
    opts = {
      include_configs = true,
    },
  },
}
