local mod = get_mod("GlowCooldown")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local get_hud_color = UIHudSettings.get_hud_color
local ColorUtilities = require("scripts/utilities/ui/colors")
local AbilitySettings = require("scripts/ui/hud/elements/player_ability/hud_element_player_ability_settings")
local offset_x = mod:get("x_pos") or 0
local offset_y = mod:get("y_pos") or 0

local ability_hud_instances = {}

local function apply_widget_offset(self)
    local widget = self._widgets_by_name and self._widgets_by_name.ability
    local base = self._gc_base_offset
    if not widget or not base then return end
    widget.offset[1] = base[1] + offset_x
    widget.offset[2] = base[2] + offset_y
end

local function init_offset(self)
    local widget = self._widgets_by_name and self._widgets_by_name.ability
    if widget and widget.offset then
        self._gc_base_offset = { widget.offset[1], widget.offset[2] }
        ability_hud_instances[self] = self
        apply_widget_offset(self)
    end
end

mod:hook_safe("HudElementPlayerAbility", "init", init_offset)
mod:hook_safe("HudElementPlayerAbility", "destroy", function(self)
    ability_hud_instances[self] = nil
end)

mod:hook_safe("HudElementPlayerSlotItemAbility", "init", init_offset)
mod:hook_safe("HudElementPlayerSlotItemAbility", "destroy", function(self)
    ability_hud_instances[self] = nil
end)


mod:hook("PlayerUnitAbilityExtension", "stop_action", function(func, self, reason, data, t)
	local ability_type = "combat_ability"
	local components = self._ability_components
	local component = components and components[ability_type]
	local was_paused = component and component.cooldown_paused
	func(self, reason, data, t)
	if was_paused and component.cooldown_paused then
		component.cooldown_paused = false
	end
end)

mod:hook("ActionAbilityBase", "finish", function(func, self, reason, data, t, time_in_action)
	local action_settings = self._action_settings

	if action_settings then
		local use_ability_charge = self._ability_template_tweak_data.use_ability_charge == nil and action_settings.use_ability_charge or self._ability_template_tweak_data.use_ability_charge

		if use_ability_charge then
			local ability_interrupted_reasons = action_settings.ability_interrupted_reasons
			local was_interrupted = ability_interrupted_reasons and ability_interrupted_reasons[reason]

			if action_settings.use_charge_at_start then
				if was_interrupted then
					local action_type = action_settings.ability_type
					self._ability_extension:restore_ability_charge(action_type, 1)
				end
				func(self, reason, data, t, time_in_action)
			else
				if not was_interrupted then
					self:_use_ability_charge()
				end
			end
		else
			func(self, reason, data, t, time_in_action)
		end
	else
		func(self, reason, data, t, time_in_action)
	end

	if reason ~= "action_complete" then
		local ability_component = self._ability_component
		if ability_component and ability_component.cooldown_paused then
			ability_component.cooldown_paused = false
		end
	end
end)

mod.register_colors = function(self)
    AbilitySettings.cooldown_paused_colors = {
		icon = mod:get("show_ability_icon") and get_hud_color("color_tint_main_3", 200) or {0, 0, 0, 0},
		frame = {
            mod:get("cooldown_paused_frame_a") and 255 or 0,
            mod:get("cooldown_paused_frame_r") or 0,
            mod:get("cooldown_paused_frame_g") or 0,
            mod:get("cooldown_paused_frame_b") or 0
        },
		right_edge = get_hud_color("color_tint_11", 200),
		left_edge = get_hud_color("color_tint_11", 200),
		frame_glow = {
            mod:get("cooldown_paused_a") or 0,
            mod:get("cooldown_paused_r") or 0,
            mod:get("cooldown_paused_g") or 0,
            mod:get("cooldown_paused_b") or 0
        },
		text = mod:get("has_text_vis") and get_hud_color("color_tint_11", 200) or {0, 0, 0, 0},
		input_text = mod:get("input_text_vis") and get_hud_color("color_tint_11", 200) or {0, 0, 0, 0}
	}
    AbilitySettings.active_colors = {
        icon = mod:get("show_ability_icon") and get_hud_color("color_tint_main_2", 200) or {0, 0, 0, 0},
        frame = {
            mod:get("active_frame_a") and 255 or 0,
            mod:get("active_frame_r") or 0,
            mod:get("active_frame_g") or 0,
            mod:get("active_frame_b") or 0
        },
        frame_glow = {
            mod:get("active_a") or 0,
            mod:get("active_r") or 0,
            mod:get("active_g") or 0,
            mod:get("active_b") or 0
        },
        text = mod:get("has_text_vis") and get_hud_color("color_tint_main_1", 255) or {0, 0, 0, 0},
        input_text = mod:get("input_text_vis") and get_hud_color("color_tint_main_1", 255) or {0, 0, 0, 0}
    }
    AbilitySettings.cooldown_colors = {
        icon = mod:get("show_ability_icon") and get_hud_color("color_tint_main_3", 200) or {0, 0, 0, 0},
        frame = {
            mod:get("cooldown_frame_a") and 255 or 0,
            mod:get("cooldown_frame_r") or 0,
            mod:get("cooldown_frame_g") or 0,
            mod:get("cooldown_frame_b") or 0
        },
        frame_glow = {
            mod:get("cooldown_a") or 0,
            mod:get("cooldown_r") or 0,
            mod:get("cooldown_g") or 0,
            mod:get("cooldown_b") or 0
        },
        text = mod:get("has_text_vis") and get_hud_color("color_tint_main_3", 255) or {0, 0, 0, 0},
        input_text = mod:get("input_text_vis") and get_hud_color("color_tint_main_3", 255) or {0, 0, 0, 0}
    }
    AbilitySettings.out_of_charges_cooldown_colors = {
        icon = mod:get("show_ability_icon") and get_hud_color("color_tint_main_3", 200) or {0, 0, 0, 0},
        frame = {
            mod:get("out_of_frame_a") and 255 or 0,
            mod:get("out_of_frame_r") or 0,
            mod:get("out_of_frame_g") or 0,
            mod:get("out_of_frame_b") or 0
        },
        frame_glow = {
            mod:get("out_of_charges_a") or 0,
            mod:get("out_of_charges_r") or 0,
            mod:get("out_of_charges_g") or 0,
            mod:get("out_of_charges_b") or 0
        },
        text = mod:get("has_text_vis") and Color.red(255, true) or {0, 0, 0, 0},
        input_text = mod:get("input_text_vis") and get_hud_color("color_tint_main_3", 255) or {0, 0, 0, 0}
    }
    AbilitySettings.has_charges_5 = {
        icon = mod:get("show_ability_icon") and get_hud_color("color_tint_main_3", 200) or {0, 0, 0, 0},
        frame = {
            mod:get("has_charges_5_frame_a") and 255 or 0,
            mod:get("has_charges_5_frame_r") or 0,
            mod:get("has_charges_5_frame_g") or 0,
            mod:get("has_charges_5_frame_b") or 0
        },
        frame_glow = {
            mod:get("has_charges_5_a") or 0,
            mod:get("has_charges_5_r") or 0,
            mod:get("has_charges_5_g") or 0,
            mod:get("has_charges_5_b") or 0
        },
        text = mod:get("has_text_vis") and get_hud_color("color_tint_main_2", 255) or {0, 0, 0, 0},
        input_text = mod:get("input_text_vis") and get_hud_color("color_tint_main_1", 255) or {0, 0, 0, 0}
    }
    AbilitySettings.has_charges_4 = {
        icon = mod:get("show_ability_icon") and get_hud_color("color_tint_main_3", 200) or {0, 0, 0, 0},
        frame = {
            mod:get("has_charges_4_frame_a") and 255 or 0,
            mod:get("has_charges_4_frame_r") or 0,
            mod:get("has_charges_4_frame_g") or 0,
            mod:get("has_charges_4_frame_b") or 0
        },
        frame_glow = {
            mod:get("has_charges_4_a") or 0,
            mod:get("has_charges_4_r") or 0,
            mod:get("has_charges_4_g") or 0,
            mod:get("has_charges_4_b") or 0
        },
        text = mod:get("has_text_vis") and get_hud_color("color_tint_main_2", 255) or {0, 0, 0, 0},
        input_text = mod:get("input_text_vis") and get_hud_color("color_tint_main_1", 255) or {0, 0, 0, 0}
    }
    AbilitySettings.has_charges_3 = {
        icon = mod:get("show_ability_icon") and get_hud_color("color_tint_main_3", 200) or {0, 0, 0, 0},
        frame = {
            mod:get("has_charges_3_frame_a") and 255 or 0,
            mod:get("has_charges_3_frame_r") or 0,
            mod:get("has_charges_3_frame_g") or 0,
            mod:get("has_charges_3_frame_b") or 0
        },
        frame_glow = {
            mod:get("has_charges_3_a") or 0,
            mod:get("has_charges_3_r") or 0,
            mod:get("has_charges_3_g") or 0,
            mod:get("has_charges_3_b") or 0
        },
        text = mod:get("has_text_vis") and get_hud_color("color_tint_main_2", 255) or {0, 0, 0, 0},
        input_text = mod:get("input_text_vis") and get_hud_color("color_tint_main_1", 255) or {0, 0, 0, 0}
    }
    AbilitySettings.has_charges_2 = {
        icon = mod:get("show_ability_icon") and get_hud_color("color_tint_main_3", 200) or {0, 0, 0, 0},
        frame = {
            mod:get("has_charges_2_frame_a") and 255 or 0,
            mod:get("has_charges_2_frame_r") or 0,
            mod:get("has_charges_2_frame_g") or 0,
            mod:get("has_charges_2_frame_b") or 0
        },
        frame_glow = {
            mod:get("has_charges_2_a") or 0,
            mod:get("has_charges_2_r") or 0,
            mod:get("has_charges_2_g") or 0,
            mod:get("has_charges_2_b") or 0
        },
        text = mod:get("has_text_vis") and get_hud_color("color_tint_main_2", 255) or {0, 0, 0, 0},
        input_text = mod:get("input_text_vis") and get_hud_color("color_tint_main_1", 255) or {0, 0, 0, 0}
    }
    AbilitySettings.has_charges_cooldown_colors = {
        icon = mod:get("show_ability_icon") and get_hud_color("color_tint_main_3", 200) or {0, 0, 0, 0},
        frame = {
            mod:get("has_charges_frame_a") and 255 or 0,
            mod:get("has_charges_frame_r") or 0,
            mod:get("has_charges_frame_g") or 0,
            mod:get("has_charges_frame_b") or 0
        },
        frame_glow = {
            mod:get("has_charges_a") or 0,
            mod:get("has_charges_r") or 0,
            mod:get("has_charges_g") or 0,
            mod:get("has_charges_b") or 0
        },
        text = mod:get("has_text_vis") and get_hud_color("color_tint_main_2", 255) or {0, 0, 0, 0},
        input_text = mod:get("input_text_vis") and get_hud_color("color_tint_main_1", 255) or {0, 0, 0, 0}
    }
    AbilitySettings.inactive = {
        text = mod:get("has_text_vis") and get_hud_color("color_tint_main_2", 255) or {0, 0, 0, 0},
        input_text = mod:get("input_text_vis") and get_hud_color("color_tint_main_1", 255) or {0, 0, 0, 0}
    }
end

local function _get_player_unit()
    local plyr = Managers.player and Managers.player:local_player_safe(1)
    return plyr and plyr.player_unit
end

local function _get_ability_extension()
    local player_unit = _get_player_unit()
    if not player_unit then
        return
    end
    
    local ability_extension = ScriptUnit.extension(player_unit, "ability_system")
    if not ability_extension then
        return
    end
    
    return ability_extension
end

local function _is_cooldown_paused()
    local ability_extension = _get_ability_extension()
    if not ability_extension then
        return
    end
    
    if not ability_extension:is_cooldown_paused("combat_ability") then
        return nil
    end

    return ability_extension:is_cooldown_paused("combat_ability")
end

local function extra_charges(ability_id)
    local ability_extension = _get_ability_extension()
    if not ability_extension then return false, 0, 0 end

    local remaining = ability_extension:remaining_ability_charges(ability_id)
    local max_charges = ability_extension:max_ability_charges(ability_id)
    local is_intermediate = max_charges ~= nil and max_charges > 2
                            and remaining ~= nil
                            and remaining > 0
                            and remaining < max_charges
    return is_intermediate, remaining, max_charges
end

local function get_charge_count(ability_id)
    local ability_extension = _get_ability_extension()
    if not ability_extension then return 0 end
    return ability_extension:remaining_ability_charges(ability_id)
end

local charge_colors = {
    [1] = "has_charges_cooldown_colors",
    [2] = "has_charges_2",
    [3] = "has_charges_3",
    [4] = "has_charges_4",
    [5] = "has_charges_5",
    [6] = "active_colors",
}

local function apply_custom_colors(self, on_cooldown, uses_charges, has_charges_left)
    local ability_extension = _get_ability_extension()
    if not ability_extension then return end
    local ability_id = self._ability_id
    local is_paused = _is_cooldown_paused()
    local is_intermediate, remaining_charges = extra_charges(ability_id or "combat_ability")
    local source_colors = nil

    if is_paused then
        source_colors = AbilitySettings.cooldown_paused_colors
    elseif is_intermediate then
        local key = charge_colors[remaining_charges]
        source_colors = key and AbilitySettings[key] or nil
    end

    if not source_colors then return end

    local widgets_by_name = self._widgets_by_name
    local widget = widgets_by_name and widgets_by_name.ability
    if not widget then return end
    local style = widget.style

    for pass_id, pass_style in pairs(style) do
        local source_color = source_colors[pass_id]
        if source_color then
            ColorUtilities.color_copy(source_color, pass_style.color or pass_style.text_color)
        end
    end
end

local function retrigger_colors(self)
    self:_set_widget_state_colors(self._on_cooldown, self._uses_charges, self._has_charges_left)
end

-- HudElementPlayerAbility hooks
mod:hook_safe("HudElementPlayerAbility", "set_charges_amount", retrigger_colors)
mod:hook_safe("HudElementPlayerAbility", "_set_progress", retrigger_colors)
mod:hook_safe("HudElementPlayerAbility", "_set_widget_state_colors", apply_custom_colors)
mod:hook_safe("HudElementPlayerSlotItemAbility", "set_charges_amount", retrigger_colors)
mod:hook_safe("HudElementPlayerSlotItemAbility", "_set_progress", retrigger_colors)
mod:hook_safe("HudElementPlayerSlotItemAbility", "_set_widget_state_colors", apply_custom_colors)

mod.on_all_mods_loaded = function()
    mod.register_colors()
end

mod.on_enabled = function()
    mod.register_colors()
end

mod.on_setting_changed = function(setting_id)
    mod.register_colors()
    offset_x = mod:get("x_pos") or 0
    offset_y = mod:get("y_pos") or 0
    -- Re-apply position to all live instances.
    for _, instance in pairs(ability_hud_instances) do
        apply_widget_offset(instance)
    end
end