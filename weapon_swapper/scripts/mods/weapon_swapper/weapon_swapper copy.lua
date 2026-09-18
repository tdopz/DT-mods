local mod = get_mod("weapon_swapper")


-- ##########################################################
-- ################## Settings Cache ########################

local Promise = require("scripts/foundation/utilities/promise")
local MasterItems = require("scripts/backend/master_items")
local ItemPackage = require("scripts/foundation/managers/package/utilities/item_package")
local MinionVisualLoadout = require("scripts/utilities/minion_visual_loadout")
local Component = require("scripts/utilities/component")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local ScriptViewport = require("scripts/foundation/utilities/script_viewport")

local local_player_wielding_melee = false
local local_player_wielding_ranged = false
local local_player_equipped_secondary = false
local currentSlot = ""
local equipped_item_name
local weaponPrimary
local weaponSecondary
local local_player_wielding_crusher = false
local model_swap_active = false  -- runtime state: is the enemy model currently shown?
local settings_cache = {
    model_swap_enabled = true,
    club_swap = true,
    ranged_swap = true, 
    local_player_wielding_melee = false,
    local_player_wielding_ranged = false,
    -- muzzle_vfx_enabled = true,
    -- beam_vfx_enabled = true,
	-- beam_linger_vfx_enabled = true,
    -- explosion_vfx_enabled = true,
    -- color_preset = "traitor_orange",
    -- custom_r = 255,
    -- custom_g = 140,
    -- custom_b = 30,
    -- color_intensity = 3,
	-- linger_forward_offset = 1.5,
}
local function update_settings_cache()
    settings_cache.club_swap = mod:get("bully_club_toggle") and mod:get("club_swap")
    -- settings_cache.ranged_swap = mod:get("ranged_swap")
end

update_settings_cache()


local swappable_melee_weapons = {
    ["content/items/weapons/player/melee/ogryn_pickaxe_2h_p1_m1"] = true,
    ["content/items/weapons/player/melee/ogryn_pickaxe_2h_p1_m2"] = true,
    ["content/items/weapons/player/melee/ogryn_pickaxe_2h_p1_m3"] = true,
    ["content/items/weapons/player/melee/ogryn_powermaul_p1_m1"] = true,
    -- ["content/items/weapons/player/melee/ogryn_powermaul_slabshield_p1_m1"] = true,
    ["content/items/weapons/player/melee/ogryn_club_p2_m1"] = true,
    ["content/items/weapons/player/melee/ogryn_club_p2_m2"] = true,
    ["content/items/weapons/player/melee/ogryn_club_p2_m3"] = true,
}

local swappable_ranged_weapons = {
    ["content/items/weapons/player/ranged/flamer_p1_m1"] = true,
    ["content/items/weapons/player/ranged/ogryn_gauntlet_p1_m1"] = true,
    ["content/items/weapons/player/ranged/ogryn_heavystubber_p1_m1"] = true, 
    ["content/items/weapons/player/ranged/ogryn_heavystubber_p1_m2"] = true, 
    ["content/items/weapons/player/ranged/ogryn_heavystubber_p1_m3"] = true, 
    ["content/items/weapons/player/ranged/ogryn_heavystubber_p2_m1"] = true, 
    ["content/items/weapons/player/ranged/ogryn_heavystubber_p2_m2"] = true, 
    ["content/items/weapons/player/ranged/ogryn_heavystubber_p2_m3"] = true, 

}

--"content/items/weapons/player/ranged/ogryn_gauntlet_p1_m1"
--"content/items/weapons/minions/ranged/chaos_traitor_guard_flamer_01"
--"content/items/weapons/minions/melee/chaos_ogryn_offhand_melee_weapon"
--"content/items/weapons/minions/melee/ogryn_houndmaster_melee_weapon_01"
local get_weapon_to_swap = function()
    if string.find(equipped_item_name, "ogryn_pickaxe_2h_p1") then
        return "content/items/weapons/minions/melee/chaos_ogryn_executor_2h_club"
    end
    if string.find(equipped_item_name, "ogryn_powermaul_p1_m1") then
        return settings_cache.club_swap --"content/items/weapons/minions/melee/chaos_ogryn_offhand_melee_weapon"
    end
    -- if string.find(equipped_item_name, "ogryn_gauntlet_p1_m1") then
    --     return "content/items/weapons/minions/ranged/renegade_netgun"--"content/items/characters/player/human/cine_props/rannick_stubgun" --"content/items/weapons/minions/ranged/chaos_traitor_guard_flamer_01"
    -- end
    -- if string.find(equipped_item_name, "ogryn_powermaul_slabshield_p1") then
    --     return "content/items/weapons/player/melee/full/ogryn_club_pipe_full_01"
    -- end
    if string.find(equipped_item_name, "ogryn_club_p2") then
        return settings_cache.club_swap
    end
    -- if string.find(equipped_item_name, "flamer_p1") then
    --     return settings_cache.ranged_swap
    -- end
    -- if string.find(equipped_item_name, "ogryn_heavystubber") then
    --     return settings_cache.ranged_swap
    -- end
    return nil
end
--"content/items/weapons/npc/ogryn_powermaul_slabshield_npc_01"

--"content/items/weapons/minions/melee/chaos_ogryn_executor_2h_club"
--content/items/characters/player/human/cine_props/rannick_stubgun
mod.spawn_melee = function() 
	if MasterItems.has_data() then
		local item = MasterItems.get_item(get_weapon_to_swap())
		if not item then
			mod:error("Ogryn item not found in MasterItems")
			return
		end
		local world = Managers.world:world("level_world")
		local player = Managers.player:local_player_safe(1)
		if player == nil then return end
		local player_unit = player.player_unit
		mod.player_unit = player_unit
        mod:echo(weaponPrimary)
		if Unit.is_valid(player_unit) and Unit.is_valid(weaponPrimary) then
			mod.item_unit =  World.spawn_unit_ex(world, item.base_unit, nil, Vector3(0,0,0), Quaternion.identity())
			Unit.set_unit_objects_visibility(weaponPrimary, false, true)
			World.link_unit(world, mod.item_unit, 1, weaponPrimary, 1)
			-- Apply the custom_fov shader flag so our model renders at 1p weapon FOV
			-- Without this, the model renders at the wider game FOV and appears small/mispositioned
			-- (This is what the game sets on all 1p weapon units via equipment_component.lua:359)
			Unit.set_shader_pass_flag_for_meshes_in_unit_and_childs(mod.item_unit, "custom_fov", true)

			model_swap_active = true
            mod:echo("Crusher model spawned")
		end
	end
end
mod.spawn_ranged = function() 
	if MasterItems.has_data() then
		local item = MasterItems.get_item(get_weapon_to_swap())
		if not item then
			mod:error("Ogryn item not found in MasterItems")
			return
		end
		local world = Managers.world:world("level_world")
		local player = Managers.player:local_player_safe(1)
		if player == nil then return end
		local player_unit = player.player_unit
		mod.player_unit = player_unit
		if Unit.is_valid(player_unit) and Unit.is_valid(weaponSecondary) then
			mod.item_unit =  World.spawn_unit_ex(world, item.base_unit, nil, Vector3(0,0,0), Quaternion.identity())
			Unit.set_unit_objects_visibility(weaponSecondary, false, true)
			World.link_unit(world, mod.item_unit, 1, weaponSecondary, 1)
			-- Apply the custom_fov shader flag so our model renders at 1p weapon FOV
			-- Without this, the model renders at the wider game FOV and appears small/mispositioned
			-- (This is what the game sets on all 1p weapon units via equipment_component.lua:359)
			Unit.set_shader_pass_flag_for_meshes_in_unit_and_childs(mod.item_unit, "custom_fov", true)


			model_swap_active = true
            mod:echo("ranged spawned")
		end
	end
end

mod.toggle_model_swap = function()
	if not Unit.is_valid(weaponPrimary) then
		mod:echo("[WeaponSwapper] No weapon to toggle — equip a crusher first.")
		return
	end

	if model_swap_active then
        Unit.set_unit_objects_visibility(weaponPrimary, true, true)
        if Unit.is_valid(mod.item_unit) then
			Unit.set_unit_objects_visibility(mod.item_unit, false, true)
        end
		
		model_swap_active = false
		-- mod:echo("[TraitorPlasma] Original model" .. tostring(model_swap_active))
        -- mod:hook_disable(World, "create_particles")
	else
		-- Show the original player weapon overlaid on top
        Unit.set_unit_objects_visibility(weaponPrimary, false, true)
		if Unit.is_valid(mod.item_unit) then
			Unit.set_unit_objects_visibility(mod.item_unit, true, true)
		end
		model_swap_active = true
        -- mod:echo("[TraitorPlasma] Traitor model" .. tostring(model_swap_active))
        -- mod:hook_enable(World, "create_particles")
	end
end

mod:hook_safe(CLASS.PlayerUnitWeaponExtension, "_wielded_weapon", function(self, inventory_component, weapons)
    local wielded_slot = inventory_component.wielded_slot
    local weapon_data = weapons[wielded_slot]
	-- mod:echo("wielded_slot: " .. wielded_slot)
	-- if wielded_slot ~= "slot_primary" and wielded_slot ~= "slot_secondary" then
	-- 	-- mod:echo("wielded_slot: " .. wielded_slot)
	-- 	return
	-- end

    if weapon_data and weapon_data.item then
        local item = weapon_data.item
        local item_name = item.name
        equipped_item_name = item_name
        if item_name then
            -- mod:echo("wielded weapon: " .. item_name)
        end

        if swappable_melee_weapons[item_name] then
            local_player_wielding_melee = true
		else
		    local_player_wielding_melee = false
        end
        if swappable_ranged_weapons[item_name] then
            local_player_wielding_ranged = true
		else
		    local_player_wielding_ranged = false
        end
    end

    -- Track weapon unit for model swap
    if weapons.slot_primary and not mod:get("ranged_or_melee") then
        if weaponPrimary ~= weapons.slot_primary.weapon_unit then
            weaponPrimary = weapons.slot_primary.weapon_unit
            mod:echo("primary = " ..tostring(weaponPrimary))
            if Unit.is_valid(mod.item_unit) then
                Unit.set_unit_objects_visibility(mod.item_unit, false, true)
            end
            mod.item_unit = nil
        end
    end
    if weapons.slot_secondary and mod:get("ranged_or_melee") then
        if weaponSecondary ~= weapons.slot_secondary.weapon_unit then
            weaponSecondary = weapons.slot_secondary.weapon_unit
            if Unit.is_valid(mod.item_unit) then
                Unit.set_unit_objects_visibility(mod.item_unit, false, true)
            end
            mod.item_unit = nil
        end
    end
	--local wielded_slot = inventory_component.wielded_slot
	if wielded_slot ~= currentSlot then
        currentSlot = wielded_slot
        -- mod:echo(currentSlot)
	end
    -- Spawn or re-apply the traitor plasma model when wielding a plasma gun
    if wielded_slot == "slot_primary" and local_player_wielding_melee and not Unit.is_valid(mod.item_unit) then
        mod.spawn_melee()
        mod:echo("spawning melee")
    end
	if wielded_slot == "slot_secondary" and local_player_wielding_ranged and not Unit.is_valid(mod.item_unit) then
        mod.spawn_ranged()
        mod:echo("spawning ranged")
    end
end)

-- Hook World.create_particles to swap all plasma VFX
-- mod:hook(World, "create_particles", function(func, world, particles, pos, ...)
--     if local_player_wielding_plasma then
--         -- Muzzle flash swap
--         if settings_cache.muzzle_vfx_enabled and MUZZLE_VFX_SWAPS[particles] then
--             particles = MUZZLE_VFX_SWAPS[particles]
--         end

--         -- Beam & beam linger swap
--         if settings_cache.beam_vfx_enabled and BEAM_VFX_SWAP[particles] then
--             particles = BEAM_VFX_SWAP[particles]
--         end
-- 		if settings_cache.beam_linger_vfx_enabled and BEAM_LINGER_VFX_SWAP[particles] then
-- 			particles = BEAM_LINGER_VFX_SWAP[particles]
-- 			-- Offset the linger effect forward relative to the camera
-- 			if pos then
-- 				local vp = ScriptWorld.viewport(world, "player1")
-- 				local cam = ScriptViewport.camera(vp)
-- 				local forward = Quaternion.forward(Camera.local_rotation(cam))
-- 				pos = pos + forward * settings_cache.linger_forward_offset
-- 			end
-- 		end
--         -- Charged explosion swap
--         if settings_cache.explosion_vfx_enabled and EXPLOSION_VFX_SWAPS[particles] then
--             particles = EXPLOSION_VFX_SWAPS[particles]
--         end
--     end

--     return func(world, particles, pos, ...)
-- end)


mod:hook_safe(CLASS.ActionWield, "start", function(self, action_settings, ...)
    local weapon_template = self._weapon_template
    if not weapon_template then return end
    local weapon = weapon_template.name
end)
mod.on_setting_changed = function(setting_id)
    update_settings_cache()
    mod.spawn_melee()
end
mod.on_all_mods_loaded = function()
    --update_settings_cache()
end
mod.on_enabled = function()
    update_settings_cache()
    -- if not Managers.package:has_loaded(rannick_package) then
    --     Managers.package:load(rannick_package, "rannick_package", function()
    --         mod._rannick_package_loaded = true
    --         -- mod:echo("[VFX Swapper] Expedition VFX package loaded - lightning effects now available!")
    --     end)
    -- else
    --     mod._expedition_package_loaded = true
    -- end
end
mod.on_disabled = function()
    local_player_wielding_melee = false
    local_player_wielding_ranged = false
end

