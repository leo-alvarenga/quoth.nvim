---Given a quote list-like table, filter it obeying the length_constraints (if present)
---@param quotes table<quoth-nvim.Quote>
---@param config quoth-nvim.Options
---@param length_constraints quoth-nvim.LengthConstraints
---@return table<quoth-nvim.Quote>
local function get_by_length(quotes, config, length_constraints)
	local constraints =
		vim.tbl_deep_extend("force", config.filter and config.filter.length_constraints or {}, length_constraints or {})

	if type(constraints.max) ~= "number" and type(constraints.min) ~= "number" then
		return quotes
	end

	return vim.iter(quotes)
		:filter(function(quote_obj)
			local is_long_enough = not constraints.min or string.len(quote_obj.text) >= constraints.min
			local is_short_enough = not constraints.max or string.len(quote_obj.text) <= constraints.max

			return is_long_enough and is_short_enough
		end)
		:totable()
end

---Get all quotes related to one or more value in `tags`
---@param quotes table<quoth-nvim.Quote>
---@param config quoth-nvim.Options
---@param filter ?quoth-nvim.Filter
local function get_by_tag(quotes, config, filter)
	local safe_opts = vim.tbl_deep_extend("force", {}, config, { filter = filter or {} })
	local filter_opts = safe_opts.filter or {}

	local tags = filter_opts.tags
	local tag_mode = filter_opts.tag_mode or "or"

	if type(tags) ~= "table" or next(tags) == nil then
		return quotes
	end

	return vim.iter(quotes)
		:filter(function(quote_obj)
			if type(quote_obj) ~= "table" or type(quote_obj.tags) ~= "table" then
				return false
			end

			if tag_mode == "and" then
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

---Get all quotes related to one of the `authors`
---@param quotes table<quoth-nvim.Quote>
---@param config quoth-nvim.Options
---@param filter ?quoth-nvim.Filter
local function get_by_author(quotes, config, filter)
	local safe_opts = vim.tbl_deep_extend("force", {}, config, { filter = filter or {} })
	local filter_opts = safe_opts.filter or {}

	local authors = filter_opts.authors
	local relax_author_search = filter_opts.relax_author_search or false

	if type(authors) ~= "table" or next(authors) == nil then
		return quotes
	end

	return vim.iter(quotes)
		:filter(function(quote_obj)
			if type(quote_obj) ~= "table" or type(quote_obj.tags) ~= "table" then
				return false
			end

			if not relax_author_search then
				return vim.iter(authors):any(function(author)
					return string.len(author) == 0 or quote_obj.author == author
				end)
			end

			local quote_author = string.lower(quote_obj.author)
			return vim.iter(authors):any(function(author)
				if type(author) ~= "string" or string.len(author) == 0 then
					return true
				end

				local author_parts = vim.iter(vim.split(author, " ", { plain = true, trimempty = true }))
					:map(function(part)
						return string.lower(part)
					end)
					:totable()

				return vim.iter(author_parts):any(function(part)
					if string.find(quote_author, part, 1, true) then
						return true
					end

					return false
				end)
			end)
		end)
		:totable()
end

---Get all tags containing `tag`
---@param filter ?quoth-nvim.Filter
local function get_filtered(filter)
	local config = require("quoth-nvim.config").options or {}

	local get_all = require("quoth-nvim.api.get.get_all")
	local all_quotes = get_all()

	---@type table<quoth-nvim.Quote>
	local quotes = {}
	quotes = get_by_length(all_quotes, config, filter and filter.length_constraints or {})
	quotes = get_by_author(quotes, config, filter)
	quotes = get_by_tag(quotes, config, filter)

	return quotes
end

return get_filtered
