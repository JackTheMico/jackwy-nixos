require("nixCatsUtils").setup({
	non_nix_value = true,
})
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local ok, notify = pcall(require, "notify")
if ok then
	notify.setup({
		on_open = function(win)
			vim.api.nvim_win_set_config(win, { focusable = false })
		end,
	})
	vim.notify = notify
	vim.keymap.set("n", "<Esc>", function()
		notify.dismiss({ silent = true })
	end, { desc = "dismiss notify popup and clear hlsearch" })
end

require("lze").register_handlers({
	{
		enabled = true,
		handler = require("nixCatsUtils.lzUtils").for_cat,
	},
})

require("jackwy.keymaps")
require("jackwy.options")
require("jackwy.plugins")
require("jackwy.lsps")
