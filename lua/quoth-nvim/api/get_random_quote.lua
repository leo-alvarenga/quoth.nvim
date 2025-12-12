---Returns a random quote based on the user options and the optional `tags` and `mode` params
---@param filter ?quoth-nvim.Filter
---@return quoth-nvim.Quote
local function get_random_quote(filter)
	local quotes = require("quoth-nvim.api.get").get_filtered(filter)
	local get_random_index = require("quoth-nvim.api.get_random_index")

	local quote = quotes[get_random_index(#(quotes or {}))] or require("quoth-nvim.api.utils").empty_quote
	quote.count = #quotes

	return quote
end

return get_random_quote
