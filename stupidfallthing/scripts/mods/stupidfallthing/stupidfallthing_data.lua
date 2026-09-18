local mod = get_mod("stupidfallthing")

return {
	name = "stupidfallthing",
	description = mod:localize("mod_description"),
	is_togglable = true,
	
	options = {
		widgets = {
			{
				setting_id = "audio_group",
				type = "group",
				sub_widgets = {
					{
						setting_id = "audio_choice",
						type = "dropdown",
						default_value = "ds3.opus",
						options = {
							{ text = "DS3", value = "ds3.opus" },
							{ text = "Wilhelm Scream", value = "wilhelmscream.opus" },
						}
					},
				},
			},
			{
				setting_id = "volume_group",
				type = "group",
				sub_widgets = {
					{
						setting_id = "volume",
						type = "numeric",
                        default_value = 35,
                        range = {0, 100},
                        step_size_value = 1,
					},
				},
			},
		},
	},
}
