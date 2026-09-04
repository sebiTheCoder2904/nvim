---@type vim.lsp.Config
return {
    cmd = { vim.fn.stdpath("data") .. "/mason/bin/ltex-ls" },
    filetypes = { "markdown", "text", "gitcommit" },
    root_markers = { ".git" },
    settings = {
        ltex = {
            language = "de-DE",
        },
    },
}
