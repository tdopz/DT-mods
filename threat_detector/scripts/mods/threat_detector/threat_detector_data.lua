local mod = get_mod("threat_detector")

return {
	name = "Threat Detector",
	description = mod:localize("mod_description"),
	is_togglable = true,
	options = {
		widgets = {
			{
				setting_id = "toggle_group",
				type = "group",
				tab = "Main",
				title = "toggle_group_title",
				sub_widgets = {
					{
						setting_id = "toggle_hounds",
						type = "checkbox",
						default_value = true,
					},
					{
						setting_id = "toggle_bomber",
						type = "checkbox",
						default_value = true,	
					},
					{
						setting_id = "toggle_netgunner",
						type = "checkbox",
						default_value = true,	
					},
					{
						setting_id = "toggle_mutant",
						type = "checkbox",
						default_value = true,	
					}
				}
			},
			-- {
			-- 	setting_id = "distance_or_foley",
			-- 	type = "checkbox",
			-- 	default_value = false,	
			-- },
			{
				setting_id = "color_group",
				type = "group",
				tab = "Main",
				sub_widgets = {
					{
						setting_id = "threat_r",
						title = "title_r",
						type = "numeric",
						default_value = 100,
						range = {0, 100},
						step_size_value = 1
					},
					{
						setting_id = "threat_g",
						title = "title_g",
						type = "numeric",
						default_value = 100,
						range = {0, 100},
						step_size_value = 1
					},
					{
						setting_id = "threat_b",
						title = "title_b",
						type = "numeric",
						default_value = 100,
						range = {0, 100},
						step_size_value = 1
					}
				}
			}	
		}
	}
}
