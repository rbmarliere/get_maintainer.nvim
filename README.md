# [get_maintainer.nvim](https://marliere.net/posts/6/)

![](https://marliere.net/img/getmaintainer.gif)

This is a simple wrapper around
[get_maintainer.pl](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/scripts/get_maintainer.pl)

## Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
return {
  "rbmarliere/get_maintainer.nvim",
  opts = {
    -- path = "/somewhere/get_maintainer.pl" -- defaults to get_maintainer.pl, assume it's visible in $PATH
    -- use_clipboard = "" -- can be unnamed or unnamedplus, where to send the script output
    -- args = {
    --   "--flags-to-the-script", -- defaults to {"--scm"} to retrieve the trees too
    -- },
  },
  config = function(_, opts)
    local get_maintainer = require("get_maintainer")
    get_maintainer.setup(opts)

    -- suggested mappings
    vim.keymap.set("n", "<Leader>M", get_maintainer.get_from_file, { noremap = true })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "fugitive" },
      callback = function()
        vim.keymap.set("n", "<Leader>M", get_maintainer.get_from_cursor, { noremap = true, buffer = true })
        vim.keymap.set("x", "<Leader>M", get_maintainer.get_from_range, { noremap = true, buffer = true })
      end,
    })
  end,
}
```
