local M = {}
local util = require("get_maintainer.util")

M.get_from_cursor = function()
	local ref = vim.fn.expand("<cword>")
	local cmd = util.get_fullcmd(ref)
	local output = vim.fn.system(cmd)

	util.setreg(output)

	vim.api.nvim_echo({ { output, "" } }, false, {})
end

M.get_from_range = function()
	local sel = util.get_visual_selection()
	local output = ""

	for _, commit in pairs(sel) do
		vim.cmd('echo "Processing: ' .. commit .. '"')
		local ref = string.match(commit, "^(%w+)")
		local cmd = util.get_fullcmd(ref)
		local partial = vim.fn.system(cmd)

		output = output .. commit .. "\n" .. partial .. commit .. "\n\n"
	end

	util.setreg(output)

	vim.api.nvim_echo({ { output, "" } }, false, {})
end

M.get_from_file = function()
	local file = vim.fn.expand("%")
	local cmd = util.get_cmd({ "-f", file })
	local output = vim.fn.system(cmd)

	util.setreg(output)

	vim.api.nvim_echo({ { output, "" } }, false, {})
end

return M
