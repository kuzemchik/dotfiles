return {
    'nvim-telescope/telescope.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope-ui-select.nvim'
    },
    config = function()
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>o', function()
            builtin.find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})
        end, { desc = "Find files" })
        vim.keymap.set('n', '<leader>lg', builtin.git_files, { desc = "Find git files" })
        vim.keymap.set('n', '<leader>lt', builtin.treesitter, { desc = "Find TS"})
        vim.keymap.set('n', '<leader>ls', builtin.lsp_dynamic_workspace_symbols, { desc = "Find symbols" })
        vim.keymap.set('n', '<leader>lr', builtin.lsp_references, { desc = "Find references" })
        vim.keymap.set('n', '<leader>lc', builtin.lsp_outgoing_calls, { desc = "Find references" })
        vim.keymap.set('n', '<leader>li', builtin.lsp_incoming_calls, { desc = "Find references" })
        vim.keymap.set('n', '<leader>ld', builtin.lsp_definitions, { desc = "Find definitions" })
        vim.keymap.set('n', '<leader>lf', function()
            builtin.grep_string({search = vim.fn.input("Grep > ") });
        end, { desc = "Find with grep" })
        require("telescope").setup {
            extensions = {
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown {
                        -- even more opts
                    }

                }
            }
        }
        require("telescope").load_extension("ui-select")
    end,
}
