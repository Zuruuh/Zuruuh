return {
	"mbbill/undotree",
	lazy = false,
	keys = {
		{ "<leader>u", vim.cmd.UndotreeToggle },
	},
    config = function ()
        vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
        vim.opt.undofile = true
    end
}
