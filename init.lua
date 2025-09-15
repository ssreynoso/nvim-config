vim.env.PATH = vim.env.PATH .. ":/home/ssreynoso/.claude/local/node_modules/.bin"

-- Config
require("config.options")
require("config.remap")
require("config.auto-commands")
require("config.user-commands")
require("config.lazy")

-- Keymaps
require("keymaps.buffers").setup()

-- Fixes
require("fixes.treesitter-window-fix")

-- Welcome
require("config.show-welcome")
