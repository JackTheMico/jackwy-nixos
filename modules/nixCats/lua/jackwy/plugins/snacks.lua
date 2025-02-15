-- return {
--   "snacks.nvim",
--   event = "DeferredUIEnter",
--   -- 将键位映射移到 after 回调中
--   after = function(_)
--     local Snacks = require("snacks")  -- 局部引入模块
--     Snacks.setup({
--       terminal = { enabled = true },
--       explorer = { enabled = true },
--       picker = { enabled = true },
--       dashboard = { enabled = true },
--       indent = { enabled = true },
--     })
--     -- 在初始化后设置键位映射
--     vim.keymap.set("n", "<c-\\>", function()
--       Snacks.terminal()
--     end, { desc = "Toggle Terminal" })
--     vim.keymap.set("n", "<leader>gg", function()
--       Snacks.lazygit()
--     end, { desc = "Lazygit" })
--   end,
-- }


-- NOTE: this plugin is "loaded" at startup,
-- but we delay the main setup call until later.
-- also we still need to require bigfile from the main one
-- because it tries to index the Snacks global unsafely...

-- also shut up I dont care
---@diagnostic disable-next-line: invisible
require('snacks').bigfile.setup()

return {
  {
    "snacks.nvim",
    for_cat = "general",
    keys = {
      {'<c-\\>', function() Snacks.terminal() end, mode = {'n'}, desc = 'open snacks terminal' },
      {"<leader>gg", function() Snacks.lazygit.open() end, mode = {"n"}, desc = 'LazyGit' },
      {"<leader>gc", function() Snacks.lazygit.log() end, mode = {"n"}, desc = 'Lazy[G]it [C]ommit log' },
      {"<leader>gl", function() Snacks.gitbrowse.open() end, mode = {"n"}, desc = '[G]oto git [L]ink' },
    },
    event = { 'DeferredUIEnter' },
    after = function(_)
      -- NOTE: It is faster when you comment them out
      -- rather than disabling them.
      -- for some reason, they are still required
      -- when you do { enabled = false }
      Snacks.setup({
        -- dashboard = { enabled = true, },
        -- debug = { enabled = true, },
        -- bufdelete = { enabled = true, },
        -- dim = { enabled = true, },
        -- explorer = { enabled = true, },
        -- quickfile = { enabled = true, },
        -- bigfile = { enabled = true, },
        -- input = { enabled = true, },
        -- scratch = { enabled = true, },
        -- layout = { enabled = true, },
        -- zen = { enabled = true, },
        -- scroll = { enabled = true, },
        -- notifier = { enabled = true, },
        -- notify = { enabled = true, },
        -- win = { enabled = true, },
        -- picker = { enabled = true, },
        -- profiler = { enabled = true, },
        -- toggle = { enabled = true, },
        -- rename = { enabled = true, },
        -- words = { enabled = true, },

        gitbrowse = { enabled = true, },
        lazygit = { enabled = true, },
        git = { enabled = true, },
        terminal = { enabled = true, },
        scope = { enabled = true, },
        indent = {
          enabled = true,
          scope = {
            hl = 'Hlargs',
          },
          chunk = {
            -- enabled = true,
            hl = 'Hlargs',
          }
        },
        statuscolumn = {
          left = { "mark", "git" }, -- priority of signs on the left (high to low)
          right = { "sign", "fold" }, -- priority of signs on the right (high to low)
          folds = {
            open = false, -- show open fold icons
            git_hl = false, -- use Git Signs hl for fold icons
          },
          git = {
            -- patterns to match Git signs
            patterns = { "GitSign", "MiniDiffSign" },
          },
          refresh = 50, -- refresh at most every 50ms
        },
      })
    end,
  }
}

