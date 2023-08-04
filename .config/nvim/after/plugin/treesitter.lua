require('nvim-treesitter.configs').setup({
  ensure_installed = {
	  "c",
	  "javascript",
	  "typescript",
	  "rust",
	  "lua",
	  "vim",
	  "vimdoc",
	  "query"
  },

  sync_install = false,

  auto_install = true,

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  rainbow = {
     enable = true
  }
})

require('nvim-treesitter.parsers').get_parser_configs().just = {
  install_info = {
    url = "https://github.com/IndianBoy42/tree-sitter-just", -- local path or git repo
    files = { "src/parser.c", "src/scanner.cc" },
    branch = "main",
    -- use_makefile = true -- this may be necessary on MacOS (try if you see compiler errors)
  },
  maintainers = { "@IndianBoy42" },
}

require('treesitter-context').setup({
    enable=true
})
