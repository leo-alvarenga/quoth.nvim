---Returns a random quote based on the user options and the optional `tags` and `mode` params
---@param filter ?quoth-nvim.Filter
---@return quoth-nvim.Quote
local function get_random_quote(filter)
	local quotes = require("quoth-nvim.api.get").get_by_tags(filter)

	math.randomseed(os.time())
	local index = math.random(#(quotes or {}))

	return quotes[index] or require("quoth-nvim.api.utils").empty_quote
end

return get_random_quote
