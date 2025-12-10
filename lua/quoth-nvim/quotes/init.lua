local M = {}

---Prefix with the plugin prefix for safe module require
---@param arg string
---@return string
function M.prefix(arg)
	if not arg or type(arg) ~= "string" then
		return ""
	end

	return "quoth-nvim.quotes." .. arg
end

M.topics = {
	"stoic",
}

---Returns a table with all quotes (optionally filtered by kind, if present)
---@param kind ?string|nil
---@return table<quoth-nvim.Quote>
function M.get_quotes(kind)
	local quotes = {}

	for _, topic in ipairs(M.topics) do
		if kind and topic ~= kind then
			goto continue
		end

		local t_quotes = require(M.prefix(topic))

		if type(t_quotes) == "table" then
			quotes = vim.tbl_extend("force", quotes, t_quotes)
		end

		::continue::
	end

	return quotes
end

return M
