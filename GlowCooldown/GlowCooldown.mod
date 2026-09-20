return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`GlowCooldown` encountered an error loading the Darktide Mod Framework.")

		new_mod("GlowCooldown", {
			mod_script       = "GlowCooldown/scripts/mods/GlowCooldown/GlowCooldown",
			mod_data         = "GlowCooldown/scripts/mods/GlowCooldown/GlowCooldown_data",
			mod_localization = "GlowCooldown/scripts/mods/GlowCooldown/GlowCooldown_localization",
		})
	end,
	packages = {},
	version = "2.0",
}
