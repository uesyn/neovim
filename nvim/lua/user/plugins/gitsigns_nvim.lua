return {
  "gitsigns.nvim",
  after = function()
    require("gitsigns").setup({ ["signs"] = { ["add"] = { ["text"] = "+" }, ["change"] = { ["text"] = "~" } } })
  end,
  event = "BufEnter",
}
