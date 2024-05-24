return {
    "rcarriga/nvim-notify",
    name = "notify",
    config = function()
        vim.notify = require("notify")
        vim.notify.setup({
            top_down = false,
            background_colour = "#000000",

        })
    end,
}
