return {
  "barbar.nvim",
  after = function()
    require("barbar").setup({ ["animation"] = false })
    vim.keymap.set("n", "<C-n>", "<Cmd>BufferNext<CR>")
    vim.keymap.set("n", "<C-p>", "<Cmd>BufferPrevious<CR>")
    vim.keymap.set("n", "<C-q>", "<Cmd>BufferClose<CR>")
  end,
  event = "BufEnter",
}
