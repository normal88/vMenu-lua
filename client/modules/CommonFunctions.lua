CommonFunctions = {}

local currentScenario = ""
local previousVehicle = nil
CommonFunctions.DriveToWpTaskActive = false
CommonFunctions.DriveWanderTaskActive = false

function CommonFunctions.StringToArray(str)
    local result = {}
    local maxLength = 99

    for i = 1, #str, maxLength do
        table.insert(result, string.sub(str, i, i + maxLength - 1))
    end

    return result
end

function CommonFunctions.ToggleVehicleAlarm(vehicle)
    if vehicle ~= nil and DoesEntityExist(vehicle) then
        if IsVehicleAlarmActivated(vehicle) then
            SetVehicleAlarm(vehicle, false)
            SetVehicleAlarmTimeLeft(vehicle, 0)
        else
            SetVehicleAlarm(vehicle, true)
            SetVehicleAlarmTimeLeft(vehicle, math.random(8000, 45000))
            StartVehicleAlarm(vehicle)
        end
    end
end

function CommonFunctions.LockOrUnlockDoors(vehicle, lockDoors)
    if vehicle ~= nil and DoesEntityExist(vehicle) then
        Citizen.CreateThread(function()
            for i = 1, 2 do
                local timer = GetGameTimer()
                while GetGameTimer() - timer < 50 do
                    SoundVehicleHornThisFrame(vehicle)
                    Wait(0)
                end
                Wait(50)
            end

            if lockDoors then
                Subtitle.Custom("Vehicle doors are now locked.")
                SetVehicleDoorsLockedForAllPlayers(vehicle, true)
            else
                Subtitle.Custom("Vehicle doors are now unlocked.")
                SetVehicleDoorsLockedForAllPlayers(vehicle, false)
            end
        end)
    end
end

function CommonFunctions.GetVehDisplayNameFromModel(modelName)
    local hash = GetHashKey(modelName)
    local displayName = GetDisplayNameFromVehicleModel(hash)
    return GetLabelText(displayName)
end

function CommonFunctions.DoesModelExist(model)
    if type(model) == "string" then
        model = GetHashKey(model)
    end
    return IsModelInCdimage(model)
end

function CommonFunctions.GetVehicle(lastVehicle)
    lastVehicle = lastVehicle or false
    local ped = PlayerPedId()

    if lastVehicle then
        return GetVehiclePedIsIn(ped, true)
    else
        if IsPedInAnyVehicle(ped, false) then
            return GetVehiclePedIsIn(ped, false)
        end
    end

    return nil
end

function CommonFunctions.GetVehicleForPed(ped, lastVehicle)
    lastVehicle = lastVehicle or false

    if lastVehicle then
        return GetVehiclePedIsIn(ped, true)
    else
        if IsPedInAnyVehicle(ped, false) then
            return GetVehiclePedIsIn(ped, false)
        end
    end

    return nil
end

function CommonFunctions.GetVehicleModel(vehicle)
    return GetEntityModel(vehicle)
end

function CommonFunctions.IsPedPointing(ped)
    return IsTaskMoveNetworkActive(ped)
end

function CommonFunctions.GetPointingPitch()
    local pitch = GetGameplayCamRelativePitch()

    if pitch < -70.0 then
        pitch = -70.0
    elseif pitch > 42.0 then
        pitch = 42.0
    end

    pitch = pitch + 70.0
    pitch = pitch / 112.0

    return pitch
end

function CommonFunctions.GetPointingHeading()
    local heading = GetGameplayCamRelativeHeading()

    if heading < -180.0 then
        heading = -180.0
    elseif heading > 180.0 then
        heading = 180.0
    end

    heading = heading + 180.0
    heading = heading / 360.0
    heading = heading * -1.0
    heading = heading + 1.0

    return heading
end

function CommonFunctions.DriveToWp(style)
    style = style or 0

    local ped = PlayerPedId()
    ClearPedTasks(ped)
    CommonFunctions.DriveWanderTaskActive = false
    CommonFunctions.DriveToWpTaskActive = true

    local waypoint = GetBlipInfoIdCoord(GetFirstBlipInfoId(8))
    local vehicle = CommonFunctions.GetVehicle()
    local model = GetEntityModel(vehicle)

    SetDriverAbility(ped, 1.0)
    SetDriverAggressiveness(ped, 0.0)

    TaskVehicleDriveToCoordLongrange(ped, vehicle, waypoint.x, waypoint.y, waypoint.z, GetVehicleModelMaxSpeed(model),
        style, 10.0)
end

function CommonFunctions.DriveWander(style)
    style = style or 0

    local ped = PlayerPedId()
    ClearPedTasks(ped)
    CommonFunctions.DriveWanderTaskActive = true
    CommonFunctions.DriveToWpTaskActive = false

    local vehicle = CommonFunctions.GetVehicle()
    local model = GetEntityModel(vehicle)

    SetDriverAbility(ped, 1.0)
    SetDriverAggressiveness(ped, 0.0)

    TaskVehicleDriveWander(ped, vehicle, GetVehicleModelMaxSpeed(model), style)
end

function CommonFunctions.QuitSession()
    NetworkSessionEnd(true, true)
end

function CommonFunctions.QuitGame()
    Notify.Info("The game will exit in 5 seconds.")

    Citizen.SetTimeout(5000, function()
        ForceSocialClubUpdate()
    end)
end

function CommonFunctions.TeleportToCoords(coords, heading)
    heading = heading or 0.0

    Citizen.CreateThread((function()
        local ped = PlayerPedId()
        local vehicle = CommonFunctions.GetVehicle()

        DoScreenFadeOut(500)
        while not IsScreenFadedOut() do
            Wait(0)
        end

        RequestCollisionAtCoord(coords.x, coords.y, coords.z)

        if vehicle ~= nil then
            SetEntityCoords(vehicle, coords.x, coords.y, coords.z, false, false, false, false)
            SetEntityHeading(vehicle, heading)
        else
            SetEntityCoords(ped, coords.x, coords.y, coords.z, false, false, false, false)
            SetEntityHeading(ped, heading)
        end

        local startTime = GetGameTimer()
        while not HasCollisionLoadedAroundEntity(ped) and (GetGameTimer() - startTime) < 5000 do
            Wait(0)
        end

        DoScreenFadeIn(500)
        while not IsScreenFadedIn() do
            Wait(0)
        end
    end))
end

function CommonFunctions.TeleportToPlayer(playerId, inVehicle)
    inVehicle = inVehicle or false

    local targetPed = GetPlayerPed(playerId)
    if not DoesEntityExist(targetPed) then
        Notify.Error(CommonErrors.PlayerNotFound)
        return
    end

    local ped = PlayerPedId()
    if targetPed == ped then
        Notify.Error("Sorry, you can ~r~~h~not~h~ ~s~teleport to yourself!")
        return
    end

    local targetCoords = GetEntityCoords(targetPed)

    CommonFunctions.TeleportToCoords(targetCoords, 0.0)

    if inVehicle then
        Citizen.CreateThread((function()
            Wait(500)

            if IsPedInAnyVehicle(targetPed, false) then
                local targetVehicle = GetVehiclePedIsIn(targetPed, false)

                if DoesEntityExist(targetVehicle) and IsAnyVehicleSeatEmpty(targetVehicle) then
                    TaskWarpPedIntoVehicle(ped, targetVehicle, -2)
                    Notify.Success("Teleported into player's vehicle.")
                else
                    Notify.Error("No empty seats available in the vehicle!")
                end
            end
        end))
    else
        Notify.Success("Teleported to player.")
    end
end

function CommonFunctions.TeleportToWp()
    local waypoint = GetBlipInfoIdCoord(GetFirstBlipInfoId(8))

    if waypoint.x == 0.0 and waypoint.y == 0.0 then
        Notify.Error("No waypoint has been set!")
        return
    end

    local ped = PlayerPedId()
    local vehicle = CommonFunctions.GetVehicle()
    local height = 1000.0
    local foundGround, groundZ = GetGroundZFor_3dCoord(waypoint.x, waypoint.y, height, false)

    if foundGround then
        height = groundZ
    else
        height = waypoint.z
    end

    local coords = vector3(waypoint.x, waypoint.y, height)
    CommonFunctions.TeleportToCoords(coords, 0.0)

    Notify.Success("Teleported to waypoint.")
end

function CommonFunctions.LoadAnimDict(dict)
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)
        local timeout = 0
        while not HasAnimDictLoaded(dict) and timeout < 100 do
            Wait(10)
            timeout = timeout + 1
        end
    end
end

function CommonFunctions.LoadModel(model)
    if type(model) == "string" then
        model = GetHashKey(model)
    end

    if not HasModelLoaded(model) then
        RequestModel(model)
        local timeout = 0
        while not HasModelLoaded(model) and timeout < 100 do
            Wait(10)
            timeout = timeout + 1
        end
    end

    return HasModelLoaded(model)
end

function CommonFunctions.SpawnVehicle(modelName, coords, heading, callback)
    if not CommonFunctions.DoesModelExist(modelName) then
        Notify.Error(CommonErrors.InvalidModel, true, true, modelName)
        return
    end

    local modelHash = GetHashKey(modelName)

    if CommonFunctions.LoadModel(modelHash) then
        local vehicle = CreateVehicle(modelHash, coords.x, coords.y, coords.z, heading, true, false)

        SetModelAsNoLongerNeeded(modelHash)

        if callback then
            callback(vehicle)
        end

        return vehicle
    else
        Notify.Error("Failed to load vehicle model: " .. modelName)
        return nil
    end
end

function CommonFunctions.GetCurrentScenario()
    return currentScenario
end

function CommonFunctions.SetCurrentScenario(scenario)
    currentScenario = scenario
end

function CommonFunctions.ClearCurrentScenario()
    local ped = PlayerPedId()
    ClearPedTasks(ped)
    ClearPedSecondaryTask(ped)
    currentScenario = ""
end

function CommonFunctions.PlayScenario(scenarioName)
    local ped = PlayerPedId()

    if IsPedInAnyVehicle(ped, false) then
        Notify.Error("You cannot play scenarios while in a vehicle!")
        return
    end

    CommonFunctions.ClearCurrentScenario()
    TaskStartScenarioInPlace(ped, scenarioName, 0, true)
    currentScenario = scenarioName
end

return CommonFunctions
