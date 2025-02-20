return {
	"blink-cmp",
	event = "DeferredUIEnter",
	for_cat = "general.cmp",
	load = function(name)
		vim.cmd.packadd(name)
		vim.cmd.packadd("blink-cmp")
	end,
	after = function()
		require("blink-cmp").setup({
			keymap = {
				-- set to 'none' to disable the 'default' preset
				preset = "enter",
				["<C-y>"] = { "select_and_accept" },

				-- ["<Up>"] = { "select_prev", "fallback" },
				-- ["<Down>"] = { "select_next", "fallback" },

				-- disable a keymap from the preset
				-- ["<C-e>"] = {},

				-- show with a list of providers
				-- ["<C-space>"] = {
				-- 	function(cmp)
				-- 		cmp.show({ providers = { "snippets" } })
				-- 	end,
				-- },

				-- control whether the next command will be run when using a function
				-- ["<C-n>"] = {
				-- 	function(cmp)
				-- 		if some_condition then
				-- 			return
				-- 		end -- runs the next command
				-- 		return true -- doesn't run the next command
				-- 	end,
				-- 	"select_next",
				-- },

				-- optionally, separate cmdline and terminal keymaps
				-- cmdline = {
				-- 	-- sets <CR> to accept the item and run the command immediately
				-- 	-- use `select_accept_and_enter` to accept the item or the first item if none are selected
				-- 	["<CR>"] = { "accept_and_enter", "fallback" },
				-- },
				-- term = {}
			},
			completion = {
				menu = {
					draw = {
						components = {
							-- customize the drawing of kind icons
							kind_icon = {
								text = function(ctx)
									-- default kind icon
									local icon = ctx.kind_icon
									-- if LSP source, check for color derived from documentation
									if ctx.item.source_name == "LSP" then
										local color_item = require("nvim-highlight-colors").format(
											ctx.item.documentation,
											{ kind = ctx.kind }
										)
										if color_item and color_item.abbr then
											icon = color_item.abbr
										end
									end
									return icon .. ctx.icon_gap
								end,
								highlight = function(ctx)
									-- default highlight group
									local highlight = "BlinkCmpKind" .. ctx.kind
									-- if LSP source, check for color derived from documentation
									if ctx.item.source_name == "LSP" then
										local color_item = require("nvim-highlight-colors").format(
											ctx.item.documentation,
											{ kind = ctx.kind }
										)
										if color_item and color_item.abbr_hl_group then
											highlight = color_item.abbr_hl_group
										end
									end
									return highlight
								end,
							},
						},
					},
				},
			},
		})
	end,
}
