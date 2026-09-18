local mod = get_mod("weapon_swapper")

return {
	name = "weapon_swapper",
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
			-- {
			-- 	setting_id = "ranged_or_melee",
			-- 	type = "checkbox",
			-- 	default_value = false,
			-- },
			{
				setting_id = "use_crusher",
				type = "checkbox",
				default_value = false,
			},
			{
				setting_id = "use_bullmaul",
				type = "checkbox",
				default_value = false,
			},
			{
				setting_id = "use_psword",
				type = "checkbox",
				default_value = true,
			},
			{
				setting_id = "swap_falchion",
				type = "dropdown",
				default_value = "content/items/weapons/minions/melee/chaos_traitor_guard_berzerker_mainhand_weapon_01",
				options = {
						{text = "rager_01", value = "content/items/weapons/minions/melee/chaos_traitor_guard_berzerker_mainhand_weapon_01"},
						{text = "rager_02", value = "content/items/weapons/minions/melee/chaos_traitor_guard_berzerker_mainhand_weapon_02"},
						{text = "rager_03", value = "content/items/weapons/minions/melee/chaos_traitor_guard_berzerker_mainhand_weapon_03"},
						{text = "rager_04", value = "content/items/weapons/minions/melee/chaos_traitor_guard_berzerker_mainhand_weapon_04"},
						{text = "cultist_rager_01", value = "content/items/weapons/minions/melee/cultist_berzerker_mainhand_weapon_01"},
						{text = "cultist_rager_02", value = "content/items/weapons/minions/melee/cultist_berzerker_mainhand_weapon_02"},
						{text = "cultist_rager_03", value = "content/items/weapons/minions/melee/cultist_berzerker_mainhand_weapon_03"},
						{text = "packmaster", value = "content/items/weapons/minions/melee/ogryn_houndmaster_melee_weapon_01"},
				}
			},
			{
				setting_id = "swap_psword",
				type = "dropdown",
				default_value = "content/items/weapons/minions/melee/chaos_traitor_guard_2h_power_sword",
				options = {
						{text = "captain_psword", value = "content/items/weapons/minions/melee/chaos_traitor_guard_2h_power_sword"},
						{text = "captain_paul", value = "content/items/weapons/minions/melee/chaos_traitor_guard_2h_power_maul"},
				}
			}
				-- {
			-- 	setting_id = "weapon_toggle_group",
			-- 	type = "group",
			-- 	sub_widgets = {
			-- 		{
			-- 			setting_id = "bully_club_toggle",
			-- 			type = "checkbox",
			-- 			default_value = false,
			-- 		},
			-- 		{
			-- 			setting_id = "pmaul_toggle",
			-- 			type = "checkbox",
			-- 			default_value = false,
			-- 		},
			-- 	},
			-- },
			-- {
			-- 	setting_id = "club_swap",
			-- 	type = "dropdown",
			-- 	default_value = "content/items/weapons/minions/melee/chaos_ogryn_offhand_melee_weapon",
			-- 	options = {
			-- 			{ text = "bulwark_maul", value = "content/items/weapons/minions/melee/chaos_ogryn_offhand_melee_weapon" },
			-- 			{ text = "captain_maul", value = "content/items/weapons/minions/melee/renegade_captain_powermaul_01" },--"content/items/weapons/minions/melee/chaos_traitor_guard_2h_power_maul" },
			-- 	},
			-- },
			-- {
            --     setting_id = "ranged_swap",
            --     type = "dropdown",
            --     default_value = "content/items/weapons/minions/ranged/cultist_flamer",
            --     options = {
            --             { text = "minion_flamer", value = "content/items/weapons/minions/ranged/cultist_flamer" },
            --             { text = "ogryn_flamer", value = "content/items/weapons/minions/ranged/chaos_traitor_guard_flamer_01" },
			-- 			{ text = "netter", value = "content/items/weapons/minions/ranged/renegade_netgun" },
			-- 			{ text = "shotgun", value = "content/environment/artsets/imperial/global/props/cinematic/rannick_stubgun/rannick_stubgun" },
			-- 			{ text = "chaos_h_stubber", value = "content/items/weapons/minions/ranged/chaos_ogryn_heavy_stubber" },
            --     },
            -- },
		},
	},
}
