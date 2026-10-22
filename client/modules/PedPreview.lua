PedPreview = {}

PedPreview.DISTANCE = 4.2
PedPreview.MENU_GAP = 0.02
PedPreview.ROTATE_SPEED = 120.0

local resolvers = setmetatable({}, { __mode = "k" })
local previewPed = nil
local shownData, shownVersion = nil, nil
local generation = 0
local extraHeading = 0.0

function PedPreview.Register(menu, resolver)
    resolvers[menu] = resolver
end

function PedPreview.IsShowing()
    return previewPed ~= nil and DoesEntityExist(previewPed)
end

local function DeletePed()
    if previewPed and DoesEntityExist(previewPed) then
        DeleteEntity(previewPed)
    end
    previewPed = nil
end

function PedPreview.Hide()
    generation = generation + 1
    shownData, shownVersion = nil, nil
    DeletePed()
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

    local dist = PedPreview.DISTANCE
    local tanHalfV = math.tan(math.rad(GetFinalRenderedCamFov()) / 2.0)
    local tanHalfH = tanHalfV * GetAspectRatio(false)

    local margin = (1.0 - GetSafeZoneSize()) / 2.0
    local menuWidth = Menu.WIDTH / MenuController.ScreenWidth
    local pedHalfWidth = 0.4 / (2.0 * dist * tanHalfH)
    local screenX
    if MenuController:GetMenuAlignment() == "left" then
        screenX = margin + menuWidth + PedPreview.MENU_GAP + pedHalfWidth
    else
        screenX = 1.0 - margin - menuWidth - PedPreview.MENU_GAP - pedHalfWidth
    end
    screenX = screenX + MenuController.OffsetX
    local swap = menuWidth + 2.0 * (PedPreview.MENU_GAP + pedHalfWidth)
    if screenX - pedHalfWidth < 0.0 then
        screenX = screenX + swap
    elseif screenX + pedHalfWidth > 1.0 then
        screenX = screenX - swap
    end

    local side = (screenX * 2.0 - 1.0) * dist * tanHalfH
    local pos = camPos + forward * dist + right * side - up * (0.12 * dist * tanHalfV)
    return pos, rot.z + 180.0, camPos
end

local function Spawn(data, model, apply, version)
    generation = generation + 1
    local gen = generation
    shownData, shownVersion = data, version
    extraHeading = 0.0
    DeletePed()

    Citizen.CreateThread(function()
        local hash = model
        if type(hash) == "string" then
            hash = tonumber(hash) or GetHashKey(hash)
        end
        if not hash or not IsModelInCdimage(hash) or not IsModelValid(hash) then return end

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

        local pos, heading = GetPlacement()
        local ped = CreatePed(4, hash, pos.x, pos.y, pos.z, heading, false, false)
        SetModelAsNoLongerNeeded(hash)
        previewPed = ped

        SetEntityVisible(ped, false, false)
        SetEntityCollision(ped, false, false)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetEntityCanBeDamaged(ped, false)
        SetPedCanRagdoll(ped, false)
        SetBlockingOfNonTemporaryEvents(ped, true)
        SetPedDefaultComponentVariation(ped)

        if apply then
            local ok, err = pcall(apply, ped, data)
        end

        timeout = GetGameTimer() + 3000
        while gen == generation and DoesEntityExist(ped) and not HaveAllStreamingRequestsCompleted(ped)
            and GetGameTimer() < timeout do
            Wait(0)
        end

        if gen ~= generation or not DoesEntityExist(ped) then
            if DoesEntityExist(ped) then DeleteEntity(ped) end
            return
        end

        TaskStandStill(ped, -1)
        SetEntityVisible(ped, true, false)
    end)
end

local function UpdatePed()
    if not previewPed or not DoesEntityExist(previewPed) then return end

    DisableControlAction(0, 44, true)
    DisableControlAction(0, 38, true)
    local step = PedPreview.ROTATE_SPEED * GetFrameTime()
    if IsDisabledControlPressed(0, 44) then extraHeading = extraHeading - step end
    if IsDisabledControlPressed(0, 38) then extraHeading = extraHeading + step end

    local pos, heading, camPos = GetPlacement()
    SetEntityCoordsNoOffset(previewPed, pos.x, pos.y, pos.z, false, false, false)
    SetEntityHeading(previewPed, heading + extraHeading)

    local toCam = camPos - pos
    local light = pos + toCam * 0.4 + vector3(0.0, 0.0, 0.6)
    DrawLightWithRange(light.x, light.y, light.z, 255, 255, 255, 3.5, 1.2)
end

Citizen.CreateThread(function()
    while true do
        local sleep = 200
        local menu = MenuController:IsAnyMenuOpen() and MenuController:GetCurrentMenu() or nil
        local resolver = menu and resolvers[menu]
        local enabled = not MiscSettingsMenu or MiscSettingsMenu.MPPedPreviews ~= false

        local data, model, apply, version
        if resolver and enabled and not IsPauseMenuActive() then
            data, model, apply, version = resolver(menu)
        end

        if data then
            if data ~= shownData or version ~= shownVersion then
                Spawn(data, model, apply, version)
            end
            UpdatePed()
            sleep = 0
        elseif shownData then
            PedPreview.Hide()
        end

        Citizen.Wait(sleep)
    end
end)

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        DeletePed()
    end
end)

return PedPreview
