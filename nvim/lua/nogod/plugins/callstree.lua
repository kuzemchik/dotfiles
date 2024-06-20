return {
  'ldelossa/litee-calltree.nvim',
  dependencies = 'ldelossa/litee.nvim',
  event = "VeryLazy",
  opts = {
    on_open = "panel",
    map_resize_keys = false,
  },
  config = function(_, opts)
      require('litee.calltree').setup(opts)
      vim.keymap.set("n", "<F3>", function()
          vim.lsp.buf.incoming_calls()
      end)
      vim.keymap.set("n", "<S-F3>", function()
          vim.lsp.buf.outgoing_calls()
      end)
  end
}
