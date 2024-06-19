return {
  "copilot.vim",
  after = function()
    vim.g.copilot_filetypes = { markdown = false }
    -- https://github.com/orgs/community/discussions/29817#discussioncomment-4217615
    vim.keymap.set("i", "<C-l>", 'copilot#Accept("<CR>")', { silent = true, expr = true, script = true, replace_keycodes = false })
    vim.keymap.set("i", "<C-j>", "<Plug>(copilot-next)")
    vim.keymap.set("i", "<C-k>", "<Plug>(copilot-previous)")
    vim.keymap.set("i", "<C-o>", "<Plug>(copilot-dismiss)")
    vim.keymap.set("i", "<C-f>", "<Plug>(copilot-suggest)")
  end,
  event = "BufEnter", -- TODO: Use keys event
}
