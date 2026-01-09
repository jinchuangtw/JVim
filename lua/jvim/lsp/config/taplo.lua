local opts = {
  on_attach = function(_, bufnr)
    require("jvim.lsp.common-config").keyAttach(bufnr)
  end,
}
return {
  on_setup = function(server)
    server.setup(opts)
  end,
}
