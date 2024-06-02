-- Set up copilot {{{
vim.g.copilot_filetypes = { markdown = false }
-- https://github.com/orgs/community/discussions/29817#discussioncomment-4217615
vim.keymap.set("i", "<C-l>", 'copilot#Accept("<CR>")', { silent = true, expr = true, script = true, replace_keycodes = false })
vim.keymap.set("i", "<C-j>", "<Plug>(copilot-next)")
vim.keymap.set("i", "<C-k>", "<Plug>(copilot-previous)")
vim.keymap.set("i", "<C-o>", "<Plug>(copilot-dismiss)")
vim.keymap.set("i", "<C-f>", "<Plug>(copilot-suggest)")
-- }}}

-- Set up CopilotChat-nvim {{{
require("CopilotChat").setup({
  prompts = {
    Explain = {
      prompt = '/COPILOT_EXPLAIN Write an explanation for the active selection as paragraphs of text in Japanese.',
    },
    Review = {
      prompt = '/COPILOT_REVIEW Review the selected code in Japanese.',
    },
  },
})
vim.keymap.set("n", "<Leader>cc", '<Cmd>lua require("CopilotChat").open()<CR>')
vim.keymap.set("v", "<Leader>cc", '<Cmd>CopilotChatDocs<CR>')
vim.keymap.set("v", "<Leader>ce", '<Cmd>CopilotChatExplain<CR>')
vim.keymap.set("v", "<Leader>cr", '<Cmd>CopilotChatReview<CR>')
vim.keymap.set("v", "<Leader>ct", '<Cmd>CopilotChatTests<CR>')

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("my_copilotchat", { clear = true }),
    pattern = "copilot-chat",
    callback = function()
      vim.keymap.set("n", "<C-q>", '<Cmd>lua require("CopilotChat").toggle()<CR>', { buffer = true })
    end,
})
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
