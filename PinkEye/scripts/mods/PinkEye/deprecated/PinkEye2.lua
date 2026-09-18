local mod = get_mod("PinkEye")

local function get_setting(setting)
    -- Cache settings for quick checks
    local val = settings_cache[setting]
    if val == nil then
        settings_cache[setting] = mod:get(setting)
        val = settings_cache[setting]
    end
    return val
end

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


local function get_outline_rgba(group_id)
    return get_setting(group_id .. "_color_red") / 250,
        get_setting(group_id .. "_color_green") / 250,
        get_setting(group_id .. "_color_blue") / 250,
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

local function get_stim_color()
    local preset = mod:get("color_presets_stim")
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
        local r = (mod:get("outline_red_stim") or 100) / 250.0
        local g = (mod:get("outline_green_stim") or 0) / 250.0
        local b = (mod:get("outline_blue_stim") or 100) / 250.0
        return {r, g, b}
    end
end

local function clear_settings_cache()
    for key, _ in pairs(settings_cache) do
        settings_cache[key] = nil
    end
end

local OutlineSettings = require("scripts/settings/outline/outline_settings")

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
    OutlineSettings.MinionOutlineExtension.outline_blue_stimmed_enemy = {
        priority = get_stim_priority(),
        material_layers = get_material_layers(),
        color = get_stim_color(),
        visibility_check = function(unit)
            return not not HEALTH_ALIVE[unit]
        end,
    }
end


local function get_outline_toggle()
    return mod:get("outline_toggle_stim")
end

-- buff check
local function unit_has_havoc_encroaching_garden(unit)
    local buff_ext = ScriptUnit.has_extension(unit, "buff_system")
    if not buff_ext then
        return false
    end

    local ok_t, has_t = pcall(buff_ext.has_buff_using_buff_template, buff_ext, "havoc_encroaching_garden")
    if ok_t and has_t then
        return true
    end

    local ok_kw, has_kw = pcall(buff_ext.has_keyword, buff_ext, "gardens_embrace")
    if ok_kw and has_kw then
        return true
    end

    return false
end

local function unit_has_blue_stim(unit)
    local buff_ext = ScriptUnit.has_extension(unit, "buff_system")
    if not buff_ext then
        return false
    end

    local ok_t, has_t = pcall(buff_ext.has_buff_using_buff_template, buff_ext, "mutator_stimmed_minion_blue")
    if ok_t and has_t then
        return true
    end

    local ok_kw, has_kw = pcall(buff_ext.has_keyword, buff_ext, "super_armor_override")
    if ok_kw and has_kw then
        return true
    end

    return false
end
local reported_units = {}
local saved_material_layers = {}
local scan_interval = mod:get("scan_interval")
local scan_timer = 0

local function get_outline_type(unit)
    if unit_has_havoc_encroaching_garden(unit) then
        return tostring("outline_encroaching_garden")
    elseif unit_has_blue_stim(unit) then
        return tostring("outline_blue_stimmed_enemy")
    end
end

local function get_outline_system()
    return Managers.state.extension and Managers.state.extension:system("outline_system")
end

-- player in hub/prologue hub?
mod.is_in_hub = function()
    local state_manager = Managers.state
    local game_mode = state_manager and state_manager.game_mode
    local game_mode_name = game_mode and game_mode:game_mode_name()
    return game_mode_name == "hub" or mod:is_in_prologue_hub()
end

mod.is_in_prologue_hub = function()
    local state_manager = Managers.state
    local game_mode = state_manager and state_manager.game_mode
    local game_mode_name = game_mode and game_mode:game_mode_name()
    return game_mode_name == "prologue_hub"
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
    reported_units = {}
    saved_material_layers = {}
    scan_timer = 0
    mod:update_custom_outlines(OutlineSettings)
end

function mod:on_disabled()
    -- Restore saved material layers before clearing
    for unit, layers in pairs(saved_material_layers) do
        if ALIVE[unit] then
            local outline_ext = ScriptUnit.has_extension(unit, "outline_system")
            if outline_ext then       
                    outline_ext.outline_config.material_layers = layers
            end
        end
        saved_material_layers[unit] = nil
    end

    reported_units = {}
    scan_timer = 0
end

local function remove_outline()
    local outline_system = get_outline_system()
    if not outline_system then
        return
    end

    for unit, outline_type in pairs(reported_units) do
        if ALIVE[unit] then
            local outline_type = get_outline_type(unit)
                outline_system:remove_all_outlines(unit, outline_type, false)
        end
        reported_units[unit] = nil
    end
    saved_material_layers = {}
end

-- Main update
mod.update = function(self, dt)
    if mod:is_in_hub() or mod:is_in_prologue_hub() then
        return
    end
    --  limit scan frequency for performance
    scan_timer = scan_timer + 1
        if scan_timer < mod:get("scan_interval") then
            return
        end
        scan_timer = 0

    local extension_manager = Managers.state and Managers.state.extension
    if not extension_manager then
        return
    end

    -- Get buff system from _systems table
    local buff_system = extension_manager._systems and extension_manager._systems["buff_system"]
    if not buff_system then
        return
    end

    local unit_map = buff_system._unit_to_extension_map
    if not unit_map then
        return
    end

    local outline_system = get_outline_system()
    

    for unit, buff_ext in pairs(unit_map) do
        if ALIVE[unit] and not reported_units[unit] then
            if unit_has_havoc_encroaching_garden(unit) then
                local outline_type = get_outline_type(unit)
                reported_units[unit] = outline_type
                outline_system:remove_all_outlines(unit, outline_type, false) -- Clear existing outlines first, as a bit of a failsafe
                outline_system:add_outline(unit, outline_type, false)
                -- local outline_ext = ScriptUnit.has_extension(unit, "outline_system")
                -- if outline_ext and outline_ext.outlines then
                --     for i, entry in pairs(outline_ext.outlines) do
                --         if entry then
                --             -- settings override
                --             entry.material_layers = get_material_layers()
                --             entry.priority = get_priority()
                --             entry.color = get_color() 
                --         end
                --     end                 
                -- end
            end
            if get_outline_toggle() == true and unit_has_blue_stim(unit) then
                local outline_type = get_outline_type(unit)
                reported_units[unit] = outline_type  
                outline_system:remove_all_outlines(unit, outline_type, false) -- Clear existing outlines first, as a bit of a failsafe
                outline_system:add_outline(unit, outline_type, false)
                -- local outline_ext = ScriptUnit.has_extension(unit, "outline_system")
            --     if outline_ext and outline_ext.outlines then
            --         for i, entry in pairs(outline_ext.outlines) do
            --             if entry then
            --                 entry.material_layers = get_material_layers()
            --                 entry.priority = get_stim_priority()
            --                 entry.color = get_stim_color() 
            --             end
            --         end                 
            --     end
            end            
        end
    end
    cleanup_reported()
end


mod.on_setting_changed = function(setting_id)
    if setting_id:match("^outline_") or 
        setting_id:match("^scan_") or 
        setting_id:match("^color_") then
        remove_outline()
        mod:update_custom_outlines(OutlineSettings)
    end
end
