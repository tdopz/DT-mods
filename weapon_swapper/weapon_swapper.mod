return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`weapon_swapper` encountered an error loading the Darktide Mod Framework.")

		new_mod("weapon_swapper", {
			mod_script       = "weapon_swapper/scripts/mods/weapon_swapper/weapon_swapper",
			mod_data         = "weapon_swapper/scripts/mods/weapon_swapper/weapon_swapper_data",
			mod_localization = "weapon_swapper/scripts/mods/weapon_swapper/weapon_swapper_localization",
		})
	end,
	packages = {},
}
