return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`presencespoof` encountered an error loading the Darktide Mod Framework.")

		new_mod("presencespoof", {
			mod_script       = "presencespoof/scripts/mods/presencespoof/presencespoof",
			mod_data         = "presencespoof/scripts/mods/presencespoof/presencespoof_data",
			mod_localization = "presencespoof/scripts/mods/presencespoof/presencespoof_localization",
		})
	end,
	packages = {},
}
