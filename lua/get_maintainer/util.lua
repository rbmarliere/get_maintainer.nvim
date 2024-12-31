local M = {}
local config = require("get_maintainer.config")
local log = require("get_maintainer.log")

M.get_visual_selection = function()
	log.print("get_visual_selection")

	local mode = vim.api.nvim_get_mode()
	local ctrl_v = vim.api.nvim_replace_termcodes("<C-V>", true, false, true)
	if mode.mode ~= "v" and mode.mode ~= "V" and mode.mode ~= ctrl_v then
		log.print("unsupported mode")
		return {}
	end

	-- exit visual mode to update markers
	local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
	vim.api.nvim_feedkeys(esc, "x", false)

	local _, start_row, start_col, _ = unpack(vim.fn.getpos("'<"))
	local _, end_row, end_col, _ = unpack(vim.fn.getpos("'>"))

	local lines = vim.api.nvim_buf_get_text(0, start_row - 1, start_col - 1, end_row - 1, end_col, {})
	log.print(lines)

	return lines
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
