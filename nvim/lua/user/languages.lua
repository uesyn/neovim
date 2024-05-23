-- Set up copilot {{{
vim.g.copilot_filetypes = { markdown = false }
-- https://github.com/orgs/community/discussions/29817#discussioncomment-4217615
vim.keymap.set("i", "<C-l>", 'copilot#Accept("<CR>")', { silent = true, expr = true, script = true, replace_keycodes = false })
vim.keymap.set("i", "<C-j>", "<Plug>(copilot-next)")
vim.keymap.set("i", "<C-k>", "<Plug>(copilot-previous)")
vim.keymap.set("i", "<C-o>", "<Plug>(copilot-dismiss)")
vim.keymap.set("i", "<C-f>", "<Plug>(copilot-suggest)")
-- }}}

-- Set up nvim-treesitter {{{
require("nvim-treesitter.configs").setup({ auto_install = false })
-- }}}

-- Set up markdown {{{
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("my_nvim_markdown", { clear = true }),
    pattern = "markdown",
    callback = function()
        vim.keymap.set("n", "<Leader>mc", "<Plug>Markdown_Checkbox", { buffer = true })
        vim.keymap.set("n", "<CR>", "<Plug>Markdown_FollowLink", { buffer = true })
        vim.keymap.set("i", "<Tab>", "<Plug>Markdown_Jump", { buffer = true })
        vim.keymap.set("i", "<CR>", "<Plug>Markdown_NewLineBelow", { buffer = true })
    end,
})
-- }}}
