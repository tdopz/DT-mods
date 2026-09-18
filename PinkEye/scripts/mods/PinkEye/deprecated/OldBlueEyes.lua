local mod = get_mod("OldBlueEyes")

local function get_material_layers()
    return {"minion_outline_combat_ability"}

end

local function get_priority()
    return mod:get("outline_priority")
end

local function get_color()
    local preset = mod:get("color_presets")
    
    -- Use preset colors from source code templates if not custom
    if preset == "smart_tagged_enemy" then
        return {1 * 0.6, 0.005, 0}  -- Red
    elseif preset == "smart_tagged_enemy_passive" then
        return {0.8 * 0.6, 0.75 * 0.6, 0}  -- Yellow-ish
    elseif preset == "veteran_smart_tag" then
        return {1 * 0.6, 0.8 * 0.6, 0.4 * 0.6}  -- Orange-yellow
    elseif preset == "adamant_smart_tag" then
        return {1 * 0.6, 0.25 * 0.6, 0.25 * 0.6}  -- Light red
    elseif preset == "adamant_mark_target" then
        return {0.5 * 0.6, 0.4 * 0.6, 1 * 0.6}  -- Purple-ish
    elseif preset == "hordes_tagged_remaining_target" then
        return {0, 0.73 * 0.6, 1 * 0.6}  -- Blue
    else
        local r = (mod:get("outline_red") or 100) / 250.0   
        local g = (mod:get("outline_green") or 0) / 250.0
        local b = (mod:get("outline_blue") or 100) / 250.0
        return {r, g, b}
    end
end


-- buff check
local function unit_has_blue_stim(unit)
    local buff_ext = ScriptUnit.has_extension(unit, "buff_system")
    if not buff_ext then
        return false
    end

    local ok_t, has_t = buff_ext.has_buff_using_buff_template, buff_ext, "mutator_stimmed_minion_blue"
    if ok_t and has_t then
        return true
    end

    local ok_kw, has_kw = buff_ext.has_keyword, buff_ext, "super_armor_override"
    if ok_kw and has_kw then
        return true
    end

    return false
end
local reported_units = {}
local saved_material_layers = {}
local scan_interval = mod:get("scan_interval")
local scan_timer = 0

local function get_outline_type()
    -- Used a neutral outline type that doesn't have strange interactions
    return "hordes_tagged_remaining_target"  
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

-- remove outline
local function remove_outline()
    local outline_system = get_outline_system()
    if not outline_system then
        return
    end
    
    -- Remove outlines from all reported units
    local outline_type = get_outline_type()
    for unit, _ in pairs(reported_units) do
        if ALIVE[unit] then
            -- mod:echo("removing outline: " .. tostring(unit))
            
                outline_system:remove_all_outlines(unit, outline_type, true)
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
    local outline_type = get_outline_type()

    for unit, buff_ext in pairs(unit_map) do
        if ALIVE[unit] and not reported_units[unit] then
            -- If scan_radius <= 0 then radius off (IOW infinite radius)
            -- local within_radius = (not scan_radius or scan_radius <= 0) or (nearby_units and nearby_units[unit])
            if unit_has_blue_stim(unit) then
                reported_units[unit] = outline_type 
                outline_system:remove_all_outlines(unit, outline_type, false) -- Clear existing outlines first, as a bit of a failsafe
                -- Add the outline using neutral type
                outline_system:add_outline(unit, outline_type, true)
                local outline_ext = ScriptUnit.has_extension(unit, "outline_system")
                if outline_ext and outline_ext.outlines then
                    for i, entry in pairs(outline_ext.outlines) do
                        if entry then
                            -- settings override
                            entry.material_layers = get_material_layers()
                            entry.priority = get_priority()
                            entry.color = get_color() 
                        end
                    end                 
                end
            end
        end
    end
    cleanup_reported()
    end


mod.on_setting_changed = function(setting_id)
    if setting_id:match("^outline_") or 
        setting_id:match("^scan_") or 
        setting_id == "color_presets" then
        remove_outline()   
    end
end
