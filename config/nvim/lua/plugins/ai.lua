return {
  -- Which-key group labels
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>a", group = "ai", mode = { "n", "v" } },
        { "<leader>ac", group = "claude", mode = { "n", "v" } },
        { "<leader>ag", group = "gemini", mode = { "n", "v" } },
      },
    },
  },

  -- Claude Code (LazyVim extra override)
  {
    "coder/claudecode.nvim",
    keys = {
      -- Disable old top-level <leader>a keymaps from LazyVim extra
      { "<leader>ac", false },
      { "<leader>af", false },
      { "<leader>ar", false },
      { "<leader>aC", false },
      { "<leader>ab", false },
      { "<leader>as", false },
      { "<leader>aa", false },
      { "<leader>ad", false },

      -- New <leader>ac ("activate Claude") keymaps
      { "<leader>acc", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>acf", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>acr", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>acC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>acb", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>acs", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      {
        "<leader>acs",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil" },
      },
      { "<leader>aca", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>acd", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
  },

  -- Gemini CLI
  {
    "marcinjahn/gemini-cli.nvim",
    cmd = "Gemini",
    keys = {
      { "<leader>ag/", "<cmd>Gemini toggle<cr>", desc = "Toggle Gemini CLI" },
      { "<leader>aga", "<cmd>Gemini ask<cr>", desc = "Ask Gemini", mode = { "n", "v" } },
      { "<leader>agf", "<cmd>Gemini add_file<cr>", desc = "Add File" },
    },
    dependencies = {
      "folke/snacks.nvim",
    },
    opts = function()
      local env = {}
      local handle = io.popen("zsh -i -c 'env -0' 2>/dev/null")
      if handle then
        local content = handle:read("*a")
        handle:close()
        for item in content:gmatch("([^%z]+)") do
          local k, v = item:match("^([^=]+)=(.*)$")
          if k and v then
            env[k] = v
          end
        end
      end
      return {
        env = env,
      }
    end,
    config = true,
  },
}
