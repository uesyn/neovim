-- Ignore the user lua configuration
vim.opt.runtimepath:remove(vim.fn.stdpath("config")) -- ~/.config/nvim
vim.opt.runtimepath:remove(vim.fn.stdpath("config") .. "/after") -- ~/.config/nvim/after
vim.opt.runtimepath:remove(vim.fn.stdpath("data") .. "/site") -- ~/.local/share/nvim/site
-- }}}

vim.opt.rtp:prepend("@my_nvim_config@")
vim.opt.rtp:prepend("@lazy_nvim@")

require('options')
require('keymaps')
require('autocommands')

require("lazy").setup({
  defaults = { lazy = true },
  rocks = {
    enabled = false,
  },
  performance = {
    rtp = {
      reset = false,
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  spec = "plugins",
})
