require("lze").load({
	{ import = "jackwy.plugins.which-key" },
	{ import = "jackwy.plugins.houdini" },
	{ import = "jackwy.plugins.bufferline" },
	{ import = "jackwy.plugins.fzf-lua" },
	{ import = "jackwy.plugins.yazi" },
	{ import = "jackwy.plugins.lualine" },
	{ import = "jackwy.plugins.snacks" },
	{ import = "jackwy.plugins.blink" },
	{ import = "jackwy.plugins.nestsitter" },
	{
		"treesj",
		for_cat = "general.core",
		cmd = { "TSJToggle" },
		keys = { { "<leader>Ft", ":TSJToggle<CR>", mode = { "n" }, desc = "treesj split/join" } },
		after = function(plugin)
			local tsj = require("treesj")

			-- local langs = {--[[ configuration for languages ]]}

			tsj.setup({
				---@type boolean Use default keymaps (<space>m - toggle, <space>j - join, <space>s - split)
				use_default_keymaps = true,
				---@type boolean Node with syntax error will not be formatted
				check_syntax_error = true,
				---If line after join will be longer than max value,
				---@type number If line after join will be longer than max value, node will not be formatted
				max_join_length = 120,
				---Cursor behavior:
				---hold - cursor follows the node/place on which it was called
				---start - cursor jumps to the first symbol of the node being formatted
				---end - cursor jumps to the last symbol of the node being formatted
				---@type 'hold'|'start'|'end'
				cursor_behavior = "hold",
				---@type boolean Notify about possible problems or not
				notify = true,
				---@type boolean Use `dot` for repeat action
				dot_repeat = true,
				---@type nil|function Callback for treesj error handler. func (err_text, level, ...other_text)
				on_error = nil,
				---@type table Presets for languages
				-- langs = langs, -- See the default presets in lua/treesj/langs
			})
		end,
	},
	{
		"otter.nvim",
		for_cat = "otter",
		-- event = "DeferredUIEnter",
		on_require = { "otter" },
		-- ft = { "markdown", "norg", "templ", "nix", "javascript", "html", "typescript", },
		after = function(plugin)
			local otter = require("otter")
			otter.setup({
				lsp = {
					-- `:h events` that cause the diagnostics to update. Set to:
					-- { "BufWritePost", "InsertLeave", "TextChanged" } for less performant
					-- but more instant diagnostic updates
					diagnostic_update_events = { "BufWritePost" },
					-- function to find the root dir where the otter-ls is started
					root_dir = function(_, bufnr)
						return vim.fs.root(bufnr or 0, {
							".git",
							"_quarto.yml",
							"package.json",
						}) or vim.fn.getcwd(0)
					end,
				},
				buffers = {
					-- if set to true, the filetype of the otterbuffers will be set.
					-- otherwise only the autocommand of lspconfig that attaches
					-- the language server will be executed without setting the filetype
					set_filetype = false,
					-- write <path>.otter.<embedded language extension> files
					-- to disk on save of main buffer.
					-- usefule for some linters that require actual files
					-- otter files are deleted on quit or main buffer close
					write_to_disk = false,
				},
				verbose = { -- set to false to disable all verbose messages
					no_code_found = false, -- warn if otter.activate is called, but no injected code was found
				},
				strip_wrapping_quote_characters = { "'", '"', "`" },
				-- otter may not work the way you expect when entire code blocks are indented (eg. in Org files)
				-- When true, otter handles these cases fully.
				handle_leading_whitespace = false,
			})
		end,
	},
	{
		"undotree",
		for_cat = "general.core",
		cmd = { "UndotreeToggle", "UndotreeHide", "UndotreeShow", "UndotreeFocus", "UndotreePersistUndo" },
		keys = { { "<leader>U", "<cmd>UndotreeToggle<CR>", mode = { "n" }, desc = "Undo Tree" } },
		before = function(_)
			vim.g.undotree_WindowLayout = 1
			vim.g.undotree_SplitWidth = 40
		end,
	},
	{
		"todo-comments.nvim",
		for_cat = "other",
		event = "DeferredUIEnter",
		after = function(plugin)
			require("todo-comments").setup({ signs = false })
		end,
	},
	{
		"hlargs",
		for_cat = "other",
		event = "DeferredUIEnter",
		after = function(plugin)
			require("hlargs").setup({
				color = "#32a88f",
			})
			vim.cmd([[hi clear @lsp.type.parameter]])
			vim.cmd([[hi link @lsp.type.parameter Hlargs]])
		end,
	},
	{
		"vim-sleuth",
		for_cat = "general.core",
		event = "DeferredUIEnter",
	},
	{
		"nvim-highlight-colors",
		for_cat = "other",
		event = "DeferredUIEnter",
		-- ft = "",
		after = function(plugin)
			require("nvim-highlight-colors").setup({
				---Render style
				---@usage 'background'|'foreground'|'virtual'
				render = "virtual",

				---Set virtual symbol (requires render to be set to 'virtual')
				virtual_symbol = "■",

				---Highlight named colors, e.g. 'green'
				enable_named_colors = true,

				---Highlight tailwind colors, e.g. 'bg-blue-500'
				enable_tailwind = true,

				---Set custom colors
				---Label must be properly escaped with '%' to adhere to `string.gmatch`
				--- :help string.gmatch
				custom_colors = {
					{ label = "%-%-theme%-primary%-color", color = "#0f1219" },
					{ label = "%-%-theme%-secondary%-color", color = "#5a5d64" },
				},
			})
		end,
	},
})
