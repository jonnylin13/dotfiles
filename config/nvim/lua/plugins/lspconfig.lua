return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        eslint = {
          settings = {
            workingDirectories = { mode = "auto" },
            codeActionOnSave = { enable = false, mode = "all" },
          },
        },
        vtsls = {
          settings = {
            typescript = {
              updateImportsOnFileMove = { enabled = "always" },
              tsserver = {
                maxTsServerMemory = 4096,
                useSeparateSyntaxServer = false,
                useSyntaxServer = "never",
                log = "off",
              },
              experimental = {
                useTsgo = true,
              },
              suggest = {
                completeFunctionCalls = false,
              },
              inlayHints = {
                parameterNames = { enabled = "all" },
                variableTypes = { enabled = true },
                maxInlayHintLength = 30,
              },
              preferences = {
                preferTypeOnlyAutoImports = true,
                includePackageJsonAutoImports = true,
                importModuleSpecifierPreference = "non-relative",
              },
            },
            javascript = {
              updateImportsOnFileMove = { enabled = "always" },
            },
            vtsls = {
              autoFixOnSave = false,
              autoUseWorkspaceTsdk = true,
              experimental = {
                completion = {
                  enableServiceSideFuzzyMatch = true,
                },
              },
              indexExcludePatterns = {
                "**/node_modules/**",
                "**/.git/**",
                "**/build/**",
                "**/dist/**",
              },
            },
          },
        },
      },
      -- setup = {
      --   eslint = function()
      --     vim.api.nvim_create_autocmd("BufWritePre", {
      --       callback = function(event)
      --         if require("lspconfig.util").get_active_client_by_name(event.buf, "eslint") then
      --           vim.cmd("LspEslintFixAll")
      --         end
      --       end,
      --     })
      --   end,
      -- },
    },
  },
}
