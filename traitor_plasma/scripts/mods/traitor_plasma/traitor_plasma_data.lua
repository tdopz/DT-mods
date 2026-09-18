local mod = get_mod("traitor_plasma")

return {
	name = mod:localize("mod_name"),
	description = mod:localize("mod_description"),
	is_togglable = true,
	options = {
		widgets = {
			{
				setting_id = "toggle_model_swap",
				type = "keybind",
				default_value = {},
				keybind_trigger = "pressed",
				keybind_type = "function_call",
				function_name = "toggle_model_swap",
				tooltip = "toggle_model_swap_description",
			},
			{
				setting_id = "muzzle_vfx_enabled",
				type = "checkbox",
				default_value = true,
				tooltip = "muzzle_vfx_enabled_description",
			},
			{
				setting_id = "explosion_vfx_enabled",
				type = "checkbox",
				default_value = true,
				tooltip = "explosion_vfx_enabled_description",
			},
			{
				setting_id = "beam_vfx_enabled",
				type = "checkbox",
				default_value = true,
				tooltip = "beam_vfx_enabled_description",
			},
			{
				setting_id = "beam_linger_vfx_enabled",
				type = "checkbox",
				default_value = true,
				tooltip = "beam_linger_vfx_enabled_description",
			},
			{
				setting_id = "linger_forward_offset",
				type = "numeric",
				default_value = 1.5,
				range = { -1, 5 },
				decimals_number = 1,
				step_size_value = 0.1,
				tooltip = "linger_forward_offset_description",
			},
			{
				setting_id = "coil_color_enabled",
				type = "checkbox",
				default_value = true,
				tooltip = "coil_color_enabled_description",
			},
			{
				setting_id = "coil_color_R",
				type = "numeric",
				default_value = 255,
				range = { 0, 255 },
				decimals_number = 0,
				tooltip = "coil_color_rgb_description",
			},
			{
				setting_id = "coil_color_G",
				type = "numeric",
				default_value = 35,
				range = { 0, 255 },
				decimals_number = 0,
				tooltip = "coil_color_rgb_description",
			},
			{
				setting_id = "coil_color_B",
				type = "numeric",
				default_value = 0,
				range = { 0, 255 },
				decimals_number = 0,
				tooltip = "coil_color_rgb_description",
			},
		},
	},
}
