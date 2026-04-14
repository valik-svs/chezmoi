-- Keymaps are loaded on the VeryLazy event.

local map = vim.keymap.set

map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })
map("n", "<leader>ww", "<cmd>w<cr>", { desc = "Write" })
map("n", "<leader>wq", "<cmd>wq<cr>", { desc = "Write and Quit" })

map("n", "<leader>fp", function()
  local ok, snacks = pcall(require, "snacks")
  if ok and snacks.picker then
    snacks.picker.projects()
    return
  end
  vim.cmd("Lazy load telescope.nvim")
  require("telescope.builtin").find_files()
end, { desc = "Find Project" })

map("n", "<leader>fP", function()
  vim.cmd("edit " .. vim.fn.stdpath("config"))
end, { desc = "Open Neovim Config" })

map("n", "<leader>cx", "<cmd>LazyExtras<cr>", { desc = "LazyVim Extras" })
map("n", "<leader>cm", "<cmd>Mason<cr>", { desc = "Mason" })
