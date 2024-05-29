return {
    'simrat39/rust-tools.nvim',
    name = 'rust-tools',
    dependencies = {
        'mason',
    },
    config = function()
        local rust_tools = require('rust-tools')
        local rust_dap = require('rust-tools.dap')
        local mason_registry = require( "mason-registry")

        local codelldb = mason_registry.get_package("codelldb")
        local extension_path = codelldb:get_install_path() .. "/extension/"
        local codelldb_path = extension_path .. "adapter/codelldb"
        local liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"

        rust_tools.setup({
            dap = {
                adapter = rust_dap.get_codelldb_adapter(codelldb_path, liblldb_path),
            },
            server = {
                on_attach = function(client, bufnr)
                    vim.keymap.set('n', '<leader>ca', rust_tools.hover_actions.hover_actions, {buffer = bufnr})
                    vim.keymap.set('n', '<leader>ck', rust_tools.code_action_group.code_action_group, {buffer = bufnr})
                end,
                flags = {
                    debounce_text_changes = 150,
                },
                settings = {
                    ["rust-analyzer"] = {
                        checkOnSave = {
                            enable = true,
                            command = "clippy",
                        },
                        cargo = {
                            allFeatures = true,
                        },
                        diagnostics = {
                            enable = true,
                            experimental = {
                                enable = true,
                            },
                        },
                    },
                },
            },
            tools = {
                hover_actions = {
                    -- whether the hover action window gets automatically focused
                    auto_focus = false,
                },
            },
        })
        rust_tools.runnables.runnables()
    end,
}
