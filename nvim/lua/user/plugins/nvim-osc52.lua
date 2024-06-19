return {
  "nvim-osc52",
  after = function()
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
  end,
  event = "BufEnter",
}
