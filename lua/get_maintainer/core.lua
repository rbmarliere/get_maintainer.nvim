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

	for _, line in pairs(sel) do
		log.echo("Processing %s", line)
		for word in line:gmatch("%S+") do
			log.print(word)
			local partial = ""
			if util.is_file(word) then
				local cmd = util.get_maintainer_cmd({ "-f", word })
				partial = vim.fn.system(cmd)
			elseif util.is_ref(word) then
				local cmd = util.git_show_cmd(word)
				partial = vim.fn.system(cmd)
			end
			if partial ~= "" then
				output = output .. word .. "\n" .. partial .. word .. "\n\n"
			end
		end
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
