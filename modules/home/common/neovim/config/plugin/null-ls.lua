-- Config
local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    -- Formatting
    null_ls.builtins.formatting.stylua,          -- Lua
    null_ls.builtins.formatting.alejandra,       -- Nix
    null_ls.builtins.formatting.black,           -- Python
    null_ls.builtins.formatting.codespell,       -- Spelling
    null_ls.builtins.formatting.gofmt,           -- Go
    null_ls.builtins.formatting.goimports,       -- Go (import formatting)
    null_ls.builtins.formatting.goimports_reviser, -- Go (import sorting)
    null_ls.builtins.formatting.prettierd,        -- JS/TS/Web/JSON/Markdown/YAML
    null_ls.builtins.formatting.shfmt,            -- Shell

    -- Linter / Diagnostics
    null_ls.builtins.diagnostics.codespell,      -- Spelling
    null_ls.builtins.diagnostics.pylint,         -- Python
    null_ls.builtins.diagnostics.staticcheck,    -- Go
    null_ls.builtins.diagnostics.yamllint,       -- YAML
  },
})

-- Key Bindings
vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})

-- Autocommands
vim.cmd([[
  augroup FormatOnSave
    autocmd!
    autocmd BufWritePre * lua vim.lsp.buf.format(nil, 1000)
  augroup END
]])
