-- ============================================================================
-- UW HUD Studio — Ultrawide rescaling for HUD Studio blocks
-- ============================================================================
-- stretches block X-offsets proportionally so that
-- layouts designed at 16:9 fill the wider canvas of 21:9 / 32:9 monitors.
-- ============================================================================

local mod = get_mod("uw_hud_studio")

local RESOLUTION_LOOKUP = rawget(_G, "RESOLUTION_LOOKUP")

local _hud_studio -- cached reference to hud_studio mod

local function get_stretch_factor()
    if not RESOLUTION_LOOKUP then
        return 1
    end
    local w = RESOLUTION_LOOKUP.width or 1920
    local h = RESOLUTION_LOOKUP.height or 1080
    if h <= 0 then
        return 1
    end
    local virtual_width = math.max(1920, w * (1080 / h))
    return virtual_width / 1920
end
local DEAD_ZONE_INNER = 480  -- inner 50% of the 16:9 half-width
local DEAD_ZONE_OUTER = 720  -- outer 75% of the 16:9 half-width

-- smooth 0 transition between edge0 and edge1.
local function smoothstep(edge0, edge1, x)
    local t = (x - edge0) / (edge1 - edge0)
    if t < 0 then t = 0 end
    if t > 1 then t = 1 end
    return t * t * (3 - 2 * t)
end

-- Apply per-block stretch with dead zone.
-- Returns the stretched offset_x for a single block.
local function stretch_offset_x(offset_x, stretch)
    local abs_x = math.abs(offset_x)
    -- no stretch
    if abs_x <= DEAD_ZONE_INNER then
        return offset_x
    end
    -- full stretch
    if abs_x >= DEAD_ZONE_OUTER then
        return offset_x * stretch
    end
    -- Transition zone
    local blend = smoothstep(DEAD_ZONE_INNER, DEAD_ZONE_OUTER, abs_x)
    local effective_stretch = 1 + (stretch - 1) * blend
    return offset_x * effective_stretch
end

local function stretched_draw(real_draw, hud_studio_mod, self, ...)
    local stretch = get_stretch_factor()
    if stretch <= 1.001 or hud_studio_mod.hud_studio_editor_active then
        return real_draw(self, ...)
    end
    local blocks = self._blocks
    if not blocks then
        return real_draw(self, ...)
    end
    local saved = {}
    for b = 1, #blocks do
        local block = blocks[b]
        local off = block.offset
        if off then
            saved[b] = off[1]
            off[1] = stretch_offset_x(off[1] or 0, stretch)
        end
    end
    real_draw(self, ...)
    for b = 1, #blocks do
        local block = blocks[b]
        local off = block.offset
        if off and saved[b] ~= nil then
            off[1] = saved[b]
        end
    end
end

local UW_MARKER = "__uw_hud_studio_wrapped"

local function patch_hud_canvas(ui_hud)
    if not _hud_studio then
        return
    end
    if not ui_hud or not ui_hud._elements then
        return
    end
    local canvas = ui_hud._elements["HudCanvas"]
    if not canvas then
        return
    end
    if rawget(canvas, UW_MARKER) then
        return
    end
    local class_table = rawget(_G, "CLASS") and CLASS.HudCanvas
    local real_draw = class_table and class_table._draw
    if not real_draw then
        mod:warning("Could not find HudCanvas._draw to wrap")
        return
    end
    local hs = _hud_studio
    canvas._draw = function(self, ...)
        return stretched_draw(real_draw, hs, self, ...)
    end
    rawset(canvas, UW_MARKER, true)

    mod:info("Installed UW stretch on HudCanvas instance (stretch: %.3f)", get_stretch_factor())
end

function mod.on_all_mods_loaded()
    _hud_studio = get_mod("hud_studio")
    if not _hud_studio then
        mod:info("HUD Studio is not installed -- nothing to hook.")
        return
    end
    mod:hook_safe(CLASS.UIHud, "_setup_elements", function(self)
        patch_hud_canvas(self)
    end)
    local ui_hud = Managers.ui and Managers.ui._hud
    if ui_hud then
        patch_hud_canvas(ui_hud)
    end

    mod:info("Hooked UIHud._setup_elements -- UW stretch will activate on HUD creation (stretch: %.3f)", get_stretch_factor())
end
