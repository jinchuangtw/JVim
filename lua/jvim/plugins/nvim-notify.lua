local notify = pRequire("notify")
local cfg = require("jvim").config.notify

if notify and cfg and cfg.enable then
  notify.setup({
    stages = cfg.stages,
    timeout = cfg.timeout,
    render = cfg.render,
    background_colour = "#000000",
  })
  vim.notify = notify
end
