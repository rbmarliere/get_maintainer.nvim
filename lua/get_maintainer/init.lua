local M = {}
local config = require("get_maintainer.config")
local core = require("get_maintainer.core")

M.get_from_cursor = core.get_from_cursor
M.get_from_file = core.get_from_file
M.get_from_range = core.get_from_range
M.setup = config.setup

return M
