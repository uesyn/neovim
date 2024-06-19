return {
  "dracula.nvim",
  colorscheme = "dracula",
  after = function()
    vim.cmd.colorscheme("dracula")
  end,
  event = "VimEnter",
}
