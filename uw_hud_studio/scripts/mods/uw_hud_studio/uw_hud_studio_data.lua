local mod = get_mod("uw_hud_studio")

return {
    name = mod:localize("mod_name"),
    description = mod:localize("mod_description"),
    is_togglable = true,
    options = {
        widgets = {},
    },
}
