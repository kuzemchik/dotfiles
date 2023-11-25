local function tree_on_attach(bufnr)
    local api = require "nvim-tree.api"

    local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    -- default mappings
    api.config.mappings.default_on_attach(bufnr)

    vim.keymap.set('n', '?',     api.tree.toggle_help,                  opts('Help'))
end


require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    width = 30,
  },
  on_attach = tree_on_attach,
  renderer = {
    group_empty = true,
    icons = {
        show = {
            file = false,
            folder = false,
            folder_arrow = true,
            git = false
        }
    },
  },
  filters = {
    dotfiles = true,
  },
})

local api = require "nvim-tree.api"
vim.keymap.set('n', '<leader>pv',     function() 
    api.tree.toggle({ path = "<args>", find_file = true, update_root = false, focus = true, })
end)
