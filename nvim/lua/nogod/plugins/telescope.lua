return {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>o', function()
            builtin.find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})
        end, { desc = "Find files" })
        vim.keymap.set('n', '<leader>lg', builtin.git_files, { desc = "Find git files" })
        vim.keymap.set('n', '<leader>lt', builtin.treesitter, { desc = "Find TS"})
        vim.keymap.set('n', '<leader>ls', builtin.lsp_dynamic_workspace_symbols, { desc = "Find symbols" })
        vim.keymap.set('n', '<leader>lr', builtin.lsp_references, { desc = "Find references" })
        vim.keymap.set('n', '<leader>ld', builtin.lsp_definitions, { desc = "Find definitions" })
        vim.keymap.set('n', '<leader>lf', function()
            builtin.grep_string({search = vim.fn.input("Grep > ") });
        end, { desc = "Find with grep" })
    end,
}
