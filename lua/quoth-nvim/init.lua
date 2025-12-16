local M = require("quoth-nvim.api")

M.set_options = require("quoth-nvim.config").set_options

---Setup function
---@param opts ?quoth-nvim.Options
function M.setup(opts)
	require("quoth-nvim.config").set_options(opts)
	require("quoth-nvim.commands").setup_commands()

	vim.health.start("quoth-nvim")
end

M.version = "0.6.0"

return M
