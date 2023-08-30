vim.filetype.add({
	pattern = {
		[".*%.blade%.php"] = "html",
		[".*%.html%.twig"] = "twig",
		[".*%.yaml%.dist"] = "yaml",
		[".*%.conf%.dist"] = "nginx",
	},
})
