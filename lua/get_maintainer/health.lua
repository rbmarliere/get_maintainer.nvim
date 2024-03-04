local M = {}
local config = require("get_maintainer.config")

local start = vim.health.start or vim.health.report_start
local ok = vim.health.ok or vim.health.report_ok
local error = vim.health.error or vim.health.report_error

M.check = function()
	start("get_maintainer.nvim")

	if vim.fn.executable("git") == 1 then
		ok("git found")
	else
		error("git not found")
	end

	print(vim.inspect(config.options))
	if vim.fn.executable(config.options.path) == 1 then
		ok("checkpatch.pl found")
	else
		error("checkpatch.pl not found")
	end

end

return M
