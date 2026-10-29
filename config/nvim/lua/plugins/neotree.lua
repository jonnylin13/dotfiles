return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      filtered_items = {
        visible = true,
      },
    },
    -- Add this section to handle file moves/renames via Snacks
    event_handlers = {
      {
        event = "file_moved",
        handler = function(data)
          Snacks.rename.on_rename_file(data.source, data.destination)
        end,
      },
      {
        event = "file_renamed",
        handler = function(data)
          Snacks.rename.on_rename_file(data.source, data.destination)
        end,
      },
    },
  },
}
