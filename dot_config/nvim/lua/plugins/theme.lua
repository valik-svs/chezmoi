return {
  {
    "folke/tokyonight.nvim",
    opts = function(_, opts)
      opts.style = vim.o.background == "light" and "day" or "night"
      opts.styles = opts.styles or {}
      opts.styles.comments = { italic = false }
      opts.styles.keywords = { italic = false }
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
  {
    "f-person/auto-dark-mode.nvim",
    event = "VeryLazy",
    opts = {
      update_interval = 1000,
      set_dark_mode = function()
        vim.o.background = "dark"
        vim.cmd.colorscheme("tokyonight-night")
      end,
      set_light_mode = function()
        vim.o.background = "light"
        vim.cmd.colorscheme("tokyonight-day")
      end,
    },
  },
}
