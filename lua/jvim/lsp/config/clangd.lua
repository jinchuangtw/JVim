local common = require("jvim.lsp.common-config")
local util = require("lspconfig.util")

common.capabilities.offsetEncoding = "utf-8"

local home = vim.fn.expand("~")

local opts = {
  capabilities = common.capabilities,
  flags = common.flags,

  -- For PlatformIO projects, clangd must start from the directory that owns
  -- compile_commands.json / platformio.ini, not just the nearest .git root.
  root_dir = function(fname)
    return util.root_pattern("compile_commands.json", "platformio.ini")(fname)
      or util.root_pattern(".git")(fname)
      or util.path.dirname(fname)
  end,

  cmd = {
    "clangd",
    "--background-index",
    "--pch-storage=memory",
    "--clang-tidy",
    "--completion-style=detailed",

    -- Let clangd query PlatformIO ESP toolchains for builtin/system headers.
    -- This is required for headers such as machine/endian.h, freertos/*, hal/*.
    "--query-driver="
      .. home
      .. "/.platformio/packages/toolchain-xtensa-esp32s3/bin/xtensa-esp32s3-elf-*,"
      .. home
      .. "/.platformio/packages/toolchain-xtensa-esp32/bin/xtensa-esp32-elf-*,"
      .. home
      .. "/.platformio/packages/toolchain-riscv32-esp/bin/riscv32-esp-elf-*",
  },

  init_options = {
    clangdFileStatus = true,
    usePlaceholders = true,
    completeUnimported = true,
    semanticHighlighting = true,
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
