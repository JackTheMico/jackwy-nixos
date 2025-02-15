return {
  "yazi.nvim",
  keys = {
    {"<leader>y", function ()
      require("yazi").yazi()
    end, desc = "Yazi Toggle"}
  },
  -- load = function (name)
  --     vim.cmd.packadd(name)
  --     vim.cmd.packadd("yazi")
  -- end,
  after = function ()
    require("yazi").setup({})
  end
}
