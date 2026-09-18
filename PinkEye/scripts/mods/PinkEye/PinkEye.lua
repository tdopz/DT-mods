local mod = get_mod("PinkEye")
mod:io_dofile("PinkEye/scripts/mods/PinkEye/utils")
local OutlineSettings = require("scripts/settings/outline/outline_settings")
local reported_units = {}

local function get_material_layers()
    return {
    "minion_outline_combat_ability"
    }
end

local function get_priority()
    return mod:get("outline_priority")
end

local function get_stim_priority()
    return mod:get("outline_stim_priority")
end

local function get_color()
    local preset = mod:get("color_presets")
    if preset == "smart_tagged_enemy" then
        return {1 * 0.6, 0.005, 0}
    elseif preset == "smart_tagged_enemy_passive" then
        return {0.8 * 0.6, 0.75 * 0.6, 0} 
    elseif preset == "veteran_smart_tag" then
        return {1 * 0.6, 0.8 * 0.6, 0.4 * 0.6} 
    elseif preset == "adamant_smart_tag" then
        return {1 * 0.6, 0.25 * 0.6, 0.25 * 0.6}
    elseif preset == "adamant_mark_target" then
        return {0.5 * 0.6, 0.4 * 0.6, 1 * 0.6}
    elseif preset == "hordes_tagged_remaining_target" then
        return {0, 0.73 * 0.6, 1 * 0.6}
    else
        local r = mod:get("outline_red") / 250.0   
        local g = mod:get("outline_green") / 250.0
        local b = mod:get("outline_blue") / 250.0
        return {r, g, b}
    end
end

-- local function get_stim_color()
--     local preset = mod:get("color_presets_stim")
--     if preset == "smart_tagged_enemy" then
--         return {1 * 0.6, 0.005, 0}
--     elseif preset == "smart_tagged_enemy_passive" then
--         return {0.8 * 0.6, 0.75 * 0.6, 0}
--     elseif preset == "veteran_smart_tag" then
--         return {1 * 0.6, 0.8 * 0.6, 0.4 * 0.6}
--     elseif preset == "adamant_smart_tag" then
--         return {1 * 0.6, 0.25 * 0.6, 0.25 * 0.6}
--     elseif preset == "adamant_mark_target" then
--         return {0.5 * 0.6, 0.4 * 0.6, 1 * 0.6}
--     elseif preset == "hordes_tagged_remaining_target" then
--         return {0, 0.73 * 0.6, 1 * 0.6}
--     else
--         local r = (mod:get("outline_red_stim") or 100) / 250.0
--         local g = (mod:get("outline_green_stim") or 0) / 250.0
--         local b = (mod:get("outline_blue_stim") or 100) / 250.0
--         return {r, g, b}
--     end
-- end



mod.update_custom_outlines = function(self)
    -- Define custom outline settings
    OutlineSettings.MinionOutlineExtension.outline_encroaching_garden = {
        priority = get_priority(), 
        material_layers = get_material_layers(),
        color = get_color(),
        visibility_check = function(unit)
            return not not HEALTH_ALIVE[unit]
        end,
    }
    -- OutlineSettings.MinionOutlineExtension.outline_blue_stimmed_enemy = {
    --     priority = get_stim_priority(),
    --     material_layers = get_material_layers(),
    --     color = get_stim_color(),
    --     visibility_check = function(unit)
    --         return not not HEALTH_ALIVE[unit]
    --     end,
    -- }
end

local function get_outline_type(unit)
    if unit_has_havoc_encroaching_garden(unit) then
        return tostring("outline_encroaching_garden")
    -- elseif unit_has_blue_stim(unit) then
    --     return tostring("outline_blue_stimmed_enemy")
    end
end

local function get_outline_system()
    return Managers.state.extension and Managers.state.extension:system("outline_system")
end

-- clean out table of dead/invalid unit
local function cleanup_reported()
    for unit, _ in pairs(reported_units) do
        if not ALIVE[unit] then
            reported_units[unit] = nil
        end
    end
end

function mod:on_enabled()
    mod:update_custom_outlines(OutlineSettings)
end

local function remove_outline()
    local outline_system = get_outline_system()
    if not outline_system then
        return
    end

    for unit, outline_type in pairs(reported_units) do
        if ALIVE[unit] then
            --local outline_type = get_outline_type(unit)
            outline_system:remove_all_outlines(unit, outline_type, false)
        end
        reported_units[unit] = nil
    end
end

function mod:on_disabled()
    remove_outline()
    reported_units = nil
end

mod.on_setting_changed = function(setting_id)
    if setting_id:match("^outline_") or 
        setting_id:match("^scan_") or 
        setting_id:match("^color_") then
        remove_outline()
        mod:update_custom_outlines(OutlineSettings)
    end
end
