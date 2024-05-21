return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter",
        "nvim-neotest/neotest-python",
        "rouge8/neotest-rust",
        'mfussenegger/nvim-dap',
    },
    config = function()
        local neotest = require("neotest")
        neotest.setup({
            adapters = {
                require("neotest-python")({
                    dap = { justMyCode = false },
                }),
                require("neotest-rust"),
            },
        })

        vim.keymap.set('n', '<S-F4>', neotest.run.run, {})
        vim.keymap.set('n', '<S-F5>', function()
            neotest.run.run({strategy = "dap"})
        end)
    end,
}
