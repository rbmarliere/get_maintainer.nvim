local M = {}
local config = require("get_maintainer.config")
local core = require("get_maintainer.core")

M.from_cursor = core.from_cursor
M.from_file = core.from_file
M.from_range = core.from_range
M.setup = config.setup

return M
