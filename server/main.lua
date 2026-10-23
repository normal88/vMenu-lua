local WebhookConvars = {
    time = "vmenu_webhook_time",
    weather = "vmenu_webhook_weather",
    players = "vmenu_webhook_players",
    bans = "vmenu_webhook_bans",
    vehicles = "vmenu_webhook_vehicles",
    weapons = "vmenu_webhook_weapons",
    teleport = "vmenu_webhook_teleport",
    misc = "vmenu_webhook_misc",
    spectate = "vmenu_webhook_spectate"
}

local WebhookColors = {
    time = 3447003,
    weather = 1146986,
    players = 16744272,
    bans = 16711680,
    vehicles = 10181046,
    weapons = 11534336,
    teleport = 3066993,
    misc = 9807270,
    spectate = 6591981
}

local vRP = nil
local vRPLegacy = false
local vRPLegacyTried = false

-- vRP Dunko has no getvRP export: load its lib/utils.lua + lib/Proxy at runtime
-- so the manifest does not need '@vrp/lib/utils.lua'.
local function LoadLegacyvRP()
    if vRPLegacyTried then return nil end
    vRPLegacyTried = true
    if type(module) ~= "function" then
        local code = LoadResourceFile("vrp", "lib/utils.lua")
        if not code then return nil end
        local chunk = load(code, "@vrp/lib/utils.lua")
        if not chunk or not pcall(chunk) then return nil end
    end
    local ok, Proxy = pcall(module, "vrp", "lib/Proxy")
    if not ok or type(Proxy) ~= "table" or not Proxy.getInterface then return nil end
    return Proxy.getInterface("vRP")
end

local function GetUserId(playerId)
    if not playerId then return nil end
    if not vRP and GetResourceState("vrp") == "started" then
        local ok, api = pcall(function() return exports["vrp"]:getvRP() end)
        if ok and api then
            vRP = api
        else
            vRP = LoadLegacyvRP()
            vRPLegacy = vRP ~= nil
        end
    end
    if not vRP then return nil end
    local ok, userId
    if vRPLegacy then
        ok, userId = pcall(vRP.getUserId, { playerId })
    else
        ok, userId = pcall(vRP.getUserId, playerId)
    end
    return ok and userId or nil
end

local function WebhookGetIds(playerId)
    local ids = {}
    for i = 0, GetNumPlayerIdentifiers(playerId) - 1 do
        local id = GetPlayerIdentifier(playerId, i)
        if id and (string.find(id, "discord:") or string.find(id, "license:")) then
            table.insert(ids, "`" .. id .. "`")
        end
    end
    return #ids > 0 and table.concat(ids, "\n") or "N/A"
end

local function WebhookPost(url, embed)
    PerformHttpRequest(
        url,
        function()
        end,
        "POST",
        json.encode({embeds = {embed}}),
        {["Content-Type"] = "application/json"}
    )
end

local function WebhookBuildEmbed(title, color, fields)
    return {
        title = title,
        type = "rich",
        color = color,
        fields = fields,
        footer = {text = "vMenu Logs | " .. os.date("%Y-%m-%d %H:%M:%S")}
    }
end

WebhookLogger = {}
function WebhookLogger.Send(category, playerId, title, fields, colorOver)
    local url = GetConvar(WebhookConvars[category] or "", "")
    if url == "" then
        return
    end

    local name = GetPlayerName(playerId) or "Unknown"
    local ids = WebhookGetIds(playerId)
    local color = colorOver or WebhookColors[category] or 9807270

    local embedFields = {
        {name = "**Player**", value = name .. " (ID: " .. playerId .. ")", inline = true},
        {name = "**Identifiers**", value = ids, inline = false}
    }
    if fields then
        for _, f in ipairs(fields) do
            table.insert(
                embedFields,
                {name = "**" .. f.name .. "**", value = tostring(f.value), inline = f.inline or false}
            )
        end
    end
    WebhookPost(url, WebhookBuildEmbed(title, color, embedFields))
end

function WebhookLogger.SendAction(category, adminId, targetId, title, fields, colorOver)
    local url = GetConvar(WebhookConvars[category] or "", "")
    if url == "" then
        return
    end

    local adminName = GetPlayerName(adminId) or "Unknown"
    local targetName = GetPlayerName(targetId) or "Unknown"
    local color = colorOver or WebhookColors[category] or 9807270

    local embedFields = {
        {name = "**Admin**", value = adminName .. " (ID: " .. adminId .. ")", inline = true},
        {name = "**Target**", value = targetName .. " (ID: " .. targetId .. ")", inline = true},
        {name = "**Admin Identifiers**", value = WebhookGetIds(adminId), inline = false},
        {name = "**Target Identifiers**", value = WebhookGetIds(targetId), inline = false}
    }
    if fields then
        for _, f in ipairs(fields) do
            table.insert(
                embedFields,
                {name = "**" .. f.name .. "**", value = tostring(f.value), inline = f.inline or false}
            )
        end
    end
    WebhookPost(url, WebhookBuildEmbed(title, color, embedFields))
end

local vMenuVersion = GetResourceMetadata(GetCurrentResourceName(), "version", 0) or "unknown"
local debugMode = false

local RateLimits = {
    ["vMenu:RequestAllPlayers"] = {interval = 2000, lastCall = {}},
    ["vMenu:RequestPermissions"] = {interval = 5000, lastCall = {}},
    ["vMenu:RequestTimeSync"] = {interval = 3000, lastCall = {}}
}

local function IsRateLimited(eventName, playerId)
    local playerIdStr = tostring(playerId)
    local rateConfig = RateLimits[eventName]

    if not rateConfig then
        return false
    end

    local currentTime = GetGameTimer()
    local lastCallTime = rateConfig.lastCall[playerIdStr] or 0

    if currentTime - lastCallTime < rateConfig.interval then
        if debugMode then
            DropPlayer(playerId, "[ VSX-vMenu ] Ratelimit executed")
        end
        return true
    end

    rateConfig.lastCall[playerIdStr] = currentTime
    return false
end

AddEventHandler(
    "playerDropped",
    function(reason)
        local source = source
        local playerIdStr = tostring(source)

        for eventName, rateConfig in pairs(RateLimits) do
            rateConfig.lastCall[playerIdStr] = nil
        end
    end
)

local function InitializeDebugMode()
    local debugMeta = GetResourceMetadata(GetCurrentResourceName(), "server_debug_mode", 0)
    debugMode = debugMeta and debugMeta:lower() == "true"
end

if not ConfigManager then
    ConfigManager = {}

    function ConfigManager.GetSettingsBool(setting)
        local value = GetConvar(setting, "false")
        return value:lower() == "true"
    end

    function ConfigManager.GetSettingsInt(setting)
        return GetConvarInt(setting, -1)
    end

    function ConfigManager.GetSettingsString(setting, defaultValue)
        defaultValue = defaultValue or ""
        local value = GetConvar(setting, defaultValue)
        if value == nil or value == "" then
            return nil
        end
        return value
    end

    function ConfigManager.GetTeleportLocationsData()
        local jsonFile = LoadResourceFile(GetCurrentResourceName(), "config/locations.json")
        if jsonFile and jsonFile ~= "" then
            local success, data =
                pcall(
                function()
                    return json.decode(jsonFile)
                end
            )
            if success and data and data.teleports then
                return data.teleports
            end
        end
        return {}
    end

    ConfigManager.Setting = {
        vmenu_use_permissions = "vmenu_use_permissions",
        vmenu_menu_staff_only = "vmenu_menu_staff_only"
    }
end

RegisterNetEvent(
    "vMenu:RequestPermissions",
    function()
        local source = source

        if IsRateLimited("vMenu:RequestPermissions", source) then
            return
        end

        PermissionsManager.SetPermissionsForPlayer(source)
    end
)

AddEventHandler(
    "playerJoining",
    function()
        local source = source

        TriggerClientEvent("vMenu:SyncTime", source, ServerTime.Hours, ServerTime.Minutes, ServerTime.Frozen)

        TriggerClientEvent(
            "vMenu:SyncWeather",
            source,
            ServerWeather.CurrentWeather,
            ServerWeather.DynamicEnabled,
            ServerWeather.SnowEnabled,
            ServerWeather.BlackoutEnabled,
            ServerWeather.VehicleBlackoutEnabled
        )
    end
)

ServerTime = {
    Hours = 12,
    Minutes = 0,
    Frozen = false
}

RegisterNetEvent(
    "vMenu:UpdateServerTime",
    function(hours, minutes)
        local source = source

        if not PermissionsManager.IsAllowed(PermissionsManager.Permission.TOSetTime, source) then
            return
        end

        hours = math.max(0, math.min(23, tonumber(hours) or 12))
        minutes = math.max(0, math.min(59, tonumber(minutes) or 0))

        ServerTime.Hours = hours
        ServerTime.Minutes = minutes

        WebhookLogger.Send(
            "time",
            source,
            "Time Changed",
            {
                {name = "New Time", value = string.format("%02d:%02d", hours, minutes), inline = true},
                {name = "Frozen", value = tostring(ServerTime.Frozen), inline = true}
            }
        )

        TriggerClientEvent("vMenu:SyncTime", -1, ServerTime.Hours, ServerTime.Minutes, ServerTime.Frozen)
    end
)

RegisterNetEvent(
    "vMenu:FreezeServerTime",
    function(freeze)
        local source = source

        if not PermissionsManager.IsAllowed(PermissionsManager.Permission.TOFreezeTime, source) then
            return
        end

        ServerTime.Frozen = freeze == true

        WebhookLogger.Send(
            "time",
            source,
            "Time " .. (ServerTime.Frozen and "Frozen" or "Unfrozen"),
            {
                {name = "Status", value = ServerTime.Frozen and "Frozen" or "Unfrozen", inline = true}
            }
        )

        TriggerClientEvent("vMenu:SyncTime", -1, ServerTime.Hours, ServerTime.Minutes, ServerTime.Frozen)
    end
)

RegisterNetEvent(
    "vMenu:RequestTimeSync",
    function()
        local source = source

        if IsRateLimited("vMenu:RequestTimeSync", source) then
            return
        end

        TriggerClientEvent("vMenu:SyncTime", source, ServerTime.Hours, ServerTime.Minutes, ServerTime.Frozen)
    end
)

ServerWeather = {
    CurrentWeather = "CLEAR",
    DynamicEnabled = true,
    SnowEnabled = false,
    BlackoutEnabled = false,
    VehicleBlackoutEnabled = false
}

RegisterNetEvent(
    "vMenu:UpdateServerWeather",
    function(weather, dynamicEnabled, snowEnabled)
        local source = source

        if
            not PermissionsManager.IsAllowed(PermissionsManager.Permission.WOSetWeather, source) and
                not PermissionsManager.IsAllowed(PermissionsManager.Permission.WODynamic, source)
         then
            return
        end

        ServerWeather.CurrentWeather = weather or ServerWeather.CurrentWeather
        ServerWeather.DynamicEnabled = dynamicEnabled
        ServerWeather.SnowEnabled = snowEnabled

        WebhookLogger.Send(
            "weather",
            source,
            "Weather Changed",
            {
                {name = "Weather", value = ServerWeather.CurrentWeather, inline = true},
                {name = "Dynamic", value = tostring(ServerWeather.DynamicEnabled), inline = true},
                {name = "Snow", value = tostring(ServerWeather.SnowEnabled), inline = true}
            }
        )

        TriggerClientEvent(
            "vMenu:SyncWeather",
            -1,
            ServerWeather.CurrentWeather,
            ServerWeather.DynamicEnabled,
            ServerWeather.SnowEnabled,
            ServerWeather.BlackoutEnabled,
            ServerWeather.VehicleBlackoutEnabled
        )
    end
)

RegisterNetEvent(
    "vMenu:UpdateServerBlackout",
    function(enabled)
        local source = source

        if not PermissionsManager.IsAllowed(PermissionsManager.Permission.WOBlackout, source) then
            return
        end

        ServerWeather.BlackoutEnabled = enabled == true

        WebhookLogger.Send(
            "weather",
            source,
            "Blackout " .. (ServerWeather.BlackoutEnabled and "Enabled" or "Disabled"),
            {
                {name = "Status", value = ServerWeather.BlackoutEnabled and "Enabled" or "Disabled", inline = true}
            }
        )

        TriggerClientEvent(
            "vMenu:SyncWeather",
            -1,
            ServerWeather.CurrentWeather,
            ServerWeather.DynamicEnabled,
            ServerWeather.SnowEnabled,
            ServerWeather.BlackoutEnabled,
            ServerWeather.VehicleBlackoutEnabled
        )
    end
)

RegisterNetEvent(
    "vMenu:UpdateServerVehicleBlackout",
    function(enabled)
        local source = source

        if not PermissionsManager.IsAllowed(PermissionsManager.Permission.WOVehBlackout, source) then
            return
        end

        ServerWeather.VehicleBlackoutEnabled = enabled == true

        WebhookLogger.Send(
            "weather",
            source,
            "Vehicle Blackout " .. (ServerWeather.VehicleBlackoutEnabled and "Enabled" or "Disabled"),
            {
                {
                    name = "Status",
                    value = ServerWeather.VehicleBlackoutEnabled and "Enabled" or "Disabled",
                    inline = true
                }
            }
        )

        TriggerClientEvent(
            "vMenu:SyncWeather",
            -1,
            ServerWeather.CurrentWeather,
            ServerWeather.DynamicEnabled,
            ServerWeather.SnowEnabled,
            ServerWeather.BlackoutEnabled,
            ServerWeather.VehicleBlackoutEnabled
        )
    end
)

RegisterNetEvent(
    "vMenu:RequestWeatherSync",
    function()
        local source = source
        TriggerClientEvent(
            "vMenu:SyncWeather",
            source,
            ServerWeather.CurrentWeather,
            ServerWeather.DynamicEnabled,
            ServerWeather.SnowEnabled,
            ServerWeather.BlackoutEnabled,
            ServerWeather.VehicleBlackoutEnabled
        )
    end
)

AddEventHandler(
    "onResourceStart",
    function(resourceName)
        if GetCurrentResourceName() == resourceName then
            InitializeDebugMode()
        end
    end
)

RegisterCommand(
    "vmenuserver",
    function(source, args)
        if source == 0 then
            if not args[1] then
                return
            end

            local cmd = args[1]:lower()

            if cmd == "version" then
                print(("^2vMenu version: %s^0"):format(vMenuVersion))
                if VersionCheck.Latest then
                    print(("^2Latest version: %s^0"):format(VersionCheck.Latest))
                end
            elseif cmd == "debug" then
                debugMode = not debugMode
            elseif cmd == "reload" then
                local players = GetPlayers()
                for _, playerId in ipairs(players) do
                    PermissionsManager.SetPermissionsForPlayer(playerId, true)
                end
            end
        else
            if IsPlayerAceAllowed(tostring(source), "vMenu.Everything") then
                if not args[1] then
                    TriggerClientEvent(
                        "chat:addMessage",
                        source,
                        {
                            color = {255, 0, 0},
                            multiline = true,
                            args = {"vMenu", "Available commands: version, debug, reload"}
                        }
                    )
                    return
                end

                local cmd = args[1]:lower()

                if cmd == "version" then
                    TriggerClientEvent(
                        "chat:addMessage",
                        source,
                        {
                            color = {0, 255, 0},
                            multiline = true,
                            args = {"vMenu", "Server version: " .. vMenuVersion}
                        }
                    )
                elseif cmd == "debug" then
                    debugMode = not debugMode
                    TriggerClientEvent(
                        "chat:addMessage",
                        source,
                        {
                            color = {0, 255, 0},
                            multiline = true,
                            args = {"vMenu", "Debug mode: " .. tostring(debugMode)}
                        }
                    )
                elseif cmd == "reload" then
                    local players = GetPlayers()
                    for _, playerId in ipairs(players) do
                        PermissionsManager.SetPermissionsForPlayer(playerId, true)
                    end
                    TriggerClientEvent(
                        "chat:addMessage",
                        source,
                        {
                            color = {0, 255, 0},
                            multiline = true,
                            args = {"vMenu", "Permissions reloaded for " .. #players .. " players"}
                        }
                    )
                end
            else
                TriggerClientEvent(
                    "chat:addMessage",
                    source,
                    {
                        color = {255, 0, 0},
                        multiline = true,
                        args = {"vMenu", "You do not have permission to use this command"}
                    }
                )
            end
        end
    end,
    false
)

InitializeDebugMode()

RegisterNetEvent(
    "vMenu:SummonPlayer",
    function(targetServerId)
        local source = source

        if not PermissionsManager.IsAllowed(PermissionsManager.Permission.OPSummon, source) then
            return
        end

        local adminPed = GetPlayerPed(source)
        local coords = GetEntityCoords(adminPed)

        TriggerClientEvent("vMenu:TeleportToCoords", targetServerId, coords.x, coords.y, coords.z)

        WebhookLogger.SendAction("players", source, targetServerId, "Player Summoned")
    end
)

RegisterNetEvent(
    "vMenu:KillPlayer",
    function(targetServerId)
        local source = source

        if not PermissionsManager.IsAllowed(PermissionsManager.Permission.OPKill, source) then
            return
        end

        TriggerClientEvent("vMenu:KillYourself", targetServerId, GetPlayerName(source))

        WebhookLogger.SendAction("players", source, targetServerId, "Player Killed")
    end
)

RegisterNetEvent(
    "vMenu:KickPlayer",
    function(targetServerId, reason)
        local source = source

        if not PermissionsManager.IsAllowed(PermissionsManager.Permission.OPKick, source) then
            return
        end

        reason = reason or "No reason specified"

        WebhookLogger.SendAction(
            "players",
            source,
            targetServerId,
            "Player Kicked",
            {
                {name = "Reason", value = reason}
            }
        )

        DropPlayer(targetServerId, string.format("Kicked by %s\nReason: %s", GetPlayerName(source), reason))
    end
)

RegisterNetEvent(
    "vMenu:TempBanPlayer",
    function(targetServerId, days, reason)
        local source = source

        if not PermissionsManager.IsAllowed(PermissionsManager.Permission.OPTempBan, source) then
            return
        end

        reason = reason or "No reason specified"
        days = math.min(days or 1, 30)

        local targetIdentifiers = {}
        for i = 0, GetNumPlayerIdentifiers(targetServerId) - 1 do
            local identifier = GetPlayerIdentifier(targetServerId, i)
            if identifier then
                table.insert(targetIdentifiers, identifier)
            end
        end

        local expirationTime = os.time() + (days * 24 * 60 * 60)

        WebhookLogger.SendAction(
            "bans",
            source,
            targetServerId,
            "Player Temp Banned",
            {
                {name = "Duration", value = days .. " day(s)", inline = true},
                {name = "Expires", value = os.date("%Y-%m-%d %H:%M:%S", expirationTime), inline = true},
                {name = "Reason", value = reason}
            },
            16744272
        )

        DropPlayer(
            targetServerId,
            string.format(
                "Temp Banned by %s\nReason: %s\nDuration: %d days\nExpires: %s",
                GetPlayerName(source),
                reason,
                days,
                os.date("%Y-%m-%d %H:%M:%S", expirationTime)
            )
        )
    end
)

RegisterNetEvent(
    "vMenu:PermBanPlayer",
    function(targetServerId, reason)
        local source = source

        if not PermissionsManager.IsAllowed(PermissionsManager.Permission.OPPermBan, source) then
            return
        end

        reason = reason or "No reason specified"

        local targetIdentifiers = {}
        for i = 0, GetNumPlayerIdentifiers(targetServerId) - 1 do
            local identifier = GetPlayerIdentifier(targetServerId, i)
            if identifier then
                table.insert(targetIdentifiers, identifier)
            end
        end

        WebhookLogger.SendAction(
            "bans",
            source,
            targetServerId,
            "Player Permanently Banned",
            {
                {name = "Reason", value = reason}
            }
        )

        DropPlayer(targetServerId, string.format("Permanently Banned by %s\nReason: %s", GetPlayerName(source), reason))
    end
)

RegisterNetEvent(
    "vMenu:RequestPlayerIdentifiers",
    function(targetServerId)
        local source = source

        if not PermissionsManager.IsAllowed(PermissionsManager.Permission.OPIdentifiers, source) then
            return
        end

        local identifiers = {}
        for i = 0, GetNumPlayerIdentifiers(targetServerId) - 1 do
            local identifier = GetPlayerIdentifier(targetServerId, i)
            if identifier then
                local parts = {}
                for part in string.gmatch(identifier, "[^:]+") do
                    table.insert(parts, part)
                end
                if #parts >= 2 then
                    identifiers[parts[1]] = parts[2]
                else
                    identifiers["identifier_" .. i] = identifier
                end
            end
        end

        identifiers["Server ID"] = tostring(targetServerId)
        identifiers["Player Name"] = GetPlayerName(targetServerId)
        identifiers["Ping"] = tostring(GetPlayerPing(targetServerId))
        identifiers["Endpoint"] = GetPlayerEndpoint(targetServerId) or "N/A"

        TriggerClientEvent("vMenu:ReceivePlayerIdentifiers", source, GetPlayerName(targetServerId), identifiers)
    end
)

RegisterNetEvent(
    "vMenu:RequestAllPlayers",
    function()
        local source = source

        if IsRateLimited("vMenu:RequestAllPlayers", source) then
            return
        end

        local playerList = {}

        local players = GetPlayers()

        for _, playerId in ipairs(players) do
            local serverId = tonumber(playerId)
            local playerName = GetPlayerName(serverId)

            if playerName then
                table.insert(
                    playerList,
                    {
                        serverId = serverId,
                        name = playerName
                    }
                )
            end
        end

        TriggerClientEvent("vMenu:ReceiveAllPlayers", source, playerList)
    end
)

RegisterNetEvent(
    "vMenu:LogVehicleSpawn",
    function(modelName)
        local source = source
        if not modelName or type(modelName) ~= "string" then
            return
        end
        modelName = modelName:sub(1, 64)

        WebhookLogger.Send(
            "vehicles",
            source,
            "Vehicle Spawned",
            {
                {name = "Model", value = modelName, inline = true}
            }
        )
    end
)

RegisterNetEvent(
    "vMenu:LogWeaponSpawn",
    function(weaponName)
        local source = source
        if not weaponName or type(weaponName) ~= "string" then
            return
        end
        weaponName = weaponName:sub(1, 64)

        WebhookLogger.Send(
            "weapons",
            source,
            "Weapon Spawned",
            {
                {name = "Weapon", value = weaponName, inline = true}
            }
        )
    end
)

RegisterNetEvent(
    "vMenu:LogAllWeapons",
    function()
        local source = source
        WebhookLogger.Send("weapons", source, "All Weapons Spawned", {})
    end
)

RegisterNetEvent(
    "vMenu:LogTeleport",
    function(teleportType, x, y, z)
        local source = source
        if not teleportType or type(teleportType) ~= "string" then
            return
        end

        local coordStr = "N/A"
        if type(x) == "number" and type(y) == "number" and type(z) == "number" then
            coordStr = string.format("X: %.1f | Y: %.1f | Z: %.1f", x, y, z)
        end

        WebhookLogger.Send(
            "teleport",
            source,
            "Player Teleported",
            {
                {name = "Type", value = teleportType, inline = true},
                {name = "Coords", value = coordStr}
            }
        )
    end
)

RegisterNetEvent(
    "vMenu:LogSpectate",
    function(enabled, targetName, targetServerId)
        local source = source
        local user_id = GetUserId(source)
        local fields = {
            {name = "Status", value = enabled and "Started" or "Stopped", inline = true},
            {name = "User ID", value = tostring(user_id or "N/A"), inline = true}
        }
        if enabled and targetName then
            local target_user_id = GetUserId(tonumber(targetServerId))
            table.insert(
                fields,
                {
                    name = "Target",
                    value = tostring(targetName) .. " (ID: " .. tostring(targetServerId) .. ")",
                    inline = true
                }
            )
            table.insert(fields, {name = "Target User ID", value = tostring(target_user_id or "N/A"), inline = true})
        end
        WebhookLogger.Send("spectate", source, "Spectate " .. (enabled and "Started" or "Stopped"), fields)
    end
)

RegisterNetEvent(
    "vMenu:LogPlayerOption",
    function(optionName, value)
        local source = source
        if not optionName or type(optionName) ~= "string" then
            return
        end
        optionName = optionName:sub(1, 64)

        WebhookLogger.Send(
            "misc",
            source,
            "Player Option Changed",
            {
                {name = "Option", value = optionName, inline = true},
                {name = "Value", value = tostring(value), inline = true}
            }
        )
    end
)
