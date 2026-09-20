local mod = get_mod("GlowCooldown")

return {
    name = mod:localize("mod_name"),
    description = mod:localize("mod_description"),
    is_togglable = false,
    options = {
        widgets = {
            {
                setting_id = "global_options",                
                type = "group",
                tab = "Main",
                sub_widgets = {
                    {

                        setting_id = "show_ability_icon",
                        type = "checkbox",
                        default_value = true,
                        title = "show_icon",
                        tooltip = "show_icon_tooltip"
                    },
                    {
                        setting_id = "input_text_vis",
                        type = "checkbox",
                        default_value = false,
                        title = "input_title"
                    },
                    {
                        setting_id = "has_text_vis",
                        type = "checkbox",
                        default_value = false, 
                        title = "text_title"
                    },
                    {
                        setting_id = "x_pos",
                        type = "numeric",
                        default_value = 0,
                        range = {-1500, 100},
                        step_size_value = 1,
                        tooltip = "tooltip_x"
                    },
                    {
                        setting_id = "y_pos",
                        type = "numeric",
                        default_value = 0,
                        range = {-1500, 100},
                        step_size_value = 1,
                        tooltip = "tooltip_y"
                    }
                }
            },
            {
                setting_id = "active_header",
                type = "group",
                title = "active_header",
                tab = "Off Cooldown\n/Max charges",
                description = "Applies to all ablities - those with multiple charges and those with a single charge.",
                sub_widgets = {
                    {
                        setting_id = "active_a",
                        type = "numeric",
                        title = "label_alpha_glow",
                        default_value = 255,
                        range = {0, 255},
                        step_size_value = 1,
                        tooltip = "alpha_tooltip"
                    },
                    {
                        setting_id = "active_r",
                        type = "numeric",
                        title = "label_red_glow",
                        default_value = 0,
                        range = {0, 255},
                        step_size_value = 1
                    },
                    {
                        setting_id = "active_g",
                        type = "numeric",
                        title = "label_green_glow",
                        default_value = 255,
                        range = {0, 255},
                        step_size_value = 1
                    },
                    {
                        setting_id = "active_b",
                        type = "numeric",
                        title = "label_blue_glow",
                        default_value = 0,
                        range = {0, 255},
                        step_size_value = 1
                    },
                }
            },
            {
                setting_id = "active_frame",
                type = "group",
                tab = "Off Cooldown\n/Max charges",
                sub_widgets = {
                    {
                        setting_id = "active_frame_a",
                        type = "checkbox",
                        title = "label_frame",
                        default_value = true,
                        tooltip = "frame_tooltip"
                    },
                    {
                        setting_id = "active_frame_r",
                        type = "numeric",
                        title = "label_red_frame",
                        default_value = 128,
                        range = {0, 255},
                        step_size_value = 1
                    },
                    {
                        setting_id = "active_frame_g",
                        type = "numeric",
                        title = "label_green_frame",
                        default_value = 128,
                        range = {0, 255},
                        step_size_value = 1
                    },
                    {
                        setting_id = "active_frame_b",
                        type = "numeric",
                        title = "label_blue_frame",
                        default_value = 128,
                        range = {0, 255},
                        step_size_value = 1
                    }
                }
            },
            {
                setting_id = "cooldown",
                type = "group",
                tab = "On Cooldown",
                title = "cooldown_header",
                tooltip = "tooltip for cooldown.",
                sub_widgets = {
                    {
                        setting_id = "cooldown_a",
                        type = "numeric",
                        title = "label_alpha_glow",
                        default_value = 255,
                        range = {0, 255},
                        step_size_value = 1,
                        tooltip = "alpha_tooltip"
                    },
                    {
                        setting_id = "cooldown_r",
                        type = "numeric",
                        title = "label_red_glow",
                        default_value = 255,
                        range = {0, 255},
                        step_size_value = 1
                    },
                    {
                        setting_id = "cooldown_g",
                        type = "numeric",
                        title = "label_green_glow",
                        default_value = 0,
                        range = {0, 255},
                        step_size_value = 1
                    },
                    {
                        setting_id = "cooldown_b",
                        type = "numeric",
                        title = "label_blue_glow",
                        default_value = 0,
                        range = {0, 255},
                        step_size_value = 1
                    }
                }
            },
            {
                setting_id = "cooldown_frame",
                type = "group",
                tab = "On Cooldown",
                sub_widgets = {
                    {
                        setting_id = "cooldown_frame_a",
                        type = "checkbox",
                        title = "label_frame",
                        default_value = true,
                        tooltip = "frame_tooltip"
                    },
                    {
                        setting_id = "cooldown_frame_r",
                        type = "numeric",
                        title = "label_red_frame",
                        default_value = 128,
                        range = {0, 255},
                        step_size_value = 1
                    },
                    {
                        setting_id = "cooldown_frame_g",
                        type = "numeric",
                        title = "label_green_frame",
                        default_value = 128,
                        range = {0, 255},
                        step_size_value = 1
                    },
                    {
                        setting_id = "cooldown_frame_b",
                        type = "numeric",
                        title = "label_blue_frame",
                        default_value = 128,
                        range = {0, 255},
                        step_size_value = 1
                    }
                }
            },
            {
                setting_id = "has_charges",
                type = "group",
                title = "charges_header",
                tab = "1 Charge \nRemaining",
                -- description = "Multiple charge abilities - at least one charge has been used.",
                sub_widgets = {
                    {
                        setting_id = "has_charges_a",
                        type = "numeric",
                        title = "label_alpha_glow",
                        default_value = 255,
                        range = {0, 255},
                        step_size_value = 1,
                        tooltip = "alpha_tooltip"
                    },
                    {
                        setting_id = "has_charges_r",
                        type = "numeric",
                        title = "label_red_glow",
                        default_value = 255,
                        range = {0, 255},
                        step_size_value = 1
                    },
                    {
                        setting_id = "has_charges_g",
                        type = "numeric",
                        title = "label_green_glow",
                        default_value = 255,
                        range = {0, 255},
                        step_size_value = 1
                    },
                    {
                        setting_id = "has_charges_b",
                        type = "numeric",
                        title = "label_blue_glow",
                        default_value = 0,
                        range = {0, 255},
                        step_size_value = 1
                    },
                }
            },
            {
                setting_id = "has_charges_frame",
                type = "group",
                title = "charges_header_frame",
                tab = "1 Charge \nRemaining",
                -- description = "Multiple charge abilities - at least one charge has been used.",
                sub_widgets = {
                    {   setting_id = "has_charges_frame_a",
                        type = "checkbox",
                        title = "label_frame",
                        default_value = true,
                        tooltip = "frame_tooltip"
                    },
                    {
                        setting_id = "has_charges_frame_r",
                        type = "numeric",
                        title = "label_red_frame",
                        default_value = 128,
                        range = {0, 255},
                        step_size_value = 1
                    },
                    {
                        setting_id = "has_charges_frame_g",
                        type = "numeric",
                        title = "label_green_frame",
                        default_value = 128,
                        range = {0, 255},
                        step_size_value = 1
                    },
                    {
                        setting_id = "has_charges_frame_b",
                        type = "numeric",
                        title = "label_blue_frame",
                        default_value = 128,
                        range = {0, 255},
                        step_size_value = 1
                    }
                }
            },
            {
                setting_id = "has_charges_2",
                type = "group",
                title = "has_charges_2",
                tab = "2 Charges \nRemaining",
                sub_widgets = {
                    {
                        setting_id = "has_charges_2_a",
                        type = "numeric",
                        title = "label_alpha_glow",
                        default_value = 255,
                        range = {0, 255},
                        step_size_value = 1,
                        tooltip = "alpha_tooltip"
                    },
                    {
                        setting_id = "has_charges_2_r",
                        type = "numeric",
                        title = "label_red_glow",
                        default_value = 255,
                        range = {0, 255},
                        step_size_value = 1
                    },
                    {
                        setting_id = "has_charges_2_g",
                        type = "numeric",
                        title = "label_green_glow",
                        default_value = 255,
                        range = {0, 255},
                        step_size_value = 1
                    },
                    {
                        setting_id = "has_charges_2_b",
                        type = "numeric",
                        title = "label_blue_glow",
                        default_value = 0,
                        range = {0, 255},
                        step_size_value = 1
                    },
                },
            },
            {
                setting_id = "has_charges_2_frame",
                type = "group",
                title = "has_charges_2_frame",
                tab = "2 Charges \nRemaining",
                    sub_widgets = {
                    {
                        setting_id = "has_charges_2_frame_a",
                        type = "checkbox",
                        title = "label_frame",
                        default_value = true,
                        tooltip = "frame_tooltip"
                    },
                    {
                        setting_id = "has_charges_2_frame_r",
                        type = "numeric",
                        title = "label_red_frame",
                        default_value = 128,
                        range = {0, 255},
                        step_size_value = 1
                    },
                    {
                        setting_id = "has_charges_2_frame_g",
                        type = "numeric",
                        title = "label_green_frame",
                        default_value = 128,
                        range = {0, 255},
                        step_size_value = 1
                    },
                    {
                        setting_id = "has_charges_2_frame_b",
                        type = "numeric",
                        title = "label_blue_frame",
                        default_value = 128,
                        range = {0, 255},
                        step_size_value = 1
                    }
                }
            },
            {
                setting_id = "has_charges_3",
                type = "group",
                title = "has_charges_3",
                tab = "3 Charges \nRemaining",
                sub_widgets = {
                    {
                        setting_id = "has_charges_3_a",
                        type = "numeric",
                        title = "label_alpha_glow",
                        default_value = 255,
                        range = {0, 255},
                        step_size_value = 1,
                        tooltip = "alpha_tooltip"
                    },
                    {
                        setting_id = "has_charges_3_r",
                        type = "numeric",
                        title = "label_red_glow",
                        default_value = 255,
                        range = {0, 255},
                        step_size_value = 1
                    },
                    {
                        setting_id = "has_charges_3_g",
                        type = "numeric",
                        title = "label_green_glow",
                        default_value = 255,
                        range = {0, 255},
                        step_size_value = 1
                    },
                    {
                        setting_id = "has_charges_3_b",
                        type = "numeric",
                        title = "label_blue_glow",
                        default_value = 0,
                        range = {0, 255},
                        step_size_value = 1
                    },
                },
            },
            {
                setting_id = "has_charges_3_frame",
                type = "group",
                title = "has_charges_3_frame",
                tab = "3 Charges \nRemaining",
                sub_widgets = {
                    {
                        setting_id = "has_charges_3_frame_a",
                        type = "checkbox",
                        title = "label_frame",
                        default_value = true,
                        tooltip = "frame_tooltip"
                    },
                    {
                        setting_id = "has_charges_3_frame_r",
                        type = "numeric",
                        title = "label_red_frame",
                        default_value = 128,
                        range = {0, 255},
                        step_size_value = 1
                    },
                    {
                        setting_id = "has_charges_3_frame_g",
                        type = "numeric",
                        title = "label_green_frame",
                        default_value = 128,
                        range = {0, 255},
                        step_size_value = 1
                    },
                    {
                        setting_id = "has_charges_3_frame_b",
                        type = "numeric",
                        title = "label_blue_frame",
                        default_value = 128,
                        range = {0, 255},
                        step_size_value = 1
                    }
                }
            },
            {
                setting_id = "has_charges_4",
                type = "group",
                title = "has_charges_4",
                tab = "4 Charges \nRemaining",
                sub_widgets = {
                    {
                        setting_id = "has_charges_4_a",
                        type = "numeric",
                        title = "label_alpha_glow",
                        default_value = 255,
                        range = {0, 255},
                        step_size_value = 1,
                        tooltip = "alpha_tooltip"
                    },
                    {
                        setting_id = "has_charges_4_r",
                        type = "numeric",
                        title = "label_red_glow",
                        default_value = 255,
                        range = {0, 255},
                        step_size_value = 1
                    },
                    {
                        setting_id = "has_charges_4_g",
                        type = "numeric",
                        title = "label_green_glow",
                        default_value = 255,
                        range = {0, 255},
                        step_size_value = 1
                    },
                    {
                        setting_id = "has_charges_4_b",
                        type = "numeric",
                        title = "label_blue_glow",
                        default_value = 0,
                        range = {0, 255},
                        step_size_value = 1
                    },
                },
            },
            {
                setting_id = "has_charges_4_frame",
                type = "group",
                title = "has_charges_4_frame",
                tab = "4 Charges \nRemaining",
                sub_widgets = {
                    {
                        setting_id = "has_charges_4_frame_a",
                        type = "checkbox",
                        title = "label_frame",
                        default_value = true,
                        tooltip = "frame_tooltip"
                    },
                    {
                        setting_id = "has_charges_4_frame_r",
                        type = "numeric",
                        title = "label_red_frame",
                        default_value = 128,
                        range = {0, 255},
                        step_size_value = 1
                    },
                    {
                        setting_id = "has_charges_4_frame_g",
                        type = "numeric",
                        title = "label_green_frame",
                        default_value = 128,
                        range = {0, 255},
                        step_size_value = 1
                    },
                    {
                        setting_id = "has_charges_4_frame_b",
                        type = "numeric",
                        title = "label_blue_frame",
                        default_value = 128,
                        range = {0, 255},
                        step_size_value = 1
                    }
                }
            },
            {
                setting_id = "out_of_charges",
                type = "group",
                title = "no_charges_header",
                tab = "No Charges \nRemaining",
                sub_widgets = {
                    {
                        setting_id = "out_of_charges_a",
                        type = "numeric",
                        title = "label_alpha_glow",
                        default_value = 255,
                        range = {0, 255},
                        step_size_value = 1,
                        tooltip = "alpha_tooltip"
                    },
                    {
                        setting_id = "out_of_charges_r",
                        type = "numeric",
                        title = "label_red_glow",
                        default_value = 255,
                        range = {0, 255},
                        step_size_value = 1
                    },
                    {
                        setting_id = "out_of_charges_g",
                        type = "numeric",
                        title = "label_green_glow",
                        default_value = 0,
                        range = {0, 255},
                        step_size_value = 1
                    },
                    {
                        setting_id = "out_of_charges_b",
                        type = "numeric",
                        title = "label_blue_glow",
                        default_value = 0,
                        range = {0, 255},
                        step_size_value = 1
                    }
                }
            },
            {
                setting_id = "out_of_charges_frame",
                type = "group",
                title = "out_of_charges_frame",
                tab = "No Charges \nRemaining",
                sub_widgets = {
                    {
                        setting_id = "out_of_frame_a",
                        type = "checkbox",
                        title = "label_frame",
                        default_value = true,
                        tooltip = "frame_tooltip"
                    },
                    {
                        setting_id = "out_of_frame_r",
                        type = "numeric",
                        title = "label_red_frame",
                        default_value = 128,
                        range = {0, 255},
                        step_size_value = 1
                    },
                    {
                        setting_id = "out_of_frame_g",
                        type = "numeric",
                        title = "label_green_frame",
                        default_value = 128,
                        range = {0, 255},
                        step_size_value = 1
                    },
                    {
                        setting_id = "out_of_frame_b",
                        type = "numeric",
                        title = "label_blue_frame",
                        default_value = 128,
                        range = {0, 255},
                        step_size_value = 1
                    }
                }
            },
            {
                setting_id = "cooldown_paused",
                type = "group",
                title = "cooldown_paused_header",
                tab = "Ability Paused",
                sub_widgets = {
                    {
                        setting_id = "cooldown_paused_a",
                        type = "numeric",
                        title = "label_alpha_glow",
                        default_value = 200,
                        range = {0, 255},
                        step_size_value = 1,
                        tooltip = "alpha_tooltip"
                    },
                    {
                        setting_id = "cooldown_paused_r",
                        type = "numeric",
                        title = "label_red_glow",
                        default_value = 128,
                        range = {0, 255},
                        step_size_value = 1
                    },
                    {
                        setting_id = "cooldown_paused_g",
                        type = "numeric",
                        title = "label_green_glow",
                        default_value = 128,
                        range = {0, 255},
                        step_size_value = 1
                    },
                    {
                        setting_id = "cooldown_paused_b",
                        type = "numeric",
                        title = "label_blue_glow",
                        default_value = 0,
                        range = {0, 255},
                        step_size_value = 1
                    },
                }
            },
            {
                setting_id = "cooldown_paused_frame",
                type = "group",
                title = "cooldown_paused_frame",
                tab = "Ability Paused",
                sub_widgets = {
                    {
                        setting_id = "cooldown_paused_frame_a",
                        type = "checkbox",
                        title = "label_frame",
                        default_value = true,
                        tooltip = "frame_tooltip"
                    },
                    {
                        setting_id = "cooldown_paused_frame_r",
                        type = "numeric",
                        title = "label_red_frame",
                        default_value = 200,
                        range = {0, 255},
                        step_size_value = 1
                    },
                    {
                        setting_id = "cooldown_paused_frame_g",
                        type = "numeric",
                        title = "label_green_frame",
                        default_value = 0,
                        range = {0, 255},
                        step_size_value = 1
                    },
                    {
                        setting_id = "cooldown_paused_frame_b",
                        type = "numeric",
                        title = "label_blue_frame",
                        default_value = 200,
                        range = {0, 255},
                        step_size_value = 1
                    }
                }
            }    
        }
    }
}