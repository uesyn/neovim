vim.cmd.colorscheme("dracula")

require("gitsigns").setup({ ["signs"] = { ["add"] = { ["text"] = "+" }, ["change"] = { ["text"] = "~" } } })
require("barbar").setup({ ["animation"] = false })
