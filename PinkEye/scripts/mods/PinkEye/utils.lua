local mod = get_mod("PinkEye")
-- local SpawnerManager = require("scripts/foundation/managers/unit_spawner/unit_spawner_manager")
-- Your mod code goes here.
-- https://dmf-docs.darkti.de
local DEBUG_LOGGING = false

local function debug_log(message)
    if DEBUG_LOGGING then
        mod:echo(message)
    end
end

local _get_base_name = function(breed_name)
    return breed_name:gsub("_mutator$", "")
end

local function get_outline_system()
    return Managers.state.extension and Managers.state.extension:system("outline_system")
end

mod:hook_safe("MinionBuffExtension", "_on_add_buff", function(self, buff_instance)
    local template = buff_instance:template()
    if template.name ~= "havoc_encroaching_garden" then
        return
    end

    local unit = self._unit
    if not ALIVE[unit] then
        return
    end

    local outline_system = get_outline_system()
    if not outline_system then
        return
    end

    debug_log("Encroaching Garden buff added to " .. tostring(unit) .. " applying outline")
    outline_system:add_outline(unit, "outline_encroaching_garden", false)
end)
