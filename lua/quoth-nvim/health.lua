local M = {}

function M.check()
	vim.health.start("quoth.nvim")
	vim.health.ok("Plugin loaded successfully; quoth.nvim is working")

	local ok, quote = pcall(require, "quoth-nvim")

	if ok and quote.get_random_quote then
		local test_quote = quote.get_random_quote()

		if not test_quote then
			vim.health.warn(
				"get_random_quote() return `nil`. This probably means the filter you are using did not match any quotes"
			)
		else
			vim.health.ok("get_random_quote() works: " .. vim.inspect(test_quote))
		end
	else
		vim.health.error("Failed to load quote function")
	end
end

return M
