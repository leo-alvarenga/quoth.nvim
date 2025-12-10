local M = require("quoth-nvim.features")

---Setup function
---@param opts ?quoth-nvim.Options
function M.setup(opts)
	require("quoth-nvim.config").set_options(opts)
end

M.version = "0.1.0"

return M
