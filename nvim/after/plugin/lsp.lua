local lsp = require("lsp-zero")

-- lsp.preset("recommended")

vim.keymap.set("n", "<S-F6>", function() 
    vim.lsp.buf.rename()
end)
 
require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = {
        'tsserver',
        -- 'rust_analyzer',
        'zls',
        'bashls',
        'clangd',
        'dockerls',
        'docker_compose_language_service',
        'gopls',
        'pyright',
        'ansiblels',
        'marksman',
        'lua_ls',
        'ocamllsp',
    },
    handlers = {
        lsp.default_setup,
        ansiblels = function()
            require('lspconfig').ansiblels.setup({
                ansible = {
                    python = {
                        activationScript="/Users/vkuzemchik/p3/bin/activate"
                    }
                }
            })
        end,
        lua_ls = function()
            require('lspconfig').lua_ls.setup({
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = {'vim'}
                        }
                    }
                }
            })
        end,
    },
})

-- Fix Undefined global 'vim'
--lsp.nvim_workspace()

 
require('lspconfig').sourcekit.setup{
  cmd = {'/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp'}
}
lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({buffer = bufnr})
end)

local rust_tools = require('rust-tools')
local mason_registry = require( "mason-registry")

local codelldb = mason_registry.get_package("codelldb")
local extension_path = codelldb:get_install_path() .. "/extension/"
local codelldb_path = extension_path .. "adapter/codelldb"
local liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"

rust_tools.setup({
    dap = {
        adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
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
-- require("mason-nvim-dap").setup({
--     ensure_installed = { "python", "codelldb" }
-- })
rust_tools.runnables.runnables()

local cmp = require('cmp')

local cmp_select = {behavior = cmp.SelectBehavior.Select}
cmp.setup({ 
    mappings = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ["<C-s>"] = cmp.mapping.complete(),
        ['<Tab>'] = nil,
        ['<S-Tab>'] = nil,
    })
})



lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})
local function open_split_buffer_goto_definition()
    -- Check how many windows are open
    local wins = vim.api.nvim_tabpage_list_wins(0)
    local current_cursor_pos = vim.api.nvim_win_get_cursor(0)

    local current_buf = vim.api.nvim_get_current_buf()
    local current_win = vim.api.nvim_get_current_win()

    local target_win

    -- If there are already splits, then take the next one and set buffer to current buffer
    if #wins >= 2 then
        for _, win_num in pairs(wins) do
            if win_num ~= current_win then
                target_win = win_num
            end
        end
    else
        target_win = current_win
        vim.cmd("vsplit")
    end

    -- Set buffer for new window
    vim.api.nvim_win_set_buf(target_win, current_buf)

    -- Copy cursor position to new window for lsp defintion
    vim.api.nvim_win_set_cursor(target_win, current_cursor_pos)

    -- Focus new window
    vim.api.nvim_set_current_win(target_win)

    -- Call lsp
    vim.lsp.buf.definition()
end

lsp.on_attach(function(client, bufnr)
  local opts = {buffer = bufnr, remap = false}

  -- vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "gd", open_split_buffer_goto_definition, {})
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

lsp.setup()

vim.diagnostic.config({
    virtual_text = true
})

