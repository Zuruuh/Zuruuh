--[[=================================================================
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

if vim.fn.has('unix') == 1 then
  vim.o.shell = vim.fn.trim(vim.fn.system({ 'bash', '-c', 'which bash' }))
elseif vim.fn.has('win32') == 1 then
  local shell = os.getenv('PWSH')

  if shell ~= nil then
    vim.o.shell = vim.fn.trim(shell)
  end
end

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

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
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
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
  vim.notify('Copied "' .. path .. '" to the clipboard!')
end, { desc = 'Copy relative file path from project root' })

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
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

-- Plugins
require('lazy').setup({
  { -- Detect tabstop and shiftwidth automatically
    'tpope/vim-sleuth',
    lazy = false,
    keys = {
      {
        '<leader>sl',
        vim.cmd.Sleuth,
        silent = true,
        desc = '[Sl]euth, detect tabstop and shiftwidth',
      },
    },
  },

  { 'numToStr/Comment.nvim', opts = {} },

  {
    'lewis6991/gitsigns.nvim',
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
        { '<leader>h', group = '[H]arpoon' },
        { '<leader>g', group = '[G]it' },
      })
    end,
  },

  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for install instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        build = 'make',

        cond = function()
          return vim.fn.executable('make') == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      { 'nvim-tree/nvim-web-devicons' },
    },
    config = function()
      local themes = require('telescope.themes')

      require('telescope').setup({
        pickers = {
          find_files = {
            hidden = true,
            find_command = { 'rg', '--files', '--iglob', '!.git', '--hidden' },
          },
          grep_string = {
            additional_args = { '--hidden' },
          },
          live_grep = {
            additional_args = { '--hidden' },
          },
        },
        extensions = {
          ['ui-select'] = {
            themes.get_dropdown(),
          },
        },
      })

      -- Enable telescope extensions, if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', function()
        return builtin.find_files(vim.o.columns / 2 > vim.o.lines and {} or themes.get_dropdown({
          winblend = 10,
        }))
      end, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
      vim.keymap.set('n', '<leader>sr', builtin.lsp_references, { desc = '[S]earch LSP [R]eferences' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to telescope to change theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
          winblend = 10,
          previewer = false,
        }))
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- Also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep({
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        })
      end, { desc = '[S]earch [/] in Open Files' })
    end,
  },

  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },

      -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
      -- used for completion, annotations and signatures of Neovim apis
      { 'folke/lazydev.nvim', ft = 'lua', opts = {} },
      {
        'williamboman/mason.nvim',
        cond = function()
          return vim.fn.has('win32') == 1
        end,
        opts = {},
      },
    },
    config = function()
      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
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
          end
        end,
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP Specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      local servers = {
        astro = {},
        bashls = {},
        clangd = {},
        cssls = {},
        docker_compose_language_service = {},
        dockerls = {},
        html = {},
        jsonls = {},
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
            cargo = { buildScripts = { enable = true } },
            procMacro = { enable = true },
            files = {
              excludeDirs = { '.direnv' },
            },
          },
        },
        sqlls = {},
        ts_ls = {},
        yamlls = {},
        nil_ls = {},
        nushell = {},
        vacuum = {},
        gopls = {},
        lemminx = {},
        terraformls = {},
      }

      local lspconfig = require('lspconfig')
      for server_name, settings in pairs(servers) do
        if settings ~= nil then
          lspconfig[server_name].setup({
            -- on_attach = function(_, bufnr)
            -- vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
            -- end,
            settings = settings,
            capabilities = capabilities,
          })
        end
      end
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
    opts = {
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
            command = require('conform.util').find_executable({
              'vendor/bin/phpcbf',
              'bin/phpcbf',
            }, 'phpcbf'),
          }
        end,

        php_cs_fixer = function()
          return {
            command = require('conform.util').find_executable({
              'vendor/bin/php-cs-fixer',
              'bin/php-cs-fixer',
            }, 'php-cs-fixer'),
          }
        end,
      },

      prettier = function()
        return {
          command = require('conform.util').from_node_modules('prettier'),
        }
      end,

      biome = function()
        return {
          command = require('conform.util').find_executable({
            'node_modules/.bin/biome',
            'node_modules/.bin/prettier',
          }, 'biome'),
        }
      end,

      formatters_by_ft = {
        lua = { 'stylua' },
        javascript = { 'biome', stop_after_first = true },
        typescript = { 'biome', stop_after_first = true },
        javascriptreact = { 'biome', stop_after_first = true },
        typescriptreact = { 'biome', stop_after_first = true },
        svelte = { 'biome', stop_after_first = true },
        yaml = { 'prettier' },
        astro = { 'biome', stop_after_first = true },
        html = { 'prettier' },
        css = { 'biome' },
        json = { 'biome', stop_after_first = true },
        markdown = { 'deno_fmt', stop_after_first = true },
        sh = { 'shfmt' },
        toml = { 'taplo' },
        php = { 'php_cs_fixer', 'phpcbf', stop_after_first = true },
        rust = { 'rustfmt' },
        nix = { 'nixpkgs_fmt' },
        terraform = { 'tofu_fmt' },
        ['_'] = { 'trim_whitespace' },
      },
    },
  },

  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          -- Build Step is needed for regex support in snippets
          -- This step is not supported in many windows environments
          -- Remove the below condition to re-enable on windows
          if vim.fn.has('win32') == 1 or vim.fn.executable('make') == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
      },
      'saadparwaiz1/cmp_luasnip',

      -- Adds other completion capabilities.
      --  nvim-cmp does not ship with all sources by default. They are split
      --  into multiple repos for maintenance purposes.
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',

      -- If you want to add a bunch of pre-configured snippets,
      --    you can use this plugin to help you. It even has snippets
      --    for various frameworks/libraries/etc. but you will have to
      --    set up the ones that are useful for you.

      -- Disabled bcz it's a pain to configure correctly
      -- {
      --   'rafamadriz/friendly-snippets',
      --   config = function()
      --     require('luasnip.loaders.from_vscode').lazy_load({
      --       exclude = { 'php', 'rust', 'javascript', 'global' },
      --     })
      --   end,
      -- },

      -- LSP Symbols in completions menu
      'onsails/lspkind.nvim',
    },
    config = function()
      -- See `:help cmp`
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      luasnip.config.setup({})

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },

        -- For an understanding of why these mappings were
        -- chosen, you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        mapping = cmp.mapping.preset.insert({
          -- Select the [n]ext item
          ['<C-n>'] = cmp.mapping.select_next_item(),
          -- Select the [p]revious item
          ['<C-p>'] = cmp.mapping.select_prev_item(),

          -- Accept ([y]es) the completion.
          --  This will auto-import if your LSP supports it.
          --  This will expand snippets if the LSP sent a snippet.
          ['<Enter>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping.confirm({ select = true }),

          -- Manually trigger a completion from nvim-cmp.
          --  Generally you don't need this, because nvim-cmp will display
          --  completions whenever it has completion options available.
          ['<C-Space>'] = cmp.mapping.complete({}),
          ['<C-e>'] = cmp.mapping.complete({}),

          -- Think of <c-l> as moving to the right of your snippet expansion.
          --  So if you have a snippet that's like:
          --  function $name($args)
          --    $body
          --  end
          --
          -- <c-l> will move you to the right of each of the expansion locations.
          -- <c-h> is similar, except moving you backwards.
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),
        }),
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
          { name = 'crates' },
        },
        ---@diagnostic disable-next-line: missing-fields
        formatting = {
          format = require('lspkind').cmp_format({
            mode = 'symbol', -- show only symbol annotations
            maxwidth = {
              -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
              -- can also be a function to dynamically calculate max width such as
              -- menu = function() return math.floor(0.45 * vim.o.columns) end,
              -- menu = 50, -- leading text (labelDetails)
              -- abbr = 50, - actual suggestion item
            },
            ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)

            -- The function below will be called before any actual modifications from lspkind
            -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
            before = function(_, vim_item)
              -- ...
              return vim_item
            end,
          }),
        },
      })
    end,
  },

  { -- Persistent theme selector, run with `:Themery`
    'zaldih/themery.nvim',
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
  { 'navarasu/onedark.nvim', lazy = true },
  { 'Mofiqul/vscode.nvim', lazy = true },
  { 'folke/tokyonight.nvim', lazy = true },
  { 'ellisonleao/gruvbox.nvim', lazy = true },
  { 'ellisonleao/gruvbox.nvim', lazy = true },
  { 'catppuccin/nvim', name = 'catppuccin', lazy = true },
  { 'shaunsingh/nord.nvim', lazy = true },
  { 'nyoom-engineering/oxocarbon.nvim', lazy = true },

  {
    'f-person/auto-dark-mode.nvim',
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
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
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
      statusline.setup({ use_icons = true })

      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
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
  },
  {
    'saecki/crates.nvim',
    event = { 'BufRead Cargo.toml' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    tag = 'stable',
    opts = {
      completion = {
        cmp = {
          enabled = true,
        },
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
      { '<leader>gph', '<CMD>Git push -u origin HEAD<CR>', silent = true, desc = '[G]it [P]ush to origin/[H]EAD' },
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
  },
  {
    'kawre/leetcode.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'nvim-lua/plenary.nvim', -- required by telescope
      'MunifTanjim/nui.nvim',
    },
    opts = {
      lang = 'rust',
      cn = {
        enabled = false,
      },
      storage = {
        home = vim.fn.stdpath('data') .. '/leetcode',
        cache = vim.fn.stdpath('cache') .. '/leetcode',
      },
    },
  },
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = 'nvim-tree/nvim-web-devicons',
    lazy = false,
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
    opts = {
      bigfile = {},
      dashboard = {},
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
    'OXY2DEV/markview.nvim',
    lazy = false,

    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    {
      'dariuscorvus/tree-sitter-surrealdb.nvim',
      dependencies = { 'nvim-treesitter/nvim-treesitter' },
      opts = {},
      event = { 'BufRead *.surql' },
    },
  },
}, {
  rocks = {
    enabled = false,
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
