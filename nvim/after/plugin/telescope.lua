local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', "<cmd>lua require'telescope.builtin'.find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<cr>", {})
vim.keymap.set('n', '<C-p>pf', builtin.git_files, {})
vim.keymap.set('n', '<leader>po', builtin.treesitter, {})
--vim.keymap.set('n', '<leader>po', builtin.lsp_definitions, {})
vim.keymap.set('n', '<leader>pc', builtin.lsp_dynamic_workspace_symbols, {})
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({search = vim.fn.input("Grep > ") });
end)
