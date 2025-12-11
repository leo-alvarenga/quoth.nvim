---Prefix with the plugin prefix for safe module require
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
---@return table
local function get_all()
	local quotes = {}
	local custom_quotes = require("quoth-nvim.config").options.custom_quotes

	-- Include all native quotes if true or if no custom_quotes were provided
	if not custom_quotes or require("quoth-nvim.config").options.include_all then
		for _, file in ipairs(files) do
			local t_quotes = require(prefix(file))

			if type(t_quotes) == "table" then
				quotes = vim.tbl_extend("force", quotes, t_quotes)
			end
		end
	end

	if type(custom_quotes) == "table" then
		quotes = vim.tbl_extend("force", quotes, custom_quotes or {})
	end

	return quotes
end

return get_all
