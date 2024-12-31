M = {}
local config = require("get_maintainer.config")

M.print = function(msg, ...)
	if type(msg) == "string" then
		msg = string.format(msg, ...)
	end
	if config.options.verbose then
		vim.print(msg)
	end
	return msg
end

M.echo = function(msg, ...)
	msg = M.print(msg, ...)
	if vim.fn.strdisplaywidth(msg) > vim.v.echospace then
		msg = vim.fn.strcharpart(msg, 0, vim.v.echospace)
	end
	vim.api.nvim_echo({ { msg, "" } }, false, {})
end

return M
