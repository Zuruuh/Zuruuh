return {
	"glepnir/dashboard-nvim",
	event = "VimEnter",
	config = function()
		require("dashboard").setup({
			config = { project = { enable = false } },
		})
	end,
}
