local M = {}

function M.setup_commands()
	vim.api.nvim_create_user_command("QuothGetRandom", function()
		vim.print(require("quoth-nvim.api").get_random_quote_text())
	end, {})
end

return M
