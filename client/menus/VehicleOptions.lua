VehicleOptionsMenu = {}

local menu = nil
local godModeMenu = nil
local modMenu = nil
local doorsMenu = nil
local windowsMenu = nil
local extrasMenu = nil
local liveriesMenu = nil
local colorsMenu = nil
local underglowMenu = nil

VehicleOptionsMenu.VehicleGodMode = false
VehicleOptionsMenu.VehicleGodInvincible = false
VehicleOptionsMenu.VehicleGodEngine = false
VehicleOptionsMenu.VehicleGodVisual = false
VehicleOptionsMenu.VehicleGodStrongWheels = false
VehicleOptionsMenu.VehicleGodRamp = false
VehicleOptionsMenu.VehicleGodAutoRepair = false

VehicleOptionsMenu.VehicleNeverDirty = false
VehicleOptionsMenu.VehicleEngineAlwaysOn = false
VehicleOptionsMenu.VehicleNoSiren = false
VehicleOptionsMenu.VehicleNoBikeHelmets = false
VehicleOptionsMenu.VehicleBikeSeatbelt = false
VehicleOptionsMenu.VehicleShowHealth = false
VehicleOptionsMenu.VehicleInfiniteFuel = false
VehicleOptionsMenu.VehicleFrozen = false
VehicleOptionsMenu.VehicleInvisible = false
VehicleOptionsMenu.FlashHighbeamsOnHonk = false
VehicleOptionsMenu.DisablePlaneTurbulence = false
VehicleOptionsMenu.DisableHelicopterTurbulence = false
VehicleOptionsMenu.TorqueEnabled = false
VehicleOptionsMenu.PowerEnabled = false
VehicleOptionsMenu.TorqueMultiplier = 2.0
VehicleOptionsMenu.PowerMultiplier = 2.0
VehicleOptionsMenu.SpeedLimit = 0.0
VehicleOptionsMenu.SpeedLimitEnabled = false

local plateTypes = {
    { name = "Blue on White 1", index = 0 },
    { name = "Blue on White 2", index = 1 },
    { name = "Blue on White 3", index = 2 },
    { name = "Yellow on Blue",  index = 3 },
    { name = "Yellow on Black", index = 4 },
    { name = "North Yankton",   index = 5 }
}

local multiplierValues = { "x2", "x4", "x8", "x16", "x32", "x64", "x128", "x256", "x512", "x1024" }
local multiplierNumbers = { 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024 }

local dirtLevels = { "No Dirt", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15" }

local lightTypes = { "Hazard Lights", "Left Indicator", "Right Indicator", "Interior Lights", "Helicopter Spotlight" }

local tireOptions = { "All Tires", "Tire #1", "Tire #2", "Tire #3", "Tire #4", "Tire #5", "Tire #6", "Tire #7", "Tire #8" }

local neonColors = {
    { name = "White",         r = 222, g = 222, b = 255 },
    { name = "Blue",          r = 2,   g = 21,  b = 255 },
    { name = "Electric Blue", r = 3,   g = 83,  b = 255 },
    { name = "Mint Green",    r = 0,   g = 255, b = 140 },
    { name = "Lime Green",    r = 94,  g = 255, b = 1 },
    { name = "Yellow",        r = 255, g = 255, b = 0 },
    { name = "Golden Shower", r = 255, g = 150, b = 5 },
    { name = "Orange",        r = 255, g = 62,  b = 0 },
    { name = "Red",           r = 255, g = 1,   b = 1 },
    { name = "Pony Pink",     r = 255, g = 50,  b = 100 },
    { name = "Hot Pink",      r = 255, g = 5,   b = 190 },
    { name = "Purple",        r = 35,  g = 1,   b = 255 },
    { name = "Blacklight",    r = 15,  g = 3,   b = 255 }
}

function VehicleOptionsMenu.CreateMenu()
    menu = Menu:New("Vehicle Options", "Vehicle Related Options")
    MenuController:AddMenu(menu)

    godModeMenu = Menu:New("Vehicle Options", "God Mode Options")
    modMenu = Menu:New("Vehicle Options", "Mod Menu")
    doorsMenu = Menu:New("Vehicle Options", "Vehicle Doors")
    windowsMenu = Menu:New("Vehicle Options", "Vehicle Windows")
    extrasMenu = Menu:New("Vehicle Options", "Vehicle Extras")
    liveriesMenu = Menu:New("Vehicle Options", "Vehicle Liveries")
    colorsMenu = Menu:New("Vehicle Options", "Vehicle Colors")
    underglowMenu = Menu:New("Vehicle Options", "Neon Underglow")

    MenuController:AddMenu(godModeMenu)
    MenuController:AddMenu(modMenu)
    MenuController:AddMenu(doorsMenu)
    MenuController:AddMenu(windowsMenu)
    MenuController:AddMenu(extrasMenu)
    MenuController:AddMenu(liveriesMenu)
    MenuController:AddMenu(colorsMenu)
    MenuController:AddMenu(underglowMenu)

    local vehicleGodModeCheckbox = MenuCheckboxItem:New("Vehicle God Mode",
        "Makes your vehicle not take any damage. Enable options in the submenu below.", VehicleOptionsMenu
        .VehicleGodMode)
    local godModeMenuBtn = MenuItem:New("God Mode Options", "Enable or disable specific damage types.")
    godModeMenuBtn.Label = "→→→"

    local repairVehicleBtn = MenuItem:New("Repair Vehicle",
        "Repair any visual and physical damage present on your vehicle.")
    local keepCleanCheckbox = MenuCheckboxItem:New("Keep Vehicle Clean",
        "This will constantly clean your car if the vehicle dirt level goes above 0.",
        VehicleOptionsMenu.VehicleNeverDirty)
    local cleanVehicleBtn = MenuItem:New("Wash Vehicle", "Clean your vehicle.")

    local dirtLevelList = MenuListItem:New("Set Dirt Level", dirtLevels, 1,
        "Select how much dirt should be visible on your vehicle.")

    local setLicensePlateBtn = MenuItem:New("Set License Plate Text", "Enter a custom license plate for your vehicle.")
    local plateTypeNames = {}
    for _, plate in ipairs(plateTypes) do
        table.insert(plateTypeNames, plate.name)
    end
    local licensePlateTypeList = MenuListItem:New("License Plate Type", plateTypeNames, 1,
        "Choose a license plate type and press enter to apply.")

    local modMenuBtn = MenuItem:New("Mod Menu", "Tune and customize your vehicle here.")
    modMenuBtn.Label = "→→→"
    local doorsMenuBtn = MenuItem:New("Vehicle Doors", "Open, close, remove and restore vehicle doors.")
    doorsMenuBtn.Label = "→→→"
    local windowsMenuBtn = MenuItem:New("Vehicle Windows", "Roll windows up/down or remove/restore windows.")
    windowsMenuBtn.Label = "→→→"
    local extrasMenuBtn = MenuItem:New("Vehicle Extras", "Add/remove vehicle components/extras.")
    extrasMenuBtn.Label = "→→→"
    local liveriesMenuBtn = MenuItem:New("Vehicle Liveries", "Style your vehicle with fancy liveries!")
    liveriesMenuBtn.Label = "→→→"
    local colorsMenuBtn = MenuItem:New("Vehicle Colors", "Change your vehicle colors.")
    colorsMenuBtn.Label = "→→→"
    local underglowMenuBtn = MenuItem:New("Neon Underglow", "Add neon underglow to your vehicle!")
    underglowMenuBtn.Label = "→→→"

    local toggleEngineBtn = MenuItem:New("Toggle Engine On/Off", "Turn your engine on/off.")
    local bikeSeatbeltCheckbox = MenuCheckboxItem:New("Bike Seatbelt",
        "Prevents you from being knocked off your bike, bicycle, ATV or similar.", VehicleOptionsMenu
        .VehicleBikeSeatbelt)
    local engineAlwaysOnCheckbox = MenuCheckboxItem:New("Engine Always On",
        "Keeps your vehicle engine on when you exit your vehicle.", VehicleOptionsMenu.VehicleEngineAlwaysOn)
    local noSirenCheckbox = MenuCheckboxItem:New("Disable Siren",
        "Disables your vehicle's siren. Only works if your vehicle actually has a siren.",
        VehicleOptionsMenu.VehicleNoSiren)
    local noBikeHelmetsCheckbox = MenuCheckboxItem:New("No Bike Helmet",
        "No longer auto-equip a helmet when getting on a bike or quad.", VehicleOptionsMenu.VehicleNoBikeHelmets)
    local freezeVehicleCheckbox = MenuCheckboxItem:New("Freeze Vehicle",
        "Freeze your vehicle's position.", VehicleOptionsMenu.VehicleFrozen)
    local highbeamsOnHonkCheckbox = MenuCheckboxItem:New("Flash Highbeams On Honk",
        "Turn on your highbeams when honking your horn.", VehicleOptionsMenu.FlashHighbeamsOnHonk)
    local showHealthCheckbox = MenuCheckboxItem:New("Show Vehicle Health",
        "Shows the vehicle health on screen.", VehicleOptionsMenu.VehicleShowHealth)
    local infiniteFuelCheckbox = MenuCheckboxItem:New("Infinite Fuel",
        "Enables infinite fuel for this vehicle.", VehicleOptionsMenu.VehicleInfiniteFuel)

    local noPlaneTurbulenceCheckbox = MenuCheckboxItem:New("Disable Plane Turbulence",
        "Disables the turbulence for all planes.", VehicleOptionsMenu.DisablePlaneTurbulence)
    local noHeliTurbulenceCheckbox = MenuCheckboxItem:New("Disable Helicopter Turbulence",
        "Disables the turbulence for all helicopters.", VehicleOptionsMenu.DisableHelicopterTurbulence)

    local torqueEnabledCheckbox = MenuCheckboxItem:New("Enable Torque Multiplier",
        "Enables the torque multiplier selected from the list below.", VehicleOptionsMenu.TorqueEnabled)
    local torqueMultiplierList = MenuListItem:New("Set Engine Torque Multiplier", multiplierValues, 1,
        "Set the engine torque multiplier.")
    local powerEnabledCheckbox = MenuCheckboxItem:New("Enable Power Multiplier",
        "Enables the power multiplier selected from the list below.", VehicleOptionsMenu.PowerEnabled)
    local powerMultiplierList = MenuListItem:New("Set Engine Power Multiplier", multiplierValues, 1,
        "Set the engine power multiplier.")

    local speedLimiterOptions = { "Set Current Speed", "Reset", "Custom Speed Limit" }
    local speedLimiterList = MenuListItem:New("Speed Limiter", speedLimiterOptions, 1,
        "Set your vehicle's max speed to your current speed, reset it, or enter a custom limit.")

    local vehicleLightsList = MenuListItem:New("Vehicle Lights", lightTypes, 1, "Toggle vehicle lights on/off.")

    local tiresFixList = MenuListItem:New("Fix Tires", tireOptions, 1, "Fix specific or all tires.")
    local tiresDestroyList = MenuListItem:New("Destroy Tires", tireOptions, 1, "Destroy specific or all tires.")

    local toggleVisibilityBtn = MenuItem:New("Toggle Vehicle Visibility",
        "Makes your vehicle visible/invisible. Your vehicle will be made visible again when you exit.")
    local toggleAlarmBtn = MenuItem:New("Toggle Vehicle Alarm", "Starts/stops your vehicle's alarm.")
    local cycleSeatsBtn = MenuItem:New("Cycle Through Seats", "Cycle through the available vehicle seats.")
    local flipVehicleBtn = MenuItem:New("Flip Vehicle", "Sets your vehicle on all 4 wheels.")
    local destroyEngineBtn = MenuItem:New("Destroy Engine", "Destroys your vehicle's engine.")
    local deleteVehicleBtn = MenuItem:New("~r~Delete Vehicle", "Delete your vehicle. This cannot be undone!")
    deleteVehicleBtn.LeftIcon = Icon.WARNING

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.VOGod) then
        menu:AddMenuItem(vehicleGodModeCheckbox)
        menu:AddMenuItem(godModeMenuBtn)
        MenuController:BindMenuItem(menu, godModeMenu, godModeMenuBtn)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.VORepair) then
        menu:AddMenuItem(repairVehicleBtn)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.VOKeepClean) then
        menu:AddMenuItem(keepCleanCheckbox)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.VOWash) then
        menu:AddMenuItem(cleanVehicleBtn)
        menu:AddMenuItem(dirtLevelList)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.VOMod) then
        menu:AddMenuItem(modMenuBtn)
        MenuController:BindMenuItem(menu, modMenu, modMenuBtn)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.VODoors) then
        menu:AddMenuItem(doorsMenuBtn)
        MenuController:BindMenuItem(menu, doorsMenu, doorsMenuBtn)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.VOWindows) then
        menu:AddMenuItem(windowsMenuBtn)
        MenuController:BindMenuItem(menu, windowsMenu, windowsMenuBtn)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.VOComponents) then
        menu:AddMenuItem(extrasMenuBtn)
        MenuController:BindMenuItem(menu, extrasMenu, extrasMenuBtn)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.VOLiveries) then
        menu:AddMenuItem(liveriesMenuBtn)
        MenuController:BindMenuItem(menu, liveriesMenu, liveriesMenuBtn)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.VOColors) then
        menu:AddMenuItem(colorsMenuBtn)
        MenuController:BindMenuItem(menu, colorsMenu, colorsMenuBtn)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.VOUnderglow) then
        menu:AddMenuItem(underglowMenuBtn)
        MenuController:BindMenuItem(menu, underglowMenu, underglowMenuBtn)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.VOEngine) then
        menu:AddMenuItem(toggleEngineBtn)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.VOChangePlate) then
        menu:AddMenuItem(setLicensePlateBtn)
        menu:AddMenuItem(licensePlateTypeList)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.VOBikeSeatbelt) then
        menu:AddMenuItem(bikeSeatbeltCheckbox)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.VOSpeedLimiter) then
        menu:AddMenuItem(speedLimiterList)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.VOTorqueMultiplier) then
        menu:AddMenuItem(torqueEnabledCheckbox)
        menu:AddMenuItem(torqueMultiplierList)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.VOPowerMultiplier) then
        menu:AddMenuItem(powerEnabledCheckbox)
        menu:AddMenuItem(powerMultiplierList)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.VODisableTurbulence) then
        menu:AddMenuItem(noPlaneTurbulenceCheckbox)
        menu:AddMenuItem(noHeliTurbulenceCheckbox)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.VOEngineAlwaysOn) then
        menu:AddMenuItem(engineAlwaysOnCheckbox)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.VONoSiren) then
        menu:AddMenuItem(noSirenCheckbox)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.VONoHelmet) then
        menu:AddMenuItem(noBikeHelmetsCheckbox)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.VOFlashHighbeamsOnHonk) then
        menu:AddMenuItem(highbeamsOnHonkCheckbox)
    end

    menu:AddMenuItem(freezeVehicleCheckbox)
    menu:AddMenuItem(showHealthCheckbox)
    menu:AddMenuItem(infiniteFuelCheckbox)

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.VOLights) then
        menu:AddMenuItem(vehicleLightsList)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.VOFixOrDestroyTires) then
        menu:AddMenuItem(tiresFixList)
        menu:AddMenuItem(tiresDestroyList)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.VOInvisible) then
        menu:AddMenuItem(toggleVisibilityBtn)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.VOAlarm) then
        menu:AddMenuItem(toggleAlarmBtn)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.VODoors) then
        menu:AddMenuItem(cycleSeatsBtn)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.VOFlip) then
        menu:AddMenuItem(flipVehicleBtn)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.VODestroyEngine) then
        menu:AddMenuItem(destroyEngineBtn)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.VODelete) then
        menu:AddMenuItem(deleteVehicleBtn)
    end

    VehicleOptionsMenu.SetupGodModeMenu()
    VehicleOptionsMenu.SetupModMenu()
    VehicleOptionsMenu.SetupDoorsMenu()
    VehicleOptionsMenu.SetupWindowsMenu()
    VehicleOptionsMenu.SetupExtrasMenu()
    VehicleOptionsMenu.SetupLiveriesMenu()
    VehicleOptionsMenu.SetupColorsMenu()
    VehicleOptionsMenu.SetupUnderglowMenu()

    menu.OnCheckboxChange = function(sender, item, index, checked)
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)

        if item == vehicleGodModeCheckbox then
            VehicleOptionsMenu.VehicleGodMode = checked
            VehicleOptionsMenu.VehicleGodInvincible = checked
            VehicleOptionsMenu.VehicleGodEngine = checked
            VehicleOptionsMenu.VehicleGodVisual = checked
            VehicleOptionsMenu.VehicleGodStrongWheels = checked
            VehicleOptionsMenu.VehicleGodAutoRepair = checked
            if not checked and vehicle ~= 0 then
                SetEntityInvincible(vehicle, false)
                SetVehicleCanBeVisiblyDamaged(vehicle, true)
                SetVehicleWheelsCanBreak(vehicle, true)
            end
            Notify.Custom("Vehicle god mode " .. (checked and "~g~enabled~s~" or "~r~disabled~s~") .. ".")
        elseif item == keepCleanCheckbox then
            VehicleOptionsMenu.VehicleNeverDirty = checked
            Notify.Custom("Keep vehicle clean " .. (checked and "~g~enabled~s~" or "~r~disabled~s~") .. ".")
        elseif item == bikeSeatbeltCheckbox then
            VehicleOptionsMenu.VehicleBikeSeatbelt = checked
            Notify.Custom("Bike seatbelt " .. (checked and "~g~enabled~s~" or "~r~disabled~s~") .. ".")
        elseif item == engineAlwaysOnCheckbox then
            VehicleOptionsMenu.VehicleEngineAlwaysOn = checked
            Notify.Custom("Engine always on " .. (checked and "~g~enabled~s~" or "~r~disabled~s~") .. ".")
        elseif item == noSirenCheckbox then
            VehicleOptionsMenu.VehicleNoSiren = checked
            if vehicle ~= 0 then
                SetVehicleHasMutedSirens(vehicle, checked)
            end
            Notify.Custom("Disable siren " .. (checked and "~g~enabled~s~" or "~r~disabled~s~") .. ".")
        elseif item == noBikeHelmetsCheckbox then
            VehicleOptionsMenu.VehicleNoBikeHelmets = checked
            SetPedConfigFlag(ped, 35, checked)
            Notify.Custom("No bike helmet " .. (checked and "~g~enabled~s~" or "~r~disabled~s~") .. ".")
        elseif item == freezeVehicleCheckbox then
            VehicleOptionsMenu.VehicleFrozen = checked
            if vehicle ~= 0 then
                FreezeEntityPosition(vehicle, checked)
            end
            Notify.Custom("Vehicle frozen " .. (checked and "~g~enabled~s~" or "~r~disabled~s~") .. ".")
        elseif item == highbeamsOnHonkCheckbox then
            VehicleOptionsMenu.FlashHighbeamsOnHonk = checked
            Notify.Custom("Flash highbeams on honk " .. (checked and "~g~enabled~s~" or "~r~disabled~s~") .. ".")
        elseif item == showHealthCheckbox then
            VehicleOptionsMenu.VehicleShowHealth = checked
            Notify.Custom("Show vehicle health " .. (checked and "~g~enabled~s~" or "~r~disabled~s~") .. ".")
        elseif item == infiniteFuelCheckbox then
            VehicleOptionsMenu.VehicleInfiniteFuel = checked
            Notify.Custom("Infinite fuel " .. (checked and "~g~enabled~s~" or "~r~disabled~s~") .. ".")
        elseif item == noPlaneTurbulenceCheckbox then
            VehicleOptionsMenu.DisablePlaneTurbulence = checked
            Notify.Custom("Disable plane turbulence " .. (checked and "~g~enabled~s~" or "~r~disabled~s~") .. ".")
        elseif item == noHeliTurbulenceCheckbox then
            VehicleOptionsMenu.DisableHelicopterTurbulence = checked
            Notify.Custom("Disable helicopter turbulence " .. (checked and "~g~enabled~s~" or "~r~disabled~s~") .. ".")
        elseif item == torqueEnabledCheckbox then
            VehicleOptionsMenu.TorqueEnabled = checked
            Notify.Custom("Torque multiplier " .. (checked and "~g~enabled~s~" or "~r~disabled~s~") .. ".")
        elseif item == powerEnabledCheckbox then
            VehicleOptionsMenu.PowerEnabled = checked
            if vehicle ~= 0 then
                if checked then
                    SetVehicleEnginePowerMultiplier(vehicle, VehicleOptionsMenu.PowerMultiplier + 0.0)
                else
                    SetVehicleEnginePowerMultiplier(vehicle, 1.0)
                end
            end
            Notify.Custom("Power multiplier " .. (checked and "~g~enabled~s~" or "~r~disabled~s~") .. ".")
        end
    end

    menu.OnItemSelect = function(sender, item, index)
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)

        if item == repairVehicleBtn then
            if vehicle ~= 0 then
                SetVehicleFixed(vehicle)
                SetVehicleDeformationFixed(vehicle)
                SetVehicleUndriveable(vehicle, false)
                SetVehicleEngineOn(vehicle, true, false, true)
                Notify.Success("Vehicle repaired.")
            else
                Notify.Error("You need to be in a vehicle.")
            end
        elseif item == cleanVehicleBtn then
            if vehicle ~= 0 then
                SetVehicleDirtLevel(vehicle, 0.0)
                WashDecalsFromVehicle(vehicle, 1.0)
                Notify.Success("Vehicle cleaned.")
            else
                Notify.Error("You need to be in a vehicle.")
            end
        elseif item == toggleEngineBtn then
            if vehicle ~= 0 then
                local engineOn = GetIsVehicleEngineRunning(vehicle)
                SetVehicleEngineOn(vehicle, not engineOn, false, true)
                Notify.Custom("Engine " .. (not engineOn and "~g~started~s~" or "~r~stopped~s~") .. ".")
            else
                Notify.Error("You need to be in a vehicle.")
            end
        elseif item == setLicensePlateBtn then
            if vehicle ~= 0 then
                DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 8)
                while UpdateOnscreenKeyboard() == 0 do
                    Wait(0)
                end
                if GetOnscreenKeyboardResult() then
                    local plate = GetOnscreenKeyboardResult()
                    if plate and plate ~= "" then
                        SetVehicleNumberPlateText(vehicle, plate)
                        Notify.Success("License plate set to: ~g~" .. plate)
                    end
                end
            else
                Notify.Error("You need to be in a vehicle.")
            end
        elseif item == toggleVisibilityBtn then
            if vehicle ~= 0 then
                VehicleOptionsMenu.VehicleInvisible = not VehicleOptionsMenu.VehicleInvisible
                SetEntityVisible(vehicle, not VehicleOptionsMenu.VehicleInvisible, false)
                Notify.Custom("Vehicle " ..
                    (VehicleOptionsMenu.VehicleInvisible and "~r~invisible~s~" or "~g~visible~s~") .. ".")
            else
                Notify.Error("You need to be in a vehicle.")
            end
        elseif item == toggleAlarmBtn then
            if vehicle ~= 0 then
                local alarmActive = IsVehicleAlarmActivated(vehicle)
                if alarmActive then
                    SetVehicleAlarm(vehicle, false)
                    SetVehicleAlarmTimeLeft(vehicle, 0)
                else
                    SetVehicleAlarm(vehicle, true)
                    SetVehicleAlarmTimeLeft(vehicle, 10000)
                    StartVehicleAlarm(vehicle)
                end
                Notify.Custom("Vehicle alarm " .. (not alarmActive and "~g~started~s~" or "~r~stopped~s~") .. ".")
            else
                Notify.Error("You need to be in a vehicle.")
            end
        elseif item == cycleSeatsBtn then
            if vehicle ~= 0 then
                local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
                local currentSeat = -2
                for i = -1, maxSeats do
                    if GetPedInVehicleSeat(vehicle, i) == ped then
                        currentSeat = i
                        break
                    end
                end
                local nextSeat = currentSeat + 1
                if nextSeat > maxSeats - 1 then
                    nextSeat = -1
                end
                if IsVehicleSeatFree(vehicle, nextSeat) then
                    TaskWarpPedIntoVehicle(ped, vehicle, nextSeat)
                    Notify.Custom("Moved to seat #" .. (nextSeat + 2))
                else
                    Notify.Error("That seat is occupied.")
                end
            else
                Notify.Error("You need to be in a vehicle.")
            end
        elseif item == flipVehicleBtn then
            if vehicle ~= 0 then
                local coords = GetEntityCoords(vehicle)
                local heading = GetEntityHeading(vehicle)
                SetEntityCoords(vehicle, coords.x, coords.y, coords.z + 1.0, false, false, false, false)
                SetEntityRotation(vehicle, 0.0, 0.0, heading, 2, true)
                SetVehicleOnGroundProperly(vehicle)
                Notify.Success("Vehicle flipped.")
            else
                Notify.Error("You need to be in a vehicle.")
            end
        elseif item == destroyEngineBtn then
            if vehicle ~= 0 then
                SetVehicleEngineHealth(vehicle, -4000.0)
                Notify.Success("Engine destroyed.")
            else
                Notify.Error("You need to be in a vehicle.")
            end
        elseif item == deleteVehicleBtn then
            if vehicle ~= 0 then
                SetEntityAsMissionEntity(vehicle, true, true)
                DeleteVehicle(vehicle)
                Notify.Success("Vehicle deleted.")
            else
                Notify.Error("You need to be in a vehicle.")
            end
        end
    end

    menu.OnListItemSelect = function(sender, item, selectedIndex, itemIndex)
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)

        if vehicle == 0 then
            Notify.Error("You need to be in a vehicle.")
            return
        end

        if item == dirtLevelList then
            SetVehicleDirtLevel(vehicle, selectedIndex - 1)
            Notify.Custom("Dirt level set to " .. dirtLevels[selectedIndex])
        elseif item == licensePlateTypeList then
            SetVehicleNumberPlateTextIndex(vehicle, plateTypes[selectedIndex].index)
            Notify.Custom("License plate type set to " .. plateTypes[selectedIndex].name)
        elseif item == speedLimiterList then
            if selectedIndex == 1 then
                local speed = GetEntitySpeed(vehicle)
                VehicleOptionsMenu.SpeedLimit = speed
                VehicleOptionsMenu.SpeedLimitEnabled = true
                local speedKmh = speed * 3.6
                Notify.Custom(string.format("Speed limit set to ~y~%.0f km/h~s~", speedKmh))
            elseif selectedIndex == 2 then
                VehicleOptionsMenu.SpeedLimitEnabled = false
                VehicleOptionsMenu.SpeedLimit = 0.0
                SetVehicleMaxSpeed(vehicle, 0.0)
                Notify.Custom("Speed limit ~r~reset~s~.")
            elseif selectedIndex == 3 then
                DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 10)
                while UpdateOnscreenKeyboard() == 0 do
                    Wait(0)
                end
                if GetOnscreenKeyboardResult() then
                    local speedStr = GetOnscreenKeyboardResult()
                    local speedKmh = tonumber(speedStr)
                    if speedKmh then
                        local speedMs = speedKmh / 3.6
                        VehicleOptionsMenu.SpeedLimit = speedMs
                        VehicleOptionsMenu.SpeedLimitEnabled = true
                        Notify.Custom(string.format("Speed limit set to ~y~%.0f km/h~s~", speedKmh))
                    else
                        Notify.Error("Invalid speed value.")
                    end
                end
            end
        elseif item == vehicleLightsList then
            if selectedIndex == 1 then
                local hazards = GetVehicleIndicatorLights(vehicle)
                SetVehicleIndicatorLights(vehicle, 0, hazards == 0)
                SetVehicleIndicatorLights(vehicle, 1, hazards == 0)
            elseif selectedIndex == 2 then
                SetVehicleIndicatorLights(vehicle, 1, not IsVehicleIndicatorLightOn(vehicle, 1))
            elseif selectedIndex == 3 then
                SetVehicleIndicatorLights(vehicle, 0, not IsVehicleIndicatorLightOn(vehicle, 0))
            elseif selectedIndex == 4 then
                SetVehicleInteriorlight(vehicle, not IsVehicleInteriorLightOn(vehicle))
            elseif selectedIndex == 5 then
                if IsVehicleSearchlightOn(vehicle) then
                    SetVehicleSearchlight(vehicle, false, false)
                else
                    SetVehicleSearchlight(vehicle, true, false)
                end
            end
        elseif item == tiresFixList then
            if selectedIndex == 1 then
                for i = 0, 7 do
                    SetVehicleTyreFixed(vehicle, i)
                end
                Notify.Success("All tires fixed.")
            else
                SetVehicleTyreFixed(vehicle, selectedIndex - 2)
                Notify.Success("Tire #" .. (selectedIndex - 1) .. " fixed.")
            end
        elseif item == tiresDestroyList then
            if selectedIndex == 1 then
                for i = 0, 7 do
                    SetVehicleTyreBurst(vehicle, i, true, 1000.0)
                end
                Notify.Success("All tires destroyed.")
            else
                SetVehicleTyreBurst(vehicle, selectedIndex - 2, true, 1000.0)
                Notify.Success("Tire #" .. (selectedIndex - 1) .. " destroyed.")
            end
        elseif item == torqueMultiplierList then
            VehicleOptionsMenu.TorqueMultiplier = multiplierNumbers[selectedIndex] + 0.0
            Notify.Custom("Torque multiplier set to x" .. multiplierNumbers[selectedIndex])
        elseif item == powerMultiplierList then
            VehicleOptionsMenu.PowerMultiplier = multiplierNumbers[selectedIndex] + 0.0
            if VehicleOptionsMenu.PowerEnabled and vehicle ~= 0 then
                SetVehicleEnginePowerMultiplier(vehicle, VehicleOptionsMenu.PowerMultiplier)
            end
            Notify.Custom("Power multiplier set to x" .. multiplierNumbers[selectedIndex])
        end
    end

    menu.OnListIndexChange = function(sender, item, oldIndex, newIndex, itemIndex)
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)

        if item == torqueMultiplierList then
            VehicleOptionsMenu.TorqueMultiplier = multiplierNumbers[newIndex] + 0.0
        elseif item == powerMultiplierList then
            VehicleOptionsMenu.PowerMultiplier = multiplierNumbers[newIndex] + 0.0
            if VehicleOptionsMenu.PowerEnabled and vehicle ~= 0 then
                SetVehicleEnginePowerMultiplier(vehicle, VehicleOptionsMenu.PowerMultiplier)
            end
        end
    end

    return menu
end

function VehicleOptionsMenu.SetupGodModeMenu()
    local godInvincibleCheckbox, godEngineCheckbox, godVisualCheckbox
    local godStrongWheelsCheckbox, godRampCheckbox, godAutoRepairCheckbox

    local function CreateCheckboxes()
        godInvincibleCheckbox = MenuCheckboxItem:New("Invincible",
            "Makes the car invincible. Includes fire, explosion, and collision damage.",
            VehicleOptionsMenu.VehicleGodInvincible)
        godEngineCheckbox = MenuCheckboxItem:New("Engine Damage",
            "Disables your engine from taking any damage.", VehicleOptionsMenu.VehicleGodEngine)
        godVisualCheckbox = MenuCheckboxItem:New("Visual Damage",
            "Prevents scratches and other damage decals from being applied.", VehicleOptionsMenu.VehicleGodVisual)
        godStrongWheelsCheckbox = MenuCheckboxItem:New("Strong Wheels",
            "Disables your wheels from being deformed.", VehicleOptionsMenu.VehicleGodStrongWheels)
        godRampCheckbox = MenuCheckboxItem:New("Ramp Damage",
            "Disables vehicles like the Ramp Buggy from taking damage when using the ramp.",
            VehicleOptionsMenu.VehicleGodRamp)
        godAutoRepairCheckbox = MenuCheckboxItem:New("~r~Auto Repair",
            "Automatically repairs your vehicle when it has any damage. May cause glitches.",
            VehicleOptionsMenu.VehicleGodAutoRepair)

        godModeMenu:ClearMenuItems()
        godModeMenu:AddMenuItem(godInvincibleCheckbox)
        godModeMenu:AddMenuItem(godEngineCheckbox)
        godModeMenu:AddMenuItem(godVisualCheckbox)
        godModeMenu:AddMenuItem(godStrongWheelsCheckbox)
        godModeMenu:AddMenuItem(godRampCheckbox)
        godModeMenu:AddMenuItem(godAutoRepairCheckbox)
    end

    CreateCheckboxes()

    godModeMenu.OnMenuOpen = function(sender)
        godInvincibleCheckbox.Checked = VehicleOptionsMenu.VehicleGodInvincible
        godEngineCheckbox.Checked = VehicleOptionsMenu.VehicleGodEngine
        godVisualCheckbox.Checked = VehicleOptionsMenu.VehicleGodVisual
        godStrongWheelsCheckbox.Checked = VehicleOptionsMenu.VehicleGodStrongWheels
        godRampCheckbox.Checked = VehicleOptionsMenu.VehicleGodRamp
        godAutoRepairCheckbox.Checked = VehicleOptionsMenu.VehicleGodAutoRepair
    end

    godModeMenu.OnCheckboxChange = function(sender, item, index, checked)
        if item == godInvincibleCheckbox then
            VehicleOptionsMenu.VehicleGodInvincible = checked
        elseif item == godEngineCheckbox then
            VehicleOptionsMenu.VehicleGodEngine = checked
        elseif item == godVisualCheckbox then
            VehicleOptionsMenu.VehicleGodVisual = checked
        elseif item == godStrongWheelsCheckbox then
            VehicleOptionsMenu.VehicleGodStrongWheels = checked
        elseif item == godRampCheckbox then
            VehicleOptionsMenu.VehicleGodRamp = checked
        elseif item == godAutoRepairCheckbox then
            VehicleOptionsMenu.VehicleGodAutoRepair = checked
        end
    end
end

function VehicleOptionsMenu.SetupModMenu()
    local modTypeNames = {
        [0] = "Spoilers",
        [1] = "Front Bumper",
        [2] = "Rear Bumper",
        [3] = "Side Skirts",
        [4] = "Exhaust",
        [5] = "Frame",
        [6] = "Grille",
        [7] = "Hood",
        [8] = "Fenders",
        [9] = "Right Fender",
        [10] = "Roof",
        [11] = "Engine",
        [12] = "Brakes",
        [13] = "Transmission",
        [14] = "Horns",
        [15] = "Suspension",
        [16] = "Armor",
        [23] = "Front Wheels",
        [24] = "Back Wheels",
        [25] = "Plate Holders",
        [26] = "Vanity Plates",
        [27] = "Trim Design",
        [28] = "Ornaments",
        [29] = "Dashboard",
        [30] = "Dial Design",
        [31] = "Door Speakers",
        [32] = "Seats",
        [33] = "Steering Wheels",
        [34] = "Column Shifters",
        [35] = "Plaques",
        [36] = "Speakers",
        [37] = "Trunk",
        [38] = "Hydraulics",
        [39] = "Engine Block",
        [40] = "Air Filter",
        [41] = "Struts",
        [42] = "Arch Cover",
        [43] = "Aerials",
        [44] = "Trim",
        [45] = "Tank",
        [46] = "Windows",
        [48] = "Livery"
    }

    local wheelTypes = {
        "Sports", "Muscle", "Lowrider", "SUV", "Offroad", "Tuner",
        "Bike Wheels", "High End", "Benny's (1)", "Benny's (2)",
        "Open Wheel", "Street", "Track"
    }

    local tireSmokeColors = {
        { name = "Red",         r = 244, g = 65,  b = 65 },
        { name = "Orange",      r = 244, g = 167, b = 66 },
        { name = "Yellow",      r = 244, g = 217, b = 65 },
        { name = "Gold",        r = 181, g = 120, b = 0 },
        { name = "Light Green", r = 158, g = 255, b = 84 },
        { name = "Dark Green",  r = 44,  g = 94,  b = 5 },
        { name = "Light Blue",  r = 65,  g = 211, b = 244 },
        { name = "Dark Blue",   r = 24,  g = 54,  b = 163 },
        { name = "Purple",      r = 108, g = 24,  b = 192 },
        { name = "Pink",        r = 192, g = 24,  b = 172 },
        { name = "Black",       r = 1,   g = 1,   b = 1 }
    }

    local headlightColors = {
        "White", "Blue", "Electric Blue", "Mint Green", "Lime Green",
        "Yellow", "Golden Shower", "Orange", "Red", "Pony Pink",
        "Hot Pink", "Purple", "Blacklight", "Default Xenon"
    }

    local windowTints = {
        "Stock", "None", "Limo", "Light Smoke", "Dark Smoke", "Pure Black", "Green"
    }

    local modMenuItems = {}

    local function RefreshModMenu(vehicle)
        modMenu:ClearMenuItems()
        modMenuItems = {}

        if vehicle == 0 then
            local noVehicleBtn = MenuItem:New("No vehicle", "You need to be in a vehicle.")
            noVehicleBtn.Enabled = false
            modMenu:AddMenuItem(noVehicleBtn)
            return
        end

        SetVehicleModKit(vehicle, 0)

        local isBoat = IsThisModelABoat(GetEntityModel(vehicle))
        local isHeli = IsThisModelAHeli(GetEntityModel(vehicle))
        local isPlane = IsThisModelAPlane(GetEntityModel(vehicle))
        local isBike = IsThisModelABike(GetEntityModel(vehicle))
        local isBicycle = IsThisModelABicycle(GetEntityModel(vehicle))

        for modType = 0, 48 do
            local numMods = GetNumVehicleMods(vehicle, modType)
            if numMods > 0 and modTypeNames[modType] then
                local modOptions = { "Stock" }
                local currentMod = GetVehicleMod(vehicle, modType)

                for i = 0, numMods - 1 do
                    local modName = GetModSlotName(vehicle, modType)
                    local labelText = GetLabelText(GetModTextLabel(vehicle, modType, i))
                    if labelText and labelText ~= "NULL" and labelText ~= "" then
                        table.insert(modOptions, labelText)
                    else
                        table.insert(modOptions, modTypeNames[modType] .. " #" .. (i + 1))
                    end
                end

                local modList = MenuListItem:New(modTypeNames[modType], modOptions, currentMod + 2,
                    "Choose a " .. modTypeNames[modType]:lower() .. " upgrade.")
                modList.ItemData = { modType = modType }
                modMenu:AddMenuItem(modList)
                modMenuItems[modType] = modList
            end
        end

        if not isBoat and not isHeli and not isPlane and not isBicycle then
            local currentWheelType = GetVehicleWheelType(vehicle)
            if currentWheelType < 0 then currentWheelType = 0 end
            if currentWheelType > 12 then currentWheelType = 12 end

            local wheelTypeList = MenuListItem:New("Wheel Type", wheelTypes, currentWheelType + 1,
                "Choose a wheel type for your vehicle.")
            wheelTypeList.ItemData = { special = "wheelType" }
            modMenu:AddMenuItem(wheelTypeList)
            modMenuItems["wheelType"] = wheelTypeList
        end

        local customWheels = GetVehicleModVariation(vehicle, 23)
        local toggleCustomWheelsCheckbox = MenuCheckboxItem:New("Toggle Custom Wheels",
            "Add or remove custom wheels.", customWheels)
        toggleCustomWheelsCheckbox.ItemData = { special = "customWheels" }
        modMenu:AddMenuItem(toggleCustomWheelsCheckbox)
        modMenuItems["customWheels"] = toggleCustomWheelsCheckbox

        local xenonEnabled = IsToggleModOn(vehicle, 22)
        local xenonCheckbox = MenuCheckboxItem:New("Xenon Headlights",
            "Enable or disable xenon headlights.", xenonEnabled)
        xenonCheckbox.ItemData = { special = "xenon" }
        modMenu:AddMenuItem(xenonCheckbox)
        modMenuItems["xenon"] = xenonCheckbox

        local currentHeadlightColor = GetVehicleHeadlightsColour(vehicle)
        if currentHeadlightColor < 0 or currentHeadlightColor > 12 then
            currentHeadlightColor = 13
        end
        local headlightColorList = MenuListItem:New("Headlight Color", headlightColors, currentHeadlightColor + 1,
            "Choose a headlight color. Requires Xenon Headlights enabled.")
        headlightColorList.ItemData = { special = "headlightColor" }
        modMenu:AddMenuItem(headlightColorList)
        modMenuItems["headlightColor"] = headlightColorList

        local turboEnabled = IsToggleModOn(vehicle, 18)
        local turboCheckbox = MenuCheckboxItem:New("Turbo",
            "Enable or disable turbo for this vehicle.", turboEnabled)
        turboCheckbox.ItemData = { special = "turbo" }
        modMenu:AddMenuItem(turboCheckbox)
        modMenuItems["turbo"] = turboCheckbox

        local bulletProof = not GetVehicleTyresCanBurst(vehicle)
        local bulletProofCheckbox = MenuCheckboxItem:New("Bullet Proof Tires",
            "Enable or disable bullet proof tires.", bulletProof)
        bulletProofCheckbox.ItemData = { special = "bulletProof" }
        modMenu:AddMenuItem(bulletProofCheckbox)
        modMenuItems["bulletProof"] = bulletProofCheckbox

        local lowGripCheckbox = MenuCheckboxItem:New("Low Grip Tires",
            "Enable or disable low grip tires for drifting.", false)
        lowGripCheckbox.ItemData = { special = "lowGrip" }
        pcall(function()
            lowGripCheckbox.Checked = GetDriftTyresEnabled(vehicle)
        end)
        modMenu:AddMenuItem(lowGripCheckbox)
        modMenuItems["lowGrip"] = lowGripCheckbox

        local tireSmokeNames = {}
        for _, color in ipairs(tireSmokeColors) do
            table.insert(tireSmokeNames, color.name)
        end
        local tireSmokeList = MenuListItem:New("Tire Smoke Color", tireSmokeNames, 1,
            "Choose a tire smoke color.")
        tireSmokeList.ItemData = { special = "tireSmokeColor" }
        modMenu:AddMenuItem(tireSmokeList)
        modMenuItems["tireSmokeColor"] = tireSmokeList

        local tireSmokeEnabled = IsToggleModOn(vehicle, 20)
        local tireSmokeCheckbox = MenuCheckboxItem:New("Tire Smoke",
            "Enable or disable tire smoke.", tireSmokeEnabled)
        tireSmokeCheckbox.ItemData = { special = "tireSmoke" }
        modMenu:AddMenuItem(tireSmokeCheckbox)
        modMenuItems["tireSmoke"] = tireSmokeCheckbox

        local currentTint = GetVehicleWindowTint(vehicle)
        local tintIndex = 1
        if currentTint == 0 then
            tintIndex = 2
        elseif currentTint == 5 then
            tintIndex = 3
        elseif currentTint == 3 then
            tintIndex = 4
        elseif currentTint == 2 then
            tintIndex = 5
        elseif currentTint == 1 then
            tintIndex = 6
        elseif currentTint == 6 then
            tintIndex = 7
        end
        local windowTintList = MenuListItem:New("Window Tint", windowTints, tintIndex,
            "Apply tint to your windows.")
        windowTintList.ItemData = { special = "windowTint" }
        modMenu:AddMenuItem(windowTintList)
        modMenuItems["windowTint"] = windowTintList
    end

    modMenu.OnMenuOpen = function(sender)
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)
        RefreshModMenu(vehicle)
    end

    modMenu.OnCheckboxChange = function(sender, item, index, checked)
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)

        if vehicle == 0 then
            Notify.Error("You need to be in a vehicle.")
            return
        end

        SetVehicleModKit(vehicle, 0)

        if item.ItemData then
            local special = item.ItemData.special

            if special == "customWheels" then
                local currentMod = GetVehicleMod(vehicle, 23)
                SetVehicleMod(vehicle, 23, currentMod, checked)
                if IsThisModelABike(GetEntityModel(vehicle)) then
                    SetVehicleMod(vehicle, 24, GetVehicleMod(vehicle, 24), checked)
                end
                Notify.Custom("Custom wheels " .. (checked and "~g~enabled~s~" or "~r~disabled~s~") .. ".")
            elseif special == "xenon" then
                ToggleVehicleMod(vehicle, 22, checked)
                Notify.Custom("Xenon headlights " .. (checked and "~g~enabled~s~" or "~r~disabled~s~") .. ".")
            elseif special == "turbo" then
                ToggleVehicleMod(vehicle, 18, checked)
                Notify.Custom("Turbo " .. (checked and "~g~enabled~s~" or "~r~disabled~s~") .. ".")
            elseif special == "bulletProof" then
                SetVehicleTyresCanBurst(vehicle, not checked)
                Notify.Custom("Bullet proof tires " .. (checked and "~g~enabled~s~" or "~r~disabled~s~") .. ".")
            elseif special == "lowGrip" then
                pcall(function()
                    SetDriftTyresEnabled(vehicle, checked)
                end)
                Notify.Custom("Low grip tires " .. (checked and "~g~enabled~s~" or "~r~disabled~s~") .. ".")
            elseif special == "tireSmoke" then
                if checked then
                    ToggleVehicleMod(vehicle, 20, true)
                    local colorItem = modMenuItems["tireSmokeColor"]
                    if colorItem then
                        local colorIndex = colorItem:get_Index()
                        local color = tireSmokeColors[colorIndex]
                        if color then
                            SetVehicleTyreSmokeColor(vehicle, color.r, color.g, color.b)
                        end
                    end
                else
                    SetVehicleTyreSmokeColor(vehicle, 255, 255, 255)
                    ToggleVehicleMod(vehicle, 20, false)
                    RemoveVehicleMod(vehicle, 20)
                end
                Notify.Custom("Tire smoke " .. (checked and "~g~enabled~s~" or "~r~disabled~s~") .. ".")
            end
        end
    end

    modMenu.OnListIndexChange = function(sender, item, oldIndex, newIndex, itemIndex)
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)

        if vehicle == 0 then return end

        SetVehicleModKit(vehicle, 0)

        if item.ItemData then
            local special = item.ItemData.special
            local modType = item.ItemData.modType

            if modType then
                local selectedMod = newIndex - 2
                local customWheels = GetVehicleModVariation(vehicle, 23)
                SetVehicleMod(vehicle, modType, selectedMod, customWheels)
            elseif special == "wheelType" then
                local wheelType = newIndex - 1
                local isBike = IsThisModelABike(GetEntityModel(vehicle))
                local vehicleClass = GetVehicleClass(vehicle)
                local isOpenWheel = vehicleClass == 22

                if wheelType == 6 and not isBike then
                    if newIndex > oldIndex then
                        item:set_Index(newIndex + 1)
                    else
                        item:set_Index(newIndex - 1)
                    end
                    return
                end
                if wheelType == 10 and not isOpenWheel then
                    if newIndex > oldIndex then
                        item:set_Index(newIndex + 1)
                    else
                        item:set_Index(newIndex - 1)
                    end
                    return
                end

                SetVehicleWheelType(vehicle, wheelType)
                local customWheels = GetVehicleModVariation(vehicle, 23)
                SetVehicleMod(vehicle, 23, -1, customWheels)
                if isBike then
                    SetVehicleMod(vehicle, 24, -1, customWheels)
                end
            elseif special == "headlightColor" then
                local colorIndex = newIndex - 1
                if colorIndex == 13 then
                    SetVehicleHeadlightsColour(vehicle, -1)
                else
                    SetVehicleHeadlightsColour(vehicle, colorIndex)
                end
            elseif special == "tireSmokeColor" then
                local color = tireSmokeColors[newIndex]
                if color then
                    SetVehicleTyreSmokeColor(vehicle, color.r, color.g, color.b)
                end
            elseif special == "windowTint" then
                local tintMap = { 4, 0, 5, 3, 2, 1, 6 }
                SetVehicleWindowTint(vehicle, tintMap[newIndex] or 4)
            end
        end
    end

    modMenu.OnListItemSelect = function(sender, item, selectedIndex, itemIndex)
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)

        if vehicle == 0 then
            Notify.Error("You need to be in a vehicle.")
            return
        end

        if item.ItemData and item.ItemData.modType then
            Notify.Custom("Applied ~y~" .. (item.Text or "mod") .. "~s~.")
        end
    end
end

function VehicleOptionsMenu.SetupDoorsMenu()
    local doorNames = { "Front Left", "Front Right", "Rear Left", "Rear Right", "Hood", "Trunk", "Extra 1", "Extra 2" }

    doorsMenu.OnMenuOpen = function(sender)
        doorsMenu:ClearMenuItems()

        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)

        if vehicle == 0 then
            local noVehicleBtn = MenuItem:New("No vehicle", "You need to be in a vehicle.")
            noVehicleBtn.Enabled = false
            doorsMenu:AddMenuItem(noVehicleBtn)
            return
        end

        local openAllBtn = MenuItem:New("Open All Doors", "Open all vehicle doors.")
        local closeAllBtn = MenuItem:New("Close All Doors", "Close all vehicle doors.")

        doorsMenu:AddMenuItem(openAllBtn)
        doorsMenu:AddMenuItem(closeAllBtn)

        for i, name in ipairs(doorNames) do
            local doorIndex = i - 1
            if GetIsDoorValid(vehicle, doorIndex) then
                local doorStatus = GetVehicleDoorAngleRatio(vehicle, doorIndex) > 0.1
                local doorBtn = MenuItem:New(name, "Open/Close this door.")
                doorBtn.Label = doorStatus and "Open" or "Closed"
                doorBtn.ItemData = doorIndex
                doorsMenu:AddMenuItem(doorBtn)
            end
        end

        doorsMenu.OnItemSelect = function(sender2, item, index)
            if item == openAllBtn then
                for i = 0, 7 do
                    SetVehicleDoorOpen(vehicle, i, false, false)
                end
            elseif item == closeAllBtn then
                SetVehicleDoorsShut(vehicle, false)
            elseif item.ItemData ~= nil then
                local doorIndex = item.ItemData
                local doorOpen = GetVehicleDoorAngleRatio(vehicle, doorIndex) > 0.1
                if doorOpen then
                    SetVehicleDoorShut(vehicle, doorIndex, false)
                    item.Label = "Closed"
                else
                    SetVehicleDoorOpen(vehicle, doorIndex, false, false)
                    item.Label = "Open"
                end
            end
        end
    end
end

function VehicleOptionsMenu.SetupWindowsMenu()
    local windowNames = { "Front Left", "Front Right", "Rear Left", "Rear Right" }

    windowsMenu.OnMenuOpen = function(sender)
        windowsMenu:ClearMenuItems()

        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)

        if vehicle == 0 then
            local noVehicleBtn = MenuItem:New("No vehicle", "You need to be in a vehicle.")
            noVehicleBtn.Enabled = false
            windowsMenu:AddMenuItem(noVehicleBtn)
            return
        end

        local rollDownAllBtn = MenuItem:New("Roll Down All Windows", "Roll down all windows.")
        local rollUpAllBtn = MenuItem:New("Roll Up All Windows", "Roll up all windows.")

        windowsMenu:AddMenuItem(rollDownAllBtn)
        windowsMenu:AddMenuItem(rollUpAllBtn)

        for i, name in ipairs(windowNames) do
            local windowIndex = i - 1
            local windowBtn = MenuItem:New(name, "Toggle this window.")
            windowBtn.ItemData = windowIndex
            windowsMenu:AddMenuItem(windowBtn)
        end

        windowsMenu.OnItemSelect = function(sender2, item, index)
            if item == rollDownAllBtn then
                for i = 0, 3 do
                    RollDownWindow(vehicle, i)
                end
            elseif item == rollUpAllBtn then
                for i = 0, 3 do
                    RollUpWindow(vehicle, i)
                end
            elseif item.ItemData ~= nil then
                local windowIndex = item.ItemData
                if IsVehicleWindowIntact(vehicle, windowIndex) then
                    RollDownWindow(vehicle, windowIndex)
                else
                    RollUpWindow(vehicle, windowIndex)
                end
            end
        end
    end
end

function VehicleOptionsMenu.SetupExtrasMenu()
    extrasMenu.OnMenuOpen = function(sender)
        extrasMenu:ClearMenuItems()

        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)

        if vehicle == 0 then
            local noVehicleBtn = MenuItem:New("No vehicle", "You need to be in a vehicle.")
            noVehicleBtn.Enabled = false
            extrasMenu:AddMenuItem(noVehicleBtn)
            return
        end

        local hasExtras = false
        for i = 0, 14 do
            if DoesExtraExist(vehicle, i) then
                hasExtras = true
                local extraEnabled = IsVehicleExtraTurnedOn(vehicle, i)
                local extraCheckbox = MenuCheckboxItem:New("Extra #" .. i, "Toggle extra #" .. i, extraEnabled)
                extraCheckbox.ItemData = i
                extrasMenu:AddMenuItem(extraCheckbox)
            end
        end

        if not hasExtras then
            local noExtrasBtn = MenuItem:New("No Extras", "This vehicle has no extras.")
            noExtrasBtn.Enabled = false
            extrasMenu:AddMenuItem(noExtrasBtn)
        end

        extrasMenu.OnCheckboxChange = function(sender2, item, index, checked)
            if item.ItemData ~= nil then
                SetVehicleExtra(vehicle, item.ItemData, not checked)
            end
        end
    end
end

function VehicleOptionsMenu.SetupLiveriesMenu()
    liveriesMenu.OnMenuOpen = function(sender)
        liveriesMenu:ClearMenuItems()

        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)

        if vehicle == 0 then
            local noVehicleBtn = MenuItem:New("No vehicle", "You need to be in a vehicle.")
            noVehicleBtn.Enabled = false
            liveriesMenu:AddMenuItem(noVehicleBtn)
            return
        end

        local liveryCount = GetVehicleLiveryCount(vehicle)
        if liveryCount < 1 then
            local noLiveriesBtn = MenuItem:New("No Liveries", "This vehicle has no liveries.")
            noLiveriesBtn.Enabled = false
            liveriesMenu:AddMenuItem(noLiveriesBtn)
            return
        end

        local currentLivery = GetVehicleLivery(vehicle)

        for i = 0, liveryCount - 1 do
            local liveryName = GetLiveryName(vehicle, i)
            if liveryName == "NULL" then
                liveryName = "Livery #" .. (i + 1)
            else
                liveryName = GetLabelText(liveryName)
            end
            local liveryBtn = MenuItem:New(liveryName, "Apply this livery.")
            liveryBtn.ItemData = i
            if i == currentLivery then
                liveryBtn.Label = "Current"
            end
            liveriesMenu:AddMenuItem(liveryBtn)
        end

        liveriesMenu.OnItemSelect = function(sender2, item, index)
            if item.ItemData ~= nil then
                SetVehicleLivery(vehicle, item.ItemData)
                Notify.Success("Livery applied.")
                for _, menuItem in ipairs(liveriesMenu:GetMenuItems()) do
                    if menuItem.ItemData == item.ItemData then
                        menuItem.Label = "Current"
                    else
                        menuItem.Label = ""
                    end
                end
            end
        end
    end
end

function VehicleOptionsMenu.SetupColorsMenu()
    local primaryColorsMenu = Menu:New("Vehicle Colors", "Primary Colors")
    local secondaryColorsMenu = Menu:New("Vehicle Colors", "Secondary Colors")
    MenuController:AddMenu(primaryColorsMenu)
    MenuController:AddMenu(secondaryColorsMenu)

    local classicColorNames = {}
    local matteColorNames = {}
    local metalColorNames = {}
    local utilColorNames = {}
    local wornColorNames = {}
    local chameleonColorNames = {}

    for i, color in ipairs(VehicleColors.ClassicColors) do
        table.insert(classicColorNames, color.name .. " (" .. i .. "/" .. #VehicleColors.ClassicColors .. ")")
    end
    for i, color in ipairs(VehicleColors.MatteColors) do
        table.insert(matteColorNames, color.name .. " (" .. i .. "/" .. #VehicleColors.MatteColors .. ")")
    end
    for i, color in ipairs(VehicleColors.MetalColors) do
        table.insert(metalColorNames, color.name .. " (" .. i .. "/" .. #VehicleColors.MetalColors .. ")")
    end
    for i, color in ipairs(VehicleColors.UtilColors) do
        table.insert(utilColorNames, color.name .. " (" .. i .. "/" .. #VehicleColors.UtilColors .. ")")
    end
    for i, color in ipairs(VehicleColors.WornColors) do
        table.insert(wornColorNames, color.name .. " (" .. i .. "/" .. #VehicleColors.WornColors .. ")")
    end
    for i, color in ipairs(VehicleColors.ChameleonColors) do
        table.insert(chameleonColorNames, color.name .. " (" .. i .. "/" .. #VehicleColors.ChameleonColors .. ")")
    end

    local wheelColorNames = { "Default Alloy" }
    for _, name in ipairs(classicColorNames) do
        table.insert(wheelColorNames, name)
    end

    colorsMenu.OnMenuOpen = function(sender)
        colorsMenu:ClearMenuItems()

        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)

        if vehicle == 0 then
            local noVehicleBtn = MenuItem:New("No vehicle", "You need to be in a vehicle.")
            noVehicleBtn.Enabled = false
            colorsMenu:AddMenuItem(noVehicleBtn)
            return
        end

        local primaryColor, secondaryColor = GetVehicleColours(vehicle)
        local pearlColor, wheelColor = GetVehicleExtraColours(vehicle)
        local currentDash = GetVehicleInteriorColour(vehicle)
        local currentInt = GetVehicleDashboardColour(vehicle)

        local currentDashIdx = VehicleColors.GetIndexById(VehicleColors.ClassicColors, currentDash)
        local currentIntIdx = VehicleColors.GetIndexById(VehicleColors.ClassicColors, currentInt)

        local currentWheelIdx = 1
        if wheelColor ~= 156 then
            currentWheelIdx = VehicleColors.GetIndexById(VehicleColors.ClassicColors, wheelColor) + 1
        end

        local primaryColorsBtn = MenuItem:New("Primary Color", "Change the primary color of your vehicle.")
        primaryColorsBtn.Label = "→→→"
        colorsMenu:AddMenuItem(primaryColorsBtn)
        MenuController:BindMenuItem(colorsMenu, primaryColorsMenu, primaryColorsBtn)

        local secondaryColorsBtn = MenuItem:New("Secondary Color", "Change the secondary color of your vehicle.")
        secondaryColorsBtn.Label = "→→→"
        colorsMenu:AddMenuItem(secondaryColorsBtn)
        MenuController:BindMenuItem(colorsMenu, secondaryColorsMenu, secondaryColorsBtn)

        local chromeBtn = MenuItem:New("Chrome", "Set your vehicle to chrome.")
        colorsMenu:AddMenuItem(chromeBtn)

        local currentEnveff = GetVehicleEnveffScale(vehicle)
        local enveffSlider = MenuSliderItem:New("Vehicle Enveff Scale",
            "This works on certain vehicles only, like the besra for example. It 'fades' certain paint layers.",
            0, 20, math.floor(currentEnveff * 20), true)
        colorsMenu:AddMenuItem(enveffSlider)

        local dashColorList = MenuListItem:New("Dashboard Color", classicColorNames, currentDashIdx,
            "Change your vehicle's dashboard color.")
        colorsMenu:AddMenuItem(dashColorList)

        local intColorList = MenuListItem:New("Interior / Trim Color", classicColorNames, currentIntIdx,
            "Change your vehicle's interior/trim color.")
        colorsMenu:AddMenuItem(intColorList)

        local wheelColorList = MenuListItem:New("Wheel Color", wheelColorNames, currentWheelIdx,
            "Change your vehicle's wheel color.")
        colorsMenu:AddMenuItem(wheelColorList)

        colorsMenu.OnItemSelect = function(sender2, item, index)
            if item == chromeBtn then
                local veh = GetVehiclePedIsIn(PlayerPedId(), false)
                if veh ~= 0 then
                    SetVehicleColours(veh, VehicleColors.ChromeColorId, VehicleColors.ChromeColorId)
                    Notify.Success("Vehicle set to Chrome!")
                end
            end
        end

        colorsMenu.OnSliderPositionChange = function(sender2, item, oldValue, newValue, index)
            if item == enveffSlider then
                local veh = GetVehiclePedIsIn(PlayerPedId(), false)
                if veh ~= 0 then
                    SetVehicleEnveffScale(veh, newValue / 20.0)
                end
            end
        end

        colorsMenu.OnListIndexChange = function(sender2, item, oldIndex, newIndex, itemIndex)
            local veh = GetVehiclePedIsIn(PlayerPedId(), false)
            if veh == 0 then return end

            local primaryColor, secondaryColor = GetVehicleColours(veh)
            local pearlColor, wheelColor = GetVehicleExtraColours(veh)

            if item == dashColorList then
                local colorId = VehicleColors.ClassicColors[newIndex].id
                SetVehicleInteriorColour(veh, colorId)
            elseif item == intColorList then
                local colorId = VehicleColors.ClassicColors[newIndex].id
                SetVehicleDashboardColour(veh, colorId)
            elseif item == wheelColorList then
                if newIndex == 1 then
                    SetVehicleExtraColours(veh, pearlColor, 156)
                else
                    local colorId = VehicleColors.ClassicColors[newIndex - 1].id
                    SetVehicleExtraColours(veh, pearlColor, colorId)
                end
            end
        end

        colorsMenu.OnListItemSelect = function(sender2, item, selectedIndex, itemIndex)
            local veh = GetVehiclePedIsIn(PlayerPedId(), false)
            if veh == 0 then
                Notify.Error("You need to be in a vehicle.")
                return
            end

            if item == dashColorList then
                Notify.Custom("Dashboard color changed!")
            elseif item == intColorList then
                Notify.Custom("Interior/Trim color changed!")
            elseif item == wheelColorList then
                Notify.Custom("Wheel color changed!")
            end
        end
    end

    primaryColorsMenu.OnMenuOpen = function(sender)
        primaryColorsMenu:ClearMenuItems()

        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)

        if vehicle == 0 then
            local noVehicleBtn = MenuItem:New("No vehicle", "You need to be in a vehicle.")
            noVehicleBtn.Enabled = false
            primaryColorsMenu:AddMenuItem(noVehicleBtn)
            return
        end

        local primaryColor, secondaryColor = GetVehicleColours(vehicle)
        local pearlColor, wheelColor = GetVehicleExtraColours(vehicle)

        local currentClassicIdx = VehicleColors.GetIndexById(VehicleColors.ClassicColors, primaryColor)
        local currentMatteIdx = VehicleColors.GetIndexById(VehicleColors.MatteColors, primaryColor)
        local currentMetalIdx = VehicleColors.GetIndexById(VehicleColors.MetalColors, primaryColor)
        local currentUtilIdx = VehicleColors.GetIndexById(VehicleColors.UtilColors, primaryColor)
        local currentWornIdx = VehicleColors.GetIndexById(VehicleColors.WornColors, primaryColor)
        local currentChameleonIdx = VehicleColors.GetIndexById(VehicleColors.ChameleonColors, primaryColor)

        local customRgbBtn = MenuItem:New("Custom RGB", "Set a custom RGB color for the primary color.")
        customRgbBtn.Label = "→→→"
        primaryColorsMenu:AddMenuItem(customRgbBtn)

        local classicList = MenuListItem:New("Classic", classicColorNames, currentClassicIdx, "Select a classic color.")
        local metallicList = MenuListItem:New("Metallic", classicColorNames, currentClassicIdx,
            "Select a metallic color with pearlescent.")
        local matteList = MenuListItem:New("Matte", matteColorNames, currentMatteIdx, "Select a matte color.")
        local metalList = MenuListItem:New("Metals", metalColorNames, currentMetalIdx, "Select a metal color.")
        local utilList = MenuListItem:New("Util", utilColorNames, currentUtilIdx, "Select a util color.")
        local wornList = MenuListItem:New("Worn", wornColorNames, currentWornIdx, "Select a worn color.")
        local chameleonList = MenuListItem:New("Chameleon", chameleonColorNames, currentChameleonIdx,
            "Select a chameleon color (May only work on certain vehicles).")

        primaryColorsMenu:AddMenuItem(classicList)
        primaryColorsMenu:AddMenuItem(metallicList)
        primaryColorsMenu:AddMenuItem(matteList)
        primaryColorsMenu:AddMenuItem(metalList)
        primaryColorsMenu:AddMenuItem(utilList)
        primaryColorsMenu:AddMenuItem(wornList)
        primaryColorsMenu:AddMenuItem(chameleonList)

        primaryColorsMenu.OnItemSelect = function(sender2, item, index)
            if item == customRgbBtn then
                local veh = GetVehiclePedIsIn(PlayerPedId(), false)
                if veh ~= 0 then
                    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "0", "", "", "", 3)
                    while UpdateOnscreenKeyboard() == 0 do Wait(0) end
                    local rResult = GetOnscreenKeyboardResult()
                    if not rResult then return end
                    local r = tonumber(rResult) or 0
                    r = math.max(0, math.min(255, r))

                    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "0", "", "", "", 3)
                    while UpdateOnscreenKeyboard() == 0 do Wait(0) end
                    local gResult = GetOnscreenKeyboardResult()
                    if not gResult then return end
                    local g = tonumber(gResult) or 0
                    g = math.max(0, math.min(255, g))

                    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "0", "", "", "", 3)
                    while UpdateOnscreenKeyboard() == 0 do Wait(0) end
                    local bResult = GetOnscreenKeyboardResult()
                    if not bResult then return end
                    local b = tonumber(bResult) or 0
                    b = math.max(0, math.min(255, b))

                    SetVehicleCustomPrimaryColour(veh, r, g, b)
                    Notify.Success("Primary color set to RGB(" .. r .. ", " .. g .. ", " .. b .. ")")
                end
            end
        end

        primaryColorsMenu.OnListIndexChange = function(sender2, item, oldIndex, newIndex, itemIndex)
            local veh = GetVehiclePedIsIn(PlayerPedId(), false)
            if veh == 0 then return end

            local primaryColor, secondaryColor = GetVehicleColours(veh)
            local pearlColor, wheelColor = GetVehicleExtraColours(veh)
            local newPrimaryColor = primaryColor
            local newPearlColor = 0

            if item == classicList then
                newPrimaryColor = VehicleColors.ClassicColors[newIndex].id
            elseif item == metallicList then
                newPrimaryColor = VehicleColors.ClassicColors[newIndex].id
                newPearlColor = VehicleColors.ClassicColors[newIndex].id
            elseif item == matteList then
                newPrimaryColor = VehicleColors.MatteColors[newIndex].id
            elseif item == metalList then
                newPrimaryColor = VehicleColors.MetalColors[newIndex].id
            elseif item == utilList then
                newPrimaryColor = VehicleColors.UtilColors[newIndex].id
            elseif item == wornList then
                newPrimaryColor = VehicleColors.WornColors[newIndex].id
            elseif item == chameleonList then
                newPrimaryColor = VehicleColors.ChameleonColors[newIndex].id
            end

            ClearVehicleCustomPrimaryColour(veh)
            SetVehicleColours(veh, newPrimaryColor, secondaryColor)
            if item == metallicList then
                SetVehicleExtraColours(veh, newPearlColor, wheelColor)
            end
        end

        primaryColorsMenu.OnListItemSelect = function(sender2, item, selectedIndex, itemIndex)
            Notify.Custom("Primary color changed!")
        end
    end

    secondaryColorsMenu.OnMenuOpen = function(sender)
        secondaryColorsMenu:ClearMenuItems()

        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)

        if vehicle == 0 then
            local noVehicleBtn = MenuItem:New("No vehicle", "You need to be in a vehicle.")
            noVehicleBtn.Enabled = false
            secondaryColorsMenu:AddMenuItem(noVehicleBtn)
            return
        end

        local primaryColor, secondaryColor = GetVehicleColours(vehicle)
        local pearlColor, wheelColor = GetVehicleExtraColours(vehicle)

        local currentPearlIdx = VehicleColors.GetIndexById(VehicleColors.ClassicColors, pearlColor)
        local currentClassicIdx = VehicleColors.GetIndexById(VehicleColors.ClassicColors, secondaryColor)
        local currentMatteIdx = VehicleColors.GetIndexById(VehicleColors.MatteColors, secondaryColor)
        local currentMetalIdx = VehicleColors.GetIndexById(VehicleColors.MetalColors, secondaryColor)
        local currentUtilIdx = VehicleColors.GetIndexById(VehicleColors.UtilColors, secondaryColor)
        local currentWornIdx = VehicleColors.GetIndexById(VehicleColors.WornColors, secondaryColor)
        local currentChameleonIdx = VehicleColors.GetIndexById(VehicleColors.ChameleonColors, secondaryColor)

        local customRgbBtn = MenuItem:New("Custom RGB", "Set a custom RGB color for the secondary color.")
        customRgbBtn.Label = "→→→"
        secondaryColorsMenu:AddMenuItem(customRgbBtn)

        local pearlList = MenuListItem:New("Pearlescent", classicColorNames, currentPearlIdx,
            "Select a pearlescent color.")
        secondaryColorsMenu:AddMenuItem(pearlList)

        local classicList = MenuListItem:New("Classic", classicColorNames, currentClassicIdx, "Select a classic color.")
        local matteList = MenuListItem:New("Matte", matteColorNames, currentMatteIdx, "Select a matte color.")
        local metalList = MenuListItem:New("Metals", metalColorNames, currentMetalIdx, "Select a metal color.")
        local utilList = MenuListItem:New("Util", utilColorNames, currentUtilIdx, "Select a util color.")
        local wornList = MenuListItem:New("Worn", wornColorNames, currentWornIdx, "Select a worn color.")
        local chameleonList = MenuListItem:New("Chameleon", chameleonColorNames, currentChameleonIdx,
            "Select a chameleon color (May only work on certain vehicles).")

        secondaryColorsMenu:AddMenuItem(classicList)
        secondaryColorsMenu:AddMenuItem(matteList)
        secondaryColorsMenu:AddMenuItem(metalList)
        secondaryColorsMenu:AddMenuItem(utilList)
        secondaryColorsMenu:AddMenuItem(wornList)
        secondaryColorsMenu:AddMenuItem(chameleonList)

        secondaryColorsMenu.OnItemSelect = function(sender2, item, index)
            if item == customRgbBtn then
                local veh = GetVehiclePedIsIn(PlayerPedId(), false)
                if veh ~= 0 then
                    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "0", "", "", "", 3)
                    while UpdateOnscreenKeyboard() == 0 do Wait(0) end
                    local rResult = GetOnscreenKeyboardResult()
                    if not rResult then return end
                    local r = tonumber(rResult) or 0
                    r = math.max(0, math.min(255, r))

                    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "0", "", "", "", 3)
                    while UpdateOnscreenKeyboard() == 0 do Wait(0) end
                    local gResult = GetOnscreenKeyboardResult()
                    if not gResult then return end
                    local g = tonumber(gResult) or 0
                    g = math.max(0, math.min(255, g))

                    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "0", "", "", "", 3)
                    while UpdateOnscreenKeyboard() == 0 do Wait(0) end
                    local bResult = GetOnscreenKeyboardResult()
                    if not bResult then return end
                    local b = tonumber(bResult) or 0
                    b = math.max(0, math.min(255, b))

                    SetVehicleCustomSecondaryColour(veh, r, g, b)
                    Notify.Success("Secondary color set to RGB(" .. r .. ", " .. g .. ", " .. b .. ")")
                end
            end
        end

        secondaryColorsMenu.OnListIndexChange = function(sender2, item, oldIndex, newIndex, itemIndex)
            local veh = GetVehiclePedIsIn(PlayerPedId(), false)
            if veh == 0 then return end

            local primaryColor, secondaryColor = GetVehicleColours(veh)
            local pearlColor, wheelColor = GetVehicleExtraColours(veh)
            local newSecondaryColor = secondaryColor
            local newPearlColor = pearlColor

            if item == pearlList then
                newPearlColor = VehicleColors.ClassicColors[newIndex].id
                SetVehicleExtraColours(veh, newPearlColor, wheelColor)
                return
            elseif item == classicList then
                newSecondaryColor = VehicleColors.ClassicColors[newIndex].id
            elseif item == matteList then
                newSecondaryColor = VehicleColors.MatteColors[newIndex].id
            elseif item == metalList then
                newSecondaryColor = VehicleColors.MetalColors[newIndex].id
            elseif item == utilList then
                newSecondaryColor = VehicleColors.UtilColors[newIndex].id
            elseif item == wornList then
                newSecondaryColor = VehicleColors.WornColors[newIndex].id
            elseif item == chameleonList then
                newSecondaryColor = VehicleColors.ChameleonColors[newIndex].id
            end

            ClearVehicleCustomSecondaryColour(veh)
            SetVehicleColours(veh, primaryColor, newSecondaryColor)
        end

        secondaryColorsMenu.OnListItemSelect = function(sender2, item, selectedIndex, itemIndex)
            if item == pearlList then
                Notify.Custom("Pearlescent color changed!")
            else
                Notify.Custom("Secondary color changed!")
            end
        end
    end
end

function VehicleOptionsMenu.SetupUnderglowMenu()
    underglowMenu.OnMenuOpen = function(sender)
        underglowMenu:ClearMenuItems()

        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)

        if vehicle == 0 then
            local noVehicleBtn = MenuItem:New("No vehicle", "You need to be in a vehicle.")
            noVehicleBtn.Enabled = false
            underglowMenu:AddMenuItem(noVehicleBtn)
            return
        end

        local frontCheckbox = MenuCheckboxItem:New("Enable Front Light", "Toggle the front neon light.",
            IsVehicleNeonLightEnabled(vehicle, 2))
        local backCheckbox = MenuCheckboxItem:New("Enable Back Light", "Toggle the back neon light.",
            IsVehicleNeonLightEnabled(vehicle, 3))
        local leftCheckbox = MenuCheckboxItem:New("Enable Left Light", "Toggle the left neon light.",
            IsVehicleNeonLightEnabled(vehicle, 0))
        local rightCheckbox = MenuCheckboxItem:New("Enable Right Light", "Toggle the right neon light.",
            IsVehicleNeonLightEnabled(vehicle, 1))

        underglowMenu:AddMenuItem(frontCheckbox)
        underglowMenu:AddMenuItem(backCheckbox)
        underglowMenu:AddMenuItem(leftCheckbox)
        underglowMenu:AddMenuItem(rightCheckbox)

        for i, color in ipairs(neonColors) do
            local colorBtn = MenuItem:New(color.name, "Set underglow color to " .. color.name)
            colorBtn.ItemData = color
            underglowMenu:AddMenuItem(colorBtn)
        end

        underglowMenu.OnCheckboxChange = function(sender2, item, index, checked)
            if item == frontCheckbox then
                SetVehicleNeonLightEnabled(vehicle, 2, checked)
            elseif item == backCheckbox then
                SetVehicleNeonLightEnabled(vehicle, 3, checked)
            elseif item == leftCheckbox then
                SetVehicleNeonLightEnabled(vehicle, 0, checked)
            elseif item == rightCheckbox then
                SetVehicleNeonLightEnabled(vehicle, 1, checked)
            end
        end

        underglowMenu.OnItemSelect = function(sender2, item, index)
            if item.ItemData then
                local color = item.ItemData
                SetVehicleNeonLightsColour(vehicle, color.r, color.g, color.b)
                Notify.Custom("Underglow color set to " .. color.name)
            end
        end
    end
end

function VehicleOptionsMenu.GetMenu()
    if menu == nil then
        VehicleOptionsMenu.CreateMenu()
    end
    return menu
end

function VehicleOptionsMenu.SaveSettings()
    local settings = {
        VehicleGodMode               = VehicleOptionsMenu.VehicleGodMode,
        VehicleGodInvincible         = VehicleOptionsMenu.VehicleGodInvincible,
        VehicleGodEngine             = VehicleOptionsMenu.VehicleGodEngine,
        VehicleGodVisual             = VehicleOptionsMenu.VehicleGodVisual,
        VehicleGodStrongWheels       = VehicleOptionsMenu.VehicleGodStrongWheels,
        VehicleGodRamp               = VehicleOptionsMenu.VehicleGodRamp,
        VehicleGodAutoRepair         = VehicleOptionsMenu.VehicleGodAutoRepair,
        VehicleNeverDirty            = VehicleOptionsMenu.VehicleNeverDirty,
        VehicleEngineAlwaysOn        = VehicleOptionsMenu.VehicleEngineAlwaysOn,
        VehicleNoSiren               = VehicleOptionsMenu.VehicleNoSiren,
        VehicleNoBikeHelmets         = VehicleOptionsMenu.VehicleNoBikeHelmets,
        VehicleBikeSeatbelt          = VehicleOptionsMenu.VehicleBikeSeatbelt,
        VehicleInfiniteFuel          = VehicleOptionsMenu.VehicleInfiniteFuel,
        FlashHighbeamsOnHonk         = VehicleOptionsMenu.FlashHighbeamsOnHonk,
        DisablePlaneTurbulence       = VehicleOptionsMenu.DisablePlaneTurbulence,
        DisableHelicopterTurbulence  = VehicleOptionsMenu.DisableHelicopterTurbulence,
        TorqueEnabled                = VehicleOptionsMenu.TorqueEnabled,
        PowerEnabled                 = VehicleOptionsMenu.PowerEnabled,
        TorqueMultiplier             = VehicleOptionsMenu.TorqueMultiplier,
        PowerMultiplier              = VehicleOptionsMenu.PowerMultiplier,
        SpeedLimitEnabled            = VehicleOptionsMenu.SpeedLimitEnabled,
        SpeedLimit                   = VehicleOptionsMenu.SpeedLimit,
    }
    SetResourceKvp("vmenu_vehicle_options", json.encode(settings))
end

function VehicleOptionsMenu.LoadSettings()
    local data = GetResourceKvpString("vmenu_vehicle_options")
    if not data or data == "" then return end
    local settings = json.decode(data)
    if not settings then return end
    for key, value in pairs(settings) do
        if VehicleOptionsMenu[key] ~= nil then
            VehicleOptionsMenu[key] = value
        end
    end
end

Citizen.CreateThread((function()
    while true do
        local sleep = 1000

        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)
        local lastVehicle = GetVehiclePedIsIn(ped, true)

        local activeFeatures = VehicleOptionsMenu.VehicleGodMode or
            VehicleOptionsMenu.VehicleNeverDirty or
            VehicleOptionsMenu.VehicleEngineAlwaysOn or
            VehicleOptionsMenu.VehicleNoSiren or
            VehicleOptionsMenu.FlashHighbeamsOnHonk or
            VehicleOptionsMenu.DisablePlaneTurbulence or
            VehicleOptionsMenu.DisableHelicopterTurbulence or
            VehicleOptionsMenu.TorqueEnabled or
            VehicleOptionsMenu.PowerEnabled or
            VehicleOptionsMenu.SpeedLimitEnabled or
            VehicleOptionsMenu.VehicleShowHealth or
            VehicleOptionsMenu.VehicleBikeSeatbelt or
            VehicleOptionsMenu.VehicleFrozen

        if activeFeatures then
            sleep = 0

            if VehicleOptionsMenu.VehicleGodMode and vehicle ~= 0 then
                if VehicleOptionsMenu.VehicleGodInvincible then
                    SetEntityInvincible(vehicle, true)
                end
                if VehicleOptionsMenu.VehicleGodEngine then
                    SetVehicleEngineHealth(vehicle, 1000.0)
                end
                if VehicleOptionsMenu.VehicleGodVisual then
                    SetVehicleCanBeVisiblyDamaged(vehicle, false)
                end
                if VehicleOptionsMenu.VehicleGodStrongWheels then
                    SetVehicleWheelsCanBreak(vehicle, false)
                end
                if VehicleOptionsMenu.VehicleGodAutoRepair then
                    if GetVehicleEngineHealth(vehicle) < 1000.0 or GetVehicleBodyHealth(vehicle) < 1000.0 then
                        SetVehicleFixed(vehicle)
                    end
                end
            end

            if VehicleOptionsMenu.VehicleNeverDirty and vehicle ~= 0 then
                if GetVehicleDirtLevel(vehicle) > 0.0 then
                    SetVehicleDirtLevel(vehicle, 0.0)
                end
            end

            if VehicleOptionsMenu.VehicleEngineAlwaysOn and lastVehicle ~= 0 and not IsPedInAnyVehicle(ped, false) then
                SetVehicleEngineOn(lastVehicle, true, true, false)
            end

            if VehicleOptionsMenu.VehicleNoSiren and vehicle ~= 0 then
                SetVehicleHasMutedSirens(vehicle, true)
            end

            if VehicleOptionsMenu.FlashHighbeamsOnHonk and vehicle ~= 0 then
                if IsControlPressed(0, 86) then
                    SetVehicleFullbeam(vehicle, true)
                else
                    SetVehicleFullbeam(vehicle, false)
                end
            end

            if VehicleOptionsMenu.DisablePlaneTurbulence and vehicle ~= 0 then
                if IsThisModelAPlane(GetEntityModel(vehicle)) then
                    SetPlaneTurbulenceMultiplier(vehicle, 0.0)
                end
            end

            if VehicleOptionsMenu.DisableHelicopterTurbulence and vehicle ~= 0 then
                if IsThisModelAHeli(GetEntityModel(vehicle)) then
                    SetHeliTurbulenceScalar(vehicle, 0.0)
                end
            end

            if VehicleOptionsMenu.TorqueEnabled and vehicle ~= 0 then
                SetVehicleEngineTorqueMultiplier(vehicle, VehicleOptionsMenu.TorqueMultiplier)
            end

            if VehicleOptionsMenu.PowerEnabled and vehicle ~= 0 then
                SetVehicleEnginePowerMultiplier(vehicle, VehicleOptionsMenu.PowerMultiplier)
            end

            if VehicleOptionsMenu.SpeedLimitEnabled and vehicle ~= 0 then
                SetVehicleMaxSpeed(vehicle, VehicleOptionsMenu.SpeedLimit)
            end

            if VehicleOptionsMenu.VehicleBikeSeatbelt and vehicle ~= 0 then
                local model = GetEntityModel(vehicle)
                if IsThisModelABike(model) or IsThisModelAQuadbike(model) then
                    SetPedCanBeKnockedOffVehicle(ped, 1)
                end
            end

            if VehicleOptionsMenu.VehicleFrozen and vehicle ~= 0 then
                FreezeEntityPosition(vehicle, true)
            end

            if VehicleOptionsMenu.VehicleShowHealth and vehicle ~= 0 then
                local health = GetVehicleEngineHealth(vehicle)
                local body = GetVehicleBodyHealth(vehicle)
                local tank = GetVehiclePetrolTankHealth(vehicle)

                SetTextFont(4)
                SetTextScale(0.3, 0.3)
                SetTextColour(255, 255, 255, 255)
                SetTextDropshadow(0, 0, 0, 0, 255)
                SetTextEdge(1, 0, 0, 0, 255)
                SetTextDropShadow()
                SetTextOutline()
                SetTextCentre(true)
                SetTextEntry("STRING")
                AddTextComponentString(string.format("Engine: %.0f | Body: %.0f | Tank: %.0f", health, body, tank))
                DrawText(0.5, 0.95)
            end
        end

        if VehicleOptionsMenu.VehicleInvisible and not IsPedInAnyVehicle(ped, false) and lastVehicle ~= 0 then
            SetEntityVisible(lastVehicle, true, false)
            VehicleOptionsMenu.VehicleInvisible = false
        end

        Citizen.Wait(sleep)
    end
end))

return VehicleOptionsMenu
