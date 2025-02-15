vim.g.mapleader = ' '

-- Bufferline
vim.keymap.set("n", "<leader><leader>f", "<cmd>FzfLua buffers<CR>", { desc = "FzfLua Buffers" })
vim.keymap.set("n", "H", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "L", "<cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" })
vim.keymap.set("n", "<leader><leader>q", "<cmd>bdelete<CR>", { desc = "Kill buffer" })
vim.keymap.set("n", "<leader><leader>d", "<cmd>BufferLineSortByDirectory<CR>", { desc = "Sort buffer by dir" })

