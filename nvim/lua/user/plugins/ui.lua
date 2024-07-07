return {
  {
    "dracula.nvim",
    colorscheme = "dracula",
    after = function()
      vim.cmd.colorscheme("dracula")
    end,
    event = "VimEnter",
  },
  {
    "barbar.nvim",
    after = function()
      require("barbar").setup({
        ["animation"] = false,
        auto_hide = 0,
        exclude_ft = {'dump'},
      })
      vim.keymap.set("n", "<C-n>", "<Cmd>BufferNext<CR>")
      vim.keymap.set("n", "<C-p>", "<Cmd>BufferPrevious<CR>")
      vim.keymap.set("n", "<C-q>", "<Cmd>BufferClose<CR>")
    end,
    event = "BufEnter",
  },
  {
    "cellwidths.nvim",
    after = function()
      require("cellwidths").setup { name = "default" }
    end,
    event = "VimEnter",
  },
}
