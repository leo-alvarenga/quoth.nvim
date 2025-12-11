---Get all tags containing `tag`
---@param filter ?quoth-nvim.Filter
local function get_by_tags(filter)
	local get_all = require("quoth-nvim.api.get.get_all")
	local all_quotes = get_all()

	local config = require("quoth-nvim.config").options or {}
	local safe_opts = vim.tbl_deep_extend("force", {}, config, { filter = filter or {} })
	local filter_opts = safe_opts.filter or {}

	local tags = filter_opts.tags
	local mode = filter_opts.mode or "or"

	if type(tags) ~= "table" or next(tags) == nil then
		return all_quotes
	end

	return vim.iter(all_quotes)
		:filter(function(quote_obj)
			if type(quote_obj) ~= "table" or type(quote_obj.tags) ~= "table" then
				return false
			end

			if mode == "and" then
				return vim.iter(tags):all(function(t)
					return string.len(t) == 0
						or vim.iter(quote_obj.tags):any(function(tag)
							return t == tag
						end)
				end)
			end

			return vim.iter(tags):any(function(t)
				return string.len(t) == 0 or vim.iter(quote_obj.tags):any(function(tag)
					return t == tag
				end)
			end)
		end)
		:totable()
end

return get_by_tags
