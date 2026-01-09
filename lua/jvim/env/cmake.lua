--- @param config CMakeConfig
return function(config)
  return {
    getFormatOnSavePattern = function()
      if config.format_on_save then
        return { "*.txt" }
      end
      return {}
    end,

    getTSEnsureList = function()
      return { "cmake" }
    end,

    getLSPEnsureList = function()
      return { "cmake" }
    end,

    getLSPConfigMap = function()
      return {
        cmake = require("jvim.lsp.config.cmake"),
      }
    end,

    getToolEnsureList = function()
      if config.formatter == "cmakelang" then
        return { "cmakelang" }
      end
      return {}
    end,

    getNulllsSources = function()
      local null_ls = pRequire("null-ls")
      if not null_ls then
        return {}
      end
      if config.formatter == "cmakelang" then
        return { null_ls.builtins.formatting.cmake_format }
      end
      return {}
    end,

    getNeotestAdapters = function()
      return {}
    end,
  }
end
