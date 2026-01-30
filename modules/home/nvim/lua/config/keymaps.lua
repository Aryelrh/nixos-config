-- General keymaps
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit" })

-- Buffer navigation with Tab
vim.keymap.set("n", "<Tab>", ":bnext<CR>", { noremap = true, silent = true, desc = "Next buffer" })
vim.keymap.set("n", "<S-Tab>", ":bprev<CR>", { noremap = true, silent = true, desc = "Previous buffer" })

-- Standard editor shortcuts
vim.keymap.set("n", "<C-z>", "u", { noremap = true, silent = true, desc = "Undo" })
vim.keymap.set("n", "<C-y>", "<C-r>", { noremap = true, silent = true, desc = "Redo" })
vim.keymap.set("n", "<C-a>", "ggVG", { noremap = true, silent = true, desc = "Select all" })
vim.keymap.set("i", "<C-z>", "<C-o>u", { noremap = true, silent = true, desc = "Undo in insert mode" })
vim.keymap.set("i", "<C-y>", "<C-o><C-r>", { noremap = true, silent = true, desc = "Redo in insert mode" })
vim.keymap.set("i", "<C-a>", "<C-o>gg<C-o>VG", { noremap = true, silent = true, desc = "Select all in insert mode" })

-- Copy/Paste with system clipboard
vim.keymap.set("v", "<C-c>", '"+y', { noremap = true, silent = true, desc = "Copy to clipboard" })
vim.keymap.set("i", "<C-v>", "<C-r>+", { noremap = true, silent = true, desc = "Paste from clipboard" })
vim.keymap.set("n", "<C-v>", '"+p', { noremap = true, silent = true, desc = "Paste from clipboard" })

-- Terminal toggle
vim.keymap.set("n", "<leader><CR>", ":ToggleTerminalCwd<CR>", { noremap = true, silent = true, desc = "Toggle terminal at Neotree root" })
