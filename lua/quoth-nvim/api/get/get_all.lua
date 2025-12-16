---Returns a module string path with the plugin prefix for safe require
---@param arg string
---@return string
local function prefix(arg)
	if not arg or type(arg) ~= "string" then
		return ""
	end

	return "quoth-nvim.quotes." .. arg
end

local files = {
	"stoic",
	"tech",
}

---Get all quotes
---@return table<quoth-nvim.Quote>
local function get_all()
	local quotes = {}

	local opts = require("quoth-nvim.config").options
	local has_custom_quotes = type(opts.custom_quotes) == "table" and next(opts.custom_quotes) ~= nil
	local include_builtin = opts.include_all or not has_custom_quotes

	if has_custom_quotes then
		quotes = vim.list_extend(quotes, opts.custom_quotes or {})
	end

	if include_builtin then
		for _, file in ipairs(files) do
			---@type quoth-nvim.Quote[]
			local t_quotes = require(prefix(file))

			if type(t_quotes) == "table" then
				quotes = vim.list_extend(quotes, t_quotes)
			end
		end
	end

	return quotes
end

return get_all
