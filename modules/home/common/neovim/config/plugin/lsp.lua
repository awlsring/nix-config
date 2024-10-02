-- Config
local lspConfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

---- Go
lspConfig.gopls.setup({
    capabilities = capabilities,
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
            },
            staticcheck = true,
        },
    },
})

lspConfig.golangci_lint_ls.setup({
    capabilities = capabilities,
})

---- Rust
lspConfig.rust_analyzer.setup({
    capabilities = capabilities,
    settings = {
        ['rust-analyzer'] = {
        diagnostics = {
            enable = false;
        }
        }
    }
})

---- Python
lspConfig.pyright.setup({
    capabilities = capabilities,
})

---- TypeScript
lspConfig.tsserver.setup({
    capabilities = capabilities,
})

---- Lua
lspConfig.lua_ls.setup({
    capabilities = capabilities,
})

---- Docker
lspConfig.dockerls.setup({
    capabilities = capabilities,
})

-- ---- Smithy
-- lspConfig.smithy_ls.setup{}

-- Key Bindings
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { })
vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, { })
vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references, { })
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { })