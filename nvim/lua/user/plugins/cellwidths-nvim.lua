return {
  "cellwidths.nvim",
  after = function()
    -- 'listchars' と 'fillchars' を事前に設定しておくのがお勧めです。
    -- vim.opt.listchars = { eol = "⏎" }
    -- vim.opt.fillchars = { eob = "‣" }
    require("cellwidths").setup {
      name = "default",
      -- name = "empty",          -- 空の設定です。
      -- name = "default",        -- vim-ambiwidth のデフォルトです。
      -- name = "cica",           -- vim-ambiwidth の Cica 用設定です。
      -- name = "sfmono_square",  -- SF Mono Square 用設定です。
    }
  end,
  event = "VimEnter",
}

