M = {}
local config = require("get_maintainer.config")

M.print = function(msg, ...)
	if config.options.verbose then
		if type(msg) == "string" then
			msg = string.format(msg, ...)
		end
		vim.print(msg)
	end
end

return M
