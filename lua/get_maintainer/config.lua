local M = {}

local defaults = {
	path = "get_maintainer.pl",
	use_clipboard = "", -- |unnamed|unnamedplus
	args = {
		"--scm",
	},
}

M.options = {}

M.setup = function(options)
	M.options = vim.tbl_deep_extend("force", {}, defaults, options or {})
end

return M
