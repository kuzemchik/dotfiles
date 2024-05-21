return {
    'neovim/nvim-lspconfig',
    dependencies = {
        'mason',
        'williamboman/mason-lspconfig.nvim',
        'hrsh7th/nvim-cmp',
        'hrsh7th/cmp-nvim-lsp',
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        'L3MON4D3/LuaSnip',
    },
    config = function()
        require('mason-lspconfig').setup({
            ensure_installed = {
                'tsserver',
                'rust_analyzer',
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
                    function (server_name) -- default handler (optional)
                        require("lspconfig")[server_name].setup {}
                        require('lspconfig').sourcekit.setup{
                            cmd = {'/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp'}
                        }
                    end,
                    -- Next, you can provide a dedicated handler for specific servers.
                    -- For example, a handler override for the `rust_analyzer`:
                    rust_analyzer = function ()
                        require("rust-tools").setup {}
                    end,
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
        local cmp = require('cmp')

        local cmp_select = {behavior = cmp.SelectBehavior.Select}
        -- `/` cmdline setup.
        cmp.setup.cmdline('/', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = 'buffer' }
            }
        })

        -- `:` cmdline setup.
        cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = 'path' }
            }, {
                {
                    name = 'cmdline',
                    option = {
                        ignore_cmds = { 'Man', '!' }
                    }
                }
            })
        })

        cmp.setup({
            mappings = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ["<C-s>"] = cmp.mapping.complete(),
                ['<Tab>'] = nil,
                ['<S-Tab>'] = nil,
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                -- { name = 'vsnip' }, -- For vsnip users.
                { name = 'luasnip' }, -- For luasnip users.
                -- { name = 'ultisnips' }, -- For ultisnips users.
                -- { name = 'snippy' }, -- For snippy users.
            }, {
                { name = 'buffer' },
            })
        })
        vim.diagnostic.config({
            virtual_text = true
        })
    end,
    lazy = false,
    priority = 100
}
