local mod = get_mod("PinkEye")
-- local SpawnerManager = require("scripts/foundation/managers/unit_spawner/unit_spawner_manager")
-- Your mod code goes here.
-- https://dmf-docs.darkti.de
local DEBUG_LOGGING = false

local function debug_log(message)
    if DEBUG_LOGGING then
        mod:echo("[TD] " .. message)
    end
end

local _get_base_name = function(breed_name)
    return breed_name:gsub("_mutator$", "")
end

local function unit_has_havoc_encroaching_garden(unit)
    local buff_ext = ScriptUnit.has_extension(unit, "buff_system")
    if not buff_ext then
        return false
    end

    local ok_t = buff_ext.has_buff_using_buff_template
    if not ok_t then
        return false
    end
    local has_t = ok_t(buff_ext, "havoc_encroaching_garden")    

    if has_t then
        return true
    end
    
    return false
end

local function get_outline_system()
    return Managers.state.extension and Managers.state.extension:system("outline_system")
end

local function get_outline_type(unit)
    if unit_has_havoc_encroaching_garden(unit) then
        return tostring("outline_encroaching_garden")
    elseif unit_has_blue_stim(unit) then
        return tostring("outline_blue_stimmed_enemy")
    end
end

local function get_breed(unit)
    local unit_data_ext = ScriptUnit.has_extension(unit, "unit_data_system")
    local breed = unit_data_ext and unit_data_ext:breed()
    local breed_name = breed and _get_base_name(breed.name)
    return breed_name
end

local function get_unit_map()
    local extension_manager = Managers.state and Managers.state.extension
    if not extension_manager then
        return
    end

    -- Get buff system from _systems table
    local buff_system = extension_manager._systems and extension_manager._systems["buff_system"]
    if not buff_system then
        return
    end

    return buff_system._unit_to_extension_map
end

local reported_units = {}
local _has_encroaching_garden = false
-- local _test_print = function(self, unit)
--     debug_log("Unit updated: " .. tostring(unit))
-- end
    -- UnitSpawnerManager.game_object_id

local _on_spawned = function(_, _, unit)
    if not _has_encroaching_garden then
        return
    end
    if not ALIVE[unit] then
        return
    end
    
    local breed_name = get_breed(unit)
    
    debug_log("Unit spawned: " .. tostring(unit) .. " | Breed: " .. tostring(breed_name))

    local unit_map = get_unit_map()
    if not unit_map then
        return
    end
    local outline_system = get_outline_system()
    if not reported_units[unit] then
        for unit, buff_ext in pairs(unit_map) do
            if unit_has_havoc_encroaching_garden(unit) then
                local outline_type = get_outline_type(unit)
                reported_units[unit] = outline_type
                -- outline_system:remove_all_outlines(unit, outline_type, false) -- Clear existing outlines first, as a bit of a failsafe
                outline_system:add_outline(unit, outline_type, false)
            end
        end
    end
end

-- local function _on_buff_added(self, template, t, from_server_correction, ...)
--     mod:echo("test")
-- end

-- local function _rpc_buff_added(self, channel_id, game_object_id, buff_template_id,...)
--     mod:echo("test")
-- end
mod:hook_require("scripts/managers/game_mode/game_mode_extensions/game_mode_extension_havoc", function(GameModeExtensionHavoc)
    mod:hook(GameModeExtensionHavoc, "on_gameplay_init", function(func, self, ...)
        local result = func(self, ...)
        _has_encroaching_garden = false
        local circumstances = self._havoc_data and self._havoc_data.circumstances
        if circumstances then
            for _, circumstance_name in pairs(circumstances) do
                if circumstance_name == "mutator_encroaching_garden" then
                    _has_encroaching_garden = true
                    debug_log("Encroaching Garden detected — enabling outlines")
                end
            end
        end
        return result
    end)
end)
mod:hook_safe("HealthExtension", "init", _on_spawned)
mod:hook_safe("HuskHealthExtension", "init", _on_spawned)
-- mod:hook_safe("BuffExtensionBase", "_add_buff", _on_buff_added)
-- mod:hook_safe("BuffExtensionBase", "rpc_add_buff", _rpc_buff_added)


local BUFF_NAMES = {
    mutator_stimmed_minion_blue   = true,
    mutator_stimmed_minion_green  = true,
    mutator_stimmed_minion_red    = true,
    mutator_stimmed_minion_yellow = true,
    ogryn_mutator_stimmed_minion_blue   = true,
    ogryn_mutator_stimmed_minion_green  = true,
    ogryn_mutator_stimmed_minion_red    = true,
    ogryn_mutator_stimmed_minion_yellow = true,
}

-- local MinionBuffExtension = require("scripts/extension_systems/buff/minion_buff_extension")
-- mod:hook(MinionBuffExtension, "_on_add_buff", function(func, self, buff_instance)
--     func(self, buff_instance)
--     local template = buff_instance:template()
--     local unit = self._unit
--     local buff_name = template.name
--     -- fires for every new unique buff added to any minion
--     if BUFF_NAMES[buff_name] then
--         mod:echo("STIM buff applied: " .. buff_name)
--     else
--         mod:echo("Buff: " .. buff_name)
--     end
-- end)
