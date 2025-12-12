return {
  {
    "folke/flash.nvim",
    keys = {
      { "s", mode = { "n", "x", "o" }, false },
    },
  },
  {
    "nvim-mini/mini.surround",
    -- mimic surround maps
    opts = {
      mappings = {
        add = "ys",
        delete = "ds",
      },
    },
  },
}
