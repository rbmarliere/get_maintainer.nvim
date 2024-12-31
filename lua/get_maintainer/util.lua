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

M.is_ref = function(ref)
	local cmd = "git cat-file -t " .. ref
	local out = vim.trim(vim.fn.system(cmd))
	log.print("is_ref(%s) :: %s", ref, out)
	return out == "commit"
end

M.is_file = function(file)
	local out = vim.fn.filereadable(file)
	log.print("is_file(%s) :: %s", file, out)
	return vim.fn.filereadable(file) == 1
end

M.get_maintainer_cmd = function(args)
	local cmd = config.options.path
	local argv = table.concat(config.options.args or {}, " ") .. " " .. table.concat(args or {}, " ")
	local ret = cmd .. " " .. argv
	log.print("get_maintainer_cmd :: %s", ret)
	return ret
end

M.git_patch_cmd = function(ref)
	local cmd = "git --no-pager format-patch --stdout -1 " .. ref .. " | " .. M.get_maintainer_cmd()
	log.print("git_patch_cmd :: %s", cmd)
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
