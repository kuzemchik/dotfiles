return {
    'mfussenegger/nvim-dap',
    dependencies = {
        'rust-tools',
        'nvim-neotest/nvim-nio',
        'rcarriga/nvim-dap-ui',
    },
    config = function()
        local dapui = require('dapui')
        local dap = require('dap')
        local codelldb = require("rust-tools").config.options.dap.adapter
        dap.adapters.codelldb = codelldb
        dap.configurations.rust = {
            {
                name = "Launch file",
                type = "codelldb",
                request = "launch",
                program = function()
                    vim.fn.jobstart('cargo build')
                    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug', 'file')
                end,
                cwd = '${workspaceFolder}',
                stopOnEntry = false,
            },
        }
        vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, {})
        -- vim.keymap.set('n', '<leader>dv', dap.repl.open, {})
        vim.keymap.set('n', '<F10>', dap.step_over, {})
        vim.keymap.set('n', '<F11>', dap.step_into, {})
        vim.keymap.set('n', '<F12>', dap.step_into, {})
        vim.keymap.set('n', '<F5>', dap.continue, {})
        dapui.setup()

        dap.listeners.after.event_initialized['dapui_config'] = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated['dapui_config'] = function()
            dapui.close()
        end
        dap.listeners.before.event_exited['dapui_config'] = function()
            dapui.close()
        end
    end,
}
