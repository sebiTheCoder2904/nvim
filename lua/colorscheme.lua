-- define your colorscheme here
-- local colorscheme = 'monokai_pro'
--
-- local is_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
-- if not is_ok then
--     vim.notify('colorscheme ' .. colorscheme .. ' not found!')
--     return
-- end

local color_highlight = "#59A4FF"
local color_normal = "#0D1117"
local color_selected = "#32353E"
local color_text = "#FFFFFF"
local color_insert = "#FE4242"
local color_passthrough = "#7FD962"
local color_black = "#000000"
local color_comment = "#515151"

local colorscheme = "monokai-pro" -- Note: the plugin name often uses a hyphen

local lualine_theme = {
    normal = {
        a = { bg = color_normal, fg = color_text },
        b = { bg = color_normal, fg = color_text },
        c = { bg = color_normal, fg = color_text },
    },
    insert = {
        a = { bg = color_insert, fg = color_text },
        b = { bg = color_insert, fg = color_text },
        c = { bg = color_insert, fg = color_text },
    },
    visual = {
        a = { bg = color_normal, fg = color_text },
        b = { bg = color_normal, fg = color_text },
        c = { bg = color_normal, fg = color_text },
    },
    replace = {
        a = { bg = color_insert, fg = color_text },
        b = { bg = color_insert, fg = color_text },
        c = { bg = color_insert, fg = color_text },
    },
    command = {
        a = { bg = color_normal, fg = color_text },
        b = { bg = color_normal, fg = color_text },
        c = { bg = color_normal, fg = color_text },
    },
    inactive = {
        a = { bg = color_normal, fg = color_text },
        b = { bg = color_normal, fg = color_text },
        c = { bg = color_normal, fg = color_text },
    },
}

require("lualine").setup({
    options = {
        theme = lualine_theme,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
    },
})

local status_ok, monokai = pcall(require, "monokai-pro")
if status_ok then
    monokai.setup({
        filter = "pro", -- classic, octagon, pro, machine, risto, spectrum
        terminal_colors = true,
        italic_comments = true,
        transparent_background = true,
        devicons = true,
        styles = {
            comment = { italic = true },
            keyword = { italic = true },
            type = { italic = true },
            storageclass = { italic = true },
            structure = { italic = true },
            parameter = { italic = true },
            annotation = { italic = true },
            tag_attribute = { italic = true },
        },
        plugins = {
            indent_blankline = {
                context_highlight = "pro",
                context_start_underline = true,
            },
        },

        override = function(c)
            return {
                -- Example: override the background color of the Normal highlight group

                Comment = { fg = color_comment, italic = true },
                SignColumn = { bg = color_highlight },
                CursorLineNr = { fg = color_highlight, bg = color_selected, bold = true },
                CursorColumn = { bg = color_selected },

                Insert = { bg = color_insert },
                InsertNOS = { link = "Insert" },

                Tabline = { bg = color_selected },
                TablineFill = { bg = color_normal },
                TablineSel = { bg = color_highlight, fg = color_black },

                NormalFloat = { bg = color_normal, fg = color_text },
                FloatBorder = { fg = color_highlight },
                FloatTitle = { bg = color_normal, fg = color_highlight },
                Tabline = { bg = color_selected },

                WinSeparator = { fg = color_highlight },
                VertSplit = { fg = color_highlight },
                WinSeparator = { fg = color_highlight },

                Directory = { fg = color_highlight, bg = color_normal },

                Statement = { fg = color_text },
                Special = { fg = color_passthrough },

                ["@markup.raw.markdown_inline"] = { fg = color_highlight },

                -- Snacks

                SnacksPickerGitStatusUntracked = { fg = color_highlight },
                SnacksPickerDir = { fg = color_highlight },
                SnacksPickerTotals = { fg = color_highlight },
                SnacksPickerBorder = { fg = color_highlight, bg = color_normal },
                SnacksPickerPrompt = { fg = color_highlight, bg = color_normal },
                SnacksPickerTitle = { bg = color_normal, fg = color_highlight },
                SnacksPickerInputBorder = { bg = color_normal, fg = color_highlight },
                SnacksPickerTree = { bg = color_normal, fg = color_highlight },
                SnacksTitle = { bg = color_normal, fg = color_highlight },
                SnacksDashboardSpecial = { fg = color_highlight },
                SnacksDashboardHeader = { fg = color_highlight },
                SnacksDashboardFooter = { fg = color_text },
                SnacksDashboardIcon = { fg = color_highlight },
                SnacksDashboardDesc = { fg = color_text },
                -- SnacksIndent1
                -- SnacksIndent2
                -- SnacksIndent3
                -- SnacksIndent4
                -- SnacksIndent5
                -- SnacksIndent4
                SnacksDashboardNormal = { fg = color_highlight },

                SnacksDashboardDir = { fg = color_highlight, bg = color_normal },
                SnacksDashboardTitle = { fg = color_highlight, bg = color_normal },
                SnacksDashboardKey = { fg = color_highlight, bg = color_normal },
                SnacksDashboardTerminal = { fg = color_highlight, bg = color_normal },
                SnacksDashboardFile = { fg = color_highlight, bg = color_normal },
                SnacksInputIcon = { fg = color_highlight, bg = color_normal },
                SnacksInputTitle = { fg = color_highlight, bg = color_normal },
                SnacksInputNormal = { fg = color_text, bg = color_normal },
                SnacksInputBorder = { fg = color_highlight, bg = color_normal },
                SnacksInputPrompt = { fg = color_text, bg = color_normal },
                SnacksPickerLspDisabled = { fg = color_highlight, bg = color_normal },
                SnacksPickerLspEnabled = { fg = color_highlight, bg = color_normal },
                SnacksPickerLspAttached = { fg = color_highlight, bg = color_normal },
                SnacksPickerLspAttachedBuf = { fg = color_highlight, bg = color_normal },
                SnacksPickerLspUnavailable = { fg = color_highlight, bg = color_normal },
                SnacksPickerManPage = { fg = color_highlight, bg = color_normal },
                SnacksPickerIconSource = { fg = color_text, bg = color_normal },
                SnacksPickerIconName = { fg = color_text },
                SnacksPickerGitStatusDeleted = { fg = color_passthrough, bg = color_normal },
                SnacksPickerIconCategory = { fg = color_highlight },
                SnacksPickerPickWinCurrent = { fg = color_highlight, bg = color_normal },
                SnacksPickerIconArray = { fg = color_highlight },
                SnacksPickerPickWin = { fg = color_highlight, bg = color_normal },
                SnacksPickerManSection = { fg = color_text, bg = color_normal },
                SnacksPickerGitStatusStaged = { fg = color_highlight, bg = color_normal },
                SnacksPickerGitStatusUnmerged = { fg = color_highlight, bg = color_normal },
                SnacksPickerGitStatusIgnored = { fg = color_highlight, bg = color_normal },
                SnacksPickerGitStatus = { fg = color_highlight, bg = color_normal },
                SnacksPickerGitStatusCopied = { fg = color_highlight, bg = color_normal },
                SnacksPickerIconBoolean = { fg = color_highlight },
                SnacksPickerGitStatusRenamed = { fg = color_highlight, bg = color_normal },
                SnacksPickerIdx = { fg = color_highlight },
                SnacksPickerKeymapMode = { fg = color_highlight, bg = color_normal },
                SnacksPickerKeymapNowait = { fg = color_highlight, bg = color_normal },
                SnacksPickerBufType = { fg = color_highlight, bg = color_normal },
                SnacksPickerIconClass = { fg = color_highlight },
                SnacksPickerGitScope = { fg = color_highlight, bg = color_normal },
                SnacksPickerGitType = { fg = color_highlight, bg = color_normal },
                SnacksPickerGitAuthor = { fg = color_highlight, bg = color_normal },
                SnacksPickerGitIssue = { fg = color_highlight, bg = color_normal },
                SnacksPickerGitDate = { fg = color_highlight, bg = color_normal },
                SnacksPickerGitBranchCurrent = { fg = color_highlight, bg = color_normal },
                SnacksPickerGitBranch = { fg = color_highlight, bg = color_normal },
                SnacksPickerGitDetached = { fg = color_highlight, bg = color_normal },
                SnacksPickerGitBreaking = { fg = color_highlight, bg = color_normal },
                SnacksPickerUndoSaved = { fg = color_text, bg = color_normal },
                SnacksPickerUndoCurrent = { fg = color_text, bg = color_normal },
                SnacksPickerIconEnum = { fg = color_highlight },
                SnacksPickerUndoRemoved = { fg = color_text, bg = color_normal },
                SnacksPickerIconModule = { fg = color_highlight },
                SnacksPickerUndoAdded = { fg = color_text, bg = color_normal },
                SnacksPickerTime = { fg = color_text, bg = color_normal },
                SnacksPickerKeymapRhs = { fg = color_highlight, bg = color_normal },
                SnacksPickerBufFlags = { fg = color_highlight, bg = color_normal },
                SnacksPickerBufNr = { fg = color_highlight, bg = color_normal },
                SnacksPickerKeymapLhs = { fg = color_highlight, bg = color_normal },
                SnacksPickerDimmed = { fg = color_text, bg = color_normal },
                SnacksPickerRegister = { fg = color_highlight, bg = color_normal },
                SnacksPickerDiagnosticSource = { fg = color_highlight, bg = color_normal },
                SnacksPickerDiagnosticCode = { fg = color_highlight, bg = color_normal },
                SnacksPickerAuGroup = { fg = color_highlight, bg = color_normal },
                SnacksPickerAuEvent = { fg = color_highlight, bg = color_normal },
                SnacksPickerAuPattern = { fg = color_highlight, bg = color_normal },
                SnacksPickerCode = { fg = color_highlight, bg = color_normal },
                SnacksPickerGitStatusAdded = { fg = color_highlight, bg = color_normal },
                SnacksPickerUnselected = { fg = color_normal, bg = color_normal },
                SnacksPickerCmdBuiltin = { fg = color_text, bg = color_normal },
                SnacksPickerCmd = { fg = color_text, bg = color_normal },
                SnacksPickerSpinner = { fg = color_highlight, bg = color_normal },
                SnacksPickerDelim = { fg = color_text },
                SnacksPickerCol = { fg = color_highlight, bg = color_normal },
                SnacksPickerRow = { fg = color_highlight, bg = color_normal },
                SnacksPickerToggle = { fg = color_text, bg = color_normal },
                SnacksPickerPathHidden = { fg = color_text },
                SnacksPickerPathIgnored = { fg = color_text },
                SnacksPickerLinkBroken = { fg = color_text },
                SnacksPickerLink = { fg = color_text },
                SnacksPickerSpecial = { fg = color_highlight },
                SnacksPickerInputSearch = { fg = color_highlight, bg = color_normal },
                SnacksPickerMatch = { fg = color_passthrough },
                SnacksPickerIconTypeParameter = { fg = color_text },
                SnacksPickerIconConstant = { fg = color_text },
                SnacksPickerIconVariable = { fg = color_text },
                SnacksPickerRule = { fg = color_text },
                SnacksPickerIconConstructor = { fg = color_text },
                SnacksPickerIconStruct = { fg = color_text },
                SnacksPickerFileType = { fg = color_text },
                SnacksPickerIconString = { fg = color_text },
                SnacksPickerIconProperty = { fg = color_text },
                SnacksPickerIconPackage = { fg = color_text },
                SnacksPickerIconOperator = { fg = color_text },
                SnacksPickerIconObject = { fg = color_text },
                SnacksPickerIconNumber = { fg = color_text },
                SnacksPickerIconNull = { fg = color_text },
                SnacksPickerSearch = { fg = color_highlight },
                SnacksPickerIconMethod = { fg = color_text },
                SnacksPickerIconKey = { fg = color_text },
                SnacksPickerIconInterface = { fg = color_text },
                SnacksPickerIconFunction = { fg = color_text },
                SnacksPickerIconFile = { fg = color_text },
                SnacksPickerIconField = { fg = color_text },
                SnacksPickerIconEvent = { fg = color_text },
                SnacksPickerIconEnumMember = { fg = color_text },
                SnacksPickerIconNamespace = { fg = color_text },
                SnacksPickerComment = { fg = color_text },
                SnacksPickerFile = { fg = color_text },
                SnacksPickerLabel = { fg = color_text, bg = color_normal },
                SnacksPickerGitCommit = { fg = color_text, bg = color_normal },
                SnacksPickerDesc = { fg = color_text, bg = color_normal },
                SnacksPickerIcon = { fg = color_text },
                SnacksPickerSelected = { fg = color_highlight },
                SnacksPickerDirectory = { fg = color_highlight },
                SnacksPickerGitStatusModified = { fg = color_text, bg = color_normal },
                SnacksPickerToggleRegex = { fg = color_highlight, bg = color_normal },
                SnacksPickerToggleHidden = { fg = color_highlight, bg = color_normal },
                SnacksPickerToggleFollow = { fg = color_highlight, bg = color_normal },
                SnacksPickerToggleIgnored = { fg = color_highlight, bg = color_normal },
                SnacksPickerToggleModified = { fg = color_highlight, bg = color_normal },

                -- Lazy --
                LazyBold = { bold = true },
                LazyButton = { fg = color_highlight, bg = color_normal },
                LazyButtonActive = { fg = color_normal, bg = color_highlight },
                LazyComment = { fg = color_text, bg = color_normal },
                LazyCommit = { fg = color_highlight, bg = color_normal },
                LazyCommitIssue = { fg = color_highlight, bg = color_normal },
                LazyCommitScope = { fg = color_highlight, bg = color_normal },
                LazyCommitType = { fg = color_highlight, bg = color_normal },
                LazyDimmed = { fg = color_normal },
                LazyDir = { fg = color_highlight, bg = color_normal },
                LazyError = { fg = color_passthrough, bg = color_normal },
                LazyH1 = { fg = color_highlight, bg = color_normal },
                LazyH2 = { fg = color_text, bg = color_normal },
                LazyInfo = { fg = color_text, bg = color_normal },
                LazyItalic = { italic = true },
                LazyLocal = { fg = color_text },
                LazyNoCond = { fg = color_text },
                LazyNormal = { fg = color_text, bg = color_normal },
                LazyProgressDone = { fg = color_highlight, bg = color_normal },
                LazyProgressTodo = { fg = color_text, bg = color_normal },
                LazyProp = { fg = color_text },
                LazyReasonCmd = { fg = color_highlight },
                LazyReasonEvent = { fg = color_highlight },
                LazyReasonFt = { fg = color_highlight },
                LazyReasonImport = { fg = color_highlight },
                LazyReasonKeys = { fg = color_highlight },
                LazyReasonPlugin = { fg = color_highlight },
                LazyReasonRequire = { fg = color_highlight },
                LazyReasonRuntime = { fg = color_highlight },
                LazyReasonSource = { fg = color_highlight },
                LazyReasonStart = { fg = color_highlight },
                LazySpecial = { fg = color_highlight },
                LazyTaskOutput = { fg = color_text },
                LazyUrl = { fg = color_text },
                LazyValue = { fg = color_text },
                LazyWarning = { fg = color_highlight },
                DiagnosticVirtualTextWarn = { fg = color_highlight, bg = color_normal }, -- for the fetch
                DiagnosticVirtualTextInfo = { fg = color_highlight, bg = color_normal },
                DiagnosticVirtualTextHint = { fg = color_highlight, bg = color_normal },
            }
        end,
    })
end

vim.cmd.colorscheme(colorscheme)

-- local highlights = {
--     NormalFloat = { bg = color_normal, fg = color_highlight },
--     FloatBorder = { fg = color_highlight },
--     FloatTitle = { bg = color_normal, fg = color_highlight },
--     Tabline = { bg = color_selected },
--
--     SnacksPickerTitle = { bg = color_normal, fg = color_highlight },
-- }
--
-- for group, opts in pairs(highlights) do
--     vim.api.nvim_set_hl(0, group, opts)
-- end
vim.api.nvim_set_hl(0, "Normal", { bg = color_normal })
vim.api.nvim_set_hl(0, "NormalNC", { bg = color_normal })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = color_normal })
vim.api.nvim_set_hl(0, "SignColumn", { bg = color_normal })
vim.api.nvim_set_hl(0, "VertSplit", { bg = color_normal })
