-- TypeScript/React + Deno LSP for mixed monorepos.
--
-- Enables vtsls (TS/TSX → powers gd, hover, rename, refs) and denols, then
-- resolves the classic conflict where a repo has BOTH a deno.json and Node
-- packages: a file belongs to Deno only when its nearest deno.json is closer
-- than its nearest package.json. Generic — a no-op in single-language repos.
--
-- root_dir is assigned in function-form opts so it runs AFTER LazyVim merges
-- the lang.typescript extra's table-opts, and therefore wins
-- deterministically (denols' default root_dir otherwise matches ANY ancestor
-- deno.json — including a monorepo root — and steals frontend files from vtsls).
--
-- Files with neither marker (a bare scratch .ts) go to vtsls, rooted at the
-- file's own directory.
--
-- root_dir uses the nvim 0.11 vim.lsp.config signature: (bufnr, on_dir).
-- The server only starts if on_dir is called; a return value is ignored.
local function nearest(bufnr, markers)
  return vim.fs.root(bufnr, markers)
end

-- longer path == deeper == closer to the file
local function closer(a, b)
  if not a then return false end
  if not b then return true end
  return #a >= #b
end

local function deno_root(bufnr, on_dir)
  local deno = nearest(bufnr, { "deno.json", "deno.jsonc" })
  if closer(deno, nearest(bufnr, { "package.json" })) then
    on_dir(deno)
  end
end

local function node_root(bufnr, on_dir)
  local node = nearest(bufnr, { "package.json" })
  local deno = nearest(bufnr, { "deno.json", "deno.jsonc" })
  if closer(node, deno) then
    on_dir(node)
  elseif not deno then
    on_dir(vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr)))
  end
end

return {
  { import = "lazyvim.plugins.extras.lang.typescript" },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local servers = opts.servers or {}
      servers.denols = vim.tbl_deep_extend("force", servers.denols or {}, {
        root_dir = deno_root,
      })
      servers.vtsls = vim.tbl_deep_extend("force", servers.vtsls or {}, {
        root_dir = node_root,
      })
      opts.servers = servers
    end,
  },
}
