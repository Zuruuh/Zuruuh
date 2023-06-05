local lsp = require('lsp-zero').preset('recommended')
local lspconfig = require('lspconfig')
require('mason').setup()
require('mason-lspconfig').setup()

vim.g.phpactorPhpBin = "/usr/local/bin/php8.2"

lsp.ensure_installed({
    'tsserver',
    'eslint',
    'lua_ls',
    'rust_analyzer',
})

lspconfig.lua_ls.setup(lsp.nvim_lua_ls())

lspconfig.yamlls.setup({
    settings = {
        yaml = {
            keyOrdering = false
        }
    }
})

lspconfig.phpactor.setup({
    settings = {
        init_options = {
            ["language_server_phpstan.enabled"] = true,
            ["language_server_psalm.enabled"] = false,
            ["indexer.exclude_patterns"] = {
                "/vendor/**/Tests/**/*",
                "/vendor/**/tests/**/*",
                "/vendor/composer/**/*",
                "/var/**/*"
            },
            ["code_transform.class_new.variants"] = {
                ["classes"] = "classes"
            }
        }
    }
})

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<Enter>'] = cmp.mapping.confirm({ select = false }),
    ["<C-Space>"] = cmp.mapping.complete(),
})

lsp.setup_nvim_cmp({
    mapping = cmp_mappings
})

lsp.set_preferences({
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})

lsp.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

    vim.diagnostic.config({
        float = {
            format = function(diagnostic)
                if diagnostic.source == 'eslint' then
                    return string.format(
                        '%s [%s]',
                        diagnostic.message,
                        diagnostic.user_data.lsp.code
                    )
                end
            end
        }
    })
    vim.keymap.set("n", "<leader>f", "<cmd>EslintFixAll<CR>")
    vim.keymap.set("n", "<leader>hf", "<cmd>EslintFixAll<CR>")
    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "<leader>vad", function() vim.diagnostic.show() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

lsp.setup()
