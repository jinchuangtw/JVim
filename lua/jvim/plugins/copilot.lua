local M = {}

-- copilot.lua
M.copilot = function()
  local copilot = pRequire("copilot")
  if not copilot then
    return
  end

  local cmp_config = require("jvim").config.cmp or {}

  copilot.setup({
    -- We use copilot-cmp as the main Copilot UI.
    -- Therefore, inline ghost-text suggestion should be disabled when cmp.copilot = true.
    suggestion = {
      enabled = not cmp_config.copilot,
      auto_trigger = true,
      hide_during_completion = true,
      keymap = {
        accept = "<M-l>",
        accept_word = "<M-w>",
        accept_line = "<M-L>",
        next = "<M-]>",
        prev = "<M-[>",
        dismiss = "<C-]>",
      },
    },

    panel = {
      enabled = false,
    },
  })
end

-- copilot-cmp
M.copilot_cmp = function()
  local cmp_config = require("jvim").config.cmp
  if not cmp_config or not cmp_config.copilot then
    return
  end

  local copilot_cmp = pRequire("copilot_cmp")
  if copilot_cmp then
    copilot_cmp.setup()
  end
end

-- CopilotChat.nvim
M.copilot_chat = function()
  local copilot_chat_config = require("jvim").config.copilot_chat
  local copilot_chat = pRequire("CopilotChat")

  if not copilot_chat or not copilot_chat_config or not copilot_chat_config.enable then
    return
  end

  copilot_chat.setup({
    debug = false,
    auto_follow_cursor = false,
    auto_insert_mode = true,
    model = "gpt-4.1",
    temperature = 0.1,

    window = {
      layout = "vertical",
      width = 0.42,
    },

    prompts = {
      Translate = "Please translate the following text into English.",
      Summarize = "Please summarize the following text.",
      Spelling = "Please correct any grammar and spelling errors in the following text.",
      Wording = "Please improve the grammar and wording of the following text.",
      Concise = "Please rewrite the following text to make it more concise.",

      WorkspaceEdit = {
        prompt = [[
You are helping me modify this repository from Neovim.

Workflow:
1. First inspect the workspace using @copilot tools such as glob, grep, file, and gitdiff.
2. Explain the files you plan to touch.
3. Do not apply edits until I explicitly approve.
4. When editing, prefer unified diffs.
5. Keep changes minimal and easy to review.
6. After editing, summarize what changed and what I should test.
]],
        description = "Workspace-aware edit workflow with reviewable diffs",
      },
    },

    chat_autocomplete = true,
  })

  -- Custom buffer for CopilotChat
  vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "copilot-*",
    callback = function()
      vim.opt_local.relativenumber = true
      vim.opt_local.number = true
      vim.opt_local.conceallevel = 0
    end,
  })

  local keys = copilot_chat_config.keys or {}

  -- Open CopilotChat window.
  keymap({ "n", "v", "x" }, keys.chat, "<CMD>CopilotChat<CR>", {
    desc = "CopilotChat open",
  })

  -- Workspace-aware CopilotChat session.
  keymap("n", keys.workspace_agent, function()
    copilot_chat.open()
    copilot_chat.ask([[
@copilot Please inspect this workspace first.

I want a VSCode-like Copilot workflow:
- understand the whole working directory,
- identify relevant files,
- propose a plan,
- then produce reviewable diffs only after I approve.

Start by summarizing the project structure and asking what task I want to perform.
]])
  end, {
    desc = "CopilotChat workspace agent",
  })

  -- Quick one-line chat.
  keymap({ "n", "v", "x" }, keys.quick_chat, function()
    local input = vim.fn.input("Quick Chat: ")
    if input ~= "" then
      copilot_chat.ask(input)
    end
  end, {
    desc = "CopilotChat quick chat",
  })

  -- Prompt/actions for the locked CopilotChat.nvim version.
  -- This version provides :CopilotChatPrompts instead of CopilotChat.actions.
  local function command_exists(cmd)
    return vim.fn.exists(":" .. cmd) > 0
  end

  local function run_copilot_command(cmd, use_visual_range)
    if not command_exists(cmd) then
      vim.notify(cmd .. " is not available in this CopilotChat.nvim version", vim.log.levels.WARN)
      return
    end

    if use_visual_range then
      vim.cmd("'<,'>" .. cmd)
    else
      vim.cmd(cmd)
    end
  end

  -- Official prompt picker for this locked version.
  keymap("n", keys.prompt_actions, function()
    run_copilot_command("CopilotChatPrompts", false)
  end, {
    desc = "CopilotChat prompts",
  })

  keymap("x", keys.prompt_actions, function()
    run_copilot_command("CopilotChatPrompts", true)
  end, {
    desc = "CopilotChat prompts for visual selection",
  })

  -- A small command menu for this locked version.
  -- This replaces the newer CopilotChat.actions/help_actions API.
  local chat_actions = {
    { label = "Open chat", command = "CopilotChatOpen", visual = true },
    { label = "Prompt picker", command = "CopilotChatPrompts", visual = true },
    { label = "Select model", command = "CopilotChatModels", visual = false },
    { label = "Fix selected/current code", command = "CopilotChatFix", visual = true },
    { label = "Generate docs", command = "CopilotChatDocs", visual = true },
    { label = "Generate tests", command = "CopilotChatTests", visual = true },
    { label = "Reset chat", command = "CopilotChatReset", visual = false },
    { label = "Stop response", command = "CopilotChatStop", visual = false },
    { label = "Save chat", command = "CopilotChatSave", visual = false },
    { label = "Load chat", command = "CopilotChatLoad", visual = false },
    { label = "Close chat", command = "CopilotChatClose", visual = false },
  }

  keymap("n", keys.help_actions, function()
    vim.ui.select(chat_actions, {
      prompt = "CopilotChat command:",
      format_item = function(item)
        return item.label .. "  [" .. item.command .. "]"
      end,
    }, function(choice)
      if choice then
        run_copilot_command(choice.command, false)
      end
    end)
  end, {
    desc = "CopilotChat command menu",
  })

  keymap("x", keys.help_actions, function()
    vim.ui.select(chat_actions, {
      prompt = "CopilotChat command for selection:",
      format_item = function(item)
        return item.label .. "  [" .. item.command .. "]"
      end,
    }, function(choice)
      if choice then
        run_copilot_command(choice.command, choice.visual)
      end
    end)
  end, {
    desc = "CopilotChat command menu for visual selection",
  })
end

return M
