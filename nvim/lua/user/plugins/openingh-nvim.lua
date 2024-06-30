return {
  "openingh.nvim",
  after = function()
    vim.keymap.set("n", "<Leader>ho", "<Cmd>OpenInGHFile<CR>")
    vim.keymap.set("v", "<Leader>ho", "<Esc><Cmd>'<,'>OpenInGHFile<CR>")
  end,
  keys = { { "<Leader>ho", mode = "n" }, { "<Leader>ho", mode = "v" } },
}
