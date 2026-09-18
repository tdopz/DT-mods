return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`uw_hud_studio` encountered an error loading the Darktide Mod Framework.")

		new_mod("uw_hud_studio", {
			mod_script       = "uw_hud_studio/scripts/mods/uw_hud_studio/uw_hud_studio",
			mod_data         = "uw_hud_studio/scripts/mods/uw_hud_studio/uw_hud_studio_data",
			mod_localization = "uw_hud_studio/scripts/mods/uw_hud_studio/uw_hud_studio_localization",
		})
	end,
	packages = {},
}
