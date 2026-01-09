local common = require("jvim.lsp.common-config")
local opts = {
  capabilities = common.capabilities,
  flags = common.flags,
  cmd = {
    "cmake-language-server",
  },
  filetypes = {
    "cmake",
  },
  on_attach = function(client, bufnr)
    common.disableFormat(client)
    common.keyAttach(bufnr)
  end,
}

return {
  on_setup = function(server)
    server.setup(opts)
  end,
}
