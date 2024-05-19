-- Get info on hover or Shift+K
vim.o.updatetime = 1000
vim.cmd([[
augroup LspHover
    autocmd!
    autocmd CursorHold * lua vim.lsp.buf.hover()
augroup END
]])
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr })

-- Go
local lspConfig = require('lspconfig')
lspConfig.gopls.setup{}

lspConfig.golangci_lint_ls.setup{}

-- Rust
lspConfig.rust_analyzer.setup{
    settings = {
        ['rust-analyzer'] = {
        diagnostics = {
            enable = false;
        }
        }
    }
}

-- Python
lspConfig.pyright.setup{}

-- TypeScript
lspConfig.tsserver.setup{}

-- Lua
lspConfig.lua_ls.setup{}

-- Docker
lspConfig.dockerls.setup{}

-- Smithy
-- lspConfig.smithy_ls.setup{}