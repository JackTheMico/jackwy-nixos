return {
  "bufferline.nvim",
  event = "DeferredUIEnter",
  after =function (plugin)
    require("bufferline").setup()
  end
}


