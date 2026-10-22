OnlinePlayersMenu = {}

local menu = nil
local playerMenu = nil
local currentPlayer = nil
local spectatingPlayer = nil
local PlayersWaypointList = {}
local PlayerCoordWaypoints = {}

local cachedPlayerList = {}

function OnlinePlayersMenu.CreateMenu()
    menu = Menu:New("Online Players", "Online Players")
    MenuController:AddMenu(menu)

    playerMenu = Menu:New("Online Players", "Player:")
    MenuController:AddMenu(playerMenu)

    OnlinePlayersMenu.SetupPlayerMenu()

    menu.OnMenuOpen = function(sender)
        local nearbyOnly = ConfigManager.GetSettingsBool(ConfigManager.Setting.vmenu_online_players_nearby_only)

        if nearbyOnly then
            OnlinePlayersMenu.UpdatePlayerListLocal()
        else
            TriggerServerEvent("vMenu:RequestAllPlayers")
        end
    end

    return menu
end

function OnlinePlayersMenu.SetupPlayerMenu()
    local sendMessageBtn = nil
    if PermissionsManager.IsAllowed(PermissionsManager.Permission.OPSendMessage) then
        sendMessageBtn = MenuItem:New("Send Private Message",
            "Sends a private message to this player. ~r~Note: staff may be able to see all PM's.")
        playerMenu:AddMenuItem(sendMessageBtn)
    end

    local teleportToBtn = nil
    local teleportVehBtn = nil
    if PermissionsManager.IsAllowed(PermissionsManager.Permission.OPTeleport) then
        teleportToBtn = MenuItem:New("Teleport To Player", "Teleport to this player.")
        teleportVehBtn = MenuItem:New("Teleport Into Player Vehicle", "Teleport into the vehicle of the player.")
        playerMenu:AddMenuItem(teleportToBtn)
        playerMenu:AddMenuItem(teleportVehBtn)
    end

    local summonBtn = nil
    if PermissionsManager.IsAllowed(PermissionsManager.Permission.OPSummon) then
        summonBtn = MenuItem:New("Summon Player", "Teleport the player to you.")
        playerMenu:AddMenuItem(summonBtn)
    end

    local spectateBtn = nil
    if PermissionsManager.IsAllowed(PermissionsManager.Permission.OPSpectate) then
        spectateBtn = MenuItem:New("Spectate Player", "Spectate this player. Click this button again to stop spectating.")
        playerMenu:AddMenuItem(spectateBtn)
    end

    local toggleGpsBtn = nil
    if PermissionsManager.IsAllowed(PermissionsManager.Permission.OPWaypoint) then
        toggleGpsBtn = MenuItem:New("Toggle GPS", "Enables or disables the GPS route on your radar to this player.")
        playerMenu:AddMenuItem(toggleGpsBtn)
    end

    local identifiersBtn = nil
    if PermissionsManager.IsAllowed(PermissionsManager.Permission.OPIdentifiers) then
        identifiersBtn = MenuItem:New("Print Identifiers",
            "This will print the player's identifiers to the client console (F8). And also save it to the CitizenFX.log file.")
        playerMenu:AddMenuItem(identifiersBtn)
    end

    local killBtn = nil
    if PermissionsManager.IsAllowed(PermissionsManager.Permission.OPKill) then
        killBtn = MenuItem:New("~r~Kill Player",
            "Kill this player, note they will receive a notification saying that you killed them. It will also be logged in the Staff Actions log.")
        playerMenu:AddMenuItem(killBtn)
    end

    local kickBtn = nil
    if PermissionsManager.IsAllowed(PermissionsManager.Permission.OPKick) then
        kickBtn = MenuItem:New("~r~Kick Player", "Kick the player from the server.")
        playerMenu:AddMenuItem(kickBtn)
    end

    local tempBanBtn = nil
    if PermissionsManager.IsAllowed(PermissionsManager.Permission.OPTempBan) then
        tempBanBtn = MenuItem:New("~r~Ban Player Temporarily",
            "Give this player a tempban of up to 30 days (max). You can specify duration and reason after clicking this button.")
        playerMenu:AddMenuItem(tempBanBtn)
    end

    local permBanBtn = nil
    if PermissionsManager.IsAllowed(PermissionsManager.Permission.OPPermBan) then
        permBanBtn = MenuItem:New("~r~Ban Player Permanently",
            "Ban this player permanently from the server. Are you sure you want to do this? You can specify the ban reason after clicking this button.")
        permBanBtn.LeftIcon = Icon.WARNING
        playerMenu:AddMenuItem(permBanBtn)
    end

    playerMenu.OnMenuClose = function(sender)
        if permBanBtn then permBanBtn.Label = "" end
    end

    playerMenu.OnIndexChange = function(sender, oldItem, newItem, oldIndex, newIndex)
        if permBanBtn then permBanBtn.Label = "" end
    end

    playerMenu.OnItemSelect = function(sender, item, index)
        if not currentPlayer then return end

        local myPlayerId = PlayerId()
        local myServerId = GetPlayerServerId(myPlayerId)
        local targetServerId = currentPlayer.serverId

        local targetPlayerId = nil
        for _, pid in ipairs(GetActivePlayers()) do
            if GetPlayerServerId(pid) == targetServerId then
                targetPlayerId = pid
                break
            end
        end

        if item == sendMessageBtn then
            if targetServerId == myServerId then
                Notify.Error("You cannot message yourself!")
                return
            end

            DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 200)
            while UpdateOnscreenKeyboard() == 0 do
                Wait(0)
            end
            if GetOnscreenKeyboardResult() then
                local message = GetOnscreenKeyboardResult()
                if message and message ~= "" then
                    TriggerServerEvent("vMenu:SendPrivateMessage", targetServerId, message)
                    Notify.Success("Private message sent to ~y~" .. currentPlayer.name)
                end
            end

        elseif item == teleportToBtn then
            if targetServerId == myServerId then
                Notify.Error("You can not teleport to yourself!")
                return
            end

            if targetPlayerId then
                local targetPed = GetPlayerPed(targetPlayerId)
                if DoesEntityExist(targetPed) then
                    local targetCoords = GetEntityCoords(targetPed)
                    SetEntityCoords(PlayerPedId(), targetCoords.x, targetCoords.y, targetCoords.z, false, false, false,
                        false)
                    Notify.Success("Teleported to ~y~" .. currentPlayer.name)
                else
                    Notify.Error("Could not find player.")
                end
            else
                Notify.Error("Player is not in range.")
            end

        elseif item == teleportVehBtn then
            if targetServerId == myServerId then
                Notify.Error("You can not teleport to yourself!")
                return
            end

            if targetPlayerId then
                local targetPed = GetPlayerPed(targetPlayerId)
                if DoesEntityExist(targetPed) then
                    local targetVehicle = GetVehiclePedIsIn(targetPed, false)
                    if targetVehicle ~= 0 then
                        local maxSeats = GetVehicleMaxNumberOfPassengers(targetVehicle)
                        local freeSeat = nil
                        for i = -1, maxSeats do
                            if IsVehicleSeatFree(targetVehicle, i) then
                                freeSeat = i
                                break
                            end
                        end
                        if freeSeat then
                            SetPedIntoVehicle(PlayerPedId(), targetVehicle, freeSeat)
                            Notify.Success("Teleported into ~y~" .. currentPlayer.name .. "'s~s~ vehicle.")
                        else
                            Notify.Error("No free seats in the vehicle.")
                        end
                    else
                        Notify.Error("This player is not in a vehicle.")
                    end
                else
                    Notify.Error("Could not find player.")
                end
            else
                Notify.Error("Player is not in range.")
            end

        elseif item == summonBtn then
            if targetServerId == myServerId then
                Notify.Error("You can't summon yourself.")
                return
            end
            TriggerServerEvent("vMenu:SummonPlayer", targetServerId)
            Notify.Success("Summoned ~y~" .. currentPlayer.name)

        elseif item == spectateBtn then
            if spectatingPlayer == targetServerId then
                spectatingPlayer = nil
                NetworkSetInSpectatorMode(false, PlayerPedId())
                TriggerServerEvent("vMenu:LogSpectate", false)
                Notify.Info("Stopped spectating.")
            else
                if targetPlayerId then
                    local targetPed = GetPlayerPed(targetPlayerId)
                    if DoesEntityExist(targetPed) then
                        spectatingPlayer = targetServerId
                        NetworkSetInSpectatorMode(true, targetPed)
                        TriggerServerEvent("vMenu:LogSpectate", true, currentPlayer.name, targetServerId)
                        Notify.Info("Now spectating ~y~" .. currentPlayer.name)
                    else
                        Notify.Error("Could not find player.")
                    end
                else
                    Notify.Error("Player is not in range.")
                end
            end

        elseif item == toggleGpsBtn then
            if targetServerId == myServerId then
                Notify.Error("You can not set a waypoint to yourself.")
                return
            end

            local alreadyActive = false
            for i, serverId in ipairs(PlayersWaypointList) do
                if serverId == targetServerId then
                    alreadyActive = true
                    table.remove(PlayersWaypointList, i)
                    break
                end
            end

            if #PlayersWaypointList > 0 or alreadyActive then
                for serverId, blip in pairs(PlayerCoordWaypoints) do
                    if DoesBlipExist(blip) then
                        SetBlipRoute(blip, false)
                        RemoveBlip(blip)
                    end
                end
                PlayerCoordWaypoints = {}

                for _, serverId in ipairs(PlayersWaypointList) do
                    local playerId = GetPlayerFromServerId(serverId)
                    if playerId >= 0 then
                        local playerPed = GetPlayerPed(playerId)
                        if DoesEntityExist(playerPed) then
                            local blip = GetBlipFromEntity(playerPed)
                            if DoesBlipExist(blip) then
                                SetBlipRoute(blip, false)
                            end
                        end
                    end
                end
            end

            if not alreadyActive then
                if targetPlayerId then
                    local targetPed = GetPlayerPed(targetPlayerId)
                    if DoesEntityExist(targetPed) then
                        local blip = GetBlipFromEntity(targetPed)
                        if not DoesBlipExist(blip) then
                            blip = AddBlipForEntity(targetPed)
                        end
                        SetBlipColour(blip, 58)
                        SetBlipRouteColour(blip, 58)
                        SetBlipRoute(blip, true)
                        table.insert(PlayersWaypointList, targetServerId)
                        Notify.Custom("~g~GPS route to ~s~<C>" .. currentPlayer.name .. "</C>~g~ is now active.")
                    end
                else
                    Notify.Error("Player is not in range.")
                end
            else
                Notify.Custom("~g~GPS route to ~s~<C>" .. currentPlayer.name .. "</C>~g~ is now disabled.")
            end

        elseif item == identifiersBtn then
            TriggerServerEvent("vMenu:RequestPlayerIdentifiers", targetServerId)

        elseif item == killBtn then
            TriggerServerEvent("vMenu:KillPlayer", targetServerId)
            Notify.Success("Killed ~y~" .. currentPlayer.name)

        elseif item == kickBtn then
            if targetServerId == myServerId then
                Notify.Error("You cannot kick yourself!")
                return
            end

            DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 200)
            while UpdateOnscreenKeyboard() == 0 do
                Wait(0)
            end
            if GetOnscreenKeyboardResult() then
                local reason = GetOnscreenKeyboardResult()
                if reason and reason ~= "" then
                    TriggerServerEvent("vMenu:KickPlayer", targetServerId, reason)
                    Notify.Success("Kicked ~y~" .. currentPlayer.name)
                end
            end

        elseif item == tempBanBtn then
            DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 3)
            while UpdateOnscreenKeyboard() == 0 do
                Wait(0)
            end
            if GetOnscreenKeyboardResult() then
                local daysInput = GetOnscreenKeyboardResult()
                local days = tonumber(daysInput)
                if days and days > 0 and days <= 30 then
                    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 200)
                    while UpdateOnscreenKeyboard() == 0 do
                        Wait(0)
                    end
                    if GetOnscreenKeyboardResult() then
                        local reason = GetOnscreenKeyboardResult()
                        if reason and reason ~= "" then
                            TriggerServerEvent("vMenu:TempBanPlayer", targetServerId, days, reason)
                            Notify.Success("Temp banned ~y~" .. currentPlayer.name .. "~s~ for " .. days .. " days.")
                        end
                    end
                else
                    Notify.Error("Invalid duration. Must be between 1 and 30 days.")
                end
            end

        elseif item == permBanBtn then
            if item.Label == "Are you sure?" then
                item.Label = ""
                DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 200)
                while UpdateOnscreenKeyboard() == 0 do
                    Wait(0)
                end
                if GetOnscreenKeyboardResult() then
                    local reason = GetOnscreenKeyboardResult()
                    if reason and reason ~= "" then
                        TriggerServerEvent("vMenu:PermBanPlayer", targetServerId, reason)
                        Notify.Success("Permanently banned ~y~" .. currentPlayer.name)
                        TriggerServerEvent("vMenu:RequestAllPlayers")
                        playerMenu:GoBack()
                    end
                end
            else
                item.Label = "Are you sure?"
            end
        end
    end
end

function OnlinePlayersMenu.UpdatePlayerList()
    if not menu then return end

    menu:ClearMenuItems()

    local playerList = {}
    for _, p in ipairs(cachedPlayerList) do
        table.insert(playerList, p)
    end

    table.sort(playerList, function(a, b)
        return (a.name or ""):lower() < (b.name or ""):lower()
    end)

    for _, playerData in ipairs(playerList) do
        local pItem = MenuItem:New(playerData.name,
            "Click to view options for this player. Server ID: " .. playerData.serverId .. ".")
        pItem.Label = "Server #" .. playerData.serverId .. " →→→"
        pItem.ItemData = playerData
        menu:AddMenuItem(pItem)
        MenuController:BindMenuItem(menu, playerMenu, pItem)
    end

    menu.MenuSubtitle ="~b~Players: ~s~" .. #playerList
end

function OnlinePlayersMenu.UpdatePlayerListLocal()
    if not menu then return end

    menu:ClearMenuItems()

    local players = GetActivePlayers()
    local playerList = {}

    for _, playerId in ipairs(players) do
        local playerName = GetPlayerName(playerId)
        local playerServerId = GetPlayerServerId(playerId)

        if playerName and playerServerId > 0 then
            table.insert(playerList, {
                id = playerId,
                serverId = playerServerId,
                name = playerName
            })
        end
    end

    table.sort(playerList, function(a, b)
        return (a.name or ""):lower() < (b.name or ""):lower()
    end)

    for _, playerData in ipairs(playerList) do
        local pItem = MenuItem:New(playerData.name,
            "Click to view options for this player. Server ID: " .. playerData.serverId .. ".")
        pItem.Label = "Server #" .. playerData.serverId .. " →→→"
        pItem.ItemData = playerData
        menu:AddMenuItem(pItem)
        MenuController:BindMenuItem(menu, playerMenu, pItem)
    end

    menu.MenuSubtitle ="~b~Nearby Players: ~s~" .. #playerList
end

function OnlinePlayersMenu.GetMenu()
    if menu == nil then
        OnlinePlayersMenu.CreateMenu()
    end

    return menu
end

RegisterNetEvent("vMenu:ReceiveAllPlayers", function(playerList)
    cachedPlayerList = playerList or {}

    OnlinePlayersMenu.UpdatePlayerList()
end)

Citizen.CreateThread((function()
    Wait(1000)

    while not menu do
        Wait(100)
    end

    menu.OnItemSelect = function(sender, item, index)
        if item.ItemData then
            currentPlayer = item.ItemData
            playerMenu.MenuSubtitle = "~s~Player: ~y~" .. currentPlayer.name
        end
    end
end))

Citizen.CreateThread((function()
    while true do
        local sleep = 1000

        if spectatingPlayer then
            sleep = 0
            local found = false

            for _, playerId in ipairs(GetActivePlayers()) do
                if GetPlayerServerId(playerId) == spectatingPlayer then
                    local targetPed = GetPlayerPed(playerId)
                    if DoesEntityExist(targetPed) then
                        NetworkSetInSpectatorMode(true, targetPed)
                        found = true
                    end
                    break
                end
            end

            if not found then
                spectatingPlayer = nil
                NetworkSetInSpectatorMode(false, PlayerPedId())
                Notify.Info("Stopped spectating (player left).")
            end
        end

        Citizen.Wait(sleep)
    end
end))

RegisterNetEvent("vMenu:ReceivePlayerIdentifiers", function(playerName, identifiers)
    Notify.Success("Identifiers printed to console (F8).")
end)

RegisterNetEvent("vMenu:GetCoordsForSummon", function(targetServerId)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    TriggerServerEvent("vMenu:ExecuteSummon", targetServerId, {
        x = coords.x,
        y = coords.y,
        z = coords.z
    })
end)

RegisterNetEvent("vMenu:TeleportToCoords", function(x, y, z)
    local ped = PlayerPedId()
    SetEntityCoords(ped, x, y, z, false, false, false, false)
    Notify.Info("You have been summoned by an admin.")
end)

RegisterNetEvent("vMenu:KillYourself", function(killerName)
    local ped = PlayerPedId()
    PlayerOptionsMenu.PlayerGodMode = false
    SetEntityInvincible(ped, false)
    SetEntityHealth(ped, 0)
    Notify.Error("You were killed by ~y~" .. killerName)
end)

return OnlinePlayersMenu
