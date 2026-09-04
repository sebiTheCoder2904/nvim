local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

local oil_ns = vim.api.nvim_create_namespace("oil_line_selector")

local function toggle_oil_line()
    local bufnr = vim.api.nvim_get_current_buf()
    local lnum = vim.api.nvim_win_get_cursor(0)[1]

    local marks = vim.api.nvim_buf_get_extmarks(bufnr, oil_ns, { lnum - 1, 0 }, { lnum - 1, -1 }, {})
    if #marks > 0 then
        vim.api.nvim_buf_del_extmark(bufnr, oil_ns, marks[1][1])
    else
        vim.api.nvim_buf_set_extmark(bufnr, oil_ns, lnum - 1, 0, {
            line_hl_group = "Visual",
        })
    end
    vim.cmd("normal! j")
end

local function clear_oil_highlights()
    local bufnr = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_clear_namespace(bufnr, oil_ns, 0, -1)
end

require("lazy").setup({

    "loctvl842/monokai-pro.nvim",

    { "akinsho/toggleterm.nvim", version = "*", config = true },

    -- "bullets-vim/bullets.vim",
    -- ft = { "markdown", "text", "gitcommit" },

    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        ---@module "ibl"
        ---@type ibl.config
        opts = {
            indent = {
                char = "│",
            },
            whitespace = {
                remove_blankline_trail = false,
            },
            scope = {
                enabled = true,
            },
        },
    },

    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                -- Conform will run multiple formatters sequentially
                python = { "ruff_format" },
                -- You can customize some of the format options for the filetype (:help conform.format)
                rust = { "rustfmt", lsp_format = "fallback" },
                -- Conform will run the first available formatter
                javascript = { "prettierd", "prettier", stop_after_first = true },

                json = { "jq" },
                qml = { "qmlformat" },
                css = { "prettier" },
                yaml = { "prettier" },
                yml = { "prettier" },
                html = { "prettier" },
                toml = { "taplo" },
            },
            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true,
            },
            formatters = {
                prettier = {
                    prepend_args = { "--tab-width", "4", "--user-tabs", "false" },
                },
            },
        },
    },

    {
        "barreiroleo/ltex-extra.nvim",
        ft = { "markdown", "text", "gitcommit" },
        config = function()
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(ev)
                    local client = vim.lsp.get_client_by_id(ev.data.client_id)
                    if client and client.name == "ltex" then
                        require("ltex_extra").setup({
                            load_langs = { "de-DE", "en-US" },
                            init_check = true,
                            path = vim.fn.stdpath("data") .. "/ltex",
                        })
                    end
                end,
            })
        end,
    },

    -- {
    --     "karb94/neoscroll.nvim",
    --     opts = {},
    -- },

    {
        "mrcjkb/rustaceanvim",
        -- To avoid being surprised by breaking changes,
        -- I recommend you set a version range
        version = "^9",
        ft = { "rust" },
        -- This plugin implements proper lazy-loading (see :h lua-plugin-lazy).
        -- No need for lazy.nvim to lazy-load it.
        lazy = false,
    },

    {
        "yousefhadder/markdown-plus.nvim",
        ft = "markdown",
        opts = {
            enabled = true,

            features = {
                list_management = true,
                text_formatting = true,
                thematic_break = true,
                links = true,
                images = true,
                headers_toc = true,
                quotes = true,
                callouts = true,
                code_block = true,
                html_block_awareness = true,
                table = true,
                footnotes = true,
            },

            keymaps = {
                enabled = true,
            },

            filetypes = { "markdown" },

            toc = {
                initial_depth = 2,
            },

            thematic_break = {
                style = "---", -- "---" | "***" | "___"
            },

            callouts = {
                default_type = "NOTE",
                custom_types = {},
            },

            code_block = {
                enabled = true,
                fence_style = "backtick", -- "backtick" | "tilde"
                languages = { "lua", "python", "javascript", "typescript", "bash", "json", "yaml", "markdown" },
            },

            table = {
                enabled = true,
                auto_format = true,
                default_alignment = "left",
                confirm_destructive = true,
                keymaps = {
                    enabled = true,
                    prefix = "<localleader>t",
                    insert_mode_navigation = true,
                },
            },

            footnotes = {
                section_header = "Footnotes",
                confirm_delete = true,
            },

            list = {
                smart_outdent = true,
                checkbox_completion = {
                    enabled = true,
                    format = "emoji", -- "emoji" | "comment" | "dataview" | "parenthetical"
                    date_format = "%d-%m-%Y",
                    remove_on_uncheck = false,
                    update_existing = true,
                },
            },

            links = {
                smart_paste = {
                    enabled = true,
                    timeout = 5, -- 1..30
                },
            },
        },
    },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        opts = {
            ensure_installed = {
                "latex",
                "markdown",
                "markdown_inline",
                "lua",
                "python",
                "rust",
                "javascript",
                "typescript",
                "json",
                "html",
                "css",
                "yaml",
                "bash",
            },
            highlight = {
                enable = true,
            },
        },
    },

    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
            "latex-lsp/tree-sitter-latex",
        },
        opts = {
            enabled = true,
            -- Vim modes that will show a rendered view of the markdown file, :h mode(), for all enabled
            -- components. Individual components can be enabled for other modes. Remaining modes will be
            -- unaffected by this plugin.
            render_modes = { "n", "c", "t" },
            -- Milliseconds that must pass before updating marks, updates occur.
            -- within the context of the visible window, not the entire buffer.
            debounce = 100,
            -- Pre configured settings that will attempt to mimic various target user experiences.
            -- User provided settings will take precedence.
            -- | obsidian | mimic Obsidian UI                                          |
            -- | lazy     | will attempt to stay up to date with LazyVim configuration |
            -- | none     | does nothing                                               |
            preset = "none",
            -- The level of logs to write to file: vim.fn.stdpath('state') .. '/render-markdown.log'.
            -- Only intended to be used for plugin development / debugging.
            log_level = "error",
            -- Print runtime of main update method.
            -- Only intended to be used for plugin development / debugging.
            log_runtime = false,
            -- Filetypes this plugin will run on.
            file_types = { "markdown" },
            -- Maximum file size (in MB) that this plugin will attempt to render.
            -- File larger than this will effectively be ignored.
            max_file_size = 10.0,
            -- Takes buffer as input, if it returns true this plugin will not attach to the buffer.
            ignore = function()
                return false
            end,
            -- Whether markdown should be rendered when nested inside markdown, i.e. markdown code block
            -- inside markdown file.
            nested = true,
            -- Additional events that will trigger this plugin's render loop.
            change_events = {},
            -- Whether the treesitter highlighter should be restarted after this plugin attaches to its
            -- first buffer for the first time. May be necessary if this plugin is lazy loaded to clear
            -- highlights that have been dynamically disabled.
            restart_highlighter = false,
            injections = {
                -- Out of the box language injections for known filetypes that allow markdown to be interpreted
                -- in specified locations, see :h treesitter-language-injections.
                -- Set enabled to false in order to disable.

                gitcommit = {
                    enabled = true,
                    query = [[
                ((message) @injection.content
                    (#set! injection.combined)
                    (#set! injection.include-children)
                    (#set! injection.language "markdown"))
            ]],
                },
            },
            patterns = {
                -- Highlight patterns to disable for filetypes, i.e. lines concealed around code blocks

                markdown = {
                    disable = true,
                    directives = {
                        { id = 17, name = "conceal_lines" },
                        { id = 18, name = "conceal_lines" },
                    },
                },
            },
            anti_conceal = {
                -- This enables hiding added text on the line the cursor is on.
                enabled = true,
                -- Modes to disable anti conceal feature.
                disabled_modes = false,
                -- Number of lines above cursor to show.
                above = 0,
                -- Number of lines below cursor to show.
                below = 0,
                -- Which elements to always show, ignoring anti conceal behavior. Values can either be
                -- booleans to fix the behavior or string lists representing modes where anti conceal
                -- behavior will be ignored. Valid values are:
                --   bullet
                --   callout
                --   check_icon, check_scope
                --   code_background, code_border, code_language
                --   dash
                --   head_background, head_border, head_icon
                --   indent
                --   latex
                --   link
                --   quote
                --   sign
                --   table_border
                --   virtual_lines
                ignore = {
                    code_background = true,
                    indent = true,
                    sign = true,
                    virtual_lines = true,
                },
            },
            padding = {
                -- Highlight to use when adding whitespace, should match background.
                highlight = "Normal",
            },
            latex = {
                -- Turn on / off latex rendering.
                enabled = true,
                -- Additional modes to render latex.
                render_modes = false,
                -- Executable used to convert latex formula to rendered unicode.
                -- If a list is provided the commands run in order until the first success.
                converter = { "utftex", "latex2text" },
                -- Render inline latex formulas.
                inline = true,
                -- Render block latex formulas.
                block = true,
                -- Highlight for latex blocks.
                highlight = "RenderMarkdownMath",
                -- Determines where latex formula is rendered relative to block.
                -- | above  | above latex block                               |
                -- | below  | below latex block                               |
                -- | center | centered with latex block (must be single line) |
                position = "center",
                -- Number of empty lines above latex blocks.
                top_pad = 0,
                -- Number of empty lines below latex blocks.
                bottom_pad = 0,
            },
            on = {
                -- Called when plugin initially attaches to a buffer.
                attach = function() end,
                -- Called before adding marks to the buffer for the first time.
                initial = function() end,
                -- Called after plugin renders a buffer.
                render = function() end,
                -- Called after plugin clears a buffer.
                clear = function() end,
            },
            completions = {
                -- Settings for blink.cmp completions source
                blink = { enabled = false },
                -- Settings for coq_nvim completions source
                coq = { enabled = false },
                -- Settings for in-process language server completions
                lsp = { enabled = false },
                filter = {
                    callout = function()
                        -- example to exclude obsidian callouts
                        -- return value.category ~= 'obsidian'
                        return true
                    end,
                    checkbox = function()
                        return true
                    end,
                },
            },
            heading = {
                -- Useful context to have when evaluating values.
                -- | level    | the number of '#' in the heading marker         |
                -- | sections | for each level how deeply nested the heading is |

                -- Turn on / off heading icon & background rendering.
                enabled = true,
                -- Additional modes to render headings.
                render_modes = false,
                -- Turn on / off atx heading rendering.
                atx = true,
                -- Turn on / off setext heading rendering.
                setext = true,
                -- Turn on / off sign column related rendering.
                sign = true,
                -- Replaces '#+' of 'atx_h._marker'.
                -- Output is evaluated depending on the type.
                -- | function | `value(context)`              |
                -- | string[] | `cycle(value, context.level)` |
                icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
                -- Determines how icons fill the available space.
                -- | eol     | '#'s are concealed and icon is placed at right most column   |
                -- | right   | '#'s are concealed and icon is appended to right side        |
                -- | inline  | '#'s are concealed and icon is inlined on left side          |
                -- | overlay | icon is left padded with spaces and overlayed hiding all '#' |
                position = "overlay",
                -- Added to the sign column if enabled.
                -- Output is evaluated by `cycle(value, context.level)`.
                signs = { "󰫎 " },
                -- Width of the heading background.
                -- | block | width of the heading text |
                -- | full  | full width of the window  |
                -- Can also be a list of the above values evaluated by `clamp(value, context.level)`.
                width = "full",
                -- Amount of margin to add to the left of headings.
                -- Margin available space is computed after accounting for padding.
                -- If a float < 1 is provided it is treated as a percentage of available window space.
                -- Can also be a list of numbers evaluated by `clamp(value, context.level)`.
                left_margin = 0,
                -- Amount of padding to add to the left of headings.
                -- Output is evaluated using the same logic as 'left_margin'.
                left_pad = 0,
                -- Amount of padding to add to the right of headings when width is 'block'.
                -- Output is evaluated using the same logic as 'left_margin'.
                right_pad = 0,
                -- Minimum width to use for headings when width is 'block'.
                -- Can also be a list of integers evaluated by `clamp(value, context.level)`.
                min_width = 0,
                -- Determines if a border is added above and below headings.
                -- Can also be a list of booleans evaluated by `clamp(value, context.level)`.
                border = false,
                -- Always use virtual lines for heading borders instead of attempting to use empty lines.
                border_virtual = false,
                -- Highlight the start of the border using the foreground highlight.
                border_prefix = false,
                -- Used above heading for border.
                above = "▄",
                -- Used below heading for border.
                below = "▀",
                -- Highlight for the heading icon and extends through the entire line.
                -- Output is evaluated by `clamp(value, context.level)`.
                backgrounds = {
                    "RenderMarkdownH1Bg",
                    "RenderMarkdownH2Bg",
                    "RenderMarkdownH3Bg",
                    "RenderMarkdownH4Bg",
                    "RenderMarkdownH5Bg",
                    "RenderMarkdownH6Bg",
                },
                -- Highlight for the heading and sign icons.
                -- Output is evaluated using the same logic as 'backgrounds'.
                foregrounds = {
                    "RenderMarkdownH1",
                    "RenderMarkdownH2",
                    "RenderMarkdownH3",
                    "RenderMarkdownH4",
                    "RenderMarkdownH5",
                    "RenderMarkdownH6",
                },
                -- Define custom heading patterns which allow you to override various properties based on
                -- the contents of a heading.
                -- The key is for healthcheck and to allow users to change its values, value type below.
                -- | pattern    | matched against the heading text @see :h lua-patterns |
                -- | icon       | optional override for the icon                        |
                -- | background | optional override for the background                  |
                -- | foreground | optional override for the foreground                  |
                custom = {},
            },
            paragraph = {
                -- Useful context to have when evaluating values.
                -- | text | text value of the node |

                -- Turn on / off paragraph rendering.
                enabled = true,
                -- Additional modes to render paragraphs.
                render_modes = false,
                -- Amount of margin to add to the left of paragraphs.
                -- If a float < 1 is provided it is treated as a percentage of available window space.
                -- Output is evaluated depending on the type.
                -- | function | `value(context)` |
                -- | number   | `value`          |
                left_margin = 0,
                -- Amount of padding to add to the first line of each paragraph.
                -- Output is evaluated using the same logic as 'left_margin'.
                indent = 0,
                -- Minimum width to use for paragraphs.
                min_width = 0,
            },
            code = {
                -- Turn on / off code block & inline code rendering.
                enabled = true,
                -- Additional modes to render code blocks.
                render_modes = false,
                -- Turn on / off sign column related rendering.
                sign = true,
                -- Whether to conceal nodes at the top and bottom of code blocks.
                conceal_delimiters = true,
                -- Turn on / off language heading related rendering.
                language = true,
                -- Determines where language icon is rendered.
                -- | center | center of code block |
                -- | right  | right of code block  |
                -- | left   | left of code block   |
                position = "left",
                -- Whether to include the language icon above code blocks.
                language_icon = true,
                -- Whether to include the language name above code blocks.
                language_name = true,
                -- Whether to include the language info above code blocks.
                language_info = true,
                -- Amount of padding to add around the language.
                -- If a float < 1 is provided it is treated as a percentage of available window space.
                language_pad = 0,
                -- A list of language names for which rendering will be disabled.
                disable = {},
                -- A list of language names for which background highlighting will be disabled.
                -- Likely because that language has background highlights itself.
                -- Use a boolean to make behavior apply to all languages.
                -- Borders above & below blocks will continue to be rendered.
                disable_background = { "diff" },
                -- Number of lines from start/end to skip rendering background.
                background_inset = 1,
                -- Width of the code block background.
                -- | block | width of the code block  |
                -- | full  | full width of the window |
                width = "full",
                -- Amount of margin to add to the left of code blocks.
                -- If a float < 1 is provided it is treated as a percentage of available window space.
                -- Margin available space is computed after accounting for padding.
                left_margin = 0,
                -- Amount of padding to add to the left of code blocks.
                -- If a float < 1 is provided it is treated as a percentage of available window space.
                left_pad = 0,
                -- Amount of padding to add to the right of code blocks when width is 'block'.
                -- If a float < 1 is provided it is treated as a percentage of available window space.
                right_pad = 0,
                -- Minimum width to use for code blocks when width is 'block'.
                min_width = 0,
                -- Determines how the top / bottom of code block are rendered.
                -- | none  | do not render a border                               |
                -- | thick | use the same highlight as the code body              |
                -- | thin  | when lines are empty overlay the above & below icons |
                -- | hide  | conceal lines unless language name or icon is added  |
                border = "hide",
                -- Used above code blocks to fill remaining space around language.
                language_border = "█",
                -- Added to the left of language.
                language_left = "",
                -- Added to the right of language.
                language_right = "",
                -- Used above code blocks for thin border.
                above = "▄",
                -- Used below code blocks for thin border.
                below = "▀",
                -- Turn on / off inline code related rendering.
                inline = true,
                -- Icon to add to the left of inline code.
                inline_left = "",
                -- Icon to add to the right of inline code.
                inline_right = "",
                -- Padding to add to the left & right of inline code.
                inline_pad = 0,
                -- Priority to assign to code background highlight.
                priority = 140,
                -- Highlight for code blocks.
                highlight = "RenderMarkdownCode",
                -- Highlight for code info section, after the language.
                highlight_info = "RenderMarkdownCodeInfo",
                -- Highlight for language, overrides icon provider value.
                highlight_language = nil,
                -- Highlight for border, use false to add no highlight.
                highlight_border = "RenderMarkdownCodeBorder",
                -- Highlight for language, used if icon provider does not have a value.
                highlight_fallback = "RenderMarkdownCodeFallback",
                -- Highlight for inline code.
                highlight_inline = "RenderMarkdownCodeInline",
                -- Highlight for inline code left icon, default to reverse of highlight_inline.
                highlight_inline_left = nil,
                -- Highlight for inline code right icon, default to reverse of highlight_inline.
                highlight_inline_right = nil,
                -- Determines how code blocks & inline code are rendered.
                -- | none     | { enabled = false }                           |
                -- | normal   | { language = false }                          |
                -- | language | { disable_background = true, inline = false } |
                -- | full     | uses all default values                       |
                style = "full",
            },
            dash = {
                -- Useful context to have when evaluating values.
                -- | width | width of the current window |

                -- Turn on / off thematic break rendering.
                enabled = true,
                -- Additional modes to render dash.
                render_modes = false,
                -- Replaces '---'|'***'|'___'|'* * *' of 'thematic_break'.
                -- The icon gets repeated across the window's width.
                icon = "─",
                -- Width of the generated line.
                -- If a float < 1 is provided it is treated as a percentage of available window space.
                -- Output is evaluated depending on the type.
                -- | function | `value(context)`    |
                -- | number   | `value`             |
                -- | full     | width of the window |
                width = "full",
                -- Amount of margin to add to the left of dash.
                -- If a float < 1 is provided it is treated as a percentage of available window space.
                left_margin = 0,
                -- Priority to assign to dash.
                priority = nil,
                -- Highlight for the whole line generated from the icon.
                highlight = "RenderMarkdownDash",
            },
            document = {
                -- Turn on / off document rendering.
                enabled = true,
                -- Additional modes to render document.
                render_modes = false,
                -- Ability to conceal arbitrary ranges of text based on lua patterns, @see :h lua-patterns.
                -- Relies entirely on user to set patterns that handle their edge cases.
                conceal = {
                    -- Matched ranges will be concealed using character level conceal.
                    char_patterns = {},
                    -- Matched ranges will be concealed using line level conceal.
                    line_patterns = {},
                },
            },
            bullet = {
                -- Useful context to have when evaluating values.
                -- | level | how deeply nested the list is, 1-indexed          |
                -- | index | how far down the item is at that level, 1-indexed |
                -- | value | text value of the marker node                     |

                -- Turn on / off list bullet rendering
                enabled = true,
                -- Additional modes to render list bullets
                render_modes = false,
                -- Replaces '-'|'+'|'*' of 'list_item'.
                -- If the item is a 'checkbox' a conceal is used to hide the bullet instead.
                -- Output is evaluated depending on the type.
                -- | function   | `value(context)`                                    |
                -- | string     | `value`                                             |
                -- | string[]   | `cycle(value, context.level)`                       |
                -- | string[][] | `clamp(cycle(value, context.level), context.index)` |
                icons = { "●", "○", "◆", "◇" },
                -- Replaces 'n.'|'n)' of 'list_item'.
                -- Output is evaluated using the same logic as 'icons'.
                ordered_icons = function(ctx)
                    local value = vim.trim(ctx.value)
                    local index = tonumber(value:sub(1, #value - 1))
                    return ("%d."):format(index > 1 and index or ctx.index)
                end,
                -- Padding to add to the left of bullet point.
                -- Output is evaluated depending on the type.
                -- | function | `value(context)` |
                -- | integer  | `value`          |
                left_pad = 0,
                -- Padding to add to the right of bullet point.
                -- Output is evaluated using the same logic as 'left_pad'.
                right_pad = 0,
                -- Highlight for the bullet icon.
                -- Output is evaluated using the same logic as 'icons'.
                highlight = "RenderMarkdownBullet",
                -- Highlight for item associated with the bullet point.
                -- Output is evaluated using the same logic as 'icons'.
                scope_highlight = {},
                -- Priority to assign to scope highlight.
                scope_priority = nil,
            },
            checkbox = {
                -- Checkboxes are a special instance of a 'list_item' that start with a 'shortcut_link'.
                -- There are two special states for unchecked & checked defined in the markdown grammar.

                -- Turn on / off checkbox state rendering.
                enabled = true,
                -- Additional modes to render checkboxes.
                render_modes = false,
                -- Render the bullet point before the checkbox.
                bullet = false,
                -- Padding to add to the left of checkboxes.
                left_pad = 0,
                -- Padding to add to the right of checkboxes.
                right_pad = 1,
                unchecked = {
                    -- Replaces '[ ]' of 'task_list_marker_unchecked'.
                    icon = "󰄱 ",
                    -- Highlight for the unchecked icon.
                    highlight = "RenderMarkdownUnchecked",
                    -- Highlight for item associated with unchecked checkbox.
                    scope_highlight = nil,
                },
                checked = {
                    -- Replaces '[x]' of 'task_list_marker_checked'.
                    icon = "󰱒 ",
                    -- Highlight for the checked icon.
                    highlight = "RenderMarkdownChecked",
                    -- Highlight for item associated with checked checkbox.
                    scope_highlight = nil,
                },
        -- Define custom checkbox states, more involved, not part of the markdown grammar.
        -- As a result this requires neovim >= 0.10.0 since it relies on 'inline' extmarks.
        -- The key is for healthcheck and to allow users to change its values, value type below.
        -- | raw             | matched against the raw text of a 'shortcut_link'           |
        -- | rendered        | replaces the 'raw' value when rendering                     |
        -- | highlight       | highlight for the 'rendered' icon                           |
        -- | scope_highlight | optional highlight for item associated with custom checkbox |
        -- stylua: ignore
        custom = {
            todo = { raw = '[-]', rendered = '󰥔 ', highlight = 'RenderMarkdownTodo', scope_highlight = nil },
        },
                -- Priority to assign to scope highlight.
                scope_priority = nil,
            },
            quote = {
                -- Turn on / off block quote & callout rendering.
                enabled = true,
                -- Additional modes to render quotes.
                render_modes = false,
                -- Replaces '>' of 'block_quote'.
                icon = "▋",
                -- Whether to repeat icon on wrapped lines. Requires neovim >= 0.10. This will obscure text
                -- if incorrectly configured with :h 'showbreak', :h 'breakindent' and :h 'breakindentopt'.
                -- A combination of these that is likely to work follows.
                -- | showbreak      | '  ' (2 spaces)   |
                -- | breakindent    | true              |
                -- | breakindentopt | '' (empty string) |
                -- These are not validated by this plugin. If you want to avoid adding these to your main
                -- configuration then set them in win_options for this plugin.
                repeat_linebreak = false,
                -- Highlight for the quote icon.
                -- If a list is provided output is evaluated by `cycle(value, level)`.
                highlight = {
                    "RenderMarkdownQuote1",
                    "RenderMarkdownQuote2",
                    "RenderMarkdownQuote3",
                    "RenderMarkdownQuote4",
                    "RenderMarkdownQuote5",
                    "RenderMarkdownQuote6",
                },
            },
            render = {
                -- Whether to render when window is in diff-mode.
                diff = false,
            },
            pipe_table = {
                -- Turn on / off pipe table rendering.
                enabled = true,
                -- Additional modes to render pipe tables.
                render_modes = false,
                -- Pre configured settings largely for setting table border easier.
                -- | heavy  | use thicker border characters     |
                -- | double | use double line border characters |
                -- | round  | use round border corners          |
                -- | none   | does nothing                      |
                preset = "none",
                -- Determines how individual cells of a table are rendered.
                -- | overlay | writes completely over the table, removing conceal behavior and highlights |
                -- | raw     | replaces only the '|' characters in each row, leaving the cells unmodified |
                -- | padded  | raw + cells are padded to maximum visual width for each column             |
                -- | trimmed | padded except empty space is subtracted from visual width calculation      |
                cell = "padded",
                -- Adjust the computed width of table cells using custom logic.
                cell_offset = function()
                    return 0
                end,
                -- Amount of space to put between cell contents and border.
                padding = 1,
                -- Minimum column width to use for padded or trimmed cell.
                min_width = 0,
        -- Characters used to replace table border.
        -- Correspond to top(3), delimiter(3), bottom(3), vertical, & horizontal.
        -- stylua: ignore
        border = {
            '┌', '┬', '┐',
            '├', '┼', '┤',
            '└', '┴', '┘',
            '│', '─',
        },
                -- Turn on / off top & bottom lines.
                border_enabled = true,
                -- Always use virtual lines for table borders instead of attempting to use empty lines.
                -- Will be automatically enabled if indentation module is enabled.
                border_virtual = false,
                -- Gets placed in delimiter row for each column, position is based on alignment.
                alignment_indicator = "━",
                -- Highlight for table heading, delimiter, and the line above.
                head = "RenderMarkdownTableHead",
                -- Highlight for everything else, main table rows and the line below.
                row = "RenderMarkdownTableRow",
                -- Determines how the table as a whole is rendered.
                -- | none   | { enabled = false }        |
                -- | normal | { border_enabled = false } |
                -- | full   | uses all default values    |
                style = "full",
            },
            callout = {
                -- Callouts are a special instance of a 'block_quote' that start with a 'shortcut_link'.
                -- The key is for healthcheck and to allow users to change its values, value type below.
                -- | raw        | matched against the raw text of a 'shortcut_link', case insensitive |
                -- | rendered   | replaces the 'raw' value when rendering                             |
                -- | highlight  | highlight for the 'rendered' text and quote markers                 |
                -- | quote_icon | optional override for quote.icon value for individual callout       |
                -- | category   | optional metadata useful for filtering                              |

                note = {
                    raw = "[!NOTE]",
                    rendered = "󰋽 Note",
                    highlight = "RenderMarkdownInfo",
                    category = "github",
                },
                tip = {
                    raw = "[!TIP]",
                    rendered = "󰌶 Tip",
                    highlight = "RenderMarkdownSuccess",
                    category = "github",
                },
                important = {
                    raw = "[!IMPORTANT]",
                    rendered = "󰅾 Important",
                    highlight = "RenderMarkdownHint",
                    category = "github",
                },
                warning = {
                    raw = "[!WARNING]",
                    rendered = "󰀪 Warning",
                    highlight = "RenderMarkdownWarn",
                    category = "github",
                },
                caution = {
                    raw = "[!CAUTION]",
                    rendered = "󰳦 Caution",
                    highlight = "RenderMarkdownError",
                    category = "github",
                },
                -- Obsidian: https://help.obsidian.md/Editing+and+formatting/Callouts
                abstract = {
                    raw = "[!ABSTRACT]",
                    rendered = "󰨸 Abstract",
                    highlight = "RenderMarkdownInfo",
                    category = "obsidian",
                },
                summary = {
                    raw = "[!SUMMARY]",
                    rendered = "󰨸 Summary",
                    highlight = "RenderMarkdownInfo",
                    category = "obsidian",
                },
                tldr = {
                    raw = "[!TLDR]",
                    rendered = "󰨸 Tldr",
                    highlight = "RenderMarkdownInfo",
                    category = "obsidian",
                },
                info = {
                    raw = "[!INFO]",
                    rendered = "󰋽 Info",
                    highlight = "RenderMarkdownInfo",
                    category = "obsidian",
                },
                todo = {
                    raw = "[!TODO]",
                    rendered = "󰗡 Todo",
                    highlight = "RenderMarkdownInfo",
                    category = "obsidian",
                },
                hint = {
                    raw = "[!HINT]",
                    rendered = "󰌶 Hint",
                    highlight = "RenderMarkdownSuccess",
                    category = "obsidian",
                },
                success = {
                    raw = "[!SUCCESS]",
                    rendered = "󰄬 Success",
                    highlight = "RenderMarkdownSuccess",
                    category = "obsidian",
                },
                check = {
                    raw = "[!CHECK]",
                    rendered = "󰄬 Check",
                    highlight = "RenderMarkdownSuccess",
                    category = "obsidian",
                },
                done = {
                    raw = "[!DONE]",
                    rendered = "󰄬 Done",
                    highlight = "RenderMarkdownSuccess",
                    category = "obsidian",
                },
                question = {
                    raw = "[!QUESTION]",
                    rendered = "󰘥 Question",
                    highlight = "RenderMarkdownWarn",
                    category = "obsidian",
                },
                help = {
                    raw = "[!HELP]",
                    rendered = "󰘥 Help",
                    highlight = "RenderMarkdownWarn",
                    category = "obsidian",
                },
                faq = {
                    raw = "[!FAQ]",
                    rendered = "󰘥 Faq",
                    highlight = "RenderMarkdownWarn",
                    category = "obsidian",
                },
                attention = {
                    raw = "[!ATTENTION]",
                    rendered = "󰀪 Attention",
                    highlight = "RenderMarkdownWarn",
                    category = "obsidian",
                },
                failure = {
                    raw = "[!FAILURE]",
                    rendered = "󰅖 Failure",
                    highlight = "RenderMarkdownError",
                    category = "obsidian",
                },
                fail = {
                    raw = "[!FAIL]",
                    rendered = "󰅖 Fail",
                    highlight = "RenderMarkdownError",
                    category = "obsidian",
                },
                missing = {
                    raw = "[!MISSING]",
                    rendered = "󰅖 Missing",
                    highlight = "RenderMarkdownError",
                    category = "obsidian",
                },
                danger = {
                    raw = "[!DANGER]",
                    rendered = "󱐌 Danger",
                    highlight = "RenderMarkdownError",
                    category = "obsidian",
                },
                error = {
                    raw = "[!ERROR]",
                    rendered = "󱐌 Error",
                    highlight = "RenderMarkdownError",
                    category = "obsidian",
                },
                bug = {
                    raw = "[!BUG]",
                    rendered = "󰨰 Bug",
                    highlight = "RenderMarkdownError",
                    category = "obsidian",
                },
                example = {
                    raw = "[!EXAMPLE]",
                    rendered = "󰉹 Example",
                    highlight = "RenderMarkdownHint",
                    category = "obsidian",
                },
                quote = {
                    raw = "[!QUOTE]",
                    rendered = "󱆨 Quote",
                    highlight = "RenderMarkdownQuote",
                    category = "obsidian",
                },
                cite = {
                    raw = "[!CITE]",
                    rendered = "󱆨 Cite",
                    highlight = "RenderMarkdownQuote",
                    category = "obsidian",
                },
            },
            link = {
                -- Turn on / off inline link icon rendering.
                enabled = true,
                -- Additional modes to render links.
                render_modes = false,
                -- How to handle footnote links, start with a '^'.
                footnote = {
                    -- Turn on / off footnote rendering.
                    enabled = true,
                    -- Inlined with content.
                    icon = "󰯔 ",
                    -- Custom processing for footnote body to show.
                    -- Runs before prefix / suffix are added and superscript processing.
                    body = function(ctx)
                        return ctx.text
                    end,
                    -- Replace value with superscript equivalent.
                    superscript = true,
                    -- Added before link content.
                    prefix = "",
                    -- Added after link content.
                    suffix = "",
                },
                -- Inlined with 'image' elements.
                image = "󰥶 ",
                -- Check custom for 'image' elements.
                image_custom = true,
                -- Inlined with 'email_autolink' elements.
                email = "󰀓 ",
                -- Fallback icon for 'inline_link' and 'uri_autolink' elements.
                hyperlink = "󰌹 ",
                -- Applies to the inlined icon as a fallback.
                highlight = "RenderMarkdownLink",
                -- Applies to the link title.
                highlight_title = "RenderMarkdownLinkTitle",
                -- Applies to WikiLink elements.
                wiki = {
                    -- Turn on / off WikiLink rendering.
                    enabled = true,
                    -- Inlined with content.
                    icon = "󱗖 ",
                    -- Hide destination if there is an alias.
                    conceal_destination = true,
                    -- Custom processing for WikiLink body to show.
                    body = function()
                        return nil
                    end,
                    -- Applies to the inlined icon.
                    highlight = "RenderMarkdownWikiLink",
                    -- Highlight for item associated with the WikiLink.
                    scope_highlight = nil,
                },
        -- Define custom destination patterns so icons can quickly inform you of what a link
        -- contains. Applies to 'image', 'inline_link', 'uri_autolink', and WikiLink nodes.
        -- When multiple patterns match a link the one with the longer pattern is used.
        -- The key is for healthcheck and to allow users to change its values, value type below.
        -- | icon      | gets inlined before the link text                               |
        -- | pattern   | matched against the destination text                            |
        -- | kind      | optional determines how pattern is checked                      |
        -- |           | pattern | @see :h lua-patterns, is the default if not set       |
        -- |           | suffix  | @see :h vim.endswith()                                |
        -- |           | url     | similar to pattern with additional prefix checks      |
        -- | priority  | optional used when multiple match, uses pattern length if empty |
        -- | highlight | optional highlight for 'icon', uses fallback highlight if empty |
        -- stylua: ignore
        custom = {
            web = { icon = '󰖟 ', pattern = '^http' },
            apple = { icon = ' ', pattern = 'apple%.com', kind = 'url' },
            discord = { icon = '󰙯 ', pattern = 'discord%.com', kind = 'url' },
            github = { icon = '󰊤 ', pattern = 'github%.com', kind = 'url' },
            gitlab = { icon = '󰮠 ', pattern = 'gitlab%.com', kind = 'url' },
            google = { icon = '󰊭 ', pattern = 'google%.com', kind = 'url' },
            hackernews = { icon = ' ', pattern = 'ycombinator%.com', kind = 'url' },
            linkedin = { icon = '󰌻 ', pattern = 'linkedin%.com', kind = 'url' },
            microsoft = { icon = ' ', pattern = 'microsoft%.com', kind = 'url' },
            neovim = { icon = ' ', pattern = 'neovim%.io', kind = 'url' },
            reddit = { icon = '󰑍 ', pattern = 'reddit%.com', kind = 'url' },
            slack = { icon = '󰒱 ', pattern = 'slack%.com', kind = 'url' },
            stackoverflow = { icon = '󰓌 ', pattern = 'stackoverflow%.com', kind = 'url' },
            steam = { icon = ' ', pattern = 'steampowered%.com', kind = 'url' },
            twitter = { icon = ' ', pattern = 'twitter%.com', kind = 'url' },
            wikipedia = { icon = '󰖬 ', pattern = 'wikipedia%.org', kind = 'url' },
            x = { icon = ' ', pattern = 'x%.com', kind = 'url' },
            youtube = { icon = '󰗃 ', pattern = 'youtube[^.]*%.com', kind = 'url' },
            youtube_short = { icon = '󰗃 ', pattern = 'youtu%.be', kind = 'url' },
        },
            },
            sign = {
                -- Turn on / off sign rendering.
                enabled = true,
                -- Priority to assign to sign.
                priority = nil,
                -- Applies to background of sign text.
                highlight = "RenderMarkdownSign",
            },
            inline_highlight = {
                -- Mimics Obsidian inline highlights when content is surrounded by double equals.
                -- The equals on both ends are concealed and the inner content is highlighted.

                -- Turn on / off inline highlight rendering.
                enabled = true,
                -- Additional modes to render inline highlights.
                render_modes = false,
                -- Applies to background of surrounded text.
                highlight = "RenderMarkdownInlineHighlight",
                -- Define custom highlights based on text prefix.
                -- The key is for healthcheck and to allow users to change its values, value type below.
                -- | prefix    | matched against text body, @see :h vim.startswith() |
                -- | highlight | highlight for text body                             |
                custom = {},
            },
            indent = {
                -- Mimic org-indent-mode behavior by indenting everything under a heading based on the
                -- level of the heading. Indenting starts from level 2 headings onward by default.

                -- Turn on / off org-indent-mode.
                enabled = false,
                -- Additional modes to render indents.
                render_modes = false,
                -- Amount of additional padding added for each heading level.
                per_level = 2,
                -- Heading levels <= this value will not be indented.
                -- Use 0 to begin indenting from the very first level.
                skip_level = 1,
                -- Do not indent heading titles, only the body.
                skip_heading = false,
                -- Prefix added when indenting, one per level.
                icon = "▎",
                -- Priority to assign to extmarks.
                priority = 0,
                -- Applied to icon.
                highlight = "RenderMarkdownIndent",
            },
            html = {
                -- Turn on / off all HTML rendering.
                enabled = true,
                -- Additional modes to render HTML.
                render_modes = false,
                comment = {
                    -- Useful context to have when evaluating values.
                    -- | text | text value of the comment node |

                    -- Turn on / off HTML comment concealing.
                    conceal = true,
                    -- Text to inline before the concealed comment.
                    -- Output is evaluated depending on the type.
                    -- | function | `value(context)` |
                    -- | string   | `value`          |
                    -- | nil      | nothing          |
                    text = nil,
                    -- Highlight for the inlined text.
                    highlight = "RenderMarkdownHtmlComment",
                },
                -- HTML tags whose start and end will be hidden and icon shown.
                -- The key is matched against the tag name, value type below.
                -- | icon            | optional icon inlined at start of tag           |
                -- | highlight       | optional highlight for the icon                 |
                -- | scope_highlight | optional highlight for item associated with tag |
                tag = {},
            },
            win_options = {
                -- Window options to use that change between rendered and raw view.

                -- @see :h 'conceallevel'
                conceallevel = {
                    -- Used when not being rendered, get user setting.
                    default = vim.o.conceallevel,
                    -- Used when being rendered, concealed text is completely hidden.
                    rendered = 3,
                },
                -- @see :h 'concealcursor'
                concealcursor = {
                    -- Used when not being rendered, get user setting.
                    default = vim.o.concealcursor,
                    -- Used when being rendered, show concealed text in all modes.
                    rendered = "",
                },
            },
            overrides = {
                -- More granular configuration mechanism, allows different aspects of buffers to have their own
                -- behavior. Values default to the top level configuration if no override is provided. Supports
                -- the following fields:
                --   enabled, render_modes, debounce, anti_conceal, bullet, callout, checkbox, code, dash,
                --   document, heading, html, indent, inline_highlight, latex, link, padding, paragraph,
                --   pipe_table, quote, sign, win_options, yaml

                -- Override for different buflisted values, @see :h 'buflisted'.
                buflisted = {},
                -- Override for different buftype values, @see :h 'buftype'.
                buftype = {
                    nofile = {
                        render_modes = true,
                        padding = { highlight = "NormalFloat" },
                        sign = { enabled = false },
                    },
                },
                -- Override for different filetype values, @see :h 'filetype'.
                filetype = {},
                -- Override for preview buffer.
                preview = {
                    render_modes = true,
                },
            },
            custom_handlers = {
                -- Mapping from treesitter language to user defined handlers.
                -- @see [Custom Handlers](doc/custom-handlers.md)
            },
            yaml = {
                -- Turn on / off all yaml rendering.
                enabled = true,
                -- Additional modes to render yaml.
                render_modes = false,
            },
        },
    },

    {
        "nickjvandyke/opencode.nvim",
        version = "*", -- Latest stable release
        dependencies = {
            {
                -- `snacks.nvim` integration is recommended, but optional
                ---@module "snacks" <- Loads `snacks.nvim` types for configuration intellisense
                "folke/snacks.nvim",
                optional = true,
                opts = {
                    input = {}, -- Enhances `ask()`
                    picker = { -- Enhances `select()`
                        actions = {
                            opencode_send = function(...)
                                return require("opencode").snacks_picker_send(...)
                            end,
                        },
                        win = {
                            input = {
                                keys = {
                                    ["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
                                },
                            },
                        },
                    },
                },
            },
        },
        config = function()
            ---@type opencode.Opts
            vim.g.opencode_opts = {
                -- Your configuration, if any; goto definition on the type or field for details
            }

            vim.o.autoread = true -- Required for `opts.events.reload`

            -- Recommended/example keymaps
            vim.keymap.set({ "n", "x" }, "<C-a>", function()
                require("opencode").ask("@this: ", { submit = true })
            end, { desc = "Ask opencode…" })

            vim.keymap.set({ "n", "x" }, "<C-x>", function()
                require("opencode").select()
            end, { desc = "Execute opencode action…" })

            vim.keymap.set({ "n", "t" }, "<C-.>", function()
                require("opencode").toggle()
            end, { desc = "Toggle opencode" })

            vim.keymap.set({ "n", "x" }, "go", function()
                return require("opencode").operator("@this ")
            end, { desc = "Add range to opencode", expr = true })

            vim.keymap.set("n", "goo", function()
                return require("opencode").operator("@this ") .. "_"
            end, { desc = "Add line to opencode", expr = true })

            vim.keymap.set("n", "<S-C-u>", function()
                require("opencode").command("session.half.page.up")
            end, { desc = "Scroll opencode up" })

            vim.keymap.set("n", "<S-C-d>", function()
                require("opencode").command("session.half.page.down")
            end, { desc = "Scroll opencode down" })

            -- You may want these if you use the opinionated `<C-a>` and `<C-x>` keymaps above — otherwise consider `<leader>o…` (and remove terminal mode from the `toggle` keymap)
            -- vim.keymap.set("n", "+", "<C-a>", { desc = "Increment under cursor", noremap = true })
            -- vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement under cursor", noremap = true })
        end,
    },

    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = true,
        ---@type snacks.Config
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
            bigfile = { enabled = true },
            dashboard = { enabled = true },
            explorer = {
                enabled = false,
                tree = false,
                auto_close = true,
                follow_file = true,

                jump = { close = false },
                -- layout = { preset = "sidebar", preview = true },
                layout = { layout = { position = "right" } },
            },
            indent = { enabled = true },
            input = { enabled = true },
            picker = { enabled = true },
            notifier = { enabled = true },
            quickfile = { enabled = true },
            scope = { enabled = true },
            scroll = { enabled = false },
            statuscolumn = { enabled = true },
            words = { enabled = true },
        },
    },

    {
        "stevearc/oil.nvim",
        ---@module 'oil'
        ---@type oil.SetupOpts
        opts = { -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
            -- Set to false if you want some other plugin (e.g. netrw) to open when you edit directories.
            default_file_explorer = true,
            -- Id is automatically added at the beginning, and name at the end
            -- See :help oil-columns
            columns = {
                "icon",
                -- "permissions",
                "size",
                -- "mtime",
            },
            -- Buffer-local options to use for oil buffers
            buf_options = {
                buflisted = false,
                bufhidden = "hide",
            },
            -- Window-local options to use for oil buffers
            win_options = {
                wrap = false,
                signcolumn = "no",
                cursorcolumn = false,
                foldcolumn = "0",
                spell = false,
                list = false,
                conceallevel = 3,
                concealcursor = "nvic",
            },
            -- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
            delete_to_trash = false,
            -- Skip the confirmation popup for simple operations (:help oil.skip_confirm_for_simple_edits)
            skip_confirm_for_simple_edits = false,
            -- Selecting a new/moved/renamed file or directory will prompt you to save changes first
            -- (:help prompt_save_on_select_new_entry)
            prompt_save_on_select_new_entry = true,
            -- Oil will automatically delete hidden buffers after this delay
            -- You can set the delay to false to disable cleanup entirely
            -- Note that the cleanup process only starts when none of the oil buffers are currently displayed
            cleanup_delay_ms = 2000,
            lsp_file_methods = {
                -- Enable or disable LSP file operations
                enabled = true,
                -- Time to wait for LSP file operations to complete before skipping
                timeout_ms = 1000,
                -- Set to true to autosave buffers that are updated with LSP willRenameFiles
                -- Set to "unmodified" to only save unmodified buffers
                autosave_changes = false,
            },
            -- Constrain the cursor to the editable parts of the oil buffer
            -- Set to `false` to disable, or "name" to keep it on the file names
            constrain_cursor = "editable",
            -- Set to true to watch the filesystem for changes and reload oil
            watch_for_changes = true,
            -- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
            -- options with a `callback` (e.g. { callback = function() ... end, desc = "", mode = "n" })
            -- Additionally, if it is a string that matches "actions.<name>",
            -- it will use the mapping at require("oil.actions").<name>
            -- Set to `false` to remove a keymap
            -- See :help oil-actions for a list of all available actions
            --
            keymaps = {
                ["g?"] = { "actions.show_help", mode = "n" },
                ["<CR>"] = "actions.select",
                ["<C-s>"] = { "actions.select", opts = { vertical = true } },
                ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
                ["<C-t>"] = { "actions.select", opts = { tab = true } },
                ["<C-p>"] = "actions.preview",
                ["<C-c>"] = { "actions.close", mode = "n" },
                ["<C-l>"] = "actions.refresh",
                ["-"] = { "actions.parent", mode = "n" },
                ["_"] = { "actions.open_cwd", mode = "n" },
                ["`"] = { "actions.cd", mode = "n" },
                ["g~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
                ["gs"] = { "actions.change_sort", mode = "n" },
                ["gx"] = "actions.open_external",
                ["g."] = { "actions.toggle_hidden", mode = "n" },
                ["g\\"] = { "actions.toggle_trash", mode = "n" },
                -- search with f
                ["f"] = {
                    callback = function()
                        -- Opens search pre-filled to match the start of filenames
                        vim.api.nvim_feedkeys("/\\<", "n", false)
                    end,
                    desc = "Ranger-style find",
                },

                -- yank filename
                ["yf"] = {
                    desc = "Yank filename under cursor",
                    callback = function()
                        local entry = require("oil").get_cursor_entry()
                        if entry then
                            vim.fn.setreg("+", entry.name)
                            vim.notify("Yanked filename: " .. entry.name)
                        end
                    end,
                },

                -- yank absolute path
                ["yp"] = {
                    desc = "Yank absolute path",
                    callback = function()
                        local oil = require("oil")
                        local entry = oil.get_cursor_entry()
                        local dir = oil.get_current_dir()
                        if entry and dir then
                            local abs_path = dir .. entry.name
                            vim.fn.setreg("+", abs_path)
                            vim.notify("Yanked absolute path: " .. abs_path)
                        end
                    end,
                },

                -- open kitty at current path
                ["gk"] = {
                    desc = "Open Kitty terminal at path",
                    callback = function()
                        local oil = require("oil")
                        local dir = oil.get_current_dir()
                        if dir then
                            vim.fn.jobstart({ "kitty", "--directory", dir }, { detach = true })
                            vim.notify("Opened Kitty terminal at: " .. dir)
                        else
                            vim.notify("Could not determine current directory", vim.log.levels.ERROR)
                        end
                    end,
                },

                ["<Space>"] = {
                    callback = toggle_oil_line,
                    desc = "Toggle line selection",
                },
                ["<BS>"] = {
                    callback = clear_oil_highlights,
                    desc = "Clear all line selections",
                },
            },
            -- Set to false to disable all of the above keymaps
            use_default_keymaps = true,
            view_options = {
                -- Show files and directories that start with "."
                show_hidden = true,
                -- This function defines what is considered a "hidden" file
                is_hidden_file = function(name, bufnr)
                    local m = name:match("^%.")
                    return m ~= nil
                end,
                -- This function defines what will never be shown, even when `show_hidden` is set
                is_always_hidden = function(name, bufnr)
                    return false
                end,
                -- Sort file names with numbers in a more intuitive order for humans.
                -- Can be "fast", true, or false. "fast" will turn it off for large directories.
                natural_order = "fast",
                -- Sort file and directory names case insensitive
                case_insensitive = false,
                sort = {
                    -- sort order can be "asc" or "desc"
                    -- see :help oil-columns to see which columns are sortable
                    { "type", "asc" },
                    { "name", "asc" },
                },
                -- Customize the highlight group for the file name
                highlight_filename = function(entry, is_hidden, is_link_target, is_link_orphan)
                    return nil
                end,
            },
            -- Extra arguments to pass to SCP when moving/copying files over SSH
            extra_scp_args = {},
            -- Extra arguments to pass to aws s3 when creating/deleting/moving/copying files using aws s3
            extra_s3_args = {},
            -- EXPERIMENTAL support for performing file operations with git
            git = {
                -- Return true to automatically git add/mv/rm files
                add = function(path)
                    return false
                end,
                mv = function(src_path, dest_path)
                    return false
                end,
                rm = function(path)
                    return false
                end,
            },
            -- Configuration for the floating window in oil.open_float
            float = {
                -- Padding around the floating window
                padding = 2,
                -- max_width and max_height can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
                max_width = 0,
                max_height = 0,
                border = nil,
                win_options = {
                    winblend = 0,
                },
                -- optionally override the oil buffers window title with custom function: fun(winid: integer): string
                get_win_title = nil,
                -- preview_split: Split direction: "auto", "left", "right", "above", "below".
                preview_split = "auto",
                -- This is the config that will be passed to nvim_open_win.
                -- Change values here to customize the layout
                override = function(conf)
                    return conf
                end,
            },
            -- Configuration for the file preview window
            preview_win = {
                -- Whether the preview window is automatically updated when the cursor is moved
                update_on_cursor_moved = true,
                -- How to open the preview window "load"|"scratch"|"fast_scratch"
                preview_method = "fast_scratch",
                -- A function that returns true to disable preview on a file e.g. to avoid lag
                disable_preview = function(filename)
                    return false
                end,
                -- Window-local options to use for preview window buffers
                win_options = {},
                preview_method = "load",
            },
            -- Configuration for the floating action confirmation window
            confirmation = {
                -- Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
                -- min_width and max_width can be a single value or a list of mixed integer/float types.
                -- max_width = {100, 0.8} means "the lesser of 100 columns or 80% of total"
                max_width = 0.9,
                -- min_width = {40, 0.4} means "the greater of 40 columns or 40% of total"
                min_width = { 40, 0.4 },
                -- optionally define an integer/float for the exact width of the preview window
                width = nil,
                -- Height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
                -- min_height and max_height can be a single value or a list of mixed integer/float types.
                -- max_height = {80, 0.9} means "the lesser of 80 columns or 90% of total"
                max_height = 0.9,
                -- min_height = {5, 0.1} means "the greater of 5 columns or 10% of total"
                min_height = { 5, 0.1 },
                -- optionally define an integer/float for the exact height of the preview window
                height = nil,
                border = nil,
                win_options = {
                    winblend = 0,
                },
            },
            -- Configuration for the floating progress window
            progress = {
                max_width = 0.9,
                min_width = { 40, 0.4 },
                width = nil,
                max_height = { 10, 0.9 },
                min_height = { 5, 0.1 },
                height = nil,
                border = nil,
                minimized_border = "none",
                win_options = {
                    winblend = 0,
                },
            },
            -- Configuration for the floating SSH window
            ssh = {
                border = nil,
            },
            -- Configuration for the floating keymaps help window
            keymaps_help = {
                border = nil,
            },
        },
        -- Optional dependencies
        -- dependencies = { { "nvim-mini/mini.icons", opts = {} } },
        dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
        -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
        lazy = false,
    },

    {
        "3rd/image.nvim",
        opts = {
            backend = "kitty", -- or "ueberzug" or "sixel"
            processor = "magick_cli", -- or "magick_rock"
            integrations = {
                markdown = {
                    enabled = false,
                    clear_in_insert_mode = false,
                    download_remote_images = true,
                    only_render_image_at_cursor = false,
                    only_render_image_at_cursor_mode = "popup", -- or "inline"
                    floating_windows = false, -- if true, images will be rendered in floating markdown windows
                    filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
                },
                asciidoc = {
                    enabled = true,
                    clear_in_insert_mode = false,
                    download_remote_images = true,
                    only_render_image_at_cursor = false,
                    only_render_image_at_cursor_mode = "popup",
                    floating_windows = false,
                    filetypes = { "asciidoc", "adoc" },
                },
                neorg = {
                    enabled = true,
                    filetypes = { "norg" },
                },
                rst = {
                    enabled = true,
                },
                typst = {
                    enabled = true,
                    filetypes = { "typst" },
                },
                html = {
                    enabled = false,
                },
                css = {
                    enabled = false,
                },
            },
            max_width = nil,
            max_height = nil,
            max_width_window_percentage = nil,
            max_height_window_percentage = 50,
            scale_factor = 1.0,
            kitty_direct_chunk_size = 4096, -- chunk size for direct Kitty graphics protocol transmission
            window_overlap_clear_enabled = false, -- toggles images when windows are overlapped
            window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "snacks_notif", "scrollview", "scrollview_sign" },
            editor_only_render_when_focused = false, -- auto show/hide images when the editor gains/looses focus
            tmux_show_only_in_active_window = false, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
            hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" }, -- render image files as images when opened
        },
    },

    -- {
    --     "kelly-lin/ranger.nvim",
    --     config = function()
    --         require("ranger-nvim").setup({ replace_netrw = true })
    --         vim.api.nvim_set_keymap("n", "<C-e>", "", {
    --             noremap = true,
    --             callback = function()
    --                 require("ranger-nvim").open(true)
    --             end,
    --         })
    --     end,
    -- },

    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            options = {
                icons_enabled = true,
                theme = "auto",
                component_separators = { left = " ", right = " " },
                section_separators = { left = " ", right = " " },
                disabled_filetypes = {
                    statusline = {},
                    winbar = {},
                },
                ignore_focus = {},
                always_divide_middle = true,
                always_show_tabline = true,
                globalstatus = false,
                refresh = {
                    statusline = 1000,
                    tabline = 1000,
                    winbar = 1000,
                    refresh_time = 16, -- ~60fps
                    events = {
                        "WinEnter",
                        "BufEnter",
                        "BufWritePost",
                        "SessionLoadPost",
                        "FileChangedShellPost",
                        "VimResized",
                        "Filetype",
                        "CursorMoved",
                        "CursorMovedI",
                        "ModeChanged",
                    },
                },
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = {},
                lualine_c = {},
                lualine_x = {},
                lualine_y = { "filename" },
                lualine_z = { "progress" },
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { "filename" },
                lualine_x = { "location" },
                lualine_y = {},
                lualine_z = {},
            },
            tabline = {},
            winbar = {},
            inactive_winbar = {},
            extensions = {},
        },
    },

    {
        "saghen/blink.cmp",
        -- optional: provides snippets for the snippet source
        dependencies = { "rafamadriz/friendly-snippets" },

        -- Use a release tag to download pre-built binaries
        version = "*",
        -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
        -- build = 'cargo build --release',
        -- If you use Nix, you can build from source using the latest nightly rust with:
        -- build = 'nix run .#build-plugin',

        opts = {
            -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
            -- 'super-tab' for mappings similar to VSCode (tab to accept)
            -- 'enter' for enter to accept
            -- 'none' for no mappings
            --
            -- All presets have the following mappings:
            -- C-space: Open menu or open docs if already open
            -- C-n/C-p or Up/Down: Select next/previous item
            -- C-e: Hide menu
            -- C-k: Toggle signature help (if signature.enabled = true)
            --
            -- See :h blink-cmp-config-keymap for defining your own keymap
            keymap = {
                -- Each keymap may be a list of commands and/or functions
                preset = "default",
                -- Select completions
                ["<Up>"] = { "select_prev", "fallback" },
                ["<Down>"] = { "select_next", "fallback" },
                -- ["<Tab>"] = { "select_next", "fallback" },
                -- ["<S-Tab>"] = { "select_prev", "fallback" },
                -- Scroll documentation
                ["<C-b>"] = { "scroll_documentation_up", "fallback" },
                ["<C-f>"] = { "scroll_documentation_down", "fallback" },
                -- Show/hide signature
                ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
            },

            appearance = {
                -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = "mono",
            },

            sources = {
                -- `lsp`, `buffer`, `snippets`, `path`, and `omni` are built-in
                -- so you don't need to define them in `sources.providers`
                default = { "lsp", "path", "snippets", "buffer" },

                -- Sources are configured via the sources.providers table
            },

            -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
            -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
            -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
            --
            -- See the fuzzy documentation for more information
            fuzzy = { implementation = "prefer_rust_with_warning" },
            completion = {
                -- The keyword should only match against the text before
                keyword = { range = "prefix" },
                menu = {
                    -- Use treesitter to highlight the label text for the given list of sources
                    draw = {
                        treesitter = { "lsp" },
                    },
                },
                -- Show completions after typing a trigger character, defined by the source
                trigger = { show_on_trigger_character = true },
                documentation = {
                    -- Show documentation automatically
                    auto_show = true,
                },
            },

            -- Signature help when tying
            signature = { enabled = true },
        },
        opts_extend = { "sources.default" },
    },

    { "mason-org/mason.nvim", opts = {} },

    "github/copilot.vim",

    {
        "brenton-leighton/multiple-cursors.nvim",
        version = "*", -- Use the latest tagged version
        opts = {}, -- This causes the plugin setup function to be called
        keys = {
            { "<C-j>", "<Cmd>MultipleCursorsAddDown<CR>", mode = { "n", "x" }, desc = "Add cursor and move down" },
            { "<C-k>", "<Cmd>MultipleCursorsAddUp<CR>", mode = { "n", "x" }, desc = "Add cursor and move up" },

            {
                "<Leader>m",
                "<Cmd>MultipleCursorsAddVisualArea<CR>",
                mode = { "x" },
                desc = "Add cursors to the lines of the visual area",
            },

            { "<Leader>a", "<Cmd>MultipleCursorsAddMatches<CR>", mode = { "n", "x" }, desc = "Add cursors to cword" },
            {
                "<Leader>A",
                "<Cmd>MultipleCursorsAddMatchesV<CR>",
                mode = { "n", "x" },
                desc = "Add cursors to cword in previous area",
            },

            {
                "<Leader>d",
                "<Cmd>MultipleCursorsAddJumpNextMatch<CR>",
                mode = { "n", "x" },
                desc = "Add cursor and jump to next cword",
            },
            { "<Leader>D", "<Cmd>MultipleCursorsJumpNextMatch<CR>", mode = { "n", "x" }, desc = "Jump to next cword" },

            { "<Leader>l", "<Cmd>MultipleCursorsLock<CR>", mode = { "n", "x" }, desc = "Lock virtual cursors" },
        },
    },
})
