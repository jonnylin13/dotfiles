return {
  "folke/noice.nvim",
  opts = function(_, opts)
    table.insert(opts.routes, {
      filter = {
        event = "lsp",
        kind = "progress",
        find = "tsconfig.json",
      },
      opts = { skip = true },
    })
  end,
}
