CameraManager = {}

local currentCam = nil
local cameraFov = 45.0
local reverseCamera = false
local isEditorOpen = false
local activationTime = 0

local currentCamPos = vector3(0.0, 0.0, 0.0)
local currentLookAtPos = vector3(0.0, 0.0, 0.0)
local targetCamPos = vector3(0.0, 0.0, 0.0)
local targetLookAtPos = vector3(0.0, 0.0, 0.0)
local cameraLerpSpeed = 0.015
local cameraTransitionLerpSpeed = 0.01
local isTransitioning = false
local lastCameraIndex = 2

local cameraOffsets = {
    { position = vector3(0.0, 2.8, 0.3),   lookAt = vector3(0.0, 0.0, 0.0) },
    { position = vector3(0.0, 0.9, 0.65),  lookAt = vector3(0.0, 0.0, 0.6) },
    { position = vector3(0.0, 1.4, 0.5),   lookAt = vector3(0.0, 0.0, 0.3) },
    { position = vector3(0.0, 1.6, -0.3),  lookAt = vector3(0.0, 0.0, -0.45) },
    { position = vector3(0.0, 0.98, -0.7), lookAt = vector3(0.0, 0.0, -0.90) },
    { position = vector3(0.0, 0.98, 0.1),  lookAt = vector3(0.0, 0.0, 0.0) },
    { position = vector3(0.0, 1.3, 0.35),  lookAt = vector3(0.0, 0.0, 0.15) }
}

local rotationOffsets = {
    { x = 2.2,  y = -1.0 },
    { x = 0.7,  y = -0.45 },
    { x = 1.35, y = -0.4 },
    { x = 1.0,  y = -0.4 },
    { x = 0.9,  y = -0.4 },
    { x = 0.8,  y = -0.7 },
    { x = 1.5,  y = -1.0 }
}

Lerp = (function(a, b, t)
    return a + (b - a) * t
end)

LerpVector3 = (function(v1, v2, t)
    return vector3(
        Lerp(v1.x, v2.x, t),
        Lerp(v1.y, v2.y, t),
        Lerp(v1.z, v2.z, t)
    )
end)

IsMpEditorMenuOpen = (function()
    if not MenuController:IsAnyMenuOpen() then
        return false
    end

    local currentMenu = MenuController:GetCurrentMenu()
    if not currentMenu then
        return false
    end

    local title = currentMenu.MenuTitle
    local subtitle = currentMenu.Subtitle

    if title == "Create Character" or
        title == "Character Inheritance" or
        title == "Character Appearance" or
        title == "Face Shape Features" or
        title == "Character Tattoo Options" or
        title == "Character Clothes" or
        title == "Character Props" then
        return true
    end

    if subtitle == "Parents and genetics" or
        subtitle == "Hair, overlays, and features" or
        subtitle == "Facial feature adjustments" or
        subtitle == "Manage tattoos" or
        subtitle == "Customize clothing" or
        subtitle == "Hats, glasses, and accessories" or
        subtitle == "Customize your character" then
        return true
    end

    return false
end)

function CameraManager.ActivateCamera()
    if not DoesCamExist(currentCam) then
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)

        currentCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)

        local initialCameraIndex = 1
        local offset = cameraOffsets[initialCameraIndex]
        local camPos = GetOffsetFromEntityInWorldCoords(ped, offset.position.x, offset.position.y, offset.position.z)
        local lookAtPos = GetOffsetFromEntityInWorldCoords(ped, offset.lookAt.x, offset.lookAt.y, offset.lookAt.z)

        currentCamPos = camPos
        currentLookAtPos = lookAtPos
        targetCamPos = camPos
        targetLookAtPos = lookAtPos
        lastCameraIndex = initialCameraIndex

        SetCamCoord(currentCam, camPos.x, camPos.y, camPos.z)
        PointCamAtCoord(currentCam, lookAtPos.x, lookAtPos.y, lookAtPos.z)
        SetCamFov(currentCam, cameraFov)
        SetCamActive(currentCam, true)
        RenderScriptCams(true, false, 0, true, false)

        isEditorOpen = true
        reverseCamera = false
        activationTime = GetGameTimer()
    end
end

function CameraManager.DeactivateCamera()
    if DoesCamExist(currentCam) then
        SetCamActive(currentCam, false)
        RenderScriptCams(false, false, 0, true, false)
        DestroyCam(currentCam, false)
        currentCam = nil
        isEditorOpen = false
        reverseCamera = false
        activationTime = 0
    end
end

function CameraManager.UpdateCamera(index)
    if not DoesCamExist(currentCam) then
        return
    end

    local ped = PlayerPedId()
    local offset = cameraOffsets[index]

    local posMultiplier = reverseCamera and -1.0 or 1.0
    local camPos = GetOffsetFromEntityInWorldCoords(ped,
        offset.position.x * posMultiplier,
        offset.position.y * posMultiplier,
        offset.position.z)

    local lookAtPos = GetOffsetFromEntityInWorldCoords(ped,
        offset.lookAt.x * posMultiplier,
        offset.lookAt.y * posMultiplier,
        offset.lookAt.z)

    local newCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(newCam, camPos.x, camPos.y, camPos.z)
    PointCamAtCoord(newCam, lookAtPos.x, lookAtPos.y, lookAtPos.z)
    SetCamFov(newCam, cameraFov)
    SetCamActive(newCam, true)

    SetCamActiveWithInterp(newCam, currentCam, 1000, 1, 1)

    Wait(1000)

    DestroyCam(currentCam, false)
    currentCam = newCam
end

function CameraManager.GetCameraIndex(menu, itemIndex)
    if not menu then
        return 2
    end

    local menuTitle = menu.MenuTitle

    if menuTitle == "Character Appearance" then
        if itemIndex >= 1 and itemIndex <= 28 then
            return 2
        elseif itemIndex >= 29 and itemIndex <= 33 then
            return 3
        elseif itemIndex == 34 then
            return 2
        end
        return 2

    elseif menuTitle == "Character Inheritance" then
        return 2

    elseif menuTitle == "Face Shape Features" then
        return 2

    elseif menuTitle == "Character Clothes" then
        if itemIndex == 1 then
            return 2
        elseif itemIndex == 2 then
            return 3
        elseif itemIndex == 3 then
            return 4
        elseif itemIndex == 4 then
            return 3
        elseif itemIndex == 5 then
            return 5
        elseif itemIndex >= 6 and itemIndex <= 7 then
            return 3
        elseif itemIndex >= 8 and itemIndex <= 10 then
            return 3
        end
        return 3

    elseif menuTitle == "Character Props" then
        if itemIndex <= 3 then
            return 2
        elseif itemIndex == 4 then
            return reverseCamera and 6 or 7
        elseif itemIndex == 5 then
            return 6
        end
        return 2

    elseif menuTitle == "Character Tattoo Options" then
        if itemIndex == 1 then
            return 2
        elseif itemIndex == 2 then
            return 3
        elseif itemIndex >= 3 and itemIndex <= 4 then
            return 7
        elseif itemIndex >= 5 and itemIndex <= 6 then
            return 4
        elseif itemIndex == 7 then
            return 3
        end
        return 2

    elseif menuTitle == "Create Character" then
        return 2

    else
        return 2
    end
end

local pedHeadingRotationRate = 2.5

local CONTROL_MOVE_DOWN = 31
local CONTROL_MOVE_DOWN_ONLY = 269
local CONTROL_MOVE_LEFT = 34
local CONTROL_MOVE_LEFT_ONLY = 270
local CONTROL_MOVE_LEFT_RIGHT = 30
local CONTROL_MOVE_RIGHT = 35
local CONTROL_MOVE_RIGHT_ONLY = 271
local CONTROL_MOVE_UP = 32
local CONTROL_MOVE_UP_DOWN = 31
local CONTROL_MOVE_UP_ONLY = 268
local CONTROL_NEXT_CAMERA = 0
local CONTROL_LOOK_BEHIND = 26
local CONTROL_LOOK_DOWN = 18
local CONTROL_LOOK_DOWN_ONLY = 273
local CONTROL_LOOK_LEFT = 16
local CONTROL_LOOK_LEFT_ONLY = 274
local CONTROL_LOOK_LEFT_RIGHT = 17
local CONTROL_LOOK_RIGHT = 15
local CONTROL_LOOK_RIGHT_ONLY = 275
local CONTROL_LOOK_UP = 14
local CONTROL_LOOK_UP_DOWN = 13
local CONTROL_LOOK_UP_ONLY = 276
local CONTROL_AIM = 25
local CONTROL_ACCURATE_AIM = 50
local CONTROL_COVER = 44
local CONTROL_DUCK = 36
local CONTROL_JUMP = 22
local CONTROL_SELECT_NEXT_WEAPON = 99
local CONTROL_PREV_WEAPON = 81
local CONTROL_WEAPON_SPECIAL = 47
local CONTROL_WEAPON_SPECIAL2 = 48
local CONTROL_WEAPON_WHEEL_LEFT_RIGHT = 156
local CONTROL_WEAPON_WHEEL_NEXT = 14
local CONTROL_WEAPON_WHEEL_PREV = 15
local CONTROL_WEAPON_WHEEL_UP_DOWN = 155
local CONTROL_VEHICLE_EXIT = 75
local CONTROL_ENTER = 23

local CONTROL_INPUT_COVER = 44
local CONTROL_INPUT_CONTEXT = 51

Citizen.CreateThread((function()
    while true do
        Wait(0)

        if isEditorOpen then
            local ped = PlayerPedId()

            FreezeEntityPosition(ped, true)
            local coords = GetEntityCoords(ped)
            RequestCollisionAtCoord(coords.x, coords.y, coords.z)

            if not HasAnimDictLoaded("anim@random@shop_clothes@watches") then
                RequestAnimDict("anim@random@shop_clothes@watches")
            end

            local currentMenu = MenuController:GetCurrentMenu()
            if currentMenu then
                local currentIndex = currentMenu.CurrentIndex or 1

                local cameraIndex = CameraManager.GetCameraIndex(currentMenu, currentIndex)

                local xOffset = 0.0
                local yOffset = 0.0

                if (IsControlPressed(0, 51) or IsControlPressed(0, 44)) and not (IsControlPressed(0, 51) and IsControlPressed(0, 44)) then
                    local offset = rotationOffsets[cameraIndex]
                    xOffset = offset.x
                    yOffset = offset.y

                    if IsControlPressed(0, 44) then
                        xOffset = xOffset * -1.0
                    end
                end

                local camOffset = cameraOffsets[cameraIndex]
                local posMultiplier = reverseCamera and -1.0 or 1.0

                targetCamPos = GetOffsetFromEntityInWorldCoords(ped,
                    (camOffset.position.x + xOffset) * posMultiplier,
                    (camOffset.position.y + yOffset) * posMultiplier,
                    camOffset.position.z)

                targetLookAtPos = GetOffsetFromEntityInWorldCoords(ped,
                    camOffset.lookAt.x * posMultiplier,
                    camOffset.lookAt.y * posMultiplier,
                    camOffset.lookAt.z)

                if cameraIndex ~= lastCameraIndex then
                    isTransitioning = true
                    lastCameraIndex = cameraIndex
                end

                local lerpSpeed = cameraLerpSpeed
                if isTransitioning then
                    lerpSpeed = cameraTransitionLerpSpeed
                    local dist = #(currentCamPos - targetCamPos)
                    if dist < 0.01 then
                        isTransitioning = false
                    end
                end

                currentCamPos = LerpVector3(currentCamPos, targetCamPos, lerpSpeed)
                currentLookAtPos = LerpVector3(currentLookAtPos, targetLookAtPos, lerpSpeed)

                if DoesCamExist(currentCam) then
                    SetCamCoord(currentCam, currentCamPos.x, currentCamPos.y, currentCamPos.z)
                    PointCamAtCoord(currentCam, currentLookAtPos.x, currentLookAtPos.y, currentLookAtPos.z)
                end

                if IsControlJustReleased(0, 22) then
                    local pos = GetEntityCoords(ped)
                    FreezeEntityPosition(ped, false)

                    local heading = GetEntityHeading(ped)
                    TaskGoStraightToCoord(ped, pos.x, pos.y, pos.z, 8.0, 1600, heading + 180.0, 0.1)

                    local timer = GetGameTimer()
                    while true do
                        Wait(0)
                        DisableAllControlActions(0)
                        RequestCollisionAtCoord(pos.x, pos.y, pos.z)
                        if GetGameTimer() - timer > 1600 then
                            break
                        end
                    end

                    ClearPedTasks(ped)
                    SetEntityCoordsNoOffset(ped, pos.x, pos.y, pos.z, false, false, false)
                    FreezeEntityPosition(ped, true)
                    reverseCamera = not reverseCamera
                end

                local menuTitle = currentMenu.MenuTitle
                if menuTitle == "Character Props" and currentIndex == 4 and not reverseCamera then
                    if not IsEntityPlayingAnim(ped, "anim@random@shop_clothes@watches", "BASE", 3) then
                        TaskPlayAnim(ped, "anim@random@shop_clothes@watches", "BASE", 8.0, -8.0, -1, 1, 0, false, false,
                            false)
                    end
                else
                    if IsEntityPlayingAnim(ped, "anim@random@shop_clothes@watches", "BASE", 3) then
                        ClearPedTasks(ped)
                    end
                end

                if IsControlPressed(0, CONTROL_MOVE_LEFT_ONLY) then
                    local lookPos = GetOffsetFromEntityInWorldCoords(ped, 1.2, 0.5, 0.7)
                    TaskLookAtCoord(ped, lookPos.x, lookPos.y, lookPos.z, 1100, 0, 2)
                elseif IsControlPressed(0, CONTROL_MOVE_RIGHT_ONLY) then
                    local lookPos = GetOffsetFromEntityInWorldCoords(ped, -1.2, 0.5, 0.7)
                    TaskLookAtCoord(ped, lookPos.x, lookPos.y, lookPos.z, 1100, 0, 2)
                else
                    local lookPos = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.5, 0.7)
                    TaskLookAtCoord(ped, lookPos.x, lookPos.y, lookPos.z, 1100, 0, 2)
                end
            end
        else
            Wait(500)
        end
    end
end))

Citizen.CreateThread((function()
    while true do
        Wait(0)

        if isEditorOpen then
            DisableControlAction(0, CONTROL_MOVE_DOWN, true)
            DisableControlAction(0, CONTROL_MOVE_DOWN_ONLY, true)
            DisableControlAction(0, CONTROL_MOVE_LEFT, true)
            DisableControlAction(0, CONTROL_MOVE_LEFT_ONLY, true)
            DisableControlAction(0, CONTROL_MOVE_LEFT_RIGHT, true)
            DisableControlAction(0, CONTROL_MOVE_RIGHT, true)
            DisableControlAction(0, CONTROL_MOVE_RIGHT_ONLY, true)
            DisableControlAction(0, CONTROL_MOVE_UP, true)
            DisableControlAction(0, CONTROL_MOVE_UP_DOWN, true)
            DisableControlAction(0, CONTROL_MOVE_UP_ONLY, true)

            DisableControlAction(0, CONTROL_NEXT_CAMERA, true)
            DisableControlAction(0, CONTROL_LOOK_BEHIND, true)
            DisableControlAction(0, CONTROL_LOOK_DOWN, true)
            DisableControlAction(0, CONTROL_LOOK_DOWN_ONLY, true)
            DisableControlAction(0, CONTROL_LOOK_LEFT, true)
            DisableControlAction(0, CONTROL_LOOK_LEFT_ONLY, true)
            DisableControlAction(0, CONTROL_LOOK_LEFT_RIGHT, true)
            DisableControlAction(0, CONTROL_LOOK_RIGHT, true)
            DisableControlAction(0, CONTROL_LOOK_RIGHT_ONLY, true)
            DisableControlAction(0, CONTROL_LOOK_UP, true)
            DisableControlAction(0, CONTROL_LOOK_UP_DOWN, true)
            DisableControlAction(0, CONTROL_LOOK_UP_ONLY, true)

            DisableControlAction(0, CONTROL_AIM, true)
            DisableControlAction(0, CONTROL_ACCURATE_AIM, true)
            DisableControlAction(0, CONTROL_DUCK, true)
            DisableControlAction(0, CONTROL_SELECT_NEXT_WEAPON, true)
            DisableControlAction(0, CONTROL_PREV_WEAPON, true)
            DisableControlAction(0, CONTROL_WEAPON_SPECIAL, true)
            DisableControlAction(0, CONTROL_WEAPON_SPECIAL2, true)
            DisableControlAction(0, CONTROL_WEAPON_WHEEL_LEFT_RIGHT, true)
            DisableControlAction(0, CONTROL_WEAPON_WHEEL_NEXT, true)
            DisableControlAction(0, CONTROL_WEAPON_WHEEL_PREV, true)
            DisableControlAction(0, CONTROL_WEAPON_WHEEL_UP_DOWN, true)

            DisableControlAction(0, CONTROL_VEHICLE_EXIT, true)
            DisableControlAction(0, CONTROL_ENTER, true)
        else
            Wait(500)
        end
    end
end))

Citizen.CreateThread((function()
    while true do
        Wait(2000)

        if isEditorOpen then
            local timeSinceActivation = GetGameTimer() - activationTime
            if timeSinceActivation < 5000 then
                goto continue
            end

            if not IsMpEditorMenuOpen() then
                CameraManager.DeactivateCamera()
                local ped = PlayerPedId()
                SetEntityCollision(ped, true, true)
                FreezeEntityPosition(ped, false)
                ClearPedTasks(ped)

                if HasAnimDictLoaded("anim@random@shop_clothes@watches") then
                    RemoveAnimDict("anim@random@shop_clothes@watches")
                end
            end
        end

        ::continue::
    end
end))

return CameraManager
