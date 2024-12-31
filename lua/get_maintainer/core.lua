local M = {}
local util = require("get_maintainer.util")
local log = require("get_maintainer.log")

M.from_cursor = function()
	log.print("from_cursor")
	local ref = vim.fn.expand("<cword>")
	local cmd = util.git_show_cmd(ref)
	local output = vim.fn.system(cmd)

	util.setreg(output)

	vim.api.nvim_echo({ { output, "" } }, false, {})
end

M.from_range = function()
	log.print("from_range")
	local sel = util.get_visual_selection()
	local output = ""

	for _, commit in pairs(sel) do
		log.print("Processing %s", commit)
		vim.cmd('echo "Processing: ' .. commit .. '"')
		local ref = string.match(commit, "^(%w+)")
		local cmd = util.git_show_cmd(ref)
		local partial = vim.fn.system(cmd)

		output = output .. commit .. "\n" .. partial .. commit .. "\n\n"
	end

	util.setreg(output)

	vim.api.nvim_echo({ { output, "" } }, false, {})
end

M.from_file = function()
	log.print("from_file")
	local file = vim.fn.expand("%")
	local cmd = util.get_maintainer_cmd({ "-f", file })
	local output = vim.fn.system(cmd)

	util.setreg(output)

	vim.api.nvim_echo({ { output, "" } }, false, {})
end

return M
