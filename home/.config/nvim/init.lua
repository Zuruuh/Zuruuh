--[[=================================================================init.lua
========                                    .-----.          ========
========         .----------------------.   | === |          ========
========         |.-""""""""""""""""""-.|   |-----|          ========
========         ||                    ||   | === |          ========
========         ||   KICKSTART.NVIM   ||   |-----|          ========
========         ||                    ||   | === |          ========
========         ||                    ||   |-----|          ========
========         ||:Tutor              ||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------(""`   ___________      ========
========        /::::::::::|  |::::::::::\  \          \     ========
========       /:::::::::::|  |::hjkl:::::\  \          \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
===================================================================]]

-- Windows support
local home = os.getenv('HOME')
if home == nil then
  home = 'C:' .. os.getenv('HOMEPATH')
end

-- Config
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- NOTE: See `:help vim.opt`
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.showmode = false
vim.opt.swapfile = false

vim.opt.breakindent = true

vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace in the editor.
--  NOTE: See `:help 'list'` and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

vim.opt.foldlevel = 99
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.wo.foldtext = 'v:lua.vim.treesitter.foldtext()'

if vim.fn.has('unix') == 1 then
  vim.o.shell = vim.fn.trim(vim.fn.system({ 'bash', '-c', 'which bash' }))
elseif vim.fn.has('win32') == 1 then
  local shell = os.getenv('PWSH')

  if shell ~= nil then
    vim.o.shell = vim.fn.trim(shell)
  end

  vim.opt.shellslash = true
end

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.diagnostic.config({
  virtual_text = {
    virt_text_pos = 'eol',
  },
})

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    (vim.hl or vim.highlight).on_yank()
  end,
})

vim.keymap.set('n', '<leader>yp', function()
  local path = vim.fn.expand('%')
  vim.fn.setreg('+', path)
  vim.notify('Copied "' .. path .. '" to the clipboard!')
end, { desc = 'Copy relative file path from project root' })

vim.keymap.set('n', '<leader>yP', function()
  local path = vim.fn.expand('%')
  vim.fn.setreg('"', path)
  vim.notify('Use `"%` instead!')
  -- vim.notify('Pushed "' .. path .. '" to register!')
end, { desc = 'Copy relative file path from project root' })

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

vim.filetype.add({
  extension = {
    caddy = 'caddyfile',
    pattern = {
      ['openapi.*%.ya?ml'] = 'yaml.openapi',
      ['openapi.*%.json'] = 'json.openapi',
    },
  },
})

vim.api.nvim_create_user_command('FormatDisable', function(args)
  if args.bang then
    -- FormatDisable! will disable formatting just for this buffer
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = 'Disable autoformat-on-save',
  bang = true,
})

vim.api.nvim_create_user_command('FormatEnable', function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = 'Re-enable autoformat-on-save',
})

local ns = vim.api.nvim_create_namespace('evenoddlines')

vim.api.nvim_set_decoration_provider(ns, {
  on_win = function() end,
  on_line = function(_, _, buf, row)
    if vim.api.nvim_buf_get_name(buf):match('NvimTree') == nil then
      return
    end

    if row % 2 == 0 then
      vim.api.nvim_buf_set_extmark(buf, ns, row, 0, {
        end_row = row + 1,
        hl_group = 'NvimTreeNormalOdd',
        hl_eol = true,
        ephemeral = true,
      })
    end
  end,
})

-- Plugins
require('lazy').setup({
  { -- Detect tabstop and shiftwidth automatically
    'NMAC427/guess-indent.nvim',
    opts = {},
  },

  {
    'numToStr/Comment.nvim',
    dependencies = {
      {
        'JoosepAlviste/nvim-ts-context-commentstring',
        opts = {
          enable_autocmd = false,
        },
      },
    },
    event = 'VimEnter',
    opts = function()
      return {
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      }
    end,
  },

  {
    'lewis6991/gitsigns.nvim',
    event = 'VimEnter',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    config = function()
      local wk = require('which-key')
      wk.setup()

      wk.add({
        { '<leader>c', group = '[C]ode' },
        { '<leader>d', group = '[D]ocument' },
        { '<leader>r', group = '[R]ename' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>p', group = '[P]roject' },
        { '<leader>g', group = '[G]it' },
      })
    end,
  },

  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for install instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        build = 'make',

        cond = function()
          return vim.fn.executable('make') == 1
        end,
      },

      'nvim-telescope/telescope-ui-select.nvim',
      'nvim-tree/nvim-web-devicons',
    },

    config = function()
      local themes = require('telescope.themes')
      local telescope = require('telescope')
      function merge(a, b)
        local result = { unpack(a) }
        for _, v in ipairs(b) do
          table.insert(result, v)
        end
        return result
      end
      local args = { '--path-separator', '/', '--iglob', '!.git', '--iglob', '!.jj', '--hidden', '--ignore-file', '.gitignore' }

      telescope.setup({
        pickers = {
          find_files = {
            hidden = true,
            find_command = merge({
              'rg',
              '--files',
            }, args),
          },
          grep_string = {
            additional_args = args,
          },
          live_grep = {
            additional_args = args,
          },
        },
        extensions = {
          ['ui-select'] = {
            themes.get_dropdown(),
          },
        },
      })

      -- Enable telescope extensions, if they are installed
      pcall(telescope.load_extension, 'fzf')
      pcall(telescope.load_extension, 'ui-select')

      local responsive_picker = function(picker, opts)
        local theme_opts = vim.tbl_deep_extend('force', {
          winblend = 10,
        }, opts or {})

        local picker_opts = (vim.o.columns / 2 > vim.o.lines) and theme_opts or themes.get_dropdown(theme_opts)

        return function()
          picker(picker_opts)
        end
      end

      local builtins = require('telescope.builtin')
      vim.keymap.set('n', '<leader>sh', responsive_picker(builtins.help_tags), { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', responsive_picker(builtins.keymaps), { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', responsive_picker(builtins.find_files), { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', responsive_picker(builtins.builtin), { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', responsive_picker(builtins.grep_string), { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', responsive_picker(builtins.live_grep), { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', responsive_picker(builtins.diagnostics), { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>s.', responsive_picker(builtins.oldfiles), { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', responsive_picker(builtins.buffers), { desc = '[ ] Find existing buffers' })
      vim.keymap.set('n', '<leader>sr', responsive_picker(builtins.lsp_references), { desc = '[S]earch LSP [R]eferences' })
      vim.keymap.set('n', '<leader>sb', responsive_picker(builtins.git_branches), { desc = '[S]earch Git [B]ranches' })

      -- Slightly advanced example of overriding default behavior and theme

      -- Also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set(
        'n',
        '<leader>s/',
        responsive_picker(builtins.live_grep, { grep_open_files = true, prompt_title = 'Live Grep in Open Files' }),
        { desc = '[S]earch [/] in Open Files' }
      )
    end,
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = 'ConformInfo',
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format({ async = true, lsp_format = 'fallback' })
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = function()
      local conform = require('conform.util')

      return {
        notify_on_error = true,
        format_on_save = function(bufnr)
          -- Disable with a global or buffer-local variable
          if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
          end
          return { timeout_ms = 500, lsp_fallback = true }
        end,

        formatters = {
          phpcbf = function()
            return {
              async = true,
              command = conform.find_executable({
                'vendor/bin/phpcbf',
                'bin/phpcbf',
              }, 'phpcbf'),
            }
          end,

          prettier = function()
            return {
              command = conform.from_node_modules('prettier'),
            }
          end,

          biome = function()
            return {
              command = conform.find_executable({
                'node_modules/.bin/biome',
              }, 'biome'),
            }
          end,

          mago = function()
            return {
              inherit = false,
              command = conform.find_executable({
                'vendor/bin/mago',
                'bin/mago',
              }, ' mago'),
              args = { 'fmt', '--stdin-input' },
              stdin = true,
              cwd = conform.root_file({ 'mago.toml' }),
              require_cwd = true,
            }
          end,

          dioxus = function()
            return {
              command = 'dx',
              args = { 'fmt', '--file', '$FILENAME' },
              cwd = conform.root_file({ 'Dioxus.toml' }),
              require_cwd = true,
              stdin = false,
            }
          end,
        },

        formatters_by_ft = {
          lua = { 'stylua' },
          javascript = { 'biome' },
          typescript = { 'biome' },
          javascriptreact = { 'biome' },
          typescriptreact = { 'biome' },
          svelte = { 'prettier' },
          -- yaml = { 'prettier', lsp_format = 'fallback' },
          astro = { 'prettier' },
          html = { 'prettier', lsp_format = 'fallback' },
          css = { 'biome' },
          json = { 'biome', lsp_format = 'fallback' },
          markdown = { 'deno_fmt' },
          sh = { 'shfmt' },
          toml = { 'taplo' },
          php = { 'mago', 'php_cs_fixer', 'phpcbf', stop_after_first = true },
          rust = { 'dioxus', 'rustfmt' },
          nix = { 'nixpkgs_fmt' },
          terraform = { 'tofu_fmt' },
          cs = { 'csharpier' },
          ['_'] = { 'trim_whitespace' },
        },
      }
    end,
  },

  {
    'saghen/blink.cmp',
    build = vim.fn.has('win32') == 1 and 'cargo build --release' or 'nix run .#build-plugin',
    dependencies = {
      -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
      -- used for completion, annotations and signatures of Neovim apis
      { 'folke/lazydev.nvim', ft = 'lua', opts = {} },
    },

    opts = {
      signature = { enabled = true },
      keymap = {
        preset = 'super-tab',
        ['<Enter>'] = { 'accept', 'fallback' },
        ['<C-Space>'] = { 'show', 'fallback' },
        ['<C-e>'] = { 'show', 'fallback' },
      },

      fuzzy = {
        implementation = vim.fn.has('win32') == 1 and 'lua' or 'prefer_rust_with_warning',
      },

      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono',
      },

      completion = {
        list = {
          selection = {
            preselect = function(ctx)
              return ctx.mode ~= 'cmdline'
            end,
          },
        },
      },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer', 'lazydev' },
        providers = {
          lazydev = {
            name = 'LazyDev',
            module = 'lazydev.integrations.blink',
            score_offset = 100,
          },
        },
      },
    },
    opts_extend = { 'sources.default' },
  },
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },
      {
        'mason-org/mason.nvim',
        cond = function()
          return vim.fn.has('win32') == 1
        end,
        opts = {},
      },
      {
        'b0o/schemastore.nvim',
        ft = 'json',
      },
    },
    opts = {
      servers = {
        astro = {},
        bashls = {},
        clangd = {},
        cssls = {},
        dockerls = {},
        html = {},
        jsonls = function()
          return {
            settings = {
              json = {
                schemas = require('schemastore').json.schemas(),
                validate = { enable = true },
              },
            },
          }
        end,
        lua_ls = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
          },
        },
        phpactor = {},
        rust_analyzer = {
          ['rust-analyzer'] = {
            cargo = {
              buildScripts = { enable = true },
              features = 'all',
            },
            procMacro = { enable = true },
            files = {
              excludeDirs = { '.direnv' },
            },
          },
        },
        sqlls = {},
        ts_ls = {},
        yamlls = function()
          return {
            settings = {
              yaml = {
                schemaStore = {
                  enable = true,
                  url = 'https://www.schemastore.org/api/json/catalog.json',
                },
                schemas = require('schemastore').yaml.schemas(),
              },
            },
          }
        end,
        -- nil_ls = {},
        nixd = {},
        nushell = {},
        gopls = {},
        lemminx = {},
        terraformls = {},
        zls = {},
        taplo = {},
        csharp_ls = {},
        tailwindcss = {},
      },
    },
    config = function(_, opts)
      local blink = require('blink.cmp')

      for server, config in pairs(opts.servers) do
        if type(config) == 'function' then
          config = config()
        end
        config.capabilities = blink.get_lsp_capabilities(config.capabilities)

        vim.lsp.config(server, config)
        vim.lsp.enable(server)
      end

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('gb', '<C-t>', '[G]o [B]ack')

          -- Find references for the word under your cursor.
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]references')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]symbols')

          -- Fuzzy find all the symbols in your current workspace
          --  Similar to document symbols, except searches over your whole project.
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]symbols')

          -- Rename the variable under your cursor
          --  Most Language Servers support renaming across files, etc.
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

          -- Opens a popup that displays documentation about the word under your cursor
          --  See `:help K` for why this keymap
          map('K', vim.lsp.buf.hover, 'Hover Documentation')

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.clear_references,
            })

            if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
              local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
              vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.document_highlight,
              })

              vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.clear_references,
              })

              vim.api.nvim_create_autocmd('LspDetach', {
                group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
                callback = function(event2)
                  vim.lsp.buf.clear_references()
                  vim.api.nvim_clear_autocmds({ group = 'kickstart-lsp-highlight', buffer = event2.buf })
                end,
              })

              if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
                map('<leader>th', function()
                  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
                end, '[T]oggle Inlay [H]ints')
              end
            end
          end
        end,
      })
    end,
  },

  { -- Persistent theme selector, run with `:Themery`
    'zaldih/themery.nvim',
    dependencies = {
      { 'navarasu/onedark.nvim', lazy = true },
      { 'Mofiqul/vscode.nvim', lazy = true },
      { 'folke/tokyonight.nvim', lazy = true },
      { 'ellisonleao/gruvbox.nvim', lazy = true },
      { 'ellisonleao/gruvbox.nvim', lazy = true },
      { 'catppuccin/nvim', name = 'catppuccin', lazy = true },
      { 'shaunsingh/nord.nvim', lazy = true },
      { 'nyoom-engineering/oxocarbon.nvim', lazy = true },
    },
    opts = {
      themes = {
        'onedark',
        'vscode',
        'tokyonight',
        'tokyonight-day',
        'tokyonight-night',
        'tokyonight-storm',
        'tokyonight-moon',
        'gruvbox',
        'catppuccin-macchiato',
        'catppuccin-latte',
        'catppuccin-frappe',
        'catppuccin-mocha',
        'nord',
        'oxocarbon',
        'default',
      },
      livePreview = true,
    },
  },

  {
    'f-person/auto-dark-mode.nvim',
    event = 'VeryLazy',
    opts = {
      update_interval = 5000,
    },
  },

  -- Highlight todo, notes, etc in comments
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    event = 'VeryLazy',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isuall/y select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [']quote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup({ n_lines = 500 })

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]inner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      local statusline = require('mini.statusline')

      statusline.setup({
        use_icons = true,
        content = {
          active = function()
            local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
            -- local git = statusline.section_git({ trunc_width = 40 })
            local diff = statusline.section_diff({ trunc_width = 75 })
            local diagnostics = statusline.section_diagnostics({ trunc_width = 75 })
            local lsp = statusline.section_lsp({ trunc_width = 75 })
            local filename = statusline.section_filename({ trunc_width = 140 })
            local fileinfo = statusline.section_fileinfo({ trunc_width = 120 })
            local location = statusline.section_location({ trunc_width = 75 })
            local search = statusline.section_searchcount({ trunc_width = 75 })

            return statusline.combine_groups({
              { hl = mode_hl, strings = { mode } },
              {
                hl = 'statuslineDevinfo',
                strings = {
                  -- git,
                  diff,
                  diagnostics,
                  lsp,
                },
              },
              '%<', -- Mark general truncate point
              { hl = 'statuslineFilename', strings = { filename } },
              '%=', -- End left alignment
              { hl = 'statuslineFileinfo', strings = { fileinfo } },
              { hl = mode_hl, strings = { search, location } },
            })
          end,
        },
        set_vim_settings = true,
      })

      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {},
  },

  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',

    dependencies = {
      'nvim-treesitter/nvim-treesitter-context',
      'windwp/nvim-ts-autotag',
    },
    opts = {
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    },
    config = function(_, opts)
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup(opts)
      require('treesitter-context').setup({
        enable = true,
        max_lines = 3,
      })

      require('nvim-ts-autotag').setup({
        autotag = {
          enable = true,
        },
      })
    end,
  },
  {
    'isobit/vim-caddyfile',
    event = 'VeryLazy',
  },
  {
    'saecki/crates.nvim',
    tag = 'stable',
    event = { 'BufRead Cargo.toml' },
    opts = {
      lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
      },
    },
  },
  {
    'tpope/vim-fugitive',
    cmd = 'Git',
    keys = {
      { '<leader>gs', vim.cmd.Git, desc = '[G]it [S]tatus UI' },
      { '<leader>gf', '<CMD>diffget //2<CR>', desc = 'Accept changes from left buffer' },
      { '<leader>gh', '<CMD>diffget //3<CR>', desc = 'Accept changes from right buffer' },
      { '<leader>gpl', '<CMD>Git pull<CR>', silent = true, desc = '[G]it [P]u[l]l' },
      { '<leader>gpp', '<CMD>Git push<CR>', silent = true, desc = '[G]it [P]ush' },
      {
        '<leader>gph',
        '<CMD>Git push -u origin HEAD<CR>',
        silent = true,
        desc = '[G]it [P]ush to origin/[H]EAD',
      },
      {
        '<leader>ggfl',
        '<CMD>Git push --force-with-lease<CR>',
        silent = true,
        desc = '[G]it [P]ush --[f]orce-with-[l]ease',
      },
    },
  },
  {
    'NoahTheDuke/vim-just',
    ft = 'just',
  },
  {
    'mbbill/undotree',
    lazy = false,
    keys = {
      { '<leader>u', vim.cmd.UndotreeToggle, desc = 'Open [U]ndotree' },
    },
    config = function()
      vim.opt.undodir = vim.fn.stdpath('data') .. '/undodir'
    end,
  },
  {
    'nvim-tree/nvim-tree.lua',
    lazy = false,
    keys = {
      {
        '<leader>pv',
        vim.cmd.NvimTreeOpen,
        desc = 'Open [P]roject [V]iew (File explorer)',
      },
    },
    opts = {
      git = { enable = true },
      renderer = {
        highlight_git = true,
        icons = {
          show = {
            git = true,
          },
        },
      },
      view = {
        side = 'right',
        relativenumber = true,
      },
    },
    config = function(_, opts)
      require('nvim-tree').setup(opts)

      local nvim_tree_normal_hl = vim.api.nvim_get_hl(0, { name = 'NvimTreeNormal' })
      if nvim_tree_normal_hl == nil or nvim_tree_normal_hl.bg == nil then
        return
      end

      -- + 5 on all 3 RGB channels
      vim.api.nvim_set_hl(0, 'NvimTreeNormalOdd', { bg = nvim_tree_normal_hl.bg - 591878 })
    end,
  },
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = 'nvim-tree/nvim-web-devicons',
    event = 'VeryLazy',
    opts = {
      options = {
        separator_style = 'slant',
        numbers = 'ordinal',
        diagnostics = 'nvim_lsp',
      },
    },
    keys = {
      { '<leader>0', vim.cmd.bdelete, desc = 'Delete current buffer' },
      {
        '<leader>1',
        function()
          vim.cmd('BufferLineGoToBuffer 1')
        end,
        desc = 'Go to buffer [1]',
      },
      {
        '<leader>2',
        function()
          vim.cmd('BufferLineGoToBuffer 2')
        end,
        desc = 'Go to buffer [2]',
      },
      {
        '<leader>3',
        function()
          vim.cmd('BufferLineGoToBuffer 3')
        end,
        desc = 'Go to buffer [3]',
      },
      {
        '<leader>4',
        function()
          vim.cmd('BufferLineGoToBuffer 4')
        end,
        desc = 'Go to buffer [4]',
      },
      {
        '<leader>5',
        function()
          vim.cmd('BufferLineGoToBuffer 5')
        end,
        desc = 'Go to buffer [5]',
      },
      {
        '<leader>6',
        function()
          vim.cmd('BufferLineGoToBuffer 6')
        end,
        desc = 'Go to buffer [6]',
      },
      {
        '<leader>7',
        function()
          vim.cmd('BufferLineGoToBuffer 7')
        end,
        desc = 'Go to buffer [7]',
      },
      {
        '<leader>8',
        function()
          vim.cmd('BufferLineGoToBuffer 8')
        end,
        desc = 'Go to buffer [8]',
      },
      {
        '<leader>9',
        function()
          vim.cmd('BufferLineGoToBuffer 9')
        end,
        desc = 'Go to buffer [9]',
      },
    },
  },
  {
    'folke/snacks.nvim',
    lazy = false,
    priority = 1000,
    opts = {
      bigfile = {},
      dashboard = {
        sections = {
          { section = 'header' },
          {
            pane = 2,
            { section = 'keys', gap = 1, padding = 1 },
            { section = 'startup' },
          },
        },
        preset = {
          keys = {
            { icon = ' ', key = 'f', desc = 'Find File', action = ":lua Snacks.dashboard.pick('files')" },
            { icon = ' ', key = 'g', desc = 'Find Text', action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = ' ', key = 'r', desc = 'Recent Files', action = ":lua Snacks.dashboard.pick('oldfiles')" },
            -- { icon = ' ', key = 'c', desc = 'Config', action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            { icon = '󰒲 ', key = 'L', desc = 'Lazy', action = ':Lazy', enabled = package.loaded.lazy ~= nil },
            { icon = '󱊣', key = 'c', desc = 'Healthcheck', action = ':checkhealth' },
            { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
          },

          header = vim.fn.system({
            vim.fn.has('win32') == 1 and 'nu' or '/run/current-system/sw/bin/nu',
            '-n',
            '-c',
            [[
              try {
                open ~/.dotfiles/home/.config/nvim/asciis.jsonl |
                from json --objects |
                shuffle |
                first |
                $"($in.data)(char newline)- ($in.title) -"
              } catch {
                'No asciis found :c'
              }
            ]],
          }),
        },
      },
      gitbrowse = {
        url_patterns = {
          ['git.staffmatch.it'] = {
            branch = '/-/tree/{branch}',
            file = '/-/blob/{branch}/{file}#L{line_start}-L{line_end}',
            commit = '/-/commit/{commit}',
          },
        },
      },
    },
    keys = {
      {
        '<leader>go',
        function()
          ---@diagnostic disable-next-line: undefined-global
          Snacks.gitbrowse.open()
        end,
        silent = true,
        desc = '[G]it [o]pen, open file in git remote web UI',
      },
    },
  },
  {
    'xzbdmw/clasp.nvim',
    opts = {
      pairs = {
        ['{'] = '}',
        ['"'] = '"',
        ["'"] = "'",
        ['('] = ')',
        ['['] = ']',
        ['<'] = '>',
        ['`'] = '`',
      },
      keep_insert_mode = true,
    },
  },
  {
    'mistweaverco/kulala.nvim',
    keys = {
      { '<leader>Rs', desc = 'Send request' },
      { '<leader>Ra', desc = 'Send all requests' },
      { '<leader>Rb', desc = 'Open scratchpad' },
    },
    ft = { 'http', 'rest' },
    opts = {
      global_keymaps = false,
      global_keymaps_prefix = '<leader>R',
      kulala_keymaps_prefix = '',
    },
  },
}, {
  rocks = {
    enabled = false,
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
