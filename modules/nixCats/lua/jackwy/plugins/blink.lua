return {
	"blink-cmp",
	event = "DeferredUIEnter",
	for_cat = "general.cmp",
	load = function(name)
		vim.cmd.packadd(name)
		vim.cmd.packadd("blink-cmp")
	end,
	after = function()
		require("blink-cmp").setup({})
	end,
}
