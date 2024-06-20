return {
    {
        'nvim-lua/plenary.nvim',
        lazy = false,
        priority = 100
    },
    {
        "FabijanZulj/blame.nvim",
        config = function()
            require("blame").setup({
                merge_consecutive = false,
            })
            vim.keymap.set("n", "<leader>b", function()
                require("blame").toggle({
                    args = "virtual"
                })
            end, { desc = "Toggle blame" })
        end,
    },
    -- {
    --     "folke/tokyonight.nvim",
    --     lazy = false,
    --     priority = 1000,
    --     opts = {},
    --     config = function()
    --         vim.cmd[[colorscheme tokyonight]]
    --     end,
    -- },
    {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end,
    },
    -- 'nvim-treesitter/playground',
    { 'christoomey/vim-tmux-navigator' },
    { 'eandrju/cellular-automaton.nvim' },
    { 'tpope/vim-surround' },
    { "tpope/vim-obsession" },
    -- {
    --     "SmiteshP/nvim-navbuddy",
    --     requires = {
    --         "neovim/nvim-lspconfig",
    --         "SmiteshP/nvim-navic",
    --         "MunifTanjim/nui.nvim",
    --         "numToStr/Comment.nvim",      -- Optional
    --         "nvim-telescope/telescope.nvim" -- Optional
    --     }
    -- }
}
