return {
    'mg979/vim-visual-multi',
    branch = 'master',
    config = function()
        vim.g.VM_leader = '<C+/>'
        vim.g.VM_maps["Add Cursor Down"] = '<S-C-Down>'
        vim.g.VM_maps["Add Cursor Up"] = '<S-C-Up>'
    end
}
