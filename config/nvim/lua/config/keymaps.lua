-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local ffi = require("ffi")

ffi.cdef([[
  int execvp(const char *file, char *const argv[]);
]])

local function restart_nvim()
  -- 1. Save all open modified buffers
  vim.cmd("silent! wall")

  -- 2. Clean argv of prior restore flags to prevent argument accumulation
  local args = {}
  local skip_next = false
  for i, arg in ipairs(vim.v.argv) do
    if skip_next then
      skip_next = false
    elseif arg == "-S" or (arg == "-c" and vim.v.argv[i + 1] and vim.v.argv[i + 1]:find("persistence")) then
      skip_next = true
    else
      table.insert(args, arg)
    end
  end

  -- 3. Save session via persistence.nvim (or fallback to :mksession)
  local has_persistence, persistence = pcall(require, "persistence")
  if has_persistence then
    persistence.save()
    table.insert(args, "-c")
    table.insert(args, "lua require('persistence').load()")
  else
    local session_file = vim.fn.stdpath("state") .. "/restart_session.vim"
    vim.cmd("mksession! " .. vim.fn.fnameescape(session_file))
    table.insert(args, "-S")
    table.insert(args, session_file)
  end

  -- 4. Convert Lua string array into C char *const argv[]
  local c_argv = ffi.new("char *[?]", #args + 1)
  for i, arg in ipairs(args) do
    c_argv[i - 1] = ffi.new("char[?]", #arg + 1, arg)
  end
  c_argv[#args] = nil

  -- 5. Replace process via execvp
  ffi.C.execvp(vim.v.progpath, c_argv)
end

-- Create user command and keymap
vim.api.nvim_create_user_command("Restart", restart_nvim, {
  desc = "Save and restart Neovim in-place with session persistence",
})

vim.keymap.set("n", "<leader>qr", restart_nvim, { desc = "Save & Restart Neovim" })
