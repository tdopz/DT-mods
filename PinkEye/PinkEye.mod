return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`PinkEye` encountered an error loading the Darktide Mod Framework.")

		new_mod("PinkEye", {
			mod_script       = "PinkEye/scripts/mods/PinkEye/PinkEye",
			mod_data         = "PinkEye/scripts/mods/PinkEye/PinkEye_data",
			mod_localization = "PinkEye/scripts/mods/PinkEye/PinkEye_localization",
		})
	end,
	packages = {},
	version = {2.0},
}
