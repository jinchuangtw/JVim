local common = require("jvim.lsp.common-config")
local util = require("lspconfig.util")

local home = vim.fn.expand("~")

-- copy common capabilities and add offsetEncoding for clangd
local capabilities = vim.tbl_deep_extend("force", {}, common.capabilities, {
  offsetEncoding = { "utf-16" },
})

local opts = {
  capabilities = capabilities,
  flags = common.flags,

  -- C/C++ root dir detection logic:
  -- 1. Has compile_commands.json
  -- 2. PlatformIO projects: platformio.ini
  -- 3. CMake projects: CMakeLists.txt
  -- 4. ROS/catkin package：package.xml
  -- 5. .git
  root_dir = function(fname)
    return util.root_pattern("compile_commands.json", "platformio.ini", "CMakeLists.txt", "package.xml", ".clangd")(
      fname
    ) or util.root_pattern(".git")(fname) or util.path.dirname(fname)
  end,

  cmd = {
    -- use "clangd" instead of "clangd-18" because the latter is not available in all distros yet.
    -- change it to clangd-18 if you want to use clangd 18 features and your system has it.
    "clangd-18",

    "--background-index",
    "--pch-storage=memory",
    "--clang-tidy",
    "--completion-style=detailed",

    -- let clangd query PlatformIO cross compiler，
    "--query-driver="
      .. home
      .. "/.platformio/packages/toolchain-xtensa-esp32s3/bin/xtensa-esp32s3-elf-*,"
      .. home
      .. "/.platformio/packages/toolchain-xtensa-esp32/bin/xtensa-esp32-elf-*,"
      .. home
      .. "/.platformio/packages/toolchain-riscv32-esp/bin/riscv32-esp-elf-*,"
      .. "**/xtensa-esp32s3-elf-*,"
      .. "**/xtensa-esp32-elf-*,"
      .. "**/riscv32-esp-elf-*",
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
