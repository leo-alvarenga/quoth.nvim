local M = {
	get_random_quote = require("quoth-nvim.api.get_random_quote"),
	get_random_quote_text = require("quoth-nvim.api.get_random_quote_text"),
}

---Small shorthand function to use Neovim's native notification API to display a simple random quote
function M.notify_random()
	vim.notify(M.get_random_quote_text())
end

return M
