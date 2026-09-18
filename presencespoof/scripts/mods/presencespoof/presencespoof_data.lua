local mod = get_mod("presencespoof")

return {
	name = "Presence Spoof",
	description = mod:localize("mod_description"),
	is_togglable = true,
	options = {
		widgets = {
			{
				setting_id = "presence_choice",
				type = "dropdown",
				default_value = "disabled",
				tooltip = "choice_tt",
				options = {
					{ text = "disabled", value = "disabled" },
					{ text = "splash_screen", value = "splash_screen" },
					{ text = "title_screen", value = "title_screen" },
					{ text = "main_menu", value = "main_menu" },
					{ text = "loading", value = "loading" },
					{ text = "onboarding", value = "onboarding" },
					{ text = "hub", value = "hub" },
					{ text = "cinematic", value = "cinematic" },
					{ text = "matchmaking", value = "matchmaking" },
					{ text = "mission", value = "mission" },
					{ text = "training_grounds", value = "training_grounds" },
					{ text = "end_of_round", value = "end_of_round" },
				},
			},
		},
	},
}
