local M = {}
local config = require("get_maintainer.config")
local log = require("get_maintainer.log")

M.get_visual_selection = function()
	log.print("get_visual_selection")

	local mode = vim.api.nvim_get_mode()
	-- if not in visual mode, return
	if mode.mode ~= "V" then
		return {}
	end

	-- exit visual mode to update markers
	local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
	vim.api.nvim_feedkeys(esc, "x", false)

	local _, start_row, _, _ = unpack(vim.fn.getpos("'<"))
	local _, end_row, _, _ = unpack(vim.fn.getpos("'>"))

	return vim.fn.getline(start_row, end_row)
end

M.get_cmd = function(args)
	local cmd = config.options.path
	local argv = table.concat(config.options.args or {}, " ") .. " " .. table.concat(args or {}, " ")
	local ret = cmd .. " " .. argv
	log.print("get_cmd :: %s", ret)
	return ret
end

M.get_fullcmd = function(ref)
	local cmd = "git --no-pager show " .. ref .. " | " .. M.get_cmd()
	log.print("get_fullcmd :: %s", cmd)
	return cmd
end

M.setreg = function(content)
	log.print("setreg :: %s", content)
	-- put into paste registers
	if config.options.use_clipboard == "unnamed" then
		vim.fn.setreg("", content)
	elseif config.options.use_clipboard == "unnamedplus" then
		vim.fn.setreg("+", content)
	end
end

return M
