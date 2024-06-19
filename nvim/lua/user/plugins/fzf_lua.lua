return {
  "fzf-lua",
  after = function()
    vim.keymap.set("n", "<Leader>fs", "<Cmd>lua require('fzf-lua').live_grep()<CR>")
    vim.keymap.set("n", "<Leader>ff", "<Cmd>lua require('fzf-lua').files()<CR>")
    vim.keymap.set("n", "<Leader>fb", "<Cmd>lua require('fzf-lua').blines()<CR>")
  end,
}

