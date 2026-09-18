return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`traitor_plasma` encountered an error loading the Darktide Mod Framework.")

		new_mod("traitor_plasma", {
			mod_script       = "traitor_plasma/scripts/mods/traitor_plasma/traitor_plasma",
			mod_data         = "traitor_plasma/scripts/mods/traitor_plasma/traitor_plasma_data",
			mod_localization = "traitor_plasma/scripts/mods/traitor_plasma/traitor_plasma_localization",
		})
	end,
	packages = {},
	version = "1.1",
}
