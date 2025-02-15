return {
  "houdini",
  event = "DeferredUIEnter",
  load = function (name)
      vim.cmd.packadd(name)
      vim.cmd.packadd("houdini")
  end,

  after = function ()
    require("houdini").setup({})
  end
}

