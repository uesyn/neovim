-- Set up blame {{
require("blame").setup()
vim.keymap.set("n", "<leader>gb", "<Cmd>BlameToggle<CR>")
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("my_blame", { clear = true }),
    pattern = "blame",
    callback = function()
        vim.bo.buflisted = false
        vim.keymap.set("n", "<C-q>", ":clo<CR>", { buffer = true })
        vim.keymap.set("n", "<C-n>", "<Nop>", { buffer = true })
        vim.keymap.set("n", "<C-p>", "<Nop>", { buffer = true })
    end,
})
-- }}}

-- Set up fzf-lua {{
vim.keymap.set("n", "<Leader>fs", "<Cmd>lua require('fzf-lua').live_grep()<CR>")
vim.keymap.set("n", "<Leader>ff", "<Cmd>lua require('fzf-lua').files()<CR>")
vim.keymap.set("n", "<Leader>fb", "<Cmd>lua require('fzf-lua').blines()<CR>")
-- }}}

-- Set up openingh {{
vim.keymap.set("n", "<Leader>ho", "<Cmd>OpenInGHFile<CR>")
vim.keymap.set("v", "<Leader>ho", "<Esc><Cmd>'<,'>OpenInGHFile<CR>")
-- }}}

-- Set up nvim-surround {{
require("nvim-surround").setup({})
-- }}}

-- Set up ocs52 {{
vim.keymap.set("v", "<leader>y", require("osc52").copy_visual)
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("my_nvim_osc52", { clear = true }),
    pattern = "*",
    callback = function()
        if vim.v.event.operator == "y" then
            require("osc52").copy_register("")
        end
    end,
})
-- }}}
