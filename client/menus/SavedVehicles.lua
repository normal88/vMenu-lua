SavedVehiclesMenu = {}

local menu = nil
local categoryMenu = nil
local selectedCategoryMenu = nil
local selectedVehicleMenu = nil
local unavailableVehiclesMenu = nil
local classSubMenus = {}
local classMenuItems = {}

local currentSelectedVehicle = nil
local currentCategory = nil
local savedVehicles = {}
local categories = {}
local menuInitialized = false

local vehicleClassNames = {
    [0] = "Compacts",
    [1] = "Sedans",
    [2] = "SUVs",
    [3] = "Coupes",
    [4] = "Muscle",
    [5] = "Sports Classics",
    [6] = "Sports",
    [7] = "Super",
    [8] = "Motorcycles",
    [9] = "Off-road",
    [10] = "Industrial",
    [11] = "Utility",
    [12] = "Vans",
    [13] = "Cycles",
    [14] = "Boats",
    [15] = "Helicopters",
    [16] = "Planes",
    [17] = "Service",
    [18] = "Emergency",
    [19] = "Military",
    [20] = "Commercial",
    [21] = "Trains",
    [22] = "Open Wheel"
}

local UNCATEGORIZED = "Uncategorized"

function SavedVehiclesMenu.CreateMenu()
    menu = Menu:New("Saved Vehicles", "Manage Saved Vehicles")
    MenuController:AddMenu(menu)

    categoryMenu = Menu:New("Saved Vehicles", "Vehicle Categories")
    selectedCategoryMenu = Menu:New("Category", "Manage Category")
    selectedVehicleMenu = Menu:New("Manage Vehicle", "Manage Saved Vehicle")
    unavailableVehiclesMenu = Menu:New("Unavailable Vehicles", "Missing Vehicle Models")

    MenuController:AddMenu(categoryMenu)
    MenuController:AddMenu(selectedCategoryMenu)
    MenuController:AddMenu(selectedVehicleMenu)
    MenuController:AddMenu(unavailableVehiclesMenu)

    for i = 0, 22 do
        local className = vehicleClassNames[i] or ("Class " .. i)
        local classSubMenu = Menu:New("Saved Vehicles", className)
        MenuController:AddMenu(classSubMenu)
        classSubMenus[i] = classSubMenu

        classSubMenu.OnItemSelect = function(sender, item, index)
            if item.ItemData then
                selectedVehicleMenu.ParentMenu = sender
                SavedVehiclesMenu.OpenSelectedVehicleMenu(item.ItemData)
            end
        end
    end

    SavedVehiclesMenu.SetupCategoryMenu()
    SavedVehiclesMenu.SetupSelectedCategoryMenu()
    SavedVehiclesMenu.SetupSelectedVehicleMenu()
    SavedVehiclesMenu.SetupUnavailableVehiclesMenu()

    menu.OnMenuOpen = function(sender)
        if not menuInitialized then
            SavedVehiclesMenu.InitMainMenu()
        else
            SavedVehiclesMenu.UpdateVehicleCounts()
        end
    end

    SavedVehiclesMenu.InitMainMenu()

    return menu
end

function SavedVehiclesMenu.UpdateVehicleCounts()
    SavedVehiclesMenu.LoadSavedVehicles()

    for i = 0, 22 do
        local classBtn = classMenuItems[i]
        if classBtn then
            local vehicleCount = 0
            for _, veh in ipairs(savedVehicles) do
                if veh.model and IsModelInCdimage(veh.model) then
                    local vehClass = GetVehicleClassFromName(veh.model)
                    if vehClass == i then
                        vehicleCount = vehicleCount + 1
                    end
                end
            end

            classBtn.Enabled = true
            classBtn.RightIcon = Icon.NONE
            if vehicleCount > 0 then
                classBtn.Label = "(" .. vehicleCount .. ") →→→"
            else
                classBtn.Label = "→→→"
            end
        end
    end

    for i = 0, 22 do
        SavedVehiclesMenu.RefreshClassSubMenu(i)
    end
end

function SavedVehiclesMenu.InitMainMenu()
    menu:ClearMenuItems()
    SavedVehiclesMenu.LoadSavedVehicles()
    classMenuItems = {}

    local saveVehicleBtn = MenuItem:New("Save Current Vehicle", "Save the vehicle you are currently in.")
    saveVehicleBtn.RightIcon = Icon.CAR
    saveVehicleBtn.ItemData = "saveVehicle"
    menu:AddMenuItem(saveVehicleBtn)

    local classSpacer = MenuItem:New("↓ Vehicle Classes ↓", "")
    classSpacer.Enabled = false
    menu:AddMenuItem(classSpacer)

    for i = 0, 22 do
        local className = vehicleClassNames[i] or ("Class " .. i)

        local vehicleCount = 0
        for _, veh in ipairs(savedVehicles) do
            if veh.model and IsModelInCdimage(veh.model) then
                local vehClass = GetVehicleClassFromName(veh.model)
                if vehClass == i then
                    vehicleCount = vehicleCount + 1
                end
            end
        end

        local classBtn = MenuItem:New(className, "All saved vehicles from the " .. className .. " category.")
        classBtn.Enabled = true
        classBtn.ItemData = { type = "class", classIndex = i }
        if vehicleCount > 0 then
            classBtn.Label = "(" .. vehicleCount .. ") →→→"
        else
            classBtn.Label = "→→→"
        end
        menu:AddMenuItem(classBtn)
        MenuController:BindMenuItem(menu, classSubMenus[i], classBtn)
        classMenuItems[i] = classBtn
    end

    local optionsSpacer = MenuItem:New("↓ Other Options ↓", "")
    optionsSpacer.Enabled = false
    menu:AddMenuItem(optionsSpacer)

    local vehicleCategoryBtn = MenuItem:New("Vehicle Category", "Select a saved vehicle by its custom category.")
    vehicleCategoryBtn.Label = "→→→"
    vehicleCategoryBtn.ItemData = "category"
    menu:AddMenuItem(vehicleCategoryBtn)
    MenuController:BindMenuItem(menu, categoryMenu, vehicleCategoryBtn)

    local unavailableBtn = MenuItem:New("Unavailable Vehicles", "Vehicles with missing models that cannot be spawned.")
    unavailableBtn.Label = "→→→"
    unavailableBtn.ItemData = "unavailable"
    menu:AddMenuItem(unavailableBtn)
    MenuController:BindMenuItem(menu, unavailableVehiclesMenu, unavailableBtn)

    for i = 0, 22 do
        SavedVehiclesMenu.RefreshClassSubMenu(i)
    end

    menu.OnItemSelect = function(sender, item, index)
        if item.ItemData == "saveVehicle" then
            SavedVehiclesMenu.SaveCurrentVehicle()
        end
    end

    menuInitialized = true
end

function SavedVehiclesMenu.LoadSavedVehicles()
    savedVehicles = {}

    local ok, findHandle = pcall(StartFindKvp, "veh_")
    if not ok or not findHandle then return end

    local loopOk, loopErr = pcall(function()
        while true do
            local key = FindKvp(findHandle)
            if not key or key == "" then break end
            if key:sub(1, 13) ~= "veh_category_" then
                local data = GetResourceKvpString(key)
                if data and data ~= "" then
                    local success, vehicleData = pcall(json.decode, data)
                    if success and type(vehicleData) == "table" then
                        vehicleData.key = key
                        vehicleData.saveName = key:sub(5)
                        table.insert(savedVehicles, vehicleData)
                    end
                end
            end
        end
    end)
    pcall(EndFindKvp, findHandle)

    table.sort(savedVehicles, function(a, b)
        return (a.saveName or ""):lower() < (b.saveName or ""):lower()
    end)
end

function SavedVehiclesMenu.LoadCategories()
    categories = {}

    local ok, findHandle = pcall(StartFindKvp, "veh_category_")
    if not ok or not findHandle then return end

    pcall(function()
        while true do
            local key = FindKvp(findHandle)
            if not key or key == "" then break end
            local data = GetResourceKvpString(key)
            if data and data ~= "" then
                local success, categoryData = pcall(json.decode, data)
                if success and type(categoryData) == "table" then
                    categoryData.key = key
                    table.insert(categories, categoryData)
                end
            end
        end
    end)
    pcall(EndFindKvp, findHandle)

    table.sort(categories, function(a, b)
        return (a.name or ""):lower() < (b.name or ""):lower()
    end)
end

function SavedVehiclesMenu.RefreshClassSubMenu(classIndex)
    local subMenu = classSubMenus[classIndex]
    if not subMenu then return end

    subMenu:ClearMenuItems()

    local classVehicles = {}
    for _, veh in ipairs(savedVehicles) do
        if veh.model and IsModelInCdimage(veh.model) then
            local vehClass = GetVehicleClassFromName(veh.model)
            if vehClass == classIndex then
                table.insert(classVehicles, veh)
            end
        end
    end

    if #classVehicles == 0 then
        local noVehiclesBtn = MenuItem:New("No vehicles", "No saved vehicles in this class.")
        noVehiclesBtn.Enabled = false
        subMenu:AddMenuItem(noVehiclesBtn)
        return
    end

    for _, vehicleData in ipairs(classVehicles) do
        local modelName = GetDisplayNameFromVehicleModel(vehicleData.model)
        if modelName == "CARNOTFOUND" then modelName = "Unknown" end

        local btn = MenuItem:New(vehicleData.saveName or "Unnamed", "Manage this saved vehicle.")
        btn.Label = "(" .. modelName .. ") →→→"
        btn.ItemData = vehicleData
        subMenu:AddMenuItem(btn)
        MenuController:BindMenuItem(subMenu, selectedVehicleMenu, btn)
    end
end

function SavedVehiclesMenu.SetupCategoryMenu()
    categoryMenu.OnMenuOpen = function(sender)
        SavedVehiclesMenu.RefreshCategoryMenu()
    end
end

function SavedVehiclesMenu.RefreshCategoryMenu()
    categoryMenu:ClearMenuItems()
    SavedVehiclesMenu.LoadCategories()
    SavedVehiclesMenu.LoadSavedVehicles()

    local createCategoryBtn = MenuItem:New("Create Category", "Create a new vehicle category.")
    createCategoryBtn.Label = "→→→"
    categoryMenu:AddMenuItem(createCategoryBtn)

    local spacer = MenuItem:New("↓ Vehicle Categories ↓", "")
    spacer.Enabled = false
    categoryMenu:AddMenuItem(spacer)

    local uncategorizedCount = 0
    for _, veh in ipairs(savedVehicles) do
        local vehCategory = veh.category or ""
        if vehCategory == "" or vehCategory == UNCATEGORIZED then
            uncategorizedCount = uncategorizedCount + 1
        end
    end

    local uncategorizedBtn = MenuItem:New(UNCATEGORIZED, "All saved vehicles that have not been assigned to a category.")
    uncategorizedBtn.Label = "→→→"
    uncategorizedBtn.ItemData = { name = UNCATEGORIZED, description = "All saved vehicles without a category" }
    categoryMenu:AddMenuItem(uncategorizedBtn)
    MenuController:BindMenuItem(categoryMenu, selectedCategoryMenu, uncategorizedBtn)

    for _, cat in ipairs(categories) do
        local catCount = 0
        for _, veh in ipairs(savedVehicles) do
            if veh.category == cat.name then
                catCount = catCount + 1
            end
        end

        local catBtn = MenuItem:New(cat.name, cat.description or "")
        catBtn.Label = "→→→"
        catBtn.ItemData = cat
        categoryMenu:AddMenuItem(catBtn)
        MenuController:BindMenuItem(categoryMenu, selectedCategoryMenu, catBtn)
    end

    categoryMenu.OnItemSelect = function(sender, item, index)
        if item == createCategoryBtn then
            SavedVehiclesMenu.CreateNewCategory()
        elseif item.ItemData then
            currentCategory = item.ItemData
            selectedCategoryMenu.MenuSubtitle =item.ItemData.name
        end
    end
end

function SavedVehiclesMenu.CreateNewCategory()
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 30)
    while UpdateOnscreenKeyboard() == 0 do
        Wait(0)
    end

    if GetOnscreenKeyboardResult() then
        local categoryName = GetOnscreenKeyboardResult()
        if categoryName and categoryName ~= "" and categoryName:lower() ~= "uncategorized" and categoryName:lower() ~= "create new" then
            local existing = GetResourceKvpString("veh_category_" .. categoryName)
            if existing and existing ~= "" then
                Notify.Error("A category with that name already exists.")
                return
            end

            DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 120)
            while UpdateOnscreenKeyboard() == 0 do
                Wait(0)
            end

            local description = ""
            if GetOnscreenKeyboardResult() then
                description = GetOnscreenKeyboardResult() or ""
            end

            local categoryData = {
                name = categoryName,
                description = description
            }
            SetResourceKvp("veh_category_" .. categoryName, json.encode(categoryData))
            Notify.Success("Category created: ~g~" .. categoryName)
            SavedVehiclesMenu.RefreshCategoryMenu()
        else
            Notify.Error("Invalid category name.")
        end
    end
end

function SavedVehiclesMenu.SetupSelectedCategoryMenu()
    selectedCategoryMenu.OnMenuOpen = function(sender)
        SavedVehiclesMenu.RefreshSelectedCategoryMenu()
    end
end

function SavedVehiclesMenu.RefreshSelectedCategoryMenu()
    selectedCategoryMenu:ClearMenuItems()
    SavedVehiclesMenu.LoadSavedVehicles()

    if not currentCategory then return end

    local isUncategorized = currentCategory.name == UNCATEGORIZED

    if not isUncategorized then
        local renameCategoryBtn = MenuItem:New("Rename Category", "Rename this category.")
        local changeDescBtn = MenuItem:New("Change Category Description", "Change this category's description.")
        local deleteCategoryBtn = MenuItem:New("~r~Delete Category", "Delete this category. This cannot be undone!")
        deleteCategoryBtn.RightIcon = Icon.WARNING
        local deleteVehiclesCheckbox = MenuCheckboxItem:New("Delete All Vehicles",
            "If checked, all vehicles in this category will be deleted. Otherwise they will be moved to Uncategorized.",
            false)

        selectedCategoryMenu:AddMenuItem(renameCategoryBtn)
        selectedCategoryMenu:AddMenuItem(changeDescBtn)
        selectedCategoryMenu:AddMenuItem(deleteCategoryBtn)
        selectedCategoryMenu:AddMenuItem(deleteVehiclesCheckbox)

        local spacer = MenuItem:New("↓ Vehicles ↓", "")
        spacer.Enabled = false
        selectedCategoryMenu:AddMenuItem(spacer)
    end

    local categoryVehicles = {}
    for _, veh in ipairs(savedVehicles) do
        local vehCategory = veh.category or ""
        local matchesCategory = false

        if isUncategorized then
            matchesCategory = (vehCategory == "" or vehCategory == UNCATEGORIZED)
        else
            matchesCategory = (vehCategory == currentCategory.name)
        end

        if matchesCategory then
            table.insert(categoryVehicles, veh)
        end
    end

    if #categoryVehicles == 0 then
        local noVehiclesBtn = MenuItem:New("No vehicles in this category", "")
        noVehiclesBtn.Enabled = false
        selectedCategoryMenu:AddMenuItem(noVehiclesBtn)
    else
        local spawnableVehicles = {}
        local unspawnableVehicles = {}

        for _, vehicleData in ipairs(categoryVehicles) do
            if vehicleData.model and IsModelInCdimage(vehicleData.model) then
                table.insert(spawnableVehicles, vehicleData)
            else
                table.insert(unspawnableVehicles, vehicleData)
            end
        end

        for _, vehicleData in ipairs(spawnableVehicles) do
            local modelName = GetDisplayNameFromVehicleModel(vehicleData.model)
            if modelName == "CARNOTFOUND" then modelName = "Unknown" end

            local btn = MenuItem:New(vehicleData.saveName or "Unnamed", "Manage this saved vehicle.")
            btn.Label = "(" .. modelName .. ") →→→"
            btn.ItemData = vehicleData
            selectedCategoryMenu:AddMenuItem(btn)
            MenuController:BindMenuItem(selectedCategoryMenu, selectedVehicleMenu, btn)
        end

        for _, vehicleData in ipairs(unspawnableVehicles) do
            local modelName = vehicleData.name or "Unknown"

            local btn = MenuItem:New("~italic~" .. (vehicleData.saveName or "Unnamed") .. "~italic~",
                "~r~NOTE~s~: This model could not be found, and cannot be spawned.")
            btn.Label = "(" .. modelName .. ")"
            btn.LeftIcon = Icon.LOCK
            btn.ItemData = vehicleData
            btn.Enabled = false
            selectedCategoryMenu:AddMenuItem(btn)
        end
    end

    selectedCategoryMenu.OnItemSelect = function(sender, item, index)
        if isUncategorized then
            if item.ItemData and item.Enabled then
                selectedVehicleMenu.ParentMenu = sender
                SavedVehiclesMenu.OpenSelectedVehicleMenu(item.ItemData)
            end
            return
        end

        if index == 0 then
            SavedVehiclesMenu.RenameCategory()
        elseif index == 1 then
            SavedVehiclesMenu.EditCategoryDescription()
        elseif index == 2 then
            if item.Label == "Are you sure?" then
                local deleteVehicles = false
                local items = selectedCategoryMenu:GetMenuItems()
                if items and items[4] then
                    deleteVehicles = items[4].Checked or false
                end
                SavedVehiclesMenu.DeleteCategory(deleteVehicles)
                item.Label = ""
            else
                item.Label = "Are you sure?"
            end
        elseif item.ItemData and item.Enabled then
            selectedVehicleMenu.ParentMenu = sender
            SavedVehiclesMenu.OpenSelectedVehicleMenu(item.ItemData)
        end
    end
end

function SavedVehiclesMenu.RenameCategory()
    if not currentCategory or currentCategory.name == UNCATEGORIZED then return end

    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", currentCategory.name, "", "", "", 30)
    while UpdateOnscreenKeyboard() == 0 do
        Wait(0)
    end

    if GetOnscreenKeyboardResult() then
        local newName = GetOnscreenKeyboardResult()
        if newName and newName ~= "" and newName ~= currentCategory.name and newName:lower() ~= "uncategorized" then
            local existing = GetResourceKvpString("veh_category_" .. newName)
            if existing and existing ~= "" then
                Notify.Error("A category with that name already exists.")
                return
            end

            local oldName = currentCategory.name

            SavedVehiclesMenu.LoadSavedVehicles()
            local updatedCount = 0
            for _, veh in ipairs(savedVehicles) do
                if veh.category == oldName then
                    veh.category = newName
                    SetResourceKvp(veh.key, json.encode(veh))
                    updatedCount = updatedCount + 1
                end
            end

            DeleteResourceKvp("veh_category_" .. oldName)
            currentCategory.name = newName
            SetResourceKvp("veh_category_" .. newName, json.encode(currentCategory))

            Notify.Success("Category renamed to ~g~" .. newName .. "~s~. " .. updatedCount .. " vehicles updated.")
            selectedCategoryMenu.MenuSubtitle =newName
            selectedCategoryMenu:GoBack()
            SavedVehiclesMenu.RefreshCategoryMenu()
        end
    end
end

function SavedVehiclesMenu.EditCategoryDescription()
    if not currentCategory or currentCategory.name == UNCATEGORIZED then return end

    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", currentCategory.description or "", "", "", "", 120)
    while UpdateOnscreenKeyboard() == 0 do
        Wait(0)
    end

    if GetOnscreenKeyboardResult() then
        local newDesc = GetOnscreenKeyboardResult() or ""
        currentCategory.description = newDesc
        SetResourceKvp("veh_category_" .. currentCategory.name, json.encode(currentCategory))
        Notify.Success("Category description updated.")
        selectedCategoryMenu:GoBack()
        SavedVehiclesMenu.RefreshCategoryMenu()
    end
end

function SavedVehiclesMenu.DeleteCategory(deleteVehicles)
    if not currentCategory or currentCategory.name == UNCATEGORIZED then return end

    SavedVehiclesMenu.LoadSavedVehicles()
    local updatedCount = 0

    for _, veh in ipairs(savedVehicles) do
        if veh.category == currentCategory.name then
            updatedCount = updatedCount + 1
            if deleteVehicles then
                DeleteResourceKvp(veh.key)
            else
                veh.category = UNCATEGORIZED
                SetResourceKvp(veh.key, json.encode(veh))
            end
        end
    end

    DeleteResourceKvp("veh_category_" .. currentCategory.name)

    if deleteVehicles then
        Notify.Success("Category deleted. " .. updatedCount .. " vehicles deleted.")
    else
        Notify.Success("Category deleted. " .. updatedCount .. " vehicles moved to Uncategorized.")
    end

    selectedCategoryMenu:GoBack()
    SavedVehiclesMenu.RefreshCategoryMenu()
end

function SavedVehiclesMenu.OpenSelectedVehicleMenu(vehicleData)
    currentSelectedVehicle = vehicleData
    selectedVehicleMenu.MenuSubtitle =(vehicleData.saveName or "Unnamed") .. " (" .. (vehicleData.name or "Unknown") .. ")"
end

function SavedVehiclesMenu.SetupSelectedVehicleMenu()
    local spawnVehicleBtn = MenuItem:New("Spawn Vehicle", "Spawn this saved vehicle.")
    local renameVehicleBtn = MenuItem:New("Rename Vehicle", "Rename this saved vehicle.")

    local setCategoryBtn = MenuItem:New("Set Vehicle Category", "Set this vehicle's category.")

    local replaceVehicleBtn = MenuItem:New("~o~Replace Vehicle", "Replace this saved vehicle with your current vehicle.")
    replaceVehicleBtn.RightIcon = Icon.WARNING

    local deleteVehicleBtn = MenuItem:New("~r~Delete Vehicle", "Delete this saved vehicle. This cannot be undone!")
    deleteVehicleBtn.RightIcon = Icon.WARNING

    selectedVehicleMenu:AddMenuItem(spawnVehicleBtn)
    selectedVehicleMenu:AddMenuItem(renameVehicleBtn)
    selectedVehicleMenu:AddMenuItem(setCategoryBtn)
    selectedVehicleMenu:AddMenuItem(replaceVehicleBtn)
    selectedVehicleMenu:AddMenuItem(deleteVehicleBtn)

    selectedVehicleMenu.OnMenuOpen = function(sender)
        if currentSelectedVehicle and currentSelectedVehicle.model then
            local canSpawn = IsModelInCdimage(currentSelectedVehicle.model)
            spawnVehicleBtn.Enabled = canSpawn
            if canSpawn then
                spawnVehicleBtn.Description = "Spawn this saved vehicle."
                local modelName = GetDisplayNameFromVehicleModel(currentSelectedVehicle.model)
                spawnVehicleBtn.Label = "(" .. modelName:lower() .. ")"
            else
                spawnVehicleBtn.Description = "~r~This model could not be found in the game files."
                spawnVehicleBtn.Label = ""
            end
        end

        replaceVehicleBtn.Label = ""
        deleteVehicleBtn.Label = ""
    end

    selectedVehicleMenu.OnMenuClose = function(sender)
        replaceVehicleBtn.Label = ""
        deleteVehicleBtn.Label = ""
    end

    selectedVehicleMenu.OnIndexChange = function(sender, oldItem, newItem, oldIndex, newIndex)
        if oldItem ~= deleteVehicleBtn then deleteVehicleBtn.Label = "" end
        if oldItem ~= replaceVehicleBtn then replaceVehicleBtn.Label = "" end
    end

    selectedVehicleMenu.OnItemSelect = function(sender, item, index)
        if item == spawnVehicleBtn then
            if currentSelectedVehicle then
                SavedVehiclesMenu.SpawnSavedVehicle(currentSelectedVehicle)
            end
        elseif item == renameVehicleBtn then
            if currentSelectedVehicle then
                SavedVehiclesMenu.RenameVehicle()
            end
        elseif item == setCategoryBtn then
            if currentSelectedVehicle then
                SavedVehiclesMenu.SetVehicleCategory()
            end
        elseif item == replaceVehicleBtn then
            if not IsPedInAnyVehicle(PlayerPedId(), false) then
                Notify.Error("You need to be in a vehicle to replace a saved vehicle.")
                return
            end
            if item.Label == "Press again to confirm." then
                item.Label = ""
                SavedVehiclesMenu.ReplaceVehicle()
            else
                item.Label = "Press again to confirm."
                Notify.Alert("Are you sure you want to replace this vehicle? Press the button again to confirm.")
            end
        elseif item == deleteVehicleBtn then
            if item.Label == "Press again to confirm." then
                item.Label = ""
                SavedVehiclesMenu.DeleteVehicle()
            else
                item.Label = "Press again to confirm."
                Notify.Alert("Are you sure you want to delete this vehicle? Press the button again to confirm.")
            end
        end

        if item ~= deleteVehicleBtn then deleteVehicleBtn.Label = "" end
        if item ~= replaceVehicleBtn then replaceVehicleBtn.Label = "" end
    end
end

function SavedVehiclesMenu.RenameVehicle()
    if not currentSelectedVehicle then return end

    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", currentSelectedVehicle.saveName or "", "", "", "", 30)
    while UpdateOnscreenKeyboard() == 0 do
        Wait(0)
    end

    if GetOnscreenKeyboardResult() then
        local newName = GetOnscreenKeyboardResult()
        if newName and newName ~= "" and newName ~= currentSelectedVehicle.saveName then
            local existingData = GetResourceKvpString("veh_" .. newName)
            if existingData and existingData ~= "" then
                Notify.Error("This name is already in use.")
                return
            end

            DeleteResourceKvp(currentSelectedVehicle.key)
            currentSelectedVehicle.saveName = newName
            currentSelectedVehicle.key = "veh_" .. newName
            SetResourceKvp("veh_" .. newName, json.encode(currentSelectedVehicle))

            Notify.Success("Your vehicle has successfully been renamed.")
            selectedVehicleMenu.MenuSubtitle =newName .. " (" .. (currentSelectedVehicle.name or "Unknown") .. ")"
            selectedVehicleMenu:GoBack()
        end
    end
end

function SavedVehiclesMenu.SetVehicleCategory()
    if not currentSelectedVehicle then return end

    SavedVehiclesMenu.LoadCategories()

    local currentCat = currentSelectedVehicle.category or UNCATEGORIZED
    Notify.Custom("Current category: ~y~" .. currentCat)

    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", currentCat, "", "", "", 30)
    while UpdateOnscreenKeyboard() == 0 do
        Wait(0)
    end

    if GetOnscreenKeyboardResult() then
        local newCategory = GetOnscreenKeyboardResult()
        if newCategory and newCategory ~= "" then
            local categoryExists = (newCategory:lower() == "uncategorized")
            for _, cat in ipairs(categories) do
                if cat.name:lower() == newCategory:lower() then
                    categoryExists = true
                    newCategory = cat.name
                    break
                end
            end

            if not categoryExists then
                local categoryData = { name = newCategory, description = "" }
                SetResourceKvp("veh_category_" .. newCategory, json.encode(categoryData))
                Notify.Custom("Category ~g~" .. newCategory .. "~s~ created.")
            end

            currentSelectedVehicle.category = newCategory
            SetResourceKvp(currentSelectedVehicle.key, json.encode(currentSelectedVehicle))
            Notify.Success("Your vehicle was saved successfully.")
            selectedVehicleMenu:GoBack()
        end
    end
end

function SavedVehiclesMenu.ReplaceVehicle()
    if not currentSelectedVehicle then return end

    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)

    if vehicle == 0 then
        Notify.Error("You need to be in a vehicle.")
        return
    end

    local vehicleData = SavedVehiclesMenu.GetVehicleData(vehicle)
    vehicleData.saveName = currentSelectedVehicle.saveName
    vehicleData.category = currentSelectedVehicle.category
    vehicleData.key = currentSelectedVehicle.key

    SetResourceKvp(currentSelectedVehicle.key, json.encode(vehicleData))
    currentSelectedVehicle = vehicleData

    SavedVehiclesMenu.LoadSavedVehicles()
    local vehClass = GetVehicleClass(vehicle)
    SavedVehiclesMenu.RefreshClassSubMenu(vehClass)

    Notify.Success("Your saved vehicle has been replaced with your current vehicle.")
    selectedVehicleMenu:GoBack()
end

function SavedVehiclesMenu.DeleteVehicle()
    if not currentSelectedVehicle then return end

    DeleteResourceKvp(currentSelectedVehicle.key)
    Notify.Success("Your saved vehicle has been deleted.")
    selectedVehicleMenu:GoBack()
    currentSelectedVehicle = nil
end

function SavedVehiclesMenu.SetupUnavailableVehiclesMenu()
    unavailableVehiclesMenu.OnMenuOpen = function(sender)
        SavedVehiclesMenu.RefreshUnavailableVehiclesMenu()
    end
end

function SavedVehiclesMenu.RefreshUnavailableVehiclesMenu()
    unavailableVehiclesMenu:ClearMenuItems()
    SavedVehiclesMenu.LoadSavedVehicles()

    local unavailable = {}
    for _, veh in ipairs(savedVehicles) do
        if not veh.model or not IsModelInCdimage(veh.model) then
            table.insert(unavailable, veh)
        end
    end

    if #unavailable == 0 then
        local noVehiclesBtn = MenuItem:New("No unavailable vehicles", "All your saved vehicles are available!")
        noVehiclesBtn.Enabled = false
        unavailableVehiclesMenu:AddMenuItem(noVehiclesBtn)
        return
    end

    for _, vehicleData in ipairs(unavailable) do
        local btn = MenuItem:New(vehicleData.saveName or "Unnamed",
            "This model could not be found. Most likely because this is an addon vehicle and it's not streamed by the server.")
        btn.Label = "(" .. (vehicleData.name or "Unknown") .. ")"
        btn.ItemData = vehicleData
        btn.LeftIcon = Icon.LOCK
        btn.Enabled = false
        unavailableVehiclesMenu:AddMenuItem(btn)
    end

    unavailableVehiclesMenu.OnItemSelect = function(sender, item, index)
        if item.ItemData then
            if item.Label == "~r~Are you sure?" then
                DeleteResourceKvp(item.ItemData.key)
                Notify.Success("Unavailable saved vehicle deleted.")
                SavedVehiclesMenu.RefreshUnavailableVehiclesMenu()
            else
                item.Label = "~r~Are you sure?"
            end
        end
    end

    unavailableVehiclesMenu.OnIndexChange = function(sender, oldItem, newItem, oldIndex, newIndex)
        for _, item in ipairs(unavailableVehiclesMenu:GetMenuItems()) do
            if item.ItemData then
                item.Label = "(" .. (item.ItemData.name or "Unknown") .. ")"
            end
        end
    end
end

function SavedVehiclesMenu.GetVehicleData(vehicle)
    local vehicleData = {}

    vehicleData.model = GetEntityModel(vehicle)
    vehicleData.name = GetDisplayNameFromVehicleModel(vehicleData.model)

    local primaryColor, secondaryColor = GetVehicleColours(vehicle)
    local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
    vehicleData.colors = {
        primary = primaryColor,
        secondary = secondaryColor,
        pearlescent = pearlescentColor,
        wheels = wheelColor
    }

    local r1, g1, b1 = GetVehicleCustomPrimaryColour(vehicle)
    local r2, g2, b2 = GetVehicleCustomSecondaryColour(vehicle)
    local hasCustomPrimary, hasCustomSecondary = false, false
    pcall(function()
        hasCustomPrimary = HasVehicleCustomPrimaryColour(vehicle)
        hasCustomSecondary = HasVehicleCustomSecondaryColour(vehicle)
    end)
    if hasCustomPrimary then
        vehicleData.customPrimaryColor = { r = r1, g = g1, b = b1 }
    end
    if hasCustomSecondary then
        vehicleData.customSecondaryColor = { r = r2, g = g2, b = b2 }
    end

    vehicleData.dashboardColor = GetVehicleDashboardColour(vehicle)
    vehicleData.interiorColor = GetVehicleInteriorColour(vehicle)

    vehicleData.neonEnabled = {
        left = IsVehicleNeonLightEnabled(vehicle, 0),
        right = IsVehicleNeonLightEnabled(vehicle, 1),
        front = IsVehicleNeonLightEnabled(vehicle, 2),
        back = IsVehicleNeonLightEnabled(vehicle, 3)
    }

    local r, g, b = GetVehicleNeonLightsColour(vehicle)

    vehicleData.xenonHeadlightsColor = GetVehicleXenonLightsColour(vehicle)

    vehicleData.mods = {}
    vehicleData.modVariations = {}
    SetVehicleModKit(vehicle, 0)
    for i = 0, 49 do
        local mod = GetVehicleMod(vehicle, i)
        vehicleData.mods[tostring(i)] = mod
        if mod ~= -1 then
            vehicleData.modVariations[tostring(i)] = GetVehicleModVariation(vehicle, i)
        end
    end

    vehicleData.toggleMods = {}
    for i = 0, 49 do
        vehicleData.toggleMods[tostring(i)] = IsToggleModOn(vehicle, i)
    end

    vehicleData.extras = {}
    for i = 0, 14 do
        if DoesExtraExist(vehicle, i) then
            vehicleData.extras[tostring(i)] = IsVehicleExtraTurnedOn(vehicle, i)
        end
    end

    vehicleData.livery = GetVehicleLivery(vehicle)
    vehicleData.roofLivery = GetVehicleRoofLivery(vehicle)
    vehicleData.plateText = GetVehicleNumberPlateText(vehicle)
    vehicleData.plateStyle = GetVehicleNumberPlateTextIndex(vehicle)
    vehicleData.windowTint = GetVehicleWindowTint(vehicle)
    vehicleData.wheelType = GetVehicleWheelType(vehicle)
    vehicleData.customWheels = GetVehicleModVariation(vehicle, 23)
    vehicleData.customWheelsRear = GetVehicleModVariation(vehicle, 24)

    vehicleData.bulletProofTires = not GetVehicleTyresCanBurst(vehicle)

    local sr, sg, sb = GetVehicleTyreSmokeColor(vehicle)
    vehicleData.tyreSmokeColor = { r = sr, g = sg, b = sb }

    vehicleData.dirtLevel = GetVehicleDirtLevel(vehicle)

    vehicleData.enveffScale = GetVehicleEnveffScale(vehicle)

    if IsVehicleAConvertible(vehicle, false) then
        vehicleData.roofState = GetConvertibleRoofState(vehicle)
    end

    vehicleData.vehicleClass = GetVehicleClass(vehicle)

    return vehicleData
end

function SavedVehiclesMenu.ApplyVehicleData(vehicle, vehicleData)
    if not vehicleData then return end

    SetVehicleModKit(vehicle, 0)

    if vehicleData.wheelType then
        SetVehicleWheelType(vehicle, vehicleData.wheelType)
    end

    if vehicleData.colors then
        SetVehicleColours(vehicle, vehicleData.colors.primary or 0, vehicleData.colors.secondary or 0)
        SetVehicleExtraColours(vehicle, vehicleData.colors.pearlescent or 0, vehicleData.colors.wheels or 0)
    end

    if vehicleData.customPrimaryColor then
        SetVehicleCustomPrimaryColour(vehicle, vehicleData.customPrimaryColor.r, vehicleData.customPrimaryColor.g,
            vehicleData.customPrimaryColor.b)
    end
    if vehicleData.customSecondaryColor then
        SetVehicleCustomSecondaryColour(vehicle, vehicleData.customSecondaryColor.r, vehicleData.customSecondaryColor.g,
            vehicleData.customSecondaryColor.b)
    end

    if vehicleData.dashboardColor then
        SetVehicleDashboardColour(vehicle, vehicleData.dashboardColor)
    end
    if vehicleData.interiorColor then
        SetVehicleInteriorColour(vehicle, vehicleData.interiorColor)
    end

    if vehicleData.mods then
        for modType, modIndex in pairs(vehicleData.mods) do
            local modTypeNum = tonumber(modType)
            if modIndex ~= -1 then
                local variation = false
                if vehicleData.modVariations and vehicleData.modVariations[modType] then
                    variation = vehicleData.modVariations[modType]
                elseif modTypeNum == 23 then
                    variation = vehicleData.customWheels or false
                elseif modTypeNum == 24 then
                    variation = vehicleData.customWheelsRear or false
                end
                SetVehicleMod(vehicle, modTypeNum, modIndex, variation)
            end
        end
    end

    if vehicleData.toggleMods then
        for modType, enabled in pairs(vehicleData.toggleMods) do
            if enabled then
                ToggleVehicleMod(vehicle, tonumber(modType), true)
            end
        end
    else
        if vehicleData.turbo then ToggleVehicleMod(vehicle, 18, true) end
        if vehicleData.xenonHeadlights then ToggleVehicleMod(vehicle, 22, true) end
        if vehicleData.tyreSmoke then ToggleVehicleMod(vehicle, 20, true) end
    end

    if vehicleData.xenonHeadlightsColor and vehicleData.xenonHeadlightsColor ~= -1 then
        SetVehicleXenonLightsColour(vehicle, vehicleData.xenonHeadlightsColor)
    end

    if vehicleData.extras then
        for extraId, enabled in pairs(vehicleData.extras) do
            SetVehicleExtra(vehicle, tonumber(extraId), not enabled)
        end
    end

    if vehicleData.livery and vehicleData.livery ~= -1 then
        SetVehicleLivery(vehicle, vehicleData.livery)
    end
    if vehicleData.roofLivery and vehicleData.roofLivery ~= -1 then
        SetVehicleRoofLivery(vehicle, vehicleData.roofLivery)
    end

    if vehicleData.plateText then
        SetVehicleNumberPlateText(vehicle, vehicleData.plateText)
    end
    if vehicleData.plateStyle then
        SetVehicleNumberPlateTextIndex(vehicle, vehicleData.plateStyle)
    end

    if vehicleData.windowTint then
        SetVehicleWindowTint(vehicle, vehicleData.windowTint)
    end

    if vehicleData.tyreSmokeColor then
        SetVehicleTyreSmokeColor(vehicle, vehicleData.tyreSmokeColor.r, vehicleData.tyreSmokeColor.g,
            vehicleData.tyreSmokeColor.b)
    end

    if vehicleData.bulletProofTires then
        SetVehicleTyresCanBurst(vehicle, false)
    end

    if vehicleData.neonEnabled then
        SetVehicleNeonLightEnabled(vehicle, 0, vehicleData.neonEnabled.left or false)
        SetVehicleNeonLightEnabled(vehicle, 1, vehicleData.neonEnabled.right or false)
        SetVehicleNeonLightEnabled(vehicle, 2, vehicleData.neonEnabled.front or false)
        SetVehicleNeonLightEnabled(vehicle, 3, vehicleData.neonEnabled.back or false)
    end
    if vehicleData.neonColor then
        SetVehicleNeonLightsColour(vehicle, vehicleData.neonColor.r, vehicleData.neonColor.g, vehicleData.neonColor.b)
    end

    if vehicleData.dirtLevel then
        SetVehicleDirtLevel(vehicle, vehicleData.dirtLevel)
    end

    if vehicleData.enveffScale then
        SetVehicleEnveffScale(vehicle, vehicleData.enveffScale)
    end

    if vehicleData.roofState ~= nil and IsVehicleAConvertible(vehicle, false) then
        if vehicleData.roofState == 0 then
            RaiseConvertibleRoof(vehicle, true)
        else
            LowerConvertibleRoof(vehicle, true)
        end
    end
end

function SavedVehiclesMenu.SaveCurrentVehicle()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)

    if vehicle == 0 then
        Notify.Error("You are currently not in any vehicle. Please enter a vehicle before trying to save it.")
        return
    end

    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 30)
    while UpdateOnscreenKeyboard() == 0 do
        Wait(0)
    end

    if GetOnscreenKeyboardResult() then
        local saveName = GetOnscreenKeyboardResult()
        if saveName and saveName ~= "" then
            local existingData = GetResourceKvpString("veh_" .. saveName)
            if existingData and existingData ~= "" then
                Notify.Error("This name is already in use.")
            else
                local vehicleData = SavedVehiclesMenu.GetVehicleData(vehicle)
                vehicleData.saveName = saveName
                vehicleData.category = UNCATEGORIZED
                local jsonData = json.encode(vehicleData)
                SetResourceKvp("veh_" .. saveName, jsonData)
                Notify.Success("Vehicle saved as: ~g~" .. saveName)
            end
        else
            Notify.Error("Invalid save name.")
        end
    end
end

function SavedVehiclesMenu.SpawnSavedVehicle(vehicleData)
    if not vehicleData or not vehicleData.model then
        Notify.Error("Invalid vehicle data.")
        return
    end

    local modelHash = vehicleData.model
    if not IsModelInCdimage(modelHash) or not IsModelAVehicle(modelHash) then
        Notify.Error("Vehicle model is not available.")
        return
    end

    RequestModel(modelHash)
    local timeout = 0
    while not HasModelLoaded(modelHash) and timeout < 1000 do
        Wait(10)
        timeout = timeout + 1
    end

    if not HasModelLoaded(modelHash) then
        Notify.Error("Failed to load vehicle model.")
        return
    end

    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)

    if VehicleSpawnerMenu and VehicleSpawnerMenu.ReplaceVehicle then
        if VehicleSpawnerMenu.LastSpawnedVehicle ~= nil then
            if DoesEntityExist(VehicleSpawnerMenu.LastSpawnedVehicle) then
                SetEntityAsMissionEntity(VehicleSpawnerMenu.LastSpawnedVehicle, true, true)
                DeleteVehicle(VehicleSpawnerMenu.LastSpawnedVehicle)
            end
            VehicleSpawnerMenu.LastSpawnedVehicle = nil
        end
    end

    local spawnCoords = coords
    local forward = GetEntityForwardVector(ped)
    spawnCoords = vector3(coords.x + forward.x * 5.0, coords.y + forward.y * 5.0, coords.z)

    local vehicle = CreateVehicle(modelHash, spawnCoords.x, spawnCoords.y, spawnCoords.z, heading, true, false)

    if vehicle ~= 0 then
        Wait(500)

        SavedVehiclesMenu.ApplyVehicleData(vehicle, vehicleData)

        TaskWarpPedIntoVehicle(ped, vehicle, -1)

        if VehicleSpawnerMenu then
            VehicleSpawnerMenu.LastSpawnedVehicle = vehicle
        end

        SetModelAsNoLongerNeeded(modelHash)
        Notify.Success("Spawned: ~y~" .. (vehicleData.saveName or vehicleData.name or "Vehicle"))
    else
        Notify.Error("Failed to spawn vehicle.")
    end
end

function SavedVehiclesMenu.GetMenu()
    if menu == nil then
        SavedVehiclesMenu.CreateMenu()
    end
    return menu
end

return SavedVehiclesMenu
