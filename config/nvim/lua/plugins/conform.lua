return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    -- 1. Define which formatters run for which filetypes
    -- This runs eslint_d FIRST, then prettier. Prettier gets the final word.
    opts.formatters_by_ft = {
      typescript = { "eslint_d", "prettier" },
      typescriptreact = { "eslint_d", "prettier" },
      javascript = { "eslint_d", "prettier" },
      javascriptreact = { "eslint_d", "prettier" },
      json = { "prettier" },
    }

    -- 2. Configuration for specific formatters (inside opts)
    opts.formatters = {
      eslint_d = {
        condition = function(self, ctx)
          return vim.fs.find(
            { ".eslintrc.js", ".eslintrc.json", "eslint.config.mjs", "eslint.config.js" },
            { path = ctx.filename, upward = true }
          )[1]
        end,
      },
    }

    -- 3. Setup format on save (inside opts)
    -- opts.format_on_save = {
    --   timeout_ms = 500,
    --   lsp_fallback = true,
    -- }
  end,
}
