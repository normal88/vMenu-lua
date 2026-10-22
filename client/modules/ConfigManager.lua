ConfigManager = {}

ConfigManager.Setting = {
    vmenu_use_permissions = "vmenu_use_permissions",
    vmenu_menu_staff_only = "vmenu_menu_staff_only",
    vmenu_menu_toggle_key = "vmenu_menu_toggle_key",
    vmenu_noclip_toggle_key = "vmenu_noclip_toggle_key",
    vmenu_keep_spawned_vehicles_persistent = "vmenu_keep_spawned_vehicles_persistent",
    vmenu_use_els_compatibility_mode = "vmenu_use_els_compatibility_mode",
    vmenu_handle_invisibility = "vmenu_handle_invisibility",
    vmenu_quit_session_in_rockstar_editor = "vmenu_quit_session_in_rockstar_editor",
    vmenu_server_info_message = "vmenu_server_info_message",
    vmenu_server_info_website_url = "vmenu_server_info_website_url",
    vmenu_teleport_to_wp_keybind_key = "vmenu_teleport_to_wp_keybind_key",
    vmenu_disable_spawning_as_default_character = "vmenu_disable_spawning_as_default_character",
    vmenu_enable_animals_spawn_menu = "vmenu_enable_animals_spawn_menu",
    vmenu_pvp_mode = "vmenu_pvp_mode",
    keep_player_head_props = "keep_player_head_props",
    vmenu_player_names_distance = "vmenu_player_names_distance",
    vmenu_disable_entity_outlines_tool = "vmenu_disable_entity_outlines_tool",
    vmenu_disable_player_stats_setup = "vmenu_disable_player_stats_setup",

    vmenu_using_chameleon_colours = "vmenu_using_chameleon_colours",

    vmenu_prevent_extras_when_damaged = "vmenu_prevent_extras_when_damaged",
    vmenu_allowed_engine_damage_for_extra_change = "vmenu_allowed_engine_damage_for_extra_change",
    vmenu_allowed_body_damage_for_extra_change = "vmenu_allowed_body_damage_for_extra_change",

    vmenu_mp_ped_preview = "vmenu_mp_ped_preview",

    vmenu_default_ban_message_information = "vmenu_default_ban_message_information",
    vmenu_auto_ban_cheaters = "vmenu_auto_ban_cheaters",
    vmenu_auto_ban_cheaters_ban_message = "vmenu_auto_ban_cheaters_ban_message",
    vmenu_log_ban_actions = "vmenu_log_ban_actions",
    vmenu_log_kick_actions = "vmenu_log_kick_actions",

    vmenu_enable_weather_sync = "vmenu_enable_weather_sync",
    vmenu_enable_dynamic_weather = "vmenu_enable_dynamic_weather",
    vmenu_dynamic_weather_timer = "vmenu_dynamic_weather_timer",
    vmenu_current_weather = "vmenu_current_weather",
    vmenu_blackout_enabled = "vmenu_blackout_enabled",
    vmenu_vehicle_blackout_enabled = "vmenu_vehicle_blackout_enabled",
    vmenu_weather_change_duration = "vmenu_weather_change_duration",
    vmenu_enable_snow = "vmenu_enable_snow",

    vmenu_enable_time_sync = "vmenu_enable_time_sync",
    vmenu_freeze_time = "vmenu_freeze_time",
    vmenu_ingame_minute_duration = "vmenu_ingame_minute_duration",
    vmenu_current_hour = "vmenu_current_hour",
    vmenu_current_minute = "vmenu_current_minute",
    vmenu_sync_to_machine_time = "vmenu_sync_to_machine_time",

    vmenu_override_voicechat_default_range = "vmenu_override_voicechat_default_range",

    vmenu_keymapping_id = "vmenu_keymapping_id",

    vmenu_online_players_nearby_only = "vmenu_online_players_nearby_only",

    vmenu_webhook_time     = "vmenu_webhook_time",
    vmenu_webhook_weather  = "vmenu_webhook_weather",
    vmenu_webhook_players  = "vmenu_webhook_players",
    vmenu_webhook_bans     = "vmenu_webhook_bans",
    vmenu_webhook_vehicles = "vmenu_webhook_vehicles",
    vmenu_webhook_weapons  = "vmenu_webhook_weapons",
    vmenu_webhook_teleport = "vmenu_webhook_teleport",
    vmenu_webhook_misc     = "vmenu_webhook_misc",
}

function ConfigManager.GetSettingsBool(setting)
    local value = GetConvar(setting, "false")
    return value:lower() == "true"
end

function ConfigManager.GetSettingsInt(setting)
    local value = GetConvarInt(setting, -1)
    return value
end

function ConfigManager.GetSettingsFloat(setting)
    local value = tonumber(GetConvar(setting, "-1.0"))
    if value then
        return value
    end
    return -1.0
end

function ConfigManager.GetSettingsString(setting, defaultValue)
    defaultValue = defaultValue or ""
    local value = GetConvar(setting, defaultValue)

    if value == nil or value == "" then
        return nil
    end

    return value
end

function ConfigManager.IsClientDebugModeEnabled()
    local debugMode = GetResourceMetadata(GetCurrentResourceName(), "client_debug_mode", 0)
    return debugMode and debugMode:lower() == "true"
end

ConfigManager.DebugMode = ConfigManager.IsClientDebugModeEnabled()

local locationsData = nil

function ConfigManager.GetLocations()
    if locationsData then
        return locationsData
    end

    local data = {
        teleports = {},
        blips = {}
    }

    local jsonFile = LoadResourceFile(GetCurrentResourceName(), "config/locations.json")

    if not jsonFile or jsonFile == "" then
        if Notify then
            Notify.Error("The locations.json file is empty or does not exist, please tell the server owner to fix this.")
        end
        locationsData = data
        return data
    end

    local success, result = pcall(function()
        return json.decode(jsonFile)
    end)

    if success and result then
        data = result
        locationsData = data
    else
        if Notify then
            Notify.Error(
            "An error occurred while processing the locations.json file. Teleport Locations and Location Blips will be unavailable. Please correct any errors in the locations.json file.")
        end
        locationsData = data
    end

    return data
end

function ConfigManager.GetTeleportLocationsData()
    local locations = ConfigManager.GetLocations()
    return locations.teleports or {}
end

function ConfigManager.GetLocationBlipsData()
    local locations = ConfigManager.GetLocations()
    return locations.blips or {}
end

RegisterNetEvent("vMenu:UpdateTeleportLocations", function(locationsJson)
    local success, locations = pcall(function()
        return json.decode(locationsJson)
    end)

    if success and locations then
        if not locationsData then
            locationsData = { teleports = {}, blips = {} }
        end
        locationsData.teleports = locations
    end
end)

return ConfigManager
