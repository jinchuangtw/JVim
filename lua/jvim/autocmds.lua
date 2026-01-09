local cfg = require("jvim").config
local myAutoGroup = vim.api.nvim_create_augroup("myAutoGroup", {
  clear = true,
})

local autocmd = vim.api.nvim_create_autocmd

if cfg.enable_imselect then
  autocmd("InsertLeave", {
    group = myAutoGroup,
    callback = require("jvim.utils.im-select").insertLeave,
  })

  autocmd("InsertEnter", {
    group = myAutoGroup,
    callback = require("jvim.utils.im-select").insertEnter,
  })
end

-- auto insert mode when TermOpen
autocmd("TermOpen", {
  group = myAutoGroup,
  command = "startinsert",
})

-- format on save
autocmd("BufWritePre", {
  group = myAutoGroup,
  pattern = require("jvim.env").getFormatOnSavePattern(),
  callback = function()
    vim.lsp.buf.format()
  end,
})

-- set *.mdx to filetype to markdown
autocmd({ "BufNewFile", "BufRead" }, {
  group = myAutoGroup,
  pattern = "*.mdx",
  command = "setfiletype markdown",
})

-- Downgrade heavy third-party/generated files to plain text to avoid freezes
-- when jumping to definitions (gd) or just scrolling.
autocmd({ "BufNewFile", "BufRead" }, {
  group = myAutoGroup,
  pattern = "*",
  callback = function(args)
    local bufnr = args.buf
    local name = vim.api.nvim_buf_get_name(bufnr)
    if not name or name == "" then
      return
    end

    local function endswith(s, suf)
      return s:sub(-#suf) == suf
    end
    local function contains(s, pat)
      return s:find(pat) ~= nil
    end

    -- Rules (edit here)
    local rules = {
      -- Python stubs inside installed packages
      {
        when = endswith(name, ".pyi") and (contains(name, "/site%-packages/") or contains(name, "/dist%-packages/")),
        ft = "text",
      },

      -- TypeScript declaration files in node_modules
      { when = endswith(name, ".d.ts") and contains(name, "/node_modules/"), ft = "text" },

      -- Minified bundles / sourcemaps
      { when = endswith(name, ".min.js") or endswith(name, ".min.css") or endswith(name, ".map"), ft = "text" },

      -- Common build output folders (optional; comment out if too aggressive)
      -- { when = contains(name, "/dist/") or contains(name, "/build/") or contains(name, "/target/") or contains(name, "/vendor/"), ft = "text" },
    }

    for _, r in ipairs(rules) do
      if r.when then
        vim.bo[bufnr].filetype = r.ft
        return
      end
    end
  end,
})

-- set wrap only in markdown
autocmd("FileType", {
  group = myAutoGroup,
  pattern = { "markdown" },
  callback = function()
    if cfg.markdown then
      vim.opt_local.wrap = cfg.markdown.wrap
      vim.wo.wrap = cfg.markdown.wrap
    end
  end,
})

-- highlight on yank
autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = myAutoGroup,
  pattern = "*",
})

-- https://www.reddit.com/r/neovim/comments/zc720y/tip_to_manage_hlsearch/
vim.on_key(function(char)
  if vim.fn.mode() == "n" then
    vim.opt.hlsearch = vim.tbl_contains({ "<CR>", "n", "N", "*", "#", "?", "/" }, vim.fn.keytrans(char))
  end
end, vim.api.nvim_create_namespace("auto_hlsearch"))

-- do not continue comments when type o
autocmd("BufEnter", {
  group = myAutoGroup,
  pattern = "*",
  callback = function()
    vim.opt.formatoptions = vim.opt.formatoptions
      - "o" -- O and o, don't continue comments
      + "r" -- But do continue when pressing enter.
  end,
})

autocmd({ "FileType" }, {
  group = myAutoGroup,
  pattern = {
    "help",
    "man",
    "neotest-output",
  },
  callback = function()
    keymap({ "i", "n" }, { "q", "<esc>" }, "<esc>:close<CR>", { buffer = true })
  end,
})

-- save fold
autocmd("BufWinEnter", {
  group = myAutoGroup,
  pattern = "*",
  command = "silent! loadview",
})

autocmd("BufWrite", {
  group = myAutoGroup,
  pattern = "*",
  command = "mkview",
})
