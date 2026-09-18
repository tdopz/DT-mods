local mod = get_mod("stupidfallthing")
local Vo = require("scripts/utilities/vo")
local SimpleAudio
local audio_clip = nil
local _volume = nil
local dt_local_server
local function settings_cache()
    audio_clip = mod:get("audio_choice")
    _volume = mod:get("volume")
end
settings_cache()

mod:hook_safe(CLASS.PlayerCharacterStateDead, "on_enter", function(func, self, unit, dt, t, previous_state, params, ...)
    if SimpleAudio then
        local clip = audio_clip -- == "random" and all_clips[math.random(#all_clips)] or audio_clip
        SimpleAudio.play_file(clip, {
            volume = _volume,
            audio_type = "sfx",
            -- filters = "asetrate=48000*1.6,atempo=0.625", 
        }, unit)
    end
end)



mod.on_setting_changed = function(setting_id)
    settings_cache()
end

mod.on_all_mods_loaded = function()
	SimpleAudio = get_mod("SimpleAudio")
    if not SimpleAudio then
        mod:echo("SimpleAudio not found, looking for Audio Plugin...")
        SimpleAudio = get_mod("Audio")
        dt_local_server = get_mod("DarktideLocalServer")
        if not SimpleAudio and dt_local_server then
            mod:echo("SimpleAudio is required.")
		    return
        else
            mod:echo("Success! Using Audio Plugin & DarktideLocalServer.")
        end
    end
end

-- mod:hook_safe(CLASS.PlayerCharacterStateFalling, "on_enter", function(func, self, unit, dt, t, previous_state, params, ...)
--     mod:echo("testing this shit")
-- end)
-- local PlayerConstants = require("scripts/settings/player_character/player_character_constants")

-- mod.on_enabled = function()
--     mod:hook("scripts/settings/player_character/player_character_constants", constants )
--     mod:echo("stupidfallthing enabled")
--     local constants = PlayerConstants.constants
--     if constants then
--         mod:echo("constants work")
--     end
-- end
-- mod:hook_safe("scripts/settings/player_character/player_character_constants", )

--[[
mod:hook_safe(CLASS.PlayerCharacterStateDead, "on_enter", function(func, self, unit, dt, t, previous_state, params, ...)
    if SimpleAudio then
        local clip = audio_clip 
        SimpleAudio.play_file(clip, {
            volume = _volume,
            audio_type = "sfx",
        }, unit)
    end
end)
]]