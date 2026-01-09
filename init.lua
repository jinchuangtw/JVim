require("jvim").setup({
  colorscheme = "dracula",

  cmp = {
    -- enable copilot auto-completion
    copilot = true,
  },

  clangd = {
    enable = true,
    lsp = "clangd",
    linter = "clangd-tidy",
    formatter = "clang-format",
    format_on_save = true,
  },

  markdown = {
    enable = true,
    mkdnflow = {
      next_link = "gn",
      prev_link = "gp",
      next_heading = "gj",
      prev_heading = "gk",
      follow_link = "gd",
      go_back = "<C-o>",
      toggle_item = "tt",
    },
    formatter = "prettier",
    format_on_save = true,
    wrap = true,
    theme = "dark",
  },

  json = {
    enable = true,
    lsp = "jsonls",
    ---@type "jsonls" | "prettier"
    formatter = "jsonls",
    format_on_save = true,
  },

  python = {
    enable = true,
    lsp = "pylsp", -- can be pylsp or pyright
    -- pip install black
    -- asdf reshim python
    formatter = "black",
    format_on_save = true,
  },

  cmake = {
    enable = true,
    lsp = "cmake-language-server",
    formatter = "cmakelang",
    format_on_save = true,
  },
})
