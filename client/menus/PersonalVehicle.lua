PersonalVehicleMenu = {}

local menu = nil
local doorsMenu = nil

PersonalVehicleMenu.CurrentPersonalVehicle = nil
PersonalVehicleMenu.AddBlip = false
PersonalVehicleMenu.ExclusiveDriver = false
PersonalVehicleMenu.PersonalVehicleBlip = nil

local vehicleLightModes = {
    "Force On",
    "Force Off",
    "Reset"
}

local vehicleStanceModes = {
    "Default",
    "Lowered"
}

function PersonalVehicleMenu.CreateMenu()
    local playerName = GetPlayerName(PlayerId())
    menu = Menu:New(playerName, "Personal Vehicle Options")
    MenuController:AddMenu(menu)

    local setVehicleBtn = MenuItem:New("Set Vehicle",
        "Sets your current vehicle as your personal vehicle. If you already have a personal vehicle set, this will override it with the vehicle you're currently sitting in.")

    local toggleEngineBtn = MenuItem:New("Toggle Engine",
        "Toggles the engine on or off, even when you're not inside the vehicle. This only works if the vehicle is not too far away.")

    local vehicleLightsListItem = MenuListItem:New("Set Vehicle Lights", vehicleLightModes, 0,
        "This will enable or disable your vehicle headlights, even when you are not inside the vehicle.")

    local vehicleStanceListItem = MenuListItem:New("Vehicle Stance", vehicleStanceModes, 0,
        "Select stance for your Personal Vehicle.")

    local kickPassengersBtn = MenuItem:New("Kick Passengers",
        "This will remove all passengers from your personal vehicle.")

    local lockDoorsBtn = MenuItem:New("Lock Vehicle Doors",
        "This will lock all your vehicle doors for all players. Anyone already inside the vehicle will be kicked out.")
    local unlockDoorsBtn = MenuItem:New("Unlock Vehicle Doors",
        "This will unlock all your vehicle doors for all players.")

    local doorsBtn = MenuItem:New("Vehicle Doors", "Open, close, remove and restore vehicle doors here.")

    local soundHornBtn = MenuItem:New("Sound Horn", "Sounds the horn of the vehicle.")

    local toggleAlarmBtn = MenuItem:New("Toggle Alarm Sound",
        "Toggles the vehicle alarm sound on or off. This does not enable/disable the alarm system. It only toggles the sound on or off.")

    local addBlipCheckbox = MenuCheckboxItem:New("Add Blip For Personal Vehicle",
        "Enables or disables the blip when marked as personal vehicle.", PersonalVehicleMenu.AddBlip)

    local exclusiveDriverCheckbox = MenuCheckboxItem:New("Exclusive Driver",
        "If enabled, you will be the only one in drivers seat. Everyone else will automatically be kicked out.",
        PersonalVehicleMenu.ExclusiveDriver)

    menu:AddMenuItem(setVehicleBtn)

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.PVToggleEngine) then
        menu:AddMenuItem(toggleEngineBtn)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.PVToggleLights) then
        menu:AddMenuItem(vehicleLightsListItem)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.PVToggleStance) then
        menu:AddMenuItem(vehicleStanceListItem)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.PVKickPassengers) then
        menu:AddMenuItem(kickPassengersBtn)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.PVLockDoors) then
        menu:AddMenuItem(lockDoorsBtn)
        menu:AddMenuItem(unlockDoorsBtn)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.PVDoors) then
        doorsMenu = PersonalVehicleMenu.CreateDoorsMenu()
        menu:AddMenuItem(doorsBtn)
        MenuController:BindMenuItem(menu, doorsMenu, doorsBtn)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.PVSoundHorn) then
        menu:AddMenuItem(soundHornBtn)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.PVToggleAlarm) then
        menu:AddMenuItem(toggleAlarmBtn)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.PVAddBlip) then
        menu:AddMenuItem(addBlipCheckbox)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.PVExclusiveDriver) then
        menu:AddMenuItem(exclusiveDriverCheckbox)
    end

    menu.OnCheckboxChange = function(sender, item, index, checked)
        if item == addBlipCheckbox then
            PersonalVehicleMenu.AddBlip = checked

            if checked and PersonalVehicleMenu.CurrentPersonalVehicle and DoesEntityExist(PersonalVehicleMenu.CurrentPersonalVehicle) then
                if PersonalVehicleMenu.PersonalVehicleBlip and DoesBlipExist(PersonalVehicleMenu.PersonalVehicleBlip) then
                    RemoveBlip(PersonalVehicleMenu.PersonalVehicleBlip)
                end

                PersonalVehicleMenu.PersonalVehicleBlip = AddBlipForEntity(PersonalVehicleMenu.CurrentPersonalVehicle)
                SetBlipSprite(PersonalVehicleMenu.PersonalVehicleBlip, 225)
                SetBlipColor(PersonalVehicleMenu.PersonalVehicleBlip, 3)
                SetBlipDisplay(PersonalVehicleMenu.PersonalVehicleBlip, 2)
                SetBlipAsShortRange(PersonalVehicleMenu.PersonalVehicleBlip, false)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentSubstringPlayerName("Personal Vehicle")
                EndTextCommandSetBlipName(PersonalVehicleMenu.PersonalVehicleBlip)

                Notify.Success("Blip enabled for personal vehicle.")
            elseif checked then
                Notify.Info("Blip will be enabled when you set a personal vehicle.")
            else
                if PersonalVehicleMenu.PersonalVehicleBlip and DoesBlipExist(PersonalVehicleMenu.PersonalVehicleBlip) then
                    RemoveBlip(PersonalVehicleMenu.PersonalVehicleBlip)
                    PersonalVehicleMenu.PersonalVehicleBlip = nil
                end
                Notify.Success("Blip disabled for personal vehicle.")
            end

        elseif item == exclusiveDriverCheckbox then
            PersonalVehicleMenu.ExclusiveDriver = checked
            Notify.Custom("Exclusive driver mode is now " .. (checked and "~g~enabled~s~" or "~r~disabled~s~") .. ".")
        end
    end

    menu.OnListIndexChange = function(sender, item, oldIndex, newIndex, itemIndex)
        if not PersonalVehicleMenu.CurrentPersonalVehicle or not DoesEntityExist(PersonalVehicleMenu.CurrentPersonalVehicle) then
            Notify.Error("You need to set a personal vehicle first!")
            return
        end

        local veh = PersonalVehicleMenu.CurrentPersonalVehicle

        if item == vehicleLightsListItem then
            if newIndex == 0 then
                SetVehicleLights(veh, 2)
                SetVehicleFullbeam(veh, false)
                Notify.Success("Vehicle lights set to: ~b~Force On")
            elseif newIndex == 1 then
                SetVehicleLights(veh, 1)
                Notify.Success("Vehicle lights set to: ~b~Force Off")
            elseif newIndex == 2 then
                SetVehicleLights(veh, 0)
                Notify.Success("Vehicle lights set to: ~b~Reset")
            end

        elseif item == vehicleStanceListItem then
            if newIndex == 0 then
                SetReduceDriftVehicleSuspension(veh, false)
                Notify.Success("Vehicle stance set to: ~b~Default")
            elseif newIndex == 1 then
                SetReduceDriftVehicleSuspension(veh, true)
                Notify.Success("Vehicle stance set to: ~b~Lowered")
            end
        end
    end

    menu.OnItemSelect = function(sender, item, index)
        if item == setVehicleBtn then
            local ped = PlayerPedId()
            local veh = GetVehiclePedIsIn(ped, false)

            if veh ~= 0 then
                if PersonalVehicleMenu.PersonalVehicleBlip and DoesBlipExist(PersonalVehicleMenu.PersonalVehicleBlip) then
                    RemoveBlip(PersonalVehicleMenu.PersonalVehicleBlip)
                    PersonalVehicleMenu.PersonalVehicleBlip = nil
                end

                PersonalVehicleMenu.CurrentPersonalVehicle = veh
                SetVehicleHasBeenOwnedByPlayer(veh, true)
                SetEntityAsMissionEntity(veh, true, true)

                if PersonalVehicleMenu.AddBlip then
                    PersonalVehicleMenu.PersonalVehicleBlip = AddBlipForEntity(veh)
                    SetBlipSprite(PersonalVehicleMenu.PersonalVehicleBlip, 225)
                    SetBlipColor(PersonalVehicleMenu.PersonalVehicleBlip, 3)
                    SetBlipDisplay(PersonalVehicleMenu.PersonalVehicleBlip, 2)
                    SetBlipAsShortRange(PersonalVehicleMenu.PersonalVehicleBlip, false)
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentSubstringPlayerName("Personal Vehicle")
                    EndTextCommandSetBlipName(PersonalVehicleMenu.PersonalVehicleBlip)
                end

                Notify.Success("Personal vehicle set!")
            else
                Notify.Error("You need to be in a vehicle to set it as your personal vehicle.")
            end
        else
            if not PersonalVehicleMenu.CurrentPersonalVehicle or not DoesEntityExist(PersonalVehicleMenu.CurrentPersonalVehicle) then
                Notify.Error("You need to set a personal vehicle first!")
                return
            end

            local veh = PersonalVehicleMenu.CurrentPersonalVehicle
            local ped = PlayerPedId()

            if item == toggleEngineBtn then
                local running = GetIsVehicleEngineRunning(veh)
                SetVehicleEngineOn(veh, not running, false, true)
                Notify.Success("Engine " .. (running and "~r~off~s~" or "~g~on~s~") .. ".")

            elseif item == kickPassengersBtn then
                local maxSeats = GetVehicleMaxNumberOfPassengers(veh)
                local kicked = 0
                for i = -1, maxSeats do
                    local occupant = GetPedInVehicleSeat(veh, i)
                    if occupant ~= 0 and occupant ~= ped then
                        TaskLeaveVehicle(occupant, veh, 4160)
                        kicked = kicked + 1
                    end
                end
                if kicked > 0 then
                    Notify.Success("Kicked " .. kicked .. " passenger(s).")
                else
                    Notify.Info("No passengers to kick.")
                end

            elseif item == lockDoorsBtn then
                SetVehicleDoorsLocked(veh, 2)
                local maxSeats = GetVehicleMaxNumberOfPassengers(veh)
                for i = -1, maxSeats do
                    local occupant = GetPedInVehicleSeat(veh, i)
                    if occupant ~= 0 and occupant ~= ped then
                        TaskLeaveVehicle(occupant, veh, 4160)
                    end
                end
                Notify.Success("Vehicle doors locked.")

            elseif item == unlockDoorsBtn then
                SetVehicleDoorsLocked(veh, 1)
                Notify.Success("Vehicle doors unlocked.")

            elseif item == soundHornBtn then
                StartVehicleHorn(veh, 1000, GetHashKey("HELDDOWN"), false)
                Notify.Success("Horn sounded.")

            elseif item == toggleAlarmBtn then
                if IsVehicleAlarmActivated(veh) then
                    SetVehicleAlarm(veh, false)
                    Notify.Success("Alarm ~r~disabled~s~.")
                else
                    SetVehicleAlarm(veh, true)
                    StartVehicleAlarm(veh)
                    Notify.Success("Alarm ~g~enabled~s~.")
                end
            end
        end
    end

    return menu
end

function PersonalVehicleMenu.CreateDoorsMenu()
    local doorsMenu = Menu:New("Vehicle Doors", "Personal Vehicle Doors")
    MenuController:AddMenu(doorsMenu)

    local frontLeftBtn = MenuItem:New("Front Left Door", "Open/close the front left door.")
    local frontRightBtn = MenuItem:New("Front Right Door", "Open/close the front right door.")
    local rearLeftBtn = MenuItem:New("Rear Left Door", "Open/close the rear left door.")
    local rearRightBtn = MenuItem:New("Rear Right Door", "Open/close the rear right door.")
    local hoodBtn = MenuItem:New("Hood", "Open/close the hood.")
    local trunkBtn = MenuItem:New("Trunk", "Open/close the trunk.")
    local backBtn = MenuItem:New("Trunk (Rear)", "Open/close the back.")

    local removeFrontLeftBtn = MenuItem:New("~r~Remove Front Left Door", "Remove the front left door.")
    local removeFrontRightBtn = MenuItem:New("~r~Remove Front Right Door", "Remove the front right door.")
    local removeRearLeftBtn = MenuItem:New("~r~Remove Rear Left Door", "Remove the rear left door.")
    local removeRearRightBtn = MenuItem:New("~r~Remove Rear Right Door", "Remove the rear right door.")
    local removeHoodBtn = MenuItem:New("~r~Remove Hood", "Remove the hood.")
    local removeTrunkBtn = MenuItem:New("~r~Remove Trunk", "Remove the trunk.")

    local openAllBtn = MenuItem:New("Open All Doors", "Open all vehicle doors.")
    local closeAllBtn = MenuItem:New("Close All Doors", "Close all vehicle doors.")

    doorsMenu:AddMenuItem(frontLeftBtn)
    doorsMenu:AddMenuItem(frontRightBtn)
    doorsMenu:AddMenuItem(rearLeftBtn)
    doorsMenu:AddMenuItem(rearRightBtn)
    doorsMenu:AddMenuItem(hoodBtn)
    doorsMenu:AddMenuItem(trunkBtn)
    doorsMenu:AddMenuItem(backBtn)
    doorsMenu:AddMenuItem(removeFrontLeftBtn)
    doorsMenu:AddMenuItem(removeFrontRightBtn)
    doorsMenu:AddMenuItem(removeRearLeftBtn)
    doorsMenu:AddMenuItem(removeRearRightBtn)
    doorsMenu:AddMenuItem(removeHoodBtn)
    doorsMenu:AddMenuItem(removeTrunkBtn)
    doorsMenu:AddMenuItem(openAllBtn)
    doorsMenu:AddMenuItem(closeAllBtn)

    doorsMenu.OnItemSelect = function(sender, item, index)
        if not PersonalVehicleMenu.CurrentPersonalVehicle or not DoesEntityExist(PersonalVehicleMenu.CurrentPersonalVehicle) then
            Notify.Error("You need to set a personal vehicle first!")
            return
        end

        local veh = PersonalVehicleMenu.CurrentPersonalVehicle

        if item == frontLeftBtn then
            local doorAngle = GetVehicleDoorAngleRatio(veh, 0)
            if doorAngle > 0.0 then
                SetVehicleDoorShut(veh, 0, false)
            else
                SetVehicleDoorOpen(veh, 0, false, false)
            end
        elseif item == frontRightBtn then
            local doorAngle = GetVehicleDoorAngleRatio(veh, 1)
            if doorAngle > 0.0 then
                SetVehicleDoorShut(veh, 1, false)
            else
                SetVehicleDoorOpen(veh, 1, false, false)
            end
        elseif item == rearLeftBtn then
            local doorAngle = GetVehicleDoorAngleRatio(veh, 2)
            if doorAngle > 0.0 then
                SetVehicleDoorShut(veh, 2, false)
            else
                SetVehicleDoorOpen(veh, 2, false, false)
            end
        elseif item == rearRightBtn then
            local doorAngle = GetVehicleDoorAngleRatio(veh, 3)
            if doorAngle > 0.0 then
                SetVehicleDoorShut(veh, 3, false)
            else
                SetVehicleDoorOpen(veh, 3, false, false)
            end
        elseif item == hoodBtn then
            local doorAngle = GetVehicleDoorAngleRatio(veh, 4)
            if doorAngle > 0.0 then
                SetVehicleDoorShut(veh, 4, false)
            else
                SetVehicleDoorOpen(veh, 4, false, false)
            end
        elseif item == trunkBtn then
            local doorAngle = GetVehicleDoorAngleRatio(veh, 5)
            if doorAngle > 0.0 then
                SetVehicleDoorShut(veh, 5, false)
            else
                SetVehicleDoorOpen(veh, 5, false, false)
            end
        elseif item == backBtn then
            local doorAngle = GetVehicleDoorAngleRatio(veh, 6)
            if doorAngle > 0.0 then
                SetVehicleDoorShut(veh, 6, false)
            else
                SetVehicleDoorOpen(veh, 6, false, false)
            end

        elseif item == removeFrontLeftBtn then
            SetVehicleDoorBroken(veh, 0, true)
        elseif item == removeFrontRightBtn then
            SetVehicleDoorBroken(veh, 1, true)
        elseif item == removeRearLeftBtn then
            SetVehicleDoorBroken(veh, 2, true)
        elseif item == removeRearRightBtn then
            SetVehicleDoorBroken(veh, 3, true)
        elseif item == removeHoodBtn then
            SetVehicleDoorBroken(veh, 4, true)
        elseif item == removeTrunkBtn then
            SetVehicleDoorBroken(veh, 5, true)

        elseif item == openAllBtn then
            for i = 0, 7 do
                SetVehicleDoorOpen(veh, i, false, false)
            end
            Notify.Success("All doors opened.")
        elseif item == closeAllBtn then
            for i = 0, 7 do
                SetVehicleDoorShut(veh, i, false)
            end
            Notify.Success("All doors closed.")
        end
    end

    return doorsMenu
end

function PersonalVehicleMenu.GetMenu()
    if menu == nil then
        PersonalVehicleMenu.CreateMenu()
    end
    return menu
end

Citizen.CreateThread((function()
    while true do
        local sleep = 1000

        if PersonalVehicleMenu.ExclusiveDriver
            and PersonalVehicleMenu.CurrentPersonalVehicle
            and DoesEntityExist(PersonalVehicleMenu.CurrentPersonalVehicle) then
            sleep = 0

            local ped = PlayerPedId()
            local veh = PersonalVehicleMenu.CurrentPersonalVehicle
            local driver = GetPedInVehicleSeat(veh, -1)

            if driver ~= 0 and driver ~= ped then
                TaskLeaveVehicle(driver, veh, 4160)
            end
        end

        Citizen.Wait(sleep)
    end
end))

return PersonalVehicleMenu
