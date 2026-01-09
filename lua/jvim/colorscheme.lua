local M = {}

M.reset = function()
  local colorscheme = require("jvim").config.colorscheme
  ---@diagnostic disable-next-line: param-type-mismatch
  local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
  if not status_ok then
    vim.notify("colorscheme: " .. colorscheme .. " not found！")
    return
  end

  local function bgTransparent()
    vim.cmd([[
        highlight Normal guibg=none
        highlight NonText guibg=none
    ]])
  end
  bgTransparent()
end

return M
