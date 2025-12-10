local M = {}

---Returns a random quote based on either an user provided Quote table or the fallback one (optionally filtered by kind)
---@param custom_quotes_or_kind ?table|string
local function generic_get_random_quote(custom_quotes_or_kind)
	if type(custom_quotes_or_kind) == "table" then
		return custom_quotes_or_kind
	end

	local safe_kind = nil
	if type(custom_quotes_or_kind) == "string" then
		safe_kind = custom_quotes_or_kind
	end

	return require("quoth-nvim.quotes").get_quotes(safe_kind)
end

---Returns a random quote based on either an user provided (flat) quote table or the fallback one (optionally filtered by kind);
---Priority other is:
---	- Call parameters
---	- User opts
---	- Default values
---@param custom_quotes_or_kind ?table|string
---@return quoth-nvim.Quote
function M.get_random_quote(custom_quotes_or_kind)
	local quotes = {}

	if custom_quotes_or_kind then
		quotes = generic_get_random_quote(custom_quotes_or_kind)
	else
		local opts = require("quoth-nvim.config").options

		quotes = generic_get_random_quote(opts.custom_quotes or opts.kind)
	end

	math.randomseed(os.time())
	local index = math.random(#quotes)

	return quotes[index]
end

---Returns a random quote based on either an user provided (flat) quote table or the fallback one (optionally filtered by kind);
---Priority other is:
---	- Call parameters
---	- User opts
---	- Default values
---@param custom_quotes_or_kind ?table|string
---@return string
function M.get_random_quote_text(custom_quotes_or_kind)
	local quote = M.get_random_quote(custom_quotes_or_kind)

	return '"' .. quote.text .. '" - ' .. quote.author
end

---Small shorthand function to use Neovim's native notification API to display a simple random quote
function M.notify_random()
	vim.notify(M.get_random_quote_text())
end

return M
