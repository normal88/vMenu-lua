Noclip = {}

local noClipEnabled = false
local followCamMode = true
local currentScalefrom = -1
local movingSpeed = 2
local lastToggleTime = 0

local movingSpeeds = {
    [0] = 'Very Slow',
    [1] = 'Slow',
    [2] = 'Normal',
    [3] = 'Fast',
    [4] = 'Very Fast',
    [5] = 'Extremely Fast',
    [6] = 'Staggeringly Fast',
    [7] = 'Max Speed'
}

function Noclip.Enable()
    if noClipEnabled then
        return
    end

    noClipEnabled = true

    currentScalefrom = RequestScaleformMovie('INSTRUCTIONAL_BUTTONS')
    while not HasScaleformMovieLoaded(currentScalefrom) do
        Wait(0)
    end

    DrawScaleformMovieFullscreen(currentScalefrom, 255, 255, 255, 0, 0)
end

function Noclip.Disable()
    if not noClipEnabled then
        return
    end

    noClipEnabled = false

    local ped = PlayerPedId()
    local entity = IsPedInAnyVehicle(ped, false) and GetVehiclePedIsIn(ped, false) or ped
    if IsEntityPositionFrozen(entity) then
        FreezeEntityPosition(entity, false)
    end

    if currentScalefrom ~= -1 then
        SetScaleformMovieAsNoLongerNeeded(currentScalefrom)
    end
    currentScalefrom = -1
end

function Noclip.Toggle()
    local currentTime = GetGameTimer()
    if currentTime - lastToggleTime < 200 then
        return
    end
    lastToggleTime = currentTime

    if noClipEnabled then
        Noclip.Disable()
    else
        Noclip.Enable()
    end
end

function Noclip.IsNoclipActive()
    return noClipEnabled
end

function Noclip.SetNoclipActive(active)
    if active then
        Noclip.Enable()
    else
        Noclip.Disable()
    end
end

Citizen.CreateThread((function()
    while true do
        if noClipEnabled then
            if not IsHudHidden() and currentScalefrom ~= -1 then
                BeginScaleformMovieMethod(currentScalefrom, 'CLEAR_ALL')
                EndScaleformMovieMethod()

                BeginScaleformMovieMethod(currentScalefrom, 'SET_DATA_SLOT')
                ScaleformMovieMethodAddParamInt(0)
                ScaleformMovieMethodAddParamTextureNameString('~INPUT_SPRINT~')
                ScaleformMovieMethodAddParamTextureNameString(('Change Speed (%s)'):format(movingSpeeds[movingSpeed]))
                EndScaleformMovieMethod()

                BeginScaleformMovieMethod(currentScalefrom, 'SET_DATA_SLOT')
                ScaleformMovieMethodAddParamInt(1)
                ScaleformMovieMethodAddParamTextureNameString('~INPUT_MOVE_LR~')
                ScaleformMovieMethodAddParamTextureNameString('Turn Left/Right')
                EndScaleformMovieMethod()

                BeginScaleformMovieMethod(currentScalefrom, 'SET_DATA_SLOT')
                ScaleformMovieMethodAddParamInt(2)
                ScaleformMovieMethodAddParamTextureNameString('~INPUT_MOVE_UD~')
                ScaleformMovieMethodAddParamTextureNameString('Move')
                EndScaleformMovieMethod()

                BeginScaleformMovieMethod(currentScalefrom, 'SET_DATA_SLOT')
                ScaleformMovieMethodAddParamInt(3)
                ScaleformMovieMethodAddParamTextureNameString('~INPUT_MULTIPLAYER_INFO~')
                ScaleformMovieMethodAddParamTextureNameString('Down')
                EndScaleformMovieMethod()

                BeginScaleformMovieMethod(currentScalefrom, 'SET_DATA_SLOT')
                ScaleformMovieMethodAddParamInt(4)
                ScaleformMovieMethodAddParamTextureNameString('~INPUT_COVER~')
                ScaleformMovieMethodAddParamTextureNameString('Up')
                EndScaleformMovieMethod()

                BeginScaleformMovieMethod(currentScalefrom, 'SET_DATA_SLOT')
                ScaleformMovieMethodAddParamInt(5)
                ScaleformMovieMethodAddParamTextureNameString('~INPUT_VEH_HEADLIGHT~')
                ScaleformMovieMethodAddParamTextureNameString('Cam Mode')
                EndScaleformMovieMethod()

                BeginScaleformMovieMethod(currentScalefrom, 'DRAW_INSTRUCTIONAL_BUTTONS')
                ScaleformMovieMethodAddParamInt(0)
                EndScaleformMovieMethod()

                DrawScaleformMovieFullscreen(currentScalefrom, 255, 255, 255, 255, 0)
            end

            local ped = PlayerPedId()
            local noclipEntity = IsPedInAnyVehicle(ped, false) and GetVehiclePedIsIn(ped, false) or ped

            if not IsEntityPositionFrozen(noclipEntity) then
                FreezeEntityPosition(noclipEntity, true)
            end
            SetEntityInvincible(noclipEntity, true)

            local aPressed = IsControlPressed(0, 34) or GetDisabledControlNormal(0, 34) > 0.0 or
            IsDisabledControlPressed(0, 34)
            local dPressed = IsControlPressed(0, 35) or GetDisabledControlNormal(0, 35) > 0.0 or
            IsDisabledControlPressed(0, 35)

            local currentHeading = GetEntityHeading(noclipEntity)
            local newHeading = currentHeading

            DisableControlAction(0, 20, true)
            DisableControlAction(0, 30, true)
            DisableControlAction(0, 31, true)
            DisableControlAction(0, 32, true)
            DisableControlAction(0, 33, true)
            DisableControlAction(0, 34, true)
            DisableControlAction(0, 35, true)
            DisableControlAction(0, 44, true)
            DisableControlAction(0, 74, true)
            if IsPedInAnyVehicle(ped, false) then
                DisableControlAction(0, 75, true)
                DisableControlAction(0, 85, true)
            end
            DisableControlAction(0, 266, true)
            DisableControlAction(0, 267, true)
            DisableControlAction(0, 268, true)
            DisableControlAction(0, 269, true)

            local yOff = 0.0
            local zOff = 0.0

            if IsUsingKeyboard(2) and UpdateOnscreenKeyboard() ~= 0 and not IsPauseMenuActive() then
                if IsControlJustPressed(0, 21) then
                    movingSpeed = movingSpeed + 1
                    if movingSpeed >= 8 then
                        movingSpeed = 0
                    end
                end

                if IsDisabledControlPressed(0, 32) then
                    yOff = 0.5
                end
                if IsDisabledControlPressed(0, 33) then
                    yOff = -0.5
                end

                if not followCamMode and (aPressed or dPressed) then
                    if aPressed then
                        newHeading = currentHeading + 3.0
                    end
                    if dPressed then
                        newHeading = currentHeading - 3.0
                    end
                end

                if IsDisabledControlPressed(0, 44) then
                    zOff = 0.21
                end
                if IsDisabledControlPressed(0, 20) then
                    zOff = -0.21
                end

                if IsDisabledControlJustPressed(0, 74) then
                    followCamMode = not followCamMode
                    Notify.Info("Cam Mode: ~b~" .. (followCamMode and "Follow" or "Manual"))
                end
            end

            local moveSpeed = movingSpeed
            if movingSpeed > 4 then
                moveSpeed = moveSpeed * 1.8
            end
            moveSpeed = moveSpeed / (1 / GetFrameTime()) * 60

            local newPos = GetOffsetFromEntityInWorldCoords(
                noclipEntity,
                0.0,
                yOff * (moveSpeed + 0.3),
                zOff * (moveSpeed + 0.3)
            )

            SetEntityVelocity(noclipEntity, 0.0, 0.0, 0.0)

            SetEntityRotation(noclipEntity, 0.0, 0.0, 0.0, 0, false)

            SetEntityHeading(noclipEntity, followCamMode and GetGameplayCamRelativeHeading() or newHeading)

            SetEntityCollision(noclipEntity, false, false)

            SetEntityCoordsNoOffset(noclipEntity, newPos.x, newPos.y, newPos.z, true, true, true)

            SetEntityVisible(noclipEntity, false, false)
            SetLocalPlayerVisibleLocally(true)
            SetEntityAlpha(noclipEntity, 51, false)

            SetEveryoneIgnorePlayer(ped, true)
            SetPoliceIgnorePlayer(ped, true)

            Wait(0)

            SetEntityInvincible(noclipEntity, false)
            SetEntityCollision(noclipEntity, true, true)

            SetEntityVisible(noclipEntity, true, false)
            SetLocalPlayerVisibleLocally(true)
            ResetEntityAlpha(noclipEntity)

            SetEveryoneIgnorePlayer(ped, false)
            SetPoliceIgnorePlayer(ped, false)
        else
            Wait(100)
        end
    end
end))

function Noclip.GetSpeed()
    return movingSpeed
end

function Noclip.SetSpeed(speed)
    if type(speed) == "number" then
        movingSpeed = math.max(0, math.min(7, math.floor(speed)))
    end
end

function Noclip.GetFollowCam()
    return followCamMode
end

function Noclip.SetFollowCam(val)
    followCamMode = (val == true)
end

exports('ToggleNoClip', Noclip.Toggle)
exports('IsNoClipActive', Noclip.IsNoclipActive)

return Noclip
