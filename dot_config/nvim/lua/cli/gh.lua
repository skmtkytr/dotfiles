local xdgDataDir = os.getenv("XDG_DATA_HOME") or os.getenv("HOME") .. "/.local/share"
local ghExtensionDir = xdgDataDir .. "/gh/extensions"

local function link(spec)
  vim.fn.mkdir(ghExtensionDir, "p")
  vim.uv.fs_symlink(spec.dir, ghExtensionDir .. "/" .. spec.name)
end

-- go build overwrites the tracked binary, making git dirty and blocking Lazy update.
-- Fix: build into ~/.local/bin, restore repo, and point gh extension there instead.
local function go_build_and_link(spec)
  local bin_dir = os.getenv("HOME") .. "/.local/bin"
  vim.fn.mkdir(bin_dir, "p")
  vim.fn.mkdir(ghExtensionDir, "p")

  -- Build to external location
  local bin_path = bin_dir .. "/" .. spec.name
  vim.fn.system({ "go", "build", "-C", spec.dir, "-o", bin_path, "." })

  -- Restore repo to clean state
  vim.fn.system({ "git", "-C", spec.dir, "checkout", "--", "." })

  -- Point gh extension to a directory containing just the built binary
  local ext_dir = ghExtensionDir .. "/" .. spec.name
  vim.fn.delete(ext_dir, "rf")
  vim.fn.mkdir(ext_dir, "p")
  vim.uv.fs_symlink(bin_path, ext_dir .. "/" .. spec.name)
end

-- Clean tracked binary on startup so Lazy update's git checkout never fails
local function clean_repo(spec)
  if vim.fn.isdirectory(spec.dir) == 1 then
    vim.fn.system({ "git", "-C", spec.dir, "checkout", "--", "." })
  end
end

return {
  { "yusukebe/gh-markdown-preview", build = go_build_and_link, init = clean_repo },
  { "dlvhdr/gh-dash", build = go_build_and_link, init = clean_repo },
  { "actions/gh-actions-cache", build = go_build_and_link, init = clean_repo },
  { "seachicken/gh-poi", build = go_build_and_link, init = clean_repo },
  { "k1LoW/gh-triage", build = go_build_and_link, init = clean_repo },
  { "k1LoW/gh-do", build = { link } },
  { "kawarimidoll/gh-graph", build = { link } },
}
