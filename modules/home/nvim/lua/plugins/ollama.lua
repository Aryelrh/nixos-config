local ollama = {}

function ollama.query(question)
	local command = string.format('ollama "%s"', question)
	local handle = io.popen(command)
	if not handle then
		vim.notify("Error: Could not execute ollama command", vim.log.levels.ERROR)
		return
	end

	local output = handle:read("*all")
	handle:close()

	vim.api.nvim_command("split")
	vim.api.nvim_set_current_buf(vim.fn.bufnr("%"))
	vim.api.nvim_buf_set_name(vim.api.nvim_get_current_buf(), "Ollama Response")
	vim.api.nvim_buf_set_lines(vim.api.nvim_get_current_buf(), 0, -1, false, { output })
end

vim.api.nvim_set_keymap(
	"n",
	"<leader>ol",
	':lua require("plugins.ollama").query(vim.fn.input("Ollama Query: "))<CR>',
	{ noremap = true, silent = true }
)

return ollama
