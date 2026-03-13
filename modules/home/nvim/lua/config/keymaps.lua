-- General keymaps
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit" })

-- Buffer close (same effect as X in tabs)
vim.keymap.set("n", "<leader>x", function()
  local buftype = vim.bo.buftype
  if buftype == "terminal" then
    vim.cmd("bdelete!")
  else
    vim.cmd("bdelete")
  end
end, { noremap = true, silent = true, desc = "Close buffer" })
vim.keymap.set("n", "<leader>X", ":bdelete!<CR>", { noremap = true, silent = true, desc = "Force close buffer" })
vim.keymap.set("t", "<leader>x", "<C-\\><C-n>:bdelete!<CR>", { noremap = true, silent = true, desc = "Close terminal buffer" })

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

-- Delete line shortcuts
vim.keymap.set("n", "<leader>d", "dd", { noremap = true, silent = true, desc = "Delete current line" })

-- Terminal: salir al modo normal con doble Esc
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { noremap = true, silent = true, desc = "Exit terminal mode" })

-- Markdown render toggle
vim.keymap.set("n", "<leader>mr", function()
  require("render-markdown").toggle()
end, { noremap = true, silent = true, desc = "Toggle markdown render" })
