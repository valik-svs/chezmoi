-- Options are loaded before lazy.nvim startup.

local function system_background()
  if vim.env.SYSTEM_APPEARANCE == "light" then
    return "light"
  end
  if vim.env.SYSTEM_APPEARANCE == "dark" then
    return "dark"
  end
  if vim.fn.has("macunix") == 1 then
    local style = vim.fn.system("defaults read -g AppleInterfaceStyle 2>/dev/null")
    return style:match("Dark") and "dark" or "light"
  end
  return "dark"
end

vim.o.background = system_background()

vim.g.lazyvim_picker = "snacks"
vim.g.lazyvim_python_lsp = "pyright"
vim.g.lazyvim_python_ruff = "ruff"
vim.g.lazyvim_ts_lsp = "vtsls"

vim.opt.clipboard = "unnamedplus"
vim.opt.confirm = true
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.inccommand = "split"
vim.opt.list = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.shiftround = true
vim.opt.shiftwidth = 2
vim.opt.sidescrolloff = 8
vim.opt.smartcase = true
vim.opt.softtabstop = 2
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.timeoutlen = 400
vim.opt.undofile = true
vim.opt.updatetime = 200
vim.opt.wrap = false

vim.opt.langmap = table.concat({
  "йq",
  "цw",
  "уe",
  "кr",
  "еt",
  "нy",
  "гu",
  "шi",
  "щo",
  "зp",
  "х[",
  "ъ]",
  "фa",
  "ыs",
  "вd",
  "аf",
  "пg",
  "рh",
  "оj",
  "лk",
  "дl",
  "ж\\;",
  "э'",
  "яz",
  "чx",
  "сc",
  "мv",
  "иb",
  "тn",
  "ьm",
  "б\\,",
  "ю.",
  "ЙQ",
  "ЦW",
  "УE",
  "КR",
  "ЕT",
  "НY",
  "ГU",
  "ШI",
  "ЩO",
  "ЗP",
  "Х{",
  "Ъ}",
  "ФA",
  "ЫS",
  "ВD",
  "АF",
  "ПG",
  "РH",
  "ОJ",
  "ЛK",
  "ДL",
  "Ж:",
  'Э\\"',
  "ЯZ",
  "ЧX",
  "СC",
  "МV",
  "ИB",
  "ТN",
  "ЬM",
  "Б<",
  "Ю>",
}, ",")
