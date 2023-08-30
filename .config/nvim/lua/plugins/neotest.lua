return {
	"nvim-neotest/neotest",
	event = "VeryLazy",
	dependencies = {
		"olimorris/neotest-phpunit",
		"marilari88/neotest-vitest",
		"rouge8/neotest-rust",
	},
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-vitest"),
				require("neotest-rust"),
				require("neotest-phpunit")({
					phpunit_cmd = function()
						local binary = io.open("vendor/bin/phpunit", "r")
						if binary ~= nil then
							io.close(binary)
							return "vendor/bin/phpunit"
						else
							return "bin/phpunit"
						end
					end,
				}),
			},
		})
	end,
}
