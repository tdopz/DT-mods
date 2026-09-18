local mod = get_mod("PinkEye")

return {
	name = "PinkEye",
	description = mod:localize("mod_description"),
	is_togglable = true, 
    options = {
    widgets = {
            {
                setting_id = "garden_settings",
                name = "test",
                type = "group",
                title = "garden_header",
                sub_widgets = {
                    {
                        setting_id = "outline_red",
                        type = "numeric",
                        default_value = 100,
                        range = {0, 100},
                        step_size_value = 1,
                        tooltip = "outline_red_tip"
                    },
                    {
                        setting_id = "outline_green",
                        type = "numeric",
                        default_value = 0,
                        range = {0, 100},
                        step_size_value = 1,
                        tooltip = "outline_green_tip"
                    },
                    {
                        setting_id = "outline_blue",
                        type = "numeric",
                        default_value = 100,
                        range = {0, 100},
                        step_size_value = 1,
                        tooltip = "outline_blue_tip"
                    },
                    {
                        setting_id = "outline_priority",
                        type = "numeric",
                        default_value = 5,
                        range = {1, 5},
                        step_size_value = 1,
                        tooltip = "outline_priority_tip"
                    },
                    {
                        setting_id = "color_presets",
                        type = "dropdown",
                        default_value = "custom",
                        options = {
                            { text = "custom", value = "custom"},
                            { text = "smart_tagged_enemy", value = "smart_tagged_enemy"},
                            { text = "smart_tagged_enemy_passive", value = "smart_tagged_enemy_passive"},
                            { text = "veteran_smart_tag", value = "veteran_smart_tag"},
                            { text = "adamant_smart_tag", value = "adamant_smart_tag"},
                            { text = "adamant_mark_target", value = "adamant_mark_target"},
                            { text = "hordes_tagged_remaining_target", value = "hordes_tagged_remaining_target"}
                        },
                        tooltip = "color_presets_tip"
                    },
                    -- {
                    --     setting_id = "scan_radius",
                    --     type = "numeric",
                    --     default_value = 25,
                    --     range = {0, 30},
                    --     step_size_value = 1,
                    --     tooltip = "scan_radius_tip"
                    -- }
                }    
            }
            -- {
            --     setting_id = "bstim_settings",
            --     name = "test",
            --     type = "group",
            --     title = "bstim_header",
            --     sub_widgets = {
            --         {
            --             setting_id = "outline_toggle_stim",
            --             type = "checkbox",
            --             default_value = true,
            --             tooltip = "outline_toggle_stim_tip"
            --         },
            --         {
            --             setting_id = "outline_red_stim",
            --             type = "numeric",
            --             default_value = 100,
            --             range = {0, 100},
            --             step_size_value = 1,
            --             tooltip = "outline_red_tip"
            --         },
            --         {
            --             setting_id = "outline_green_stim",
            --             type = "numeric",
            --             default_value = 0,
            --             range = {0, 100},
            --             step_size_value = 1,
            --             tooltip = "outline_green_tip"
            --         },
            --         {
            --             setting_id = "outline_blue_stim",
            --             type = "numeric",
            --             default_value = 100,
            --             range = {0, 100},
            --             step_size_value = 1,
            --             tooltip = "outline_blue_tip"
            --         },
            --         {
            --             setting_id = "outline_stim_priority",
            --             type = "numeric",
            --             default_value = 5,
            --             range = {1, 5},
            --             step_size_value = 1,
            --             tooltip = "outline_priority_tip"
            --         },
            --         {
            --             setting_id = "color_presets_stim",
            --             type = "dropdown",
            --             default_value = "custom",
            --             options = {
            --                 { text = "custom", value = "custom"},
            --                 { text = "smart_tagged_enemy", value = "smart_tagged_enemy"},
            --                 { text = "smart_tagged_enemy_passive", value = "smart_tagged_enemy_passive"},
            --                 { text = "veteran_smart_tag", value = "veteran_smart_tag"},
            --                 { text = "adamant_smart_tag", value = "adamant_smart_tag"},
            --                 { text = "adamant_mark_target", value = "adamant_mark_target"},
            --                 { text = "hordes_tagged_remaining_target", value = "hordes_tagged_remaining_target"}
            --             },
            --             tooltip = "color_presets_tip"
            --         },
            --     }
            -- }
        }
    }
}
