-- define common options
local opts = {
    noremap = true, -- non-recursive
    silent = true, -- do not show message
}

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true }) -- to disable the moving the cursor to the right

-----------------
-- Normal mode --
-----------------

-- Hint: see `:h vim.map.set()`
-- Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", opts)
vim.keymap.set("n", "<C-j>", "<C-w>j", opts)
vim.keymap.set("n", "<C-k>", "<C-w>k", opts)
vim.keymap.set("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
-- delta: 2 lines
vim.keymap.set("n", "<C-Up>", ":resize -2<CR>", opts)
vim.keymap.set("n", "<C-Down>", ":resize +2<CR>", opts)
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", opts)
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", opts)

vim.keymap.set("n", "<C-e>", function()
    require("snacks").explorer.open()
end, opts)

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostics under cursor" })

vim.keymap.set("n", "<leader>t", "<cmd>ToggleTerm<CR>", { noremap = true, silent = true, desc = "toggle the terminal" })

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

vim.keymap.set("n", "<leader>fr", function()
    Snacks.picker.recent()
end, { desc = "open recent files dialoge" })

vim.keymap.set("n", "<leader>lg", function()
    vim.lsp.buf_notify(0, "workspace/didChangeConfiguration", {
        settings = { ltex = { language = "de-DE" } },
    })
end, { desc = "ltex: switch to German" })

vim.keymap.set("n", "<leader>le", function()
    vim.lsp.buf_notify(0, "workspace/didChangeConfiguration", {
        settings = { ltex = { language = "en-US" } },
    })
end, { desc = "ltex: switch to English" })
-----------------
-- Visual mode --
-----------------

-- Hint: start visual mode with the same area as the previous area and the same mode
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)
-- vim.keymap.set({ "n", "v" }, "<ScrollWheelUp>", "k")
-- vim.keymap.set({ "n", "v" }, "<ScrollWheelDown>", "j")

-------------------
-- Terminal Mode --
-------------------

vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { noremap = true })

-------------------
--      all      --
-------------------

-- Disable horizontal scrolling across Normal, Visual, and Insert modes
vim.keymap.set({ "n", "v", "i" }, "<ScrollWheelLeft>", "<Nop>")
vim.keymap.set({ "n", "v", "i" }, "<ScrollWheelRight>", "<Nop>")
