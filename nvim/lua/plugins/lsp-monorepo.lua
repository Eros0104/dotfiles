-- TypeScript/React + Deno LSP for mixed monorepos.
--
-- Enables vtsls (TS/TSX → powers gd, hover, rename, refs) and denols, then
-- resolves the classic conflict where a repo has BOTH a deno.json and Node
-- packages: a file belongs to Deno only when its nearest deno.json is closer
-- than its nearest package.json. Generic — a no-op in single-language repos.
--
-- root_dir is assigned in function-form opts so it runs AFTER LazyVim merges
-- the lang.deno / lang.typescript extras' table-opts, and therefore wins
-- deterministically (the deno extra otherwise roots denols at ANY ancestor
-- deno.json — including a monorepo root — and steals frontend files from vtsls).
local function nearest(fname, ...)
  return require("lspconfig.util").root_pattern(...)(fname)
end

-- longer path == deeper == closer to the file
local function closer(a, b)
  if not a then return false end
  if not b then return true end
  return #a >= #b
end

local function deno_root(fname)
  local deno = nearest(fname, "deno.json", "deno.jsonc")
  return closer(deno, nearest(fname, "package.json")) and deno or nil
end

local function node_root(fname)
  local node = nearest(fname, "package.json")
  return closer(node, nearest(fname, "deno.json", "deno.jsonc")) and node or nil
end

return {
  { import = "lazyvim.plugins.extras.lang.typescript" },
  { import = "lazyvim.plugins.extras.lang.deno" },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local servers = opts.servers or {}
      servers.denols = vim.tbl_deep_extend("force", servers.denols or {}, {
        root_dir = deno_root,
      })
      servers.vtsls = vim.tbl_deep_extend("force", servers.vtsls or {}, {
        single_file_support = false,
        root_dir = node_root,
      })
      opts.servers = servers
    end,
  },
}
