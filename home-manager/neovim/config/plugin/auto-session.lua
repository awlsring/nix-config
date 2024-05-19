-- Config
require("auto-session").setup({
    auto_session_suppress_dirs = { "~/", "~/Downloads", "/"},
    auto_session_enable_last_session = true,

    session_lens = {
        buftypes_to_ignore = {},
        load_on_setup = true,
        theme_conf = { border = true },
        previewer = false,
    },
})

-- Key Bindings
vim.keymap.set("n", "<leader>ls", require("auto-session.session-lens").search_session, {
    noremap = true,
})
