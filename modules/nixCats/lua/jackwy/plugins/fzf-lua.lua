return {
  "fzf-lua",
  keys = {
    {"<leader>ff", "<CMD>FzfLua files<CR>", "Find files"},
    {"<leader>sp", "<CMD>FzfLua live_grep_resume<CR>", "Live grep project"},
    {"<leader>sb", "<CMD>FzfLua lgrep_curbuf<CR>", "Live grep curbuf"},
    {"<leader>sv", "<CMD>FzfLua grep_visual<CR>", "Search visual"},
  },
  after = function ()
    require("fzf-lua").setup({})
  end
}

