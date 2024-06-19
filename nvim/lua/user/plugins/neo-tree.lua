return {
  "neo-tree.nvim",
  after = function()
    require("neo-tree").setup({
        ["filesystem"] = { ["filtered_items"] = { ["hide_dotfiles"] = false, ["hide_gitignored"] = false } },
        ["popup_border_style"] = "solid",
        ["use_default_mappings"] = false,
        ["window"] = {
            ["mappings"] = {
                ["<C-q>"] = "close_window",
                ["<cr>"] = "open",
                ["<esc>"] = { "revert_preview" },
                ["?"] = "show_help",
                ["D"] = "delete",
                ["F"] = { "add", ["config"] = { ["show_path"] = "absolute" } },
                ["K"] = { "add_directory", ["config"] = { ["show_path"] = "absolute" } },
                ["P"] = { "toggle_preview", ["config"] = { ["use_float"] = true } },
                ["R"] = "rename",
                ["S"] = { "open_split" },
                ["c"] = "copy",
                ["h"] = { "close_node" },
                ["l"] = { "open" },
                ["m"] = { "move", ["config"] = { ["show_path"] = "absolute" } },
                ["p"] = "paste_from_clipboard",
                ["q"] = "close_window",
                ["r"] = "refresh",
                ["s"] = { "open_vsplit" },
                ["x"] = "cut_to_clipboard",
                ["y"] = "copy_to_clipboard",
            },
            ["position"] = "float",
        },
    })
    vim.keymap.set("n", "<Leader>fo", "<Cmd>Neotree action=focus reveal toggle<CR>", { silent = true })
  end,
  keys = "<Leader>fo",
}
