return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`stupidfallthing` encountered an error loading the Darktide Mod Framework.")

		new_mod("stupidfallthing", {
			mod_script       = "stupidfallthing/scripts/mods/stupidfallthing/stupidfallthing",
			mod_data         = "stupidfallthing/scripts/mods/stupidfallthing/stupidfallthing_data",
			mod_localization = "stupidfallthing/scripts/mods/stupidfallthing/stupidfallthing_localization",
		})
	end,
	packages = {},
}
