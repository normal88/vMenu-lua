PedPreview = {}

PedPreview.DISTANCE = 4.2
PedPreview.MENU_GAP = 0.02
PedPreview.ROTATE_SPEED = 120.0
PedPreview.VEHICLE_SCREEN_HALF = 0.11
PedPreview.VEHICLE_ANGLE = 35.0
PedPreview.VEHICLE_DISTANCE = 7.0
PedPreview.VEHICLE_ALPHA = 250

local resolvers = setmetatable({}, { __mode = "k" })
local previewEntity = nil
local previewKind = "ped"
local previewRadius = nil
local previewCenterZ = 0.0
local shownData, shownVersion, shownKind = nil, nil, nil
local generation = 0
local extraHeading = 0.0

function PedPreview.Register(menu, resolver)
    resolvers[menu] = resolver
end

function PedPreview.IsShowing()
    return previewEntity ~= nil and DoesEntityExist(previewEntity)
end

local function DeleteEntityPreview()
    if previewEntity and DoesEntityExist(previewEntity) then
        DeleteEntity(previewEntity)
    end
    previewEntity = nil
end

function PedPreview.Hide()
    generation = generation + 1
    shownData, shownVersion, shownKind = nil, nil, nil
    previewRadius = nil
    DeleteEntityPreview()
end

local function GetPlacement()
    local camPos = GetFinalRenderedCamCoord()
    local rot = GetFinalRenderedCamRot(2)
    local pitch, yaw = math.rad(rot.x), math.rad(rot.z)

    local forward = vector3(-math.sin(yaw) * math.cos(pitch), math.cos(yaw) * math.cos(pitch), math.sin(pitch))
    local right = vector3(math.cos(yaw), math.sin(yaw), 0.0)
    local up = vector3(
        right.y * forward.z - right.z * forward.y,
        right.z * forward.x - right.x * forward.z,
        right.x * forward.y - right.y * forward.x
    )

    local tanHalfV = math.tan(math.rad(GetFinalRenderedCamFov()) / 2.0)
    local tanHalfH = tanHalfV * GetAspectRatio(false)

    local dist, extent, scale = PedPreview.DISTANCE, 0.4, 1.0
    if previewKind == "vehicle" and previewRadius then
        dist = PedPreview.VEHICLE_DISTANCE
        extent = 2.0 * PedPreview.VEHICLE_SCREEN_HALF * dist * tanHalfH
        scale = extent / previewRadius
    end

    local margin = (1.0 - GetSafeZoneSize()) / 2.0
    local menuWidth = Menu.WIDTH / MenuController.ScreenWidth
    local halfWidth = extent / (2.0 * dist * tanHalfH)
    local screenX
    if MenuController:GetMenuAlignment() == "left" then
        screenX = margin + menuWidth + PedPreview.MENU_GAP + halfWidth
    else
        screenX = 1.0 - margin - menuWidth - PedPreview.MENU_GAP - halfWidth
    end
    screenX = screenX + MenuController.OffsetX
    local swap = menuWidth + 2.0 * (PedPreview.MENU_GAP + halfWidth)
    if screenX - halfWidth < 0.0 then
        screenX = screenX + swap
    elseif screenX + halfWidth > 1.0 then
        screenX = screenX - swap
    end

    local side = (screenX * 2.0 - 1.0) * dist * tanHalfH
    local pos = camPos + forward * dist + right * side - up * (0.12 * dist * tanHalfV)
    return pos, rot.z + 180.0, camPos, scale
end

local function CreatePreviewEntity(kind, hash, pos, heading)
    if kind == "vehicle" then
        local vehicle = CreateVehicle(hash, pos.x, pos.y, pos.z, heading, false, false)
        SetEntityVisible(vehicle, false, false)
        SetEntityCollision(vehicle, false, false)
        FreezeEntityPosition(vehicle, true)
        SetEntityInvincible(vehicle, true)
        SetEntityCanBeDamaged(vehicle, false)
        SetVehicleEngineOn(vehicle, false, true, true)
        SetVehicleDoorsLocked(vehicle, 2)
        SetVehicleRadioEnabled(vehicle, false)
        SetVehicleHasBeenOwnedByPlayer(vehicle, false)
        return vehicle
    end

    local ped = CreatePed(4, hash, pos.x, pos.y, pos.z, heading, false, false)
    SetEntityVisible(ped, false, false)
    SetEntityCollision(ped, false, false)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetEntityCanBeDamaged(ped, false)
    SetPedCanRagdoll(ped, false)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedDefaultComponentVariation(ped)
    return ped
end

local function Spawn(data, model, apply, version, kind)
    generation = generation + 1
    local gen = generation
    shownData, shownVersion, shownKind = data, version, kind
    extraHeading = kind == "vehicle" and PedPreview.VEHICLE_ANGLE or 0.0
    DeleteEntityPreview()

    Citizen.CreateThread(function()
        local hash = model
        if type(hash) == "string" then
            hash = tonumber(hash) or GetHashKey(hash)
        end
        if not hash or not IsModelInCdimage(hash) or not IsModelValid(hash) then return end
        if kind == "vehicle" and not IsModelAVehicle(hash) then return end

        RequestModel(hash)
        local timeout = GetGameTimer() + 5000
        while not HasModelLoaded(hash) do
            if gen ~= generation or GetGameTimer() > timeout then return end
            Wait(0)
        end
        if gen ~= generation then
            SetModelAsNoLongerNeeded(hash)
            return
        end

        previewKind = kind
        previewRadius = nil
        previewCenterZ = 0.0
        if kind == "vehicle" then
            local min, max = GetModelDimensions(hash)
            local size = max - min
            previewRadius = math.sqrt(size.x * size.x + size.y * size.y) / 2.0
            previewCenterZ = (min.z + max.z) / 2.0
        end

        local pos, heading = GetPlacement()
        local entity = CreatePreviewEntity(kind, hash, pos, heading + extraHeading)
        SetModelAsNoLongerNeeded(hash)
        previewEntity = entity

        if apply then
            pcall(apply, entity, data)
        end

        timeout = GetGameTimer() + 3000
        if kind == "vehicle" then
            local ready = GetGameTimer() + 250
            while gen == generation and DoesEntityExist(entity) and GetGameTimer() < ready do
                Wait(0)
            end
        else
            while gen == generation and DoesEntityExist(entity) and not HaveAllStreamingRequestsCompleted(entity)
                and GetGameTimer() < timeout do
                Wait(0)
            end
        end

        if gen ~= generation or not DoesEntityExist(entity) then
            if DoesEntityExist(entity) then DeleteEntity(entity) end
            return
        end

        if kind == "vehicle" then
            SetEntityAlpha(entity, PedPreview.VEHICLE_ALPHA, false)
        else
            TaskStandStill(entity, -1)
        end
        SetEntityVisible(entity, true, false)
    end)
end

local function UpdatePreview()
    if not previewEntity or not DoesEntityExist(previewEntity) then return end

    DisableControlAction(0, 44, true)
    DisableControlAction(0, 38, true)
    local step = PedPreview.ROTATE_SPEED * GetFrameTime()
    if IsDisabledControlPressed(0, 44) then extraHeading = extraHeading - step end
    if IsDisabledControlPressed(0, 38) then extraHeading = extraHeading + step end

    local pos, heading, camPos, scale = GetPlacement()
    SetEntityCoordsNoOffset(previewEntity, pos.x, pos.y, pos.z, false, false, false)
    SetEntityHeading(previewEntity, heading + extraHeading)

    local toCam = camPos - pos
    if previewKind == "vehicle" then
        local x, y, z = GetEntityMatrix(previewEntity)
        local origin = pos - z * (previewCenterZ * scale)
        x, y, z = x * scale, y * scale, z * scale
        SetEntityMatrix(previewEntity, x.x, x.y, x.z, y.x, y.y, y.z, z.x, z.y, z.z, origin.x, origin.y, origin.z)

        local light = pos + toCam * 0.25 + vector3(0.0, 0.0, 0.3)
        DrawLightWithRange(light.x, light.y, light.z, 255, 255, 255, #toCam * 0.25 + 1.0, 2.0)
        return
    end

    local light = pos + toCam * 0.4 + vector3(0.0, 0.0, 0.6)
    DrawLightWithRange(light.x, light.y, light.z, 255, 255, 255, 3.5, 1.2)
end

Citizen.CreateThread(function()
    while true do
        local sleep = 200
        local menu = MenuController:IsAnyMenuOpen() and MenuController:GetCurrentMenu() or nil
        local resolver = menu and resolvers[menu]
        local data, model, apply, version, kind
        if resolver and not IsPauseMenuActive() then
            data, model, apply, version, kind = resolver(menu)
        end
        kind = kind or "ped"

        if data and MiscSettingsMenu then
            local enabled
            if kind == "vehicle" then
                enabled = MiscSettingsMenu.VehiclePreviews == true
            else
                enabled = MiscSettingsMenu.MPPedPreviews ~= false
            end
            if not enabled then data = nil end
        end

        if data then
            if data ~= shownData or version ~= shownVersion or kind ~= shownKind then
                Spawn(data, model, apply, version, kind)
            end
            UpdatePreview()
            sleep = 0
        elseif shownData then
            PedPreview.Hide()
        end

        Citizen.Wait(sleep)
    end
end)

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        DeleteEntityPreview()
    end
end)

return PedPreview
