return {
  "nvim-markdown",
  after = function()
    vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("my_nvim_markdown", { clear = true }),
        pattern = "markdown",
        callback = function()
            vim.keymap.set("n", "<CR>", "<Plug>Markdown_FollowLink", { buffer = true })
            vim.keymap.set("i", "<Tab>", "<Plug>Markdown_Jump", { buffer = true })
            vim.keymap.set("i", "<CR>", "<Plug>Markdown_NewLineBelow", { buffer = true })
        end,
    })
  end,
  ft = "markdown",
}
