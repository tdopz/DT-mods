local mod = get_mod("PinkEye")

local function get_color_widgets(group_id, default_color)
	local widgets = {
		{
			setting_id = group_id .. "_color_red",
			type = "numeric",
			default_value = default_color[1],
			range = {0, 100},
		},
		{
			setting_id = group_id .. "_color_green",
			type = "numeric",
			default_value = default_color[2],
			range = {0, 100},
		},
		{
			setting_id = group_id .. "_color_blue",
			type = "numeric",
			default_value = default_color[3],
			range = {0, 100},
		},
	}
	return widgets
end

local function add_setting(group, group_id, default_color, default_enabled, color_groups)
	if default_enabled == nil then
		default_enabled = true
	end

	local color_widgets = get_color_widgets(group_id, default_color)
	if color_groups then
		for _, v in ipairs(color_groups) do
			for _, w in ipairs(get_color_widgets(v[1], v[2])) do
				table.insert(color_widgets, w)
			end
		end
	end

	local sub_widgets_group = group.sub_widgets
	table.insert(sub_widgets_group, {
		setting_id = group_id .. "_outline_enabled",
		type = "checkbox",
		default_value = default_enabled,
		tooltip = group_id .. "_outline_enabled_tooltip",
		sub_widgets = color_widgets,
	})
end

local group_names = {
	"encroacing_garden_effects",
	"blue_stimm_effects",
}
local groups = {}
for _, name in ipairs(group_names) do
	groups[name] = {
		setting_id = name .. "_group",
		type = "group",
		sub_widgets = {},
	}
end
add_setting(groups.area_effects, "fire_barrel_explosion", {80, 20, 0, 100})

local haz_widgets = {}
for _, val in ipairs(group_names) do
	-- Make sure to insert from top to bottom as listed in group_names
	table.insert(haz_widgets, groups[val])
end


return {
	name = mod:localize("mod_name"),
	description = mod:localize("mod_description"),
	is_togglable = true,
	options = {
        {                
            setting_id = "scan_interval",
            type = "numeric",
            tooltip = "scan_tip",
            default_value = 100,
            range = {1, 1000},
            step_size_value = 1
        },    
            widgets = haz_widgets,
	}
}

-- return {
-- 	name = "PinkEye",
-- 	description = mod:localize("mod_description"),
-- 	is_togglable = true, 
--     options = {
--     widgets = {
--             {                
--                 setting_id = "scan_interval",
--                 type = "numeric",
--                 tooltip = "scan_tip",
--                 default_value = 100,
--                 range = {1, 1000},
--                 step_size_value = 1
--             },
--             {
--                 setting_id = "garden_settings",
--                 name = "test",
--                 type = "group",
--                 title = "garden_header",
--                 sub_widgets = {
--                     {
--                         setting_id = "outline_red",
--                         type = "numeric",
--                         default_value = 100,
--                         range = {0, 100},
--                         step_size_value = 1,
--                         tooltip = "outline_red_tip"
--                     },
--                     {
--                         setting_id = "outline_green",
--                         type = "numeric",
--                         default_value = 0,
--                         range = {0, 100},
--                         step_size_value = 1,
--                         tooltip = "outline_green_tip"
--                     },
--                     {
--                         setting_id = "outline_blue",
--                         type = "numeric",
--                         default_value = 100,
--                         range = {0, 100},
--                         step_size_value = 1,
--                         tooltip = "outline_blue_tip"
--                     },
--                     {
--                         setting_id = "outline_priority",
--                         type = "numeric",
--                         default_value = 5,
--                         range = {1, 5},
--                         step_size_value = 1,
--                         tooltip = "outline_priority_tip"
--                     },
--                     {
--                         setting_id = "color_presets",
--                         type = "dropdown",
--                         default_value = "custom",
--                         options = {
--                             { text = "custom", value = "custom"},
--                             { text = "smart_tagged_enemy", value = "smart_tagged_enemy"},
--                             { text = "smart_tagged_enemy_passive", value = "smart_tagged_enemy_passive"},
--                             { text = "veteran_smart_tag", value = "veteran_smart_tag"},
--                             { text = "adamant_smart_tag", value = "adamant_smart_tag"},
--                             { text = "adamant_mark_target", value = "adamant_mark_target"},
--                             { text = "hordes_tagged_remaining_target", value = "hordes_tagged_remaining_target"}
--                         },
--                         tooltip = "color_presets_tip"
--                     },
--                     -- {
--                     --     setting_id = "scan_radius",
--                     --     type = "numeric",
--                     --     default_value = 25,
--                     --     range = {0, 30},
--                     --     step_size_value = 1,
--                     --     tooltip = "scan_radius_tip"
--                     -- }
--                 }    
--             },
--             {
--                 setting_id = "bstim_settings",
--                 name = "test",
--                 type = "group",
--                 title = "bstim_header",
--                 sub_widgets = {
--                     {
--                         setting_id = "outline_toggle_stim",
--                         type = "checkbox",
--                         default_value = true,
--                         tooltip = "outline_toggle_stim_tip"
--                     },
--                     {
--                         setting_id = "outline_red_stim",
--                         type = "numeric",
--                         default_value = 100,
--                         range = {0, 100},
--                         step_size_value = 1,
--                         tooltip = "outline_red_tip"
--                     },
--                     {
--                         setting_id = "outline_green_stim",
--                         type = "numeric",
--                         default_value = 0,
--                         range = {0, 100},
--                         step_size_value = 1,
--                         tooltip = "outline_green_tip"
--                     },
--                     {
--                         setting_id = "outline_blue_stim",
--                         type = "numeric",
--                         default_value = 100,
--                         range = {0, 100},
--                         step_size_value = 1,
--                         tooltip = "outline_blue_tip"
--                     },
--                     {
--                         setting_id = "outline_stim_priority",
--                         type = "numeric",
--                         default_value = 5,
--                         range = {1, 5},
--                         step_size_value = 1,
--                         tooltip = "outline_priority_tip"
--                     },
--                     {
--                         setting_id = "color_presets_stim",
--                         type = "dropdown",
--                         default_value = "custom",
--                         options = {
--                             { text = "custom", value = "custom"},
--                             { text = "smart_tagged_enemy", value = "smart_tagged_enemy"},
--                             { text = "smart_tagged_enemy_passive", value = "smart_tagged_enemy_passive"},
--                             { text = "veteran_smart_tag", value = "veteran_smart_tag"},
--                             { text = "adamant_smart_tag", value = "adamant_smart_tag"},
--                             { text = "adamant_mark_target", value = "adamant_mark_target"},
--                             { text = "hordes_tagged_remaining_target", value = "hordes_tagged_remaining_target"}
--                         },
--                         tooltip = "color_presets_tip"
--                     },
--                 }
--             }
--         }
--     }
-- }
