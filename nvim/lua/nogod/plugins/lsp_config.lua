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
        local cmp = require('cmp')
        --
        local cmp_select = {behavior = cmp.SelectBehavior.Select}
        cmp.setup({
            mapping = cmp.mapping.preset.insert({
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ["<C-s>"] = cmp.mapping.complete(),
                -- ['<Tab>'] = nil,
                ["<Tab>"] = cmp.mapping(function(fallback)
                    -- This little snippet will confirm with tab, and if no entry is selected, will confirm the first item
                    if cmp.visible() then
                        local entry = cmp.get_selected_entry()
                        if not entry then
                            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                        end
                        cmp.confirm()
                    else
                        fallback()
                    end
                end, {"i","s","c",}),
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

        local capabilities = require('cmp_nvim_lsp').default_capabilities()
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
                        require("lspconfig")[server_name].setup {
                            capabilities = capabilities
                        }
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
        vim.diagnostic.config({
            virtual_text = true
        })
    end,
    lazy = false,
    priority = 100
}
