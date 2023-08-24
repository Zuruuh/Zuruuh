vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    use('wbthomason/packer.nvim')
    use({
        'nvim-telescope/telescope.nvim',
        tag = '0.1.2',
        requires = { {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope-live-grep-args.nvim',
            { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
        } },
    })
    use({
        'navarasu/onedark.nvim',
        as = 'onedark',
    })
    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
    use('nvim-treesitter/nvim-treesitter-context')
    use('mrjones2014/nvim-ts-rainbow')
    use('nvim-treesitter/playground')
    use('mbbill/undotree')
    use('tpope/vim-fugitive')
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        requires = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},             -- Required
            {                                      -- Optional
                'williamboman/mason.nvim',
                run = function()
                    pcall(vim.cmd, 'MasonUpdate')
                end,
            },
            {'williamboman/mason-lspconfig.nvim'}, -- Optional

            -- Autocompletion
            {'hrsh7th/nvim-cmp'},     -- Required
            {'hrsh7th/cmp-nvim-lsp'}, -- Required
            {'L3MON4D3/LuaSnip'},     -- Required
        }
    }
    use('windwp/nvim-ts-autotag')
    use('nvim-tree/nvim-tree.lua')
    use('nvim-tree/nvim-web-devicons')
    use('prichrd/netrw.nvim')
    use({
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup()
        end
    })
    use('nvim-lualine/lualine.nvim')
    use('akinsho/bufferline.nvim')
    use('lukas-reineke/indent-blankline.nvim')
    use('phpactor/phpactor')
    use('terrortylor/nvim-comment')
    use('praem90/nvim-phpcsf')
    use('wakatime/vim-wakatime')
    use('Bekaboo/dropbar.nvim')
    use('uga-rosa/ccc.nvim')
    use('tpope/vim-dadbod')
    use('kristijanhusak/vim-dadbod-ui')
    use('phelipetls/jsonpath.nvim')
    use({
        'glepnir/dashboard-nvim',
        event = 'VimEnter',
        config = function ()
            require('dashboard').setup({})
        end,
    })
    use('christoomey/vim-tmux-navigator')
    use('NoahTheDuke/vim-just')
    use('mhartington/formatter.nvim')
end)
