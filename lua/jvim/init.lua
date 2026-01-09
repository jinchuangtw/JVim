local M = {}
M.version = "v0.2.0"

---@type UserConfig
M.config = require("jvim.config")
--- @param user_config UserConfig
function M.setup(user_config)
  require("jvim.utils.global")
  require("jvim.basic")
  -- user config override
  M.config = vim.tbl_deep_extend("force", M.config, user_config)
  require("jvim.env").init(M.config)
  require("jvim.keybindings")
  local pluginManager = require("jvim.lazy")
  if not pluginManager.avaliable() then
    pluginManager.install()
  end
  pluginManager.setup()
  require("jvim.colorscheme").reset()
  require("jvim.autocmds")
  require("jvim.lsp")
  require("jvim.cmp")
  require("jvim.format")
  require("jvim.dap")
  require("jvim.utils.color-preview")
  if M.config.fix_windows_clipboard then
    require("utils.fix-yank")
  end
end

return M
