return {
  "CopilotChat.nvim",
  after = function()
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
    vim.keymap.set("n", "<Leader>cC", '<Cmd>lua require("CopilotChat").open()<CR>')
    vim.keymap.set("v", "<Leader>cd", '<Cmd>CopilotChatDocs<CR>')
    vim.keymap.set("v", "<Leader>ce", '<Cmd>CopilotChatExplain<CR>')
    vim.keymap.set("v", "<Leader>cr", '<Cmd>CopilotChatReview<CR>')
    vim.keymap.set("v", "<Leader>ct", '<Cmd>CopilotChatTests<CR>')
    vim.keymap.set("n", "<Leader>cc", '<Cmd>CopilotChatCommitStaged<CR>')
    vim.keymap.set("v", "<Leader>cj", '<Cmd>lua require("CopilotChat").ask("Translate to Japanese.", { selection = require("CopilotChat.select").visual })<CR>')
    
    vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("my_copilotchat", { clear = true }),
        pattern = "copilot-chat",
        callback = function()
          vim.keymap.set("n", "<C-q>", '<Cmd>lua require("CopilotChat").toggle()<CR>', { buffer = true })
        end,
    })
  end,
  event = "BufEnter",
}
