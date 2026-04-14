return {
  {
    "LazyVim/LazyVim",
    init = function()
      vim.api.nvim_create_autocmd("VimEnter", {
        group = vim.api.nvim_create_augroup("user_tutor_locale", { clear = true }),
        callback = function()
          vim.api.nvim_create_user_command("Tutor", function(opts)
            local arg = vim.trim(opts.args or "")
            if arg == "ru" then
              vim.cmd("language messages ru_RU.UTF-8")
              vim.fn["tutor#TutorCmd"]("")
              return
            end
            if arg == "en" then
              vim.cmd("language messages C.UTF-8")
              vim.fn["tutor#TutorCmd"]("")
              return
            end
            vim.fn["tutor#TutorCmd"](arg)
          end, {
            nargs = "?",
            complete = function(lead, line, pos)
              local items = { "ru", "en" }
              local builtins = vim.fn["tutor#TutorCmdComplete"](lead, line, pos)
              if type(builtins) == "string" and builtins ~= "" then
                vim.list_extend(items, vim.split(builtins, "\n", { plain = true, trimempty = true }))
              elseif type(builtins) == "table" then
                vim.list_extend(items, builtins)
              end
              return items
            end,
          })
        end,
      })
    end,
  },
}
