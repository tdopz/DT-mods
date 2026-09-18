return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`threat_detector` encountered an error loading the Darktide Mod Framework.")

		new_mod("threat_detector", {
			mod_script       = "threat_detector/scripts/mods/threat_detector/threat_detector",
			mod_data         = "threat_detector/scripts/mods/threat_detector/threat_detector_data",
			mod_localization = "threat_detector/scripts/mods/threat_detector/threat_detector_localization",
		})
	end,
	packages = {},
	version = "1.0",
}
