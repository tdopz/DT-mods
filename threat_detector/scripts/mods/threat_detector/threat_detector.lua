local mod = get_mod("threat_detector")

local DEBUG_LOGGING = false
local function debug_log(message)
    if DEBUG_LOGGING then
        mod:echo("[ThreatDetector] " .. message)
    end
end

local function get_priority()
    return 2
end

local function get_material_layers()
    return {
        "minion_outline_combat_ability"
    }
end

local function get_color()
	local r = mod:get("threat_r") / 250.0
	local g = mod:get("threat_g") / 250.0
	local b = mod:get("threat_b") / 250.0

	return {r, g, b}
end

local OutlineSettings = require("scripts/settings/outline/outline_settings")

mod.update_custom_outlines = function(self)
    -- custom outline settings
    OutlineSettings.MinionOutlineExtension.outline_poxwalker_bomber = {
        priority = get_priority(), 
        material_layers = get_material_layers(),
        color = get_color(),
        visibility_check = function(unit)
            return not not HEALTH_ALIVE[unit]
        end,
    }
end
local OUTLINE_TYPE = "outline_poxwalker_bomber"

local _chaos_poxwalker_bomber = false
local _chaos_hound = false
local _renegade_netgunner = false
local _cultist_mutant = false


local function refresh_settings_cache()
    _chaos_poxwalker_bomber = mod:get("toggle_bomber")
    _chaos_hound = mod:get("toggle_hounds")
    _renegade_netgunner = mod:get("toggle_netgunner")
    _cultist_mutant = mod:get("toggle_mutant")
end

refresh_settings_cache()

local THREAT_BREEDS = {
    chaos_poxwalker_bomber = _chaos_poxwalker_bomber,
    chaos_hound = _chaos_hound,
    chaos_armored_hound = _chaos_hound,
    chaos_hound_mutator = _chaos_hound,
    renegade_netgunner = _renegade_netgunner,
    cultist_mutant = _cultist_mutant,
    cultist_mutant_mutator = _cultist_mutant,
}


local tracked_threat_units = {}

local tracked_threat_go_ids = {}

local threats_targeting_player = {}

local function get_local_player_unit()
    local local_player = Managers.player and Managers.player:local_player_safe(1)
    if not local_player then
        return nil
    end
    return local_player.player_unit
end

local function get_go_id(unit)
    local go_id = Managers.state.unit_spawner:game_object_id(unit)
    if not go_id then 
        return nil 
    end
    return go_id
end

local function cleanup_unit(unit)
    tracked_threat_units[unit] = nil

    if threats_targeting_player[unit] then
        threats_targeting_player[unit] = nil
        if HEALTH_ALIVE[unit] then
            local outline_system = Managers.state and Managers.state.extension
                and Managers.state.extension:system("outline_system")
            if outline_system then
                outline_system:remove_outline(unit, OUTLINE_TYPE, false)
            end
        end
    end

    local go_id = tracked_threat_go_ids[unit]
    if go_id then
        tracked_threat_go_ids[unit] = nil
    end
end

mod:hook_safe("OutlineSystem", "on_add_extension", function(self, world, unit, extension_name, extension_init_data, ...)
    if extension_name ~= "MinionOutlineExtension" then
        return
    end

    local breed = extension_init_data.breed
    if breed and THREAT_BREEDS[breed.name] then
        tracked_threat_units[unit] = breed.name
        debug_log("Spawn tracked: " .. breed.name .. " (" .. tostring(unit) .. ")")
    end
end)

mod:hook_safe("OutlineSystem", "on_remove_extension", function(self, unit, extension_name)
    if extension_name == "MinionOutlineExtension" and tracked_threat_units[unit] then
        debug_log("Remove cleanup: " .. tostring(unit))
        cleanup_unit(unit)
    end
end)

local function get_outline_system()
    return Managers.state.extension and Managers.state.extension:system("outline_system")
end
local function get_game_session()
    return Managers.state.game_session and Managers.state.game_session:game_session()
end

local scan_interval = 20
local scan_timer = 0
local Gamesession = GameSession.game_object_field
mod.update = function(dt)

    scan_timer = scan_timer + 1
    if scan_timer < scan_interval then
        return
    end
    scan_timer = 0

    local local_player_unit = get_local_player_unit()
    local game_session = get_game_session()
    local outline_system = get_outline_system()

    if not outline_system or not game_session then 
        return 
    end

    local new_threats = threats_targeting_player
    local prev_threats = {}
    for unit in pairs(new_threats) do 
        prev_threats[unit] = true 
    end
    table.clear(new_threats)

    for enemy_unit, breed_name in pairs(tracked_threat_units) do
        if HEALTH_ALIVE[enemy_unit] then
            local go_id = tracked_threat_go_ids[enemy_unit] or get_go_id(enemy_unit)
            if go_id then
                -- Cache go_id for O(1) cleanup later
                tracked_threat_go_ids[enemy_unit] = go_id
                debug_log("go_id: " .. tostring(go_id))
                local target_unit_id = Gamesession(game_session, go_id, "target_unit_id")
                debug_log("target_unit_id: " .. tostring(target_unit_id))
                if target_unit_id then
                    local target_unit = Managers.state.unit_spawner:unit(target_unit_id)
                    debug_log("target_unit: " .. tostring(target_unit))
                    if target_unit == local_player_unit then
                        new_threats[enemy_unit] = true
                        if not prev_threats[enemy_unit] then
                            outline_system:add_outline(enemy_unit, OUTLINE_TYPE, false)
                        end
                    end
                end
            end
        end
    end
    for unit in pairs(prev_threats) do
        if not new_threats[unit] then
            if HEALTH_ALIVE[unit] then
                debug_log("Enemy dead or switched to another target")
                outline_system:remove_outline(unit, OUTLINE_TYPE, false)
            end
        end
    end
end

mod.on_enabled = function()
    mod.update_custom_outlines()
    refresh_settings_cache()
end

mod.on_setting_changed = function(setting_id)
    mod.update_custom_outlines()
    refresh_settings_cache()

    for unit, breed_name in pairs(tracked_threat_units) do
        if not THREAT_BREEDS[breed_name] then
            cleanup_unit(unit)
        end
    end
end
