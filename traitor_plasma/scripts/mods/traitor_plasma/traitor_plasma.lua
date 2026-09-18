local mod = get_mod("traitor_plasma")

local MasterItems = require("scripts/backend/master_items")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local ScriptViewport = require("scripts/foundation/utilities/script_viewport")
local VisualLoadoutCustomization = require("scripts/extension_systems/visual_loadout/utilities/visual_loadout_customization")
local weaponSecondary = nil
local weapon_3p = nil
local model_swap_active = false
local local_player_wielding_plasma = false
local was_third_person = false
local is_third_person = nil
local spawned_3p_plasma = false
local in_hub = false
local currentSlot = ""
local settings_cache = {
    muzzle_vfx_enabled = true,
    beam_vfx_enabled = true,
	beam_linger_vfx_enabled = true,
    explosion_vfx_enabled = true,
	linger_forward_offset = 1.5,
    coil_color_enabled = true,
    coil_color_r = 255,
    coil_color_g = 35,
    coil_color_b = 0,
}

local plasma_patterns = {
    ["plasmagun_p1_m1"] = true,
    ["plasmagun_p1_m2"] = true,
}

local function update_settings_cache()
    settings_cache.coil_color_enabled = mod:get("coil_color_enabled")
    settings_cache.muzzle_vfx_enabled = mod:get("muzzle_vfx_enabled")
    settings_cache.beam_vfx_enabled = mod:get("beam_vfx_enabled")
	settings_cache.beam_linger_vfx_enabled = mod:get("beam_linger_vfx_enabled")
    settings_cache.explosion_vfx_enabled = mod:get("explosion_vfx_enabled")
	settings_cache.linger_forward_offset = mod:get("linger_forward_offset")
    settings_cache.coil_color_r = mod:get("coil_color_R") or 255
    settings_cache.coil_color_g = mod:get("coil_color_G") or 35
    settings_cache.coil_color_b = mod:get("coil_color_B") or 0
end

update_settings_cache()

-- Coil glow recolouring, credit to Wobin and his mod, Chromatic Auspex

local _coil_light_originals = setmetatable({}, { __mode = "k" })

local EMISSIVE_W = 1.0
local CHANNEL_EPSILON = 0.0001
local FULL_SPECTRUM_CCT = 12000

local function recolour_light(light, r, g, b)
    local state = _coil_light_originals[light]

    if not state then
        local cct = Light.correlated_color_temperature(light)
        local filter = Light.color_filter(light)
        local fx, fy, fz = Vector3.x(filter), Vector3.y(filter), Vector3.z(filter)
        local mag = Vector3.length(Light.color_with_intensity(light))

        state = { cct, fx, fy, fz, mag }
        _coil_light_originals[light] = state
    end

    local mag = state[5]

    if not mag or mag <= 0 then
        return
    end

    local tlen = math.sqrt(r * r + g * g + b * b)
    local tx, ty, tz = r / tlen, g / tlen, b / tlen

    Light.set_correlated_color_temperature(light, FULL_SPECTRUM_CCT)
    Light.set_color_filter(light, Vector3(1, 1, 1))

    local base_ci = Light.color_with_intensity(light)
    local bx, by, bz = Vector3.x(base_ci), Vector3.y(base_ci), Vector3.z(base_ci)

    local new_fx = bx > CHANNEL_EPSILON and (tx * mag) / bx or 0
    local new_fy = by > CHANNEL_EPSILON and (ty * mag) / by or 0
    local new_fz = bz > CHANNEL_EPSILON and (tz * mag) / bz or 0

    Light.set_color_filter(light, Vector3(new_fx, new_fy, new_fz))
end

local function recolour_coil(unit, r, g, b)
    if not unit or not Unit.is_valid(unit) then
        return
    end

    local colour = Color(r, g, b, EMISSIVE_W)
    local colour_rgb = Vector3(r, g, b)

    Unit.set_vector4_for_materials(unit, "emissive_color_intensity", colour, true)
    Unit.set_vector3_for_materials(unit, "emissive_color", colour_rgb, true)

    local num_lights = Unit.num_lights(unit)
    for i = 1, num_lights do
        local light = Unit.light(unit, i)
        recolour_light(light, r, g, b)
    end
end

local function restore_coil(unit)
    if not unit or not Unit.is_valid(unit) then
        return
    end

    local num_lights = Unit.num_lights(unit)
    for i = 1, num_lights do
        local light = Unit.light(unit, i)
        local state = _coil_light_originals[light]
        if state then
            Light.set_correlated_color_temperature(light, state[1])
            Light.set_color_filter(light, Vector3(state[2], state[3], state[4]))
        end
    end
end

local function apply_coil_color_from_settings()
    if settings_cache.coil_color_enabled then
        local r = (settings_cache.coil_color_r or 255) / 255
        local g = (settings_cache.coil_color_g or 35) / 255
        local b = (settings_cache.coil_color_b or 0) / 255
        recolour_coil(mod.item_unit, r, g, b)
        recolour_coil(mod.item_unit_3p, r, g, b)
    else
        restore_coil(mod.item_unit)
        restore_coil(mod.item_unit_3p)
    end
end

mod.toggle_model_swap = function()
    if currentSlot == "slot_secondary" then 
		if model_swap_active then
			-- Show originals, hide replacements
            Unit.set_unit_objects_visibility(weaponSecondary, true, true)
            if Unit.is_valid(mod.item_unit) then
				Unit.set_unit_objects_visibility(mod.item_unit, false, true)
            end
			if Unit.is_valid(weapon_3p) then
				Unit.set_unit_objects_visibility(weapon_3p, true, true)
			end
			if Unit.is_valid(mod.item_unit_3p) then
				Unit.set_unit_objects_visibility(mod.item_unit_3p, false, true)
			end
			model_swap_active = false
			mod:hook_disable(World, "create_particles")
		else
			-- Hide originals, show replacements
			Unit.set_unit_objects_visibility(weaponSecondary, false, true)
			if Unit.is_valid(mod.item_unit) then
				Unit.set_unit_objects_visibility(mod.item_unit, true, true)
			end
			if Unit.is_valid(weapon_3p) then
				Unit.set_unit_objects_visibility(weapon_3p, false, true)
			end
			if Unit.is_valid(mod.item_unit_3p) then
				Unit.set_unit_objects_visibility(mod.item_unit_3p, true, true)
			end
			model_swap_active = true
			mod:hook_enable(World, "create_particles")
		end
	else 
		mod:echo("[TraitorPlasma] Not wielding a secondary weapon.")
	end
end

mod.spawn_plasma = function() 
    if model_swap_active and spawned_3p_plasma then
        return
    end
    
	if MasterItems.has_data() then
		local item = MasterItems.get_item("content/items/weapons/minions/ranged/chaos_traitor_guard_trooper_plasma_gun")
		if not item then
			mod:error("Traitor plasma gun item not found in MasterItems")
			return
		end
		local world = Managers.world:world("level_world")
		local player = Managers.player:local_player_safe(1)
		if player == nil then return end
		local player_unit = player.player_unit
		mod.player_unit = player_unit

		-- 1p
		if not is_third_person and Unit.is_valid(player_unit) and Unit.is_valid(weaponSecondary) then
			mod.item_unit = World.spawn_unit_ex(world, item.base_unit, nil, Vector3(0,0,0), Quaternion.identity())
			Unit.set_unit_objects_visibility(weaponSecondary, false, true)
			World.link_unit(world, mod.item_unit, 1, weaponSecondary, 1)
			Unit.set_shader_pass_flag_for_meshes_in_unit_and_childs(mod.item_unit, "custom_fov", true)
			model_swap_active = true
		end

		-- 3p
		if is_third_person and Unit.is_valid(player_unit) and Unit.is_valid(weapon_3p) and not spawned_3p_plasma then
			mod.item_unit_3p = World.spawn_unit_ex(world, item.base_unit, nil, Vector3(0,0,0), Quaternion.identity())
			Unit.set_unit_objects_visibility(weapon_3p, false, true)
			World.link_unit(world, mod.item_unit_3p, 1, weapon_3p, 1)
            spawned_3p_plasma = true
		end

		apply_coil_color_from_settings()
	end
end

local MUZZLE_VFX_SWAPS = {
    ["content/fx/particles/weapons/rifles/plasma_gun/plasma_muzzle_ks"]  = "content/fx/particles/weapons/rifles/plasma_gun/plasma_muzzle_captain",
    ["content/fx/particles/weapons/rifles/plasma_gun/plasma_muzzle_bfg"] = "content/fx/particles/weapons/rifles/plasma_gun/plasma_muzzle_captain",
}
local BEAM_VFX_SWAP = {
    ["content/fx/particles/weapons/rifles/plasma_gun/plasma_beam"]        = "content/fx/particles/weapons/rifles/plasma_gun/plasma_beam_orange",
}
local BEAM_LINGER_VFX_SWAP = {
    ["content/fx/particles/weapons/rifles/plasma_gun/plasma_beam_linger"] = "content/fx/particles/weapons/rifles/plasma_gun/plasma_beam_linger_orange",
}

local EXPLOSION_VFX_SWAPS = {
    ["content/fx/particles/weapons/rifles/plasma_gun/plasma_charged_explosion_small"]  = "content/fx/particles/enemies/renegade_plasma_trooper/renegade_plasma_explosion_medium",
    ["content/fx/particles/weapons/rifles/plasma_gun/plasma_charged_explosion_medium"] = "content/fx/particles/enemies/renegade_plasma_trooper/renegade_plasma_explosion_medium",
    ["content/fx/particles/weapons/rifles/plasma_gun/plasma_charged_explosion_large"]  = "content/fx/particles/enemies/renegade_plasma_trooper/renegade_plasma_explosion_medium",
}


mod:hook_safe(CLASS.PlayerUnitWeaponExtension, "_wielded_weapon", function(self, inventory_component, weapons)
    if in_hub then return end
    local wielded_slot = inventory_component.wielded_slot
    local weapon_data = weapons[wielded_slot]

    if weapon_data and weapon_data.item then
        local item = weapon_data.item
        local item_name = item.name or (item.__master_item and item.__master_item.name) or ""

        if string.find(item_name, "plasmagun") then
            local_player_wielding_plasma = true
		else
		    local_player_wielding_plasma = false
        end
    end

    -- Track 1p weapon unit
    if weapons.slot_secondary then
        if weaponSecondary ~= weapons.slot_secondary.weapon_unit then
            weaponSecondary = weapons.slot_secondary.weapon_unit
            if Unit.is_valid(mod.item_unit) then
                Unit.set_unit_objects_visibility(mod.item_unit, false, true)
            end
            mod.item_unit = nil
        end
    end

    -- Track 3p weapon unit via visual_loadout_extension
    local player_unit = self._unit
    if player_unit and Unit.is_valid(player_unit) then
        local visual_loadout_ext = ScriptUnit.has_extension(player_unit, "visual_loadout_system")
        if visual_loadout_ext then
            local _, unit_3p = visual_loadout_ext:unit_and_attachments_from_slot("slot_secondary")
            if unit_3p and weapon_3p ~= unit_3p then
                weapon_3p = unit_3p
                if Unit.is_valid(mod.item_unit_3p) then
                    Unit.set_unit_objects_visibility(mod.item_unit_3p, false, true)
                end
                mod.item_unit_3p = nil
            end
        end
    end

	if wielded_slot ~= currentSlot then
        currentSlot = wielded_slot
	end
    if wielded_slot == "slot_secondary" and local_player_wielding_plasma and not Unit.is_valid(mod.item_unit) then
        mod.spawn_plasma()
    end
end)

mod:hook(World, "create_particles", function(func, world, particles, pos, ...)
    if in_hub then 
        return func(world, particles, pos, ...)
    end
    if local_player_wielding_plasma then
        if settings_cache.muzzle_vfx_enabled and MUZZLE_VFX_SWAPS[particles] then
            particles = MUZZLE_VFX_SWAPS[particles]
        end
        if settings_cache.beam_vfx_enabled and BEAM_VFX_SWAP[particles] then
            particles = BEAM_VFX_SWAP[particles]
        end
		if settings_cache.beam_linger_vfx_enabled and BEAM_LINGER_VFX_SWAP[particles] then
			particles = BEAM_LINGER_VFX_SWAP[particles]
			if pos then
				local vp = ScriptWorld.viewport(world, "player1")
				local cam = ScriptViewport.camera(vp)
				local forward = Quaternion.forward(Camera.local_rotation(cam))
				pos = pos + forward * settings_cache.linger_forward_offset
			end
		end
        if settings_cache.explosion_vfx_enabled and EXPLOSION_VFX_SWAPS[particles] then
            particles = EXPLOSION_VFX_SWAPS[particles]
        end
    end
    return func(world, particles, pos, ...)
end)

mod:hook_safe(CLASS.PlayerUnitFirstPersonExtension, "update", function(self, ...)
    if not local_player_wielding_plasma or spawned_3p_plasma or in_hub then return end
    is_third_person = self._force_third_person_mode == true
    if is_third_person ~= was_third_person then
        was_third_person = is_third_person
        if is_third_person then
            mod.spawn_plasma()
        end
    end
end)
-- mod:hook_safe(CLASS.ActionWield, "start", function(self, action_settings, ...)
--     local weapon_template = self._weapon_template
--     if not weapon_template then return end
--     local weapon = weapon_template.name
--     if plasma_patterns[weapon] then
--         local_player_equipped_secondary = true
--     else 
--         local_player_equipped_secondary = false
--     end
-- end)

mod:hook_safe(CLASS.GameModeManager, "init", function(self, game_mode_context, game_mode_name, ...)
    in_hub = game_mode_name == "hub"

    -- Reset state between missions
    weaponSecondary = nil
    weapon_3p = nil
    mod.item_unit = nil
    mod.item_unit_3p = nil
    mod.player_unit = nil
    model_swap_active = false
    local_player_wielding_plasma = false
    local_player_equipped_secondary = false
    spawned_3p_plasma = false
    was_third_person = false
    is_third_person = nil
    currentSlot = ""
end)
mod.on_setting_changed = function(setting_id)
    update_settings_cache()
    apply_coil_color_from_settings()
end

mod.on_enabled = function()
    update_settings_cache()
    apply_coil_color_from_settings()
end

mod.on_disabled = function()
    restore_coil(mod.item_unit)
    restore_coil(mod.item_unit_3p)
    -- Clear state when toggled off, just in case
    weaponSecondary = nil
    weapon_3p = nil
    mod.item_unit = nil
    mod.item_unit_3p = nil
    mod.player_unit = nil
    model_swap_active = false
    local_player_wielding_plasma = false
    local_player_equipped_secondary = false
    spawned_3p_plasma = false
    was_third_person = false
    is_third_person = nil
    currentSlot = ""
end

