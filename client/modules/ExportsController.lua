vMenuDisabled = false

local function ResetPlayerOptions()
    if not PlayerOptionsMenu then return end

    PlayerOptionsMenu.PlayerGodMode       = false
    PlayerOptionsMenu.PlayerInvisible     = false
    PlayerOptionsMenu.PlayerStamina       = false
    PlayerOptionsMenu.PlayerFastRun       = false
    PlayerOptionsMenu.PlayerFastSwim      = false
    PlayerOptionsMenu.PlayerSuperJump     = false
    PlayerOptionsMenu.PlayerNoRagdoll     = false
    PlayerOptionsMenu.PlayerNeverWanted   = false
    PlayerOptionsMenu.PlayerIsIgnored     = false
    PlayerOptionsMenu.PlayerStayInVehicle = false
    PlayerOptionsMenu.PlayerFrozen        = false

    local ped      = PlayerPedId()
    local playerId = PlayerId()

    SetEntityInvincible(ped, false)
    SetEntityVisible(ped, true, false)
    SetLocalPlayerVisibleLocally(false)
    ResetEntityAlpha(ped)
    SetRunSprintMultiplierForPlayer(playerId, 1.0)
    SetSwimMultiplierForPlayer(playerId, 1.0)
    SetPedCanRagdoll(ped, true)
    ClearPlayerWantedLevel(playerId)
    SetEveryoneIgnorePlayer(playerId, false)
    SetPoliceIgnorePlayer(playerId, false)
    SetPedCanBeDraggedOut(ped, true)
    FreezeEntityPosition(ped, false)
end

local function ResetWeaponOptions()
    if not WeaponOptionsMenu then return end

    WeaponOptionsMenu.UnlimitedAmmo       = false
    WeaponOptionsMenu.NoReload            = false
    WeaponOptionsMenu.UnlimitedParachutes = false
    WeaponOptionsMenu.AutoEquipChute      = false

    local ped = PlayerPedId()
    SetPedInfiniteAmmoClip(ped, false)
end

local function ResetVehicleOptions()
    if not VehicleOptionsMenu then return end

    VehicleOptionsMenu.VehicleGodMode               = false
    VehicleOptionsMenu.VehicleGodInvincible         = false
    VehicleOptionsMenu.VehicleGodEngine             = false
    VehicleOptionsMenu.VehicleGodVisual             = false
    VehicleOptionsMenu.VehicleGodStrongWheels       = false
    VehicleOptionsMenu.VehicleGodRamp               = false
    VehicleOptionsMenu.VehicleGodAutoRepair         = false
    VehicleOptionsMenu.VehicleNeverDirty            = false
    VehicleOptionsMenu.VehicleEngineAlwaysOn        = false
    VehicleOptionsMenu.VehicleNoSiren               = false
    VehicleOptionsMenu.VehicleNoBikeHelmets         = false
    VehicleOptionsMenu.VehicleBikeSeatbelt          = false
    VehicleOptionsMenu.VehicleShowHealth            = false
    VehicleOptionsMenu.VehicleInfiniteFuel          = false
    VehicleOptionsMenu.VehicleFrozen                = false
    VehicleOptionsMenu.VehicleInvisible             = false
    VehicleOptionsMenu.FlashHighbeamsOnHonk         = false
    VehicleOptionsMenu.DisablePlaneTurbulence       = false
    VehicleOptionsMenu.DisableHelicopterTurbulence  = false
    VehicleOptionsMenu.TorqueEnabled                = false
    VehicleOptionsMenu.PowerEnabled                 = false
    VehicleOptionsMenu.SpeedLimitEnabled            = false

    local ped = PlayerPedId()
    if not IsPedInAnyVehicle(ped, false) then return end

    local vehicle = GetVehiclePedIsIn(ped, false)
    if not DoesEntityExist(vehicle) then return end

    SetEntityInvincible(vehicle, false)
    SetVehicleCanBeVisiblyDamaged(vehicle, true)
    SetVehicleWheelsCanBreak(vehicle, true)
    SetVehicleEngineTorqueMultiplier(vehicle, 1.0)
    SetVehicleEnginePowerMultiplier(vehicle, 1.0)
    FreezeEntityPosition(vehicle, false)
    SetEntityVisible(vehicle, true, false)
    ResetEntityAlpha(vehicle)
    SetVehicleHasMutedSirens(vehicle, false)
end

local function CloseAllMenus()
    if not MenuController then return end
    for _, openMenu in ipairs(MenuController.VisibleMenus or {}) do
        if openMenu and openMenu.CloseMenu then
            openMenu:CloseMenu()
        end
    end
end

local function DisableVMenu()
    if vMenuDisabled then return end
    vMenuDisabled = true

    CloseAllMenus()
    Noclip.Disable()
    ResetPlayerOptions()
    ResetWeaponOptions()
    ResetVehicleOptions()
end

local function EnableVMenu()
    vMenuDisabled = false
end

local function IsVMenuDisabled()
    return vMenuDisabled
end

exports("DisableVMenu",    DisableVMenu)
exports("EnableVMenu",     EnableVMenu)
exports("IsVMenuDisabled", IsVMenuDisabled)
