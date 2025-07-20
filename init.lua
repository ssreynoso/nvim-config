vim.env.PATH = vim.env.PATH .. ":/home/ssreynoso/.claude/local/node_modules/.bin"

-- Config
require("config.remap")
require("config.auto-commands")
require("config.user-commands")
require("config.lazy")
require("config.options")

-- Fixes
require("fixes.treesitter-window-fix")

-- Welcome
require("config.show-welcome")
