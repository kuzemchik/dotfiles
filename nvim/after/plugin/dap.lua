local dapui = require('dapui')
local dap = require('dap')
local mason = require('mason').setup({})
local mason_registry = require( "mason-registry")
local codelldb = mason_registry.get_package("codelldb")
local extension_path = codelldb:get_install_path() .. "/extension/"
local codelldb_path = extension_path .. "adapter/codelldb"
local liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"
--
-- rust_tools.setup({
--     dap = {
--         adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
--     },
-- })
dap.adapters.codelldb =require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path)
-- {
--   type = 'server',
--   port = "${port}",
--   executable = {
--     -- CHANGE THIS to your path!
--     command = codelldb_path,
--     args = { "--liblldb", liblldb_path, "--port", "${port}"},
--
--     -- On windows you may have to uncomment this:
--     -- detached = false,
--   }
-- }
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
dap.configurations.rust = dap.configurations.rust
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
