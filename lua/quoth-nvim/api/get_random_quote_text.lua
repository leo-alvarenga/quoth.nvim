---Returns a random quote based on either an user provided (flat) quote table or the fallback one (optionally filtered by kind);
---@param filter ?quoth-nvim.Filter
---@return string
local function get_random_quote_text(filter)
	local quote = require("quoth-nvim.api.get_random_quote")(filter)

	return '"' .. quote.text .. '" - ' .. quote.author
end

return get_random_quote_text
