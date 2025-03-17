local catUtils = require('nixCatsUtils')
local colorschemer = nixCats.extra('colorscheme')
if not catUtils.isNixCats then
  colorschemer = 'onedark'
end
if colorschemer == 'onedark' then
  require('onedark').setup {
    style = 'darker'
  }
  require('onedark').load()
end

return {
  { import = "jackwy.plugins.snacks", },
  { import = "jackwy.plugins.houdini", },
  { import = "jackwy.plugins.bufferline", },
  { import = "jackwy.plugins.fzf-lua", },
  { import = "jackwy.plugins.yazi", },
  { import = "jackwy.plugins.lualine", },
  { import = "jackwy.plugins.blink", },
  { import = "jackwy.plugins.which-key", },
  { import = "jackwy.plugins.nestsitter", },
}
