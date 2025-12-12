---Returns string replacing placeholders with the quote object values
---@param fmt string
---@param quote quoth-nvim.Quote
local function fmt_quote(fmt, quote)
	local result = fmt

	for k, v in pairs(require("quoth-nvim.api.utils").placeholders) do
		if quote[k] then
			result = vim.fn.substitute(result, v, quote[k], "g")
		end
	end

	return result
end

---Returns a random quote based on either an user provided (flat) quote table or the fallback one (optionally filtered by kind);
---@param fmt string|nil
---@param filter ?quoth-nvim.Filter
---@return string
local function get_random_quote_text(fmt, filter)
	local quote = require("quoth-nvim.api.get_random_quote")(filter)

	local safe_format = fmt
		or require("quoth-nvim.config").options.format
		or require("quoth-nvim.api.utils").fallback_format

	return fmt_quote(safe_format, quote)
end

return get_random_quote_text
