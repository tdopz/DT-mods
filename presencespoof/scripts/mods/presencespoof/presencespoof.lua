local mod = get_mod("presencespoof")
mod:hook_require("scripts/settings/presence/presence_settings",function(presence_settings)
    mod:hook(presence_settings, "evaluate_presence", function(func, game_state) 
        local choice = mod:get("presence_choice")
        if choice ~= "disabled" then
            -- mod:echo("[Presence Spoof] Setting presence to " .. choice)
            return choice
        end
        return func(game_state)
     end)
end)
--[[mod:hook_require("scripts/utilities/attack/explosion", function(Explosion)
    mod:hook(Explosion, "create_husk_explosion", function(func, world, physics_world, wwise_world, attacking_owner_unit_or_nil, explosion_template, position, rotation, radius_variables, charge_level)
        -- pre-hook logic
		if BLOCKED_VFX_RPC[explosion_template.name] then
			return
		end
        return func(world, physics_world, wwise_world, attacking_owner_unit_or_nil, explosion_template, position, rotation, radius_variables, charge_level)
		 -- post-hook logic
    end)
end)]]
-- Your mod code goes here.
-- https://dmf-docs.darkti.de
