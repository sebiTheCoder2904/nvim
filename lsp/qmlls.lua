---@type vim.lsp.Config
return {
    cmd = { '/usr/lib/qt6/bin/qmlls' },
    filetypes = { 'qml', 'qmljs' },
    root_markers = { 'shell.qml', 'CMakeLists.txt', '.git' },
}
