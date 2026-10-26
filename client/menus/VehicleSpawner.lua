VehicleSpawnerMenu = {}

local menu = nil

VehicleSpawnerMenu.SpawnInVehicle = true
VehicleSpawnerMenu.ReplaceVehicle = true
VehicleSpawnerMenu.LastSpawnedVehicle = nil

local function SpawnVehicle(modelName, spawnInside, replacePrevious)
    local model = GetHashKey(modelName)

    if not IsModelInCdimage(model) or not IsModelAVehicle(model) then
        Notify.Error("Invalid vehicle model: ~r~" .. modelName)
        return false
    end

    RequestModel(model)
    local timeout = 0
    while not HasModelLoaded(model) do
        Wait(10)
        timeout = timeout + 10
        if timeout > 5000 then
            Notify.Error("Failed to load vehicle model.")
            return false
        end
    end

    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)

    local forwardX = pos.x + (math.sin(math.rad(-heading)) * 5.0)
    local forwardY = pos.y + (math.cos(math.rad(-heading)) * 5.0)

    if replacePrevious and VehicleSpawnerMenu.LastSpawnedVehicle ~= nil then
        if DoesEntityExist(VehicleSpawnerMenu.LastSpawnedVehicle) then
            SetEntityAsMissionEntity(VehicleSpawnerMenu.LastSpawnedVehicle, true, true)
            DeleteVehicle(VehicleSpawnerMenu.LastSpawnedVehicle)
        end
        VehicleSpawnerMenu.LastSpawnedVehicle = nil
    end

    local vehicle = CreateVehicle(model, forwardX, forwardY, pos.z, heading, true, false)
    SetVehicleOnGroundProperly(vehicle)
    SetVehicleHasBeenOwnedByPlayer(vehicle, true)
    SetEntityAsMissionEntity(vehicle, true, true)
    SetVehRadioStation(vehicle, "OFF")
    SetModelAsNoLongerNeeded(model)

    VehicleSpawnerMenu.LastSpawnedVehicle = vehicle

    if spawnInside then
        TaskWarpPedIntoVehicle(ped, vehicle, -1)
    end

    TriggerServerEvent("vMenu:LogVehicleSpawn", modelName)
    return true
end

function VehicleSpawnerMenu.CreateMenu()
    menu = Menu:New("Vehicle Spawner", "Spawn Vehicles")
    MenuController:AddMenu(menu)

    local spawnByNameBtn = MenuItem:New("Spawn Vehicle By Name", "Enter the name of a vehicle to spawn.")
    local spawnInsideCheckbox = MenuCheckboxItem:New("Spawn Inside Vehicle", "Teleport into the vehicle when spawned.",
        VehicleSpawnerMenu.SpawnInVehicle)
    local replacePrevCheckbox = MenuCheckboxItem:New("Replace Previous Vehicle",
        "Automatically delete your previously spawned vehicle.", VehicleSpawnerMenu.ReplaceVehicle)

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.VSSpawnByName) then
        menu:AddMenuItem(spawnByNameBtn)
    end

    menu:AddMenuItem(spawnInsideCheckbox)
    menu:AddMenuItem(replacePrevCheckbox)

    if VehicleData and VehicleData.VehicleClasses then
        for categoryName, vehicles in pairs(VehicleData.VehicleClasses) do
            local categoryMenu = Menu:New("Vehicle Spawner", categoryName)
            MenuController:AddMenu(categoryMenu)

            local categoryBtn = MenuItem:New(categoryName, "Spawn a vehicle from the " .. categoryName .. " class.")
            categoryBtn.Label = "→→→"
            menu:AddMenuItem(categoryBtn)
            MenuController:BindMenuItem(menu, categoryMenu, categoryBtn)

            for _, vehicleName in ipairs(vehicles) do
                local vehicleBtn = MenuItem:New(vehicleName, "Click to spawn " .. vehicleName .. ".")
                vehicleBtn.ItemData = vehicleName
                categoryMenu:AddMenuItem(vehicleBtn)
            end

            PedPreview.Register(categoryMenu, function(sender)
                local item = sender:GetMenuItems()[sender.CurrentIndex]
                local vehicleName = item and item.ItemData
                if type(vehicleName) ~= "string" then return nil end
                return vehicleName, vehicleName, nil, nil, "vehicle"
            end)

            categoryMenu.OnItemSelect = function(sender, item, index)
                local vehicleName = item.ItemData
                if vehicleName then
                    SpawnVehicle(vehicleName, VehicleSpawnerMenu.SpawnInVehicle, VehicleSpawnerMenu.ReplaceVehicle)
                end
            end
        end
    end

    menu.OnCheckboxChange = function(sender, item, index, checked)
        if item == spawnInsideCheckbox then
            VehicleSpawnerMenu.SpawnInVehicle = checked
            Notify.Custom("Spawn inside vehicle is now " .. (checked and "~g~enabled~s~" or "~r~disabled~s~") .. ".")

        elseif item == replacePrevCheckbox then
            VehicleSpawnerMenu.ReplaceVehicle = checked
            Notify.Custom("Replace previous vehicle is now " .. (checked and "~g~enabled~s~" or "~r~disabled~s~") .. ".")
        end
    end

    menu.OnItemSelect = function(sender, item, index)
        if item == spawnByNameBtn then
            DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 60)
            while UpdateOnscreenKeyboard() == 0 do
                Wait(0)
            end
            if GetOnscreenKeyboardResult() then
                local vehicleName = GetOnscreenKeyboardResult()
                if vehicleName and vehicleName ~= "" then
                    SpawnVehicle(vehicleName, VehicleSpawnerMenu.SpawnInVehicle, VehicleSpawnerMenu.ReplaceVehicle)
                end
            end
        end
    end

    return menu
end

function VehicleSpawnerMenu.GetMenu()
    if menu == nil then
        VehicleSpawnerMenu.CreateMenu()
    end
    return menu
end

return VehicleSpawnerMenu
