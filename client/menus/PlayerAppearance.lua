PlayerAppearanceMenu = {}

local menu = nil
local pedCustomizationMenu = nil
local savedPedsMenu = nil
local selectedSavedPedMenu = nil
local spawnPedsMenu = nil
local addonPedsMenu = nil
local mainPedsMenu = nil
local animalsPedsMenu = nil
local malePedsMenu = nil
local femalePedsMenu = nil
local otherPedsMenu = nil

local currentSavedPed = nil
local drawablesMenuListItems = {}
local propsMenuListItems = {}

local componentNames = {
    [0] = "Head",
    [1] = "Mask / Facial Hair",
    [2] = "Hair Style / Color",
    [3] = "Hands / Upper Body",
    [4] = "Legs / Pants",
    [5] = "Bags / Parachutes",
    [6] = "Shoes",
    [7] = "Neck / Scarfs",
    [8] = "Shirt / Accessory",
    [9] = "Body Armor / Accessory 2",
    [10] = "Badges / Logos",
    [11] = "Shirt Overlay / Jackets"
}

local propNames = {
    [0] = "Hats / Helmets",
    [1] = "Glasses",
    [2] = "Misc",
    [6] = "Watches",
    [7] = "Bracelets"
}

local walkingStyles = { "Normal", "Injured", "Tough Guy", "Femme", "Gangster", "Posh", "Sexy", "Business", "Drunk", "Hipster" }
local walkingStyleClipSets = {
    Normal      = "default",
    Injured     = "move_m@injured",
    ["Tough Guy"] = "move_m@tough_guy@",
    Femme       = "move_f@femme@",
    Gangster    = "move_m@gangster@ng",
    Posh        = "move_m@posh@",
    Sexy        = "move_f@sexy@a",
    Business    = "move_m@business@a",
    Drunk       = "move_m@drunk@slightlydrunk",
    Hipster     = "move_m@hipster@a"
}

local clothingGlowTypes = { "On", "Off", "Fade", "Flash" }
local clothingAnimationType = 2

function PlayerAppearanceMenu.CreateMenu()
    local playerName = GetPlayerName(PlayerId())

    menu = Menu:New(playerName, "Player Appearance")
    pedCustomizationMenu = Menu:New(playerName, "Customize Ped")
    savedPedsMenu = Menu:New(playerName, "Saved Peds")
    selectedSavedPedMenu = Menu:New("Saved Ped", "Manage Saved Ped")
    spawnPedsMenu = Menu:New(playerName, "Spawn Ped")
    addonPedsMenu = Menu:New(playerName, "Addon Peds")
    mainPedsMenu = Menu:New("Main Peds", "Spawn A Ped")
    animalsPedsMenu = Menu:New("Animals", "Spawn A Ped")
    malePedsMenu = Menu:New("Male Peds", "Spawn A Ped")
    femalePedsMenu = Menu:New("Female Peds", "Spawn A Ped")
    otherPedsMenu = Menu:New("Other Peds", "Spawn A Ped")

    MenuController:AddMenu(menu)
    MenuController:AddMenu(pedCustomizationMenu)
    MenuController:AddMenu(savedPedsMenu)
    MenuController:AddMenu(selectedSavedPedMenu)
    MenuController:AddMenu(spawnPedsMenu)
    MenuController:AddMenu(addonPedsMenu)
    MenuController:AddMenu(mainPedsMenu)
    MenuController:AddMenu(animalsPedsMenu)
    MenuController:AddMenu(malePedsMenu)
    MenuController:AddMenu(femalePedsMenu)
    MenuController:AddMenu(otherPedsMenu)

    local pedCustomizationBtn = MenuItem:New("Ped Customization", "Modify your ped's appearance.")
    pedCustomizationBtn.Label = "→→→"

    local saveCurrentPedBtn = MenuItem:New("Save Ped",
        "Save your current ped. Note for MP Male/Female peds this won't save most of their customization. Create those in the MP Character creator instead.")

    local savedPedsBtn = MenuItem:New("Saved Peds", "Edit, rename, clone, spawn or delete saved peds.")
    savedPedsBtn.Label = "→→→"

    local spawnPedsBtn = MenuItem:New("Spawn Peds",
        "Change ped model by selecting one from the list or by entering a name manually.")
    spawnPedsBtn.Label = "→→→"

    local walkingStyleList = MenuListItem:New("Walking Style", walkingStyles, 1,
        "Change the walking style of your current ped. You need to re-apply this each time you change player model or load a saved ped.")

    local clothingGlowList = MenuListItem:New("Illuminated Clothing Style", clothingGlowTypes, clothingAnimationType,
        "Set the style of the animation used on your player's illuminated clothing items.")

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.PACustomize) then
        menu:AddMenuItem(pedCustomizationBtn)
        MenuController:BindMenuItem(menu, pedCustomizationMenu, pedCustomizationBtn)
    end

    menu:AddMenuItem(saveCurrentPedBtn)
    menu:AddMenuItem(savedPedsBtn)
    menu:AddMenuItem(spawnPedsBtn)
    menu:AddMenuItem(walkingStyleList)
    menu:AddMenuItem(clothingGlowList)

    MenuController:BindMenuItem(menu, savedPedsMenu, savedPedsBtn)
    MenuController:BindMenuItem(menu, spawnPedsMenu, spawnPedsBtn)

    menu.OnItemSelect = function(sender, item, index)
        if item == saveCurrentPedBtn then
            PlayerAppearanceMenu.SaveCurrentPed()
        end
    end

    menu.OnListIndexChange = function(sender, item, oldIndex, newIndex, itemIndex)
        if item == walkingStyleList then
            local styleName = walkingStyles[newIndex]
            if styleName then
                PlayerAppearanceMenu.SetWalkingStyle(styleName)
            end
        elseif item == clothingGlowList then
            clothingAnimationType = newIndex
            SetPedIlluminatedClothingGlowIntensity(PlayerPedId(), newIndex - 1)
        end
    end

    PlayerAppearanceMenu.SetupPedCustomizationMenu()
    PlayerAppearanceMenu.SetupSavedPedsMenu()
    PlayerAppearanceMenu.SetupSpawnPedsMenu()

    return menu
end

function PlayerAppearanceMenu.SetupPedCustomizationMenu()
    pedCustomizationMenu.OnMenuOpen = function(sender)
        PlayerAppearanceMenu.RefreshCustomizationMenu()
    end

    pedCustomizationMenu.OnListIndexChange = function(sender, item, oldIndex, newIndex, itemIndex)
        local ped = PlayerPedId()
        local drawableID = drawablesMenuListItems[item]
        local propID = propsMenuListItems[item]

        if drawableID ~= nil then
            SetPedComponentVariation(ped, drawableID, newIndex - 1, 0, 0)
            item.Description = "~b~Drawable " .. (newIndex - 1) .. "~s~ / ~y~Texture 0~s~ | Press ENTER to cycle textures."
        elseif propID ~= nil then
            if newIndex == 1 then
                ClearPedProp(ped, propID)
                item.Description = "~r~No Prop~s~ | Press ENTER to cycle textures."
            else
                SetPedPropIndex(ped, propID, newIndex - 2, 0, true)
                item.Description = "~b~Prop " .. (newIndex - 2) .. "~s~ / ~y~Texture 0~s~ | Press ENTER to cycle textures."
            end
        end
    end

    pedCustomizationMenu.OnListItemSelect = function(sender, item, listIndex, itemIndex)
        local ped = PlayerPedId()
        local drawableID = drawablesMenuListItems[item]
        local propID = propsMenuListItems[item]

        if drawableID ~= nil then
            local drawable = listIndex - 1
            local currentTex = GetPedTextureVariation(ped, drawableID)
            if currentTex < 0 then currentTex = 0 end
            local maxTex = GetNumberOfPedTextureVariations(ped, drawableID, drawable) - 1
            if maxTex < 0 then maxTex = 0 end
            local newTex = (currentTex < maxTex) and (currentTex + 1) or 0
            SetPedComponentVariation(ped, drawableID, drawable, newTex, 0)
            item.Description = "~b~Drawable " .. drawable .. "~s~ / ~y~Texture " .. newTex .. "~s~ | Press ENTER to cycle textures."

        elseif propID ~= nil then
            if listIndex == 1 then return end
            local propIdx = listIndex - 2
            local currentTex = GetPedPropTextureIndex(ped, propID)
            if currentTex < 0 then currentTex = 0 end
            local maxTex = GetNumberOfPedPropTextureVariations(ped, propID, propIdx) - 1
            if maxTex < 0 then maxTex = 0 end
            local newTex = (currentTex < maxTex) and (currentTex + 1) or 0
            SetPedPropIndex(ped, propID, propIdx, newTex, true)
            item.Description = "~b~Prop " .. propIdx .. "~s~ / ~y~Texture " .. newTex .. "~s~ | Press ENTER to cycle textures."
        end
    end
end

function PlayerAppearanceMenu.RefreshCustomizationMenu()
    drawablesMenuListItems = {}
    propsMenuListItems = {}
    pedCustomizationMenu:ClearMenuItems()

    local ped = PlayerPedId()

    for componentID = 0, 11 do
        local maxVariations = GetNumberOfPedDrawableVariations(ped, componentID)
        if maxVariations > 0 then
            local currentDrawable = GetPedDrawableVariation(ped, componentID)
            local currentTexture = GetPedTextureVariation(ped, componentID)
            if currentTexture < 0 then currentTexture = 0 end

            local items = {}
            for i = 0, maxVariations - 1 do
                table.insert(items, tostring(i))
            end

            local description = "~b~Drawable " .. currentDrawable .. "~s~ / ~y~Texture " .. currentTexture .. "~s~ | Press ENTER to cycle textures."
            local listItem = MenuListItem:New(componentNames[componentID], items, currentDrawable + 1, description)

            drawablesMenuListItems[listItem] = componentID
            pedCustomizationMenu:AddMenuItem(listItem)
        end
    end

    local propSlots = { 0, 1, 2, 6, 7 }
    for _, propID in ipairs(propSlots) do
        local maxProps = GetNumberOfPedPropDrawableVariations(ped, propID)
        if maxProps > 0 then
            local currentProp = GetPedPropIndex(ped, propID)
            local currentTexture = GetPedPropTextureIndex(ped, propID)
            if currentTexture < 0 then currentTexture = 0 end

            local items = { "No Prop" }
            for i = 0, maxProps - 1 do
                table.insert(items, tostring(i))
            end

            local description
            if currentProp == -1 then
                description = "~r~No Prop~s~ | Press ENTER to cycle textures."
            else
                description = "~b~Prop " .. currentProp .. "~s~ / ~y~Texture " .. currentTexture .. "~s~ | Press ENTER to cycle textures."
            end

            local initialIndex = (currentProp == -1) and 1 or (currentProp + 2)
            local listItem = MenuListItem:New(propNames[propID], items, initialIndex, description)

            propsMenuListItems[listItem] = propID
            pedCustomizationMenu:AddMenuItem(listItem)
        end
    end
end

function PlayerAppearanceMenu.SetupSavedPedsMenu()
    local spawnSavedPedBtn = MenuItem:New("Spawn Saved Ped", "Spawn this saved ped.")
    local cloneSavedPedBtn = MenuItem:New("Clone Saved Ped", "Clone this saved ped and save it under a new name.")
    local renameSavedPedBtn = MenuItem:New("Rename Saved Ped", "Rename this saved ped.")
    renameSavedPedBtn.LeftIcon = Icon.WARNING
    local replaceSavedPedBtn = MenuItem:New("~r~Replace Saved Ped",
        "Replace this saved ped with your current ped. Note this can not be undone!")
    replaceSavedPedBtn.LeftIcon = Icon.WARNING
    local deleteSavedPedBtn = MenuItem:New("~r~Delete Saved Ped", "Delete this saved ped. Note this can not be undone!")
    deleteSavedPedBtn.LeftIcon = Icon.WARNING

    if not PermissionsManager.IsAllowed(PermissionsManager.Permission.PASpawnSaved) then
        spawnSavedPedBtn.Enabled = false
        spawnSavedPedBtn.RightIcon = Icon.LOCK
        spawnSavedPedBtn.Description = "You are not allowed to spawn saved peds."
    end

    selectedSavedPedMenu:AddMenuItem(spawnSavedPedBtn)
    selectedSavedPedMenu:AddMenuItem(cloneSavedPedBtn)
    selectedSavedPedMenu:AddMenuItem(renameSavedPedBtn)
    selectedSavedPedMenu:AddMenuItem(replaceSavedPedBtn)
    selectedSavedPedMenu:AddMenuItem(deleteSavedPedBtn)

    local function ResetLabels()
        replaceSavedPedBtn.Label = ""
        deleteSavedPedBtn.Label = ""
    end
    selectedSavedPedMenu.OnIndexChange = function(sender, oldItem, newItem, oldIndex, newIndex)
        ResetLabels()
    end
    selectedSavedPedMenu.OnMenuOpen = function(sender)
        ResetLabels()
    end

    selectedSavedPedMenu.OnItemSelect = function(sender, item, index)
        if item == spawnSavedPedBtn then
            if currentSavedPed and currentSavedPed.model then
                local savedWeapons = {}
                local currentWeaponHash = GetCurrentPedWeapon(PlayerPedId(), true)
                for _, weaponEntry in ipairs(ValidWeapon.WeaponList) do
                    local hash = GetHashKey(weaponEntry.Name)
                    if HasPedGotWeapon(PlayerPedId(), hash, false) then
                        savedWeapons[#savedWeapons + 1] = {
                            hash    = hash,
                            ammo    = GetAmmoInPedWeapon(PlayerPedId(), hash),
                            tint    = GetPedWeaponTintIndex(PlayerPedId(), hash),
                            current = (hash == currentWeaponHash),
                        }
                    end
                end

                PlayerAppearanceMenu.SetPlayerModel(currentSavedPed.model)
                if currentSavedPed.fullData then
                    PlayerAppearanceMenu.ApplyPedAppearance(currentSavedPed.fullData)
                end

                for _, w in ipairs(savedWeapons) do
                    GiveWeaponToPed(PlayerPedId(), w.hash, w.ammo, false, w.current)
                    SetPedWeaponTintIndex(PlayerPedId(), w.hash, w.tint)
                end

                Notify.Success("Spawned saved ped: ~y~" .. currentSavedPed.name)
            end

        elseif item == cloneSavedPedBtn then
            if currentSavedPed then
                DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", currentSavedPed.name, "", "", "", 30)
                while UpdateOnscreenKeyboard() == 0 do Wait(0) end
                local cloneName = GetOnscreenKeyboardResult()
                if cloneName and cloneName ~= "" then
                    if GetResourceKvpString("ped_" .. cloneName) then
                        Notify.Error("A saved ped with that name already exists.")
                    else
                        SetResourceKvp("ped_" .. cloneName, currentSavedPed.data)
                        Notify.Success("Saved ped cloned as: ~g~" .. cloneName)
                        PlayerAppearanceMenu.UpdateSavedPedsMenu()
                    end
                else
                    Notify.Error("Invalid save name.")
                end
            end

        elseif item == renameSavedPedBtn then
            if currentSavedPed then
                DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", currentSavedPed.name, "", "", "", 30)
                while UpdateOnscreenKeyboard() == 0 do Wait(0) end
                local newName = GetOnscreenKeyboardResult()
                if newName and newName ~= "" and newName ~= currentSavedPed.name then
                    if GetResourceKvpString("ped_" .. newName) then
                        Notify.Error("A saved ped with that name already exists.")
                    else
                        SetResourceKvp("ped_" .. newName, currentSavedPed.data)
                        DeleteResourceKvp("ped_" .. currentSavedPed.name)
                        Notify.Success("Renamed saved ped to: ~g~" .. newName)
                        currentSavedPed.name = newName
                        selectedSavedPedMenu.MenuSubtitle = newName
                        PlayerAppearanceMenu.UpdateSavedPedsMenu()
                    end
                else
                    Notify.Error("Invalid save name or same as current name.")
                end
            end

        elseif item == replaceSavedPedBtn then
            if item.Label == "Are you sure?" then
                item.Label = ""
                if currentSavedPed then
                    local capturedData = PlayerAppearanceMenu.CapturePedAppearance()
                    local pedDataStr = json.encode(capturedData)
                    SetResourceKvp("ped_" .. currentSavedPed.name, pedDataStr)
                    currentSavedPed.data = pedDataStr
                    currentSavedPed.model = capturedData.model
                    currentSavedPed.fullData = capturedData
                    Notify.Success("Saved ped replaced successfully.")
                end
            else
                item.Label = "Are you sure?"
            end

        elseif item == deleteSavedPedBtn then
            if item.Label == "Are you sure?" then
                item.Label = ""
                if currentSavedPed then
                    DeleteResourceKvp("ped_" .. currentSavedPed.name)
                    Notify.Success("Saved ped deleted.")
                    selectedSavedPedMenu:GoBack()
                    PlayerAppearanceMenu.UpdateSavedPedsMenu()
                end
            else
                item.Label = "Are you sure?"
            end
        end
    end

    PedPreview.Register(savedPedsMenu, function(sender)
        local item = sender:GetMenuItems()[sender.CurrentIndex]
        return PlayerAppearanceMenu.GetPreview(item and item.ItemData)
    end)
    PedPreview.Register(selectedSavedPedMenu, function()
        return PlayerAppearanceMenu.GetPreview(currentSavedPed)
    end)

    savedPedsMenu.OnMenuOpen = function(sender)
        PlayerAppearanceMenu.UpdateSavedPedsMenu()
    end

    savedPedsMenu.OnItemSelect = function(sender, item, index)
        if item.ItemData then
            currentSavedPed = item.ItemData
            selectedSavedPedMenu.MenuSubtitle = currentSavedPed.name
        end
    end
end

function PlayerAppearanceMenu.UpdateSavedPedsMenu()
    savedPedsMenu:ClearMenuItems()

    local savedPeds = {}
    local ok, findHandle = pcall(StartFindKvp, "ped_")
    if ok and findHandle then
        pcall(function()
            while true do
                local key = FindKvp(findHandle)
                if not key or key == "" then break end
                local data = GetResourceKvpString(key)
                local name = string.sub(key, 5)
                table.insert(savedPeds, { name = name, key = key, data = data })
            end
        end)
        pcall(EndFindKvp, findHandle)
    end

    table.sort(savedPeds, function(a, b) return a.name:lower() < b.name:lower() end)

    for _, pedEntry in ipairs(savedPeds) do
        local ok, decoded = pcall(json.decode, pedEntry.data)
        if ok and type(decoded) == "table" then
            pedEntry.model = decoded.model
            pedEntry.fullData = decoded
        end

        local btn = MenuItem:New(pedEntry.name, "Click to manage this saved ped.")
        btn.Label = "→→→"
        btn.ItemData = pedEntry

        savedPedsMenu:AddMenuItem(btn)
        MenuController:BindMenuItem(savedPedsMenu, selectedSavedPedMenu, btn)
    end
end

local function ApplySavedPedToPreview(ped, pedEntry)
    PlayerAppearanceMenu.ApplyPedAppearance(pedEntry.fullData, ped)
end

function PlayerAppearanceMenu.GetPreview(pedEntry)
    if type(pedEntry) ~= "table" or not pedEntry.model then return nil end
    return pedEntry, tonumber(pedEntry.model) or pedEntry.model, ApplySavedPedToPreview, pedEntry.data
end

function PlayerAppearanceMenu.SetupSpawnPedsMenu()
    local spawnByNameBtn = MenuItem:New("Spawn By Name", "Spawn a ped by entering its name manually.")
    local addonPedsBtn = MenuItem:New("Addon Peds", "Spawn a ped from the addon peds list.")
    addonPedsBtn.Label = "→→→"
    local mainPedsBtn = MenuItem:New("Main Peds", "Select a new ped from the main player-peds list.")
    mainPedsBtn.Label = "→→→"
    local animalPedsBtn = MenuItem:New("Animals",
        "Become an animal. ~r~Note this may crash your own or other players' game if you die as an animal, godmode can NOT prevent this.")
    animalPedsBtn.Label = "→→→"
    local malePedsBtn = MenuItem:New("Male Peds", "Select a male ped.")
    malePedsBtn.Label = "→→→"
    local femalePedsBtn = MenuItem:New("Female Peds", "Select a female ped.")
    femalePedsBtn.Label = "→→→"
    local otherPedsBtn = MenuItem:New("Other Peds", "Select a ped.")
    otherPedsBtn.Label = "→→→"

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.PASpawnNew) then
        spawnPedsMenu:AddMenuItem(spawnByNameBtn)
        spawnPedsMenu:AddMenuItem(addonPedsBtn)
        spawnPedsMenu:AddMenuItem(mainPedsBtn)
        spawnPedsMenu:AddMenuItem(animalPedsBtn)
        spawnPedsMenu:AddMenuItem(malePedsBtn)
        spawnPedsMenu:AddMenuItem(femalePedsBtn)
        spawnPedsMenu:AddMenuItem(otherPedsBtn)

        MenuController:BindMenuItem(spawnPedsMenu, addonPedsMenu, addonPedsBtn)
        MenuController:BindMenuItem(spawnPedsMenu, mainPedsMenu, mainPedsBtn)
        MenuController:BindMenuItem(spawnPedsMenu, animalsPedsMenu, animalPedsBtn)
        MenuController:BindMenuItem(spawnPedsMenu, malePedsMenu, malePedsBtn)
        MenuController:BindMenuItem(spawnPedsMenu, femalePedsMenu, femalePedsBtn)
        MenuController:BindMenuItem(spawnPedsMenu, otherPedsMenu, otherPedsBtn)

        PlayerAppearanceMenu.PopulatePedMenus()
    end

    spawnPedsMenu.OnItemSelect = function(sender, item, index)
        if item == spawnByNameBtn then
            DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 30)
            while UpdateOnscreenKeyboard() == 0 do Wait(0) end
            local modelName = GetOnscreenKeyboardResult()
            if modelName and modelName ~= "" then
                PlayerAppearanceMenu.SetPlayerModel(modelName)
            else
                Notify.Error("Invalid ped model name.")
            end
        end
    end
end

function PlayerAppearanceMenu.PopulatePedMenus()
    local function AddPedsToMenu(targetMenu, pedList)
        for _, pedData in ipairs(pedList) do
            local btn = MenuItem:New(pedData.model, "Click to spawn this ped.")
            btn.Label = "(" .. pedData.name .. ")"
            btn.ItemData = pedData.model
            targetMenu:AddMenuItem(btn)
        end
        targetMenu.OnItemSelect = function(sender, item, index)
            if item.ItemData then
                PlayerAppearanceMenu.SetPlayerModel(item.ItemData)
            end
        end
    end

    AddPedsToMenu(mainPedsMenu, PedModels.MainModels)
    AddPedsToMenu(animalsPedsMenu, PedModels.AnimalModels)
    AddPedsToMenu(malePedsMenu, PedModels.MaleModels)
    AddPedsToMenu(femalePedsMenu, PedModels.FemaleModels)
    AddPedsToMenu(otherPedsMenu, PedModels.OtherPeds)
end

function PlayerAppearanceMenu.SetPlayerModel(modelName)
    local modelHash
    local numericHash = tonumber(modelName)
    if numericHash then
        modelHash = numericHash
    else
        modelHash = GetHashKey(modelName)
    end

    if not IsModelInCdimage(modelHash) or not IsModelValid(modelHash) then
        Notify.Error("Invalid model: " .. tostring(modelName))
        return
    end

    local ped = PlayerPedId()
    local savedWeapons = {}
    local currentWeaponHash = GetCurrentPedWeapon(ped, true)

    for _, weaponEntry in ipairs(ValidWeapon.WeaponList) do
        local hash = GetHashKey(weaponEntry.Name)
        if HasPedGotWeapon(ped, hash, false) then
            savedWeapons[#savedWeapons + 1] = {
                hash    = hash,
                ammo    = GetAmmoInPedWeapon(ped, hash),
                tint    = GetPedWeaponTintIndex(ped, hash),
                current = (hash == currentWeaponHash),
            }
        end
    end

    RequestModel(modelHash)
    local timeout = 0
    while not HasModelLoaded(modelHash) and timeout < 1000 do
        Wait(10)
        timeout = timeout + 1
    end

    if HasModelLoaded(modelHash) then
        SetPlayerModel(PlayerId(), modelHash)
        Wait(0)
        SetPedDefaultComponentVariation(PlayerPedId())
        SetModelAsNoLongerNeeded(modelHash)

        local newPed = PlayerPedId()
        for _, w in ipairs(savedWeapons) do
            GiveWeaponToPed(newPed, w.hash, w.ammo, false, w.current)
            SetPedWeaponTintIndex(newPed, w.hash, w.tint)
        end

        Notify.Success("Changed ped model to: ~y~" .. tostring(modelName))
    else
        Notify.Error("Failed to load model: " .. tostring(modelName))
    end
end

function PlayerAppearanceMenu.SetWalkingStyle(styleName)
    local clipSet = walkingStyleClipSets[styleName]
    if clipSet and clipSet ~= "default" then
        RequestAnimSet(clipSet)
        local timeout = 0
        while not HasAnimSetLoaded(clipSet) and timeout < 1000 do
            Wait(10)
            timeout = timeout + 1
        end
        if HasAnimSetLoaded(clipSet) then
            SetPedMovementClipset(PlayerPedId(), clipSet, 0.2)
            Notify.Success("Walking style set to: ~y~" .. styleName)
        else
            Notify.Error("Failed to load walking style.")
        end
    else
        ResetPedMovementClipset(PlayerPedId(), 0.2)
        Notify.Success("Walking style reset to normal.")
    end
end

function PlayerAppearanceMenu.SaveCurrentPed()
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 30)
    while UpdateOnscreenKeyboard() == 0 do Wait(0) end

    local saveName = GetOnscreenKeyboardResult()
    if saveName and saveName ~= "" then
        if GetResourceKvpString("ped_" .. saveName) then
            Notify.Error("A saved ped with that name already exists.")
        else
            local pedData = json.encode(PlayerAppearanceMenu.CapturePedAppearance())
            SetResourceKvp("ped_" .. saveName, pedData)
            Notify.Success("Saved ped as: ~g~" .. saveName)
        end
    else
        Notify.Error("Invalid save name.")
    end
end

local MP_PED_MODELS = {
    [GetHashKey("mp_m_freemode_01")] = true,
    [GetHashKey("mp_f_freemode_01")] = true,
}

function PlayerAppearanceMenu.CapturePedAppearance()
    local ped = PlayerPedId()
    local model = GetEntityModel(ped)
    local isMpPed = MP_PED_MODELS[model] == true
    local data = {
        model = tostring(model),
        components = {},
        props = {},
        headBlend = nil,
        headOverlays = {},
        headOverlayColors = {},
        faceFeatures = {},
        hairColor = nil,
        eyeColor = nil,
    }

    for i = 0, 11 do
        data.components[tostring(i)] = {
            drawable = GetPedDrawableVariation(ped, i),
            texture  = GetPedTextureVariation(ped, i),
            palette  = GetPedPaletteVariation(ped, i),
        }
    end

    for i = 0, 7 do
        data.props[tostring(i)] = {
            drawable = GetPedPropIndex(ped, i),
            texture  = GetPedPropTextureIndex(ped, i),
        }
    end

    if isMpPed then
        local ok, s1, s2, s3, sk1, sk2, sk3, sm, skm, tm, isp = pcall(GetPedHeadBlendData, ped)
        if ok then
            data.headBlend = {
                shapeFirst  = s1,  shapeSecond = s2,  shapeThird = s3,
                skinFirst   = sk1, skinSecond  = sk2, skinThird  = sk3,
                shapeMix    = sm,  skinMix     = skm, thirdMix   = tm,
                isParent    = isp,
            }
        end

        for i = 0, 12 do
            local retval, overlayValue, colourType, firstColour, secondColour, overlayOpacity = GetPedHeadOverlayData(ped, i)
            if retval then
                data.headOverlays[tostring(i)] = { value = overlayValue, opacity = overlayOpacity }
                data.headOverlayColors[tostring(i)] = {
                    colorType   = colourType,
                    firstColor  = firstColour,
                    secondColor = secondColour,
                }
            end
        end

        for i = 0, 19 do
            data.faceFeatures[tostring(i)] = GetPedFaceFeature(ped, i)
        end

        local ok2, hc1, hc2 = pcall(GetPedHairColor, ped)
        if ok2 then data.hairColor = { hc1, hc2 } end

        local ok3, ec = pcall(GetPedEyeColor, ped)
        if ok3 then data.eyeColor = ec end
    end

    return data
end

function PlayerAppearanceMenu.ApplyPedAppearance(data, ped)
    if type(data) ~= "table" then return end
    ped = ped or PlayerPedId()
    local isMpPed = MP_PED_MODELS[GetEntityModel(ped)] == true

    if isMpPed and type(data.headBlend) == "table" then
        local hb = data.headBlend
        SetPedHeadBlendData(ped,
            hb.shapeFirst or 0, hb.shapeSecond or 0, hb.shapeThird or 0,
            hb.skinFirst  or 0, hb.skinSecond  or 0, hb.skinThird  or 0,
            hb.shapeMix   or 0.5, hb.skinMix   or 0.5, hb.thirdMix or 0.0,
            hb.isParent == true
        )
        local timeout = 0
        while not HasPedHeadBlendFinished(ped) and timeout < 200 do
            Wait(10)
            timeout = timeout + 1
        end
    end

    if type(data.components) == "table" then
        for i = 0, 11 do
            local comp = data.components[tostring(i)]
            if type(comp) == "table" then
                SetPedComponentVariation(ped, i, comp.drawable or 0, comp.texture or 0, comp.palette or 0)
            end
        end
    end

    if type(data.props) == "table" then
        for i = 0, 7 do
            local prop = data.props[tostring(i)]
            if type(prop) == "table" then
                if (prop.drawable or -1) == -1 then
                    ClearPedProp(ped, i)
                else
                    SetPedPropIndex(ped, i, prop.drawable, prop.texture or 0, true)
                end
            end
        end
    end

    if isMpPed then
        if type(data.headOverlays) == "table" then
            for i = 0, 12 do
                local overlay = data.headOverlays[tostring(i)]
                if type(overlay) == "table" then
                    SetPedHeadOverlay(ped, i, overlay.value or 255, overlay.opacity or 1.0)
                    if type(data.headOverlayColors) == "table" then
                        local color = data.headOverlayColors[tostring(i)]
                        if type(color) == "table" and (overlay.value or 255) ~= 255 then
                            SetPedHeadOverlayColor(ped, i, color.colorType or 0, color.firstColor or 0, color.secondColor or 0)
                        end
                    end
                end
            end
        end

        if type(data.faceFeatures) == "table" then
            for i = 0, 19 do
                local val = data.faceFeatures[tostring(i)]
                if val ~= nil then
                    SetPedFaceFeature(ped, i, val)
                end
            end
        end

        if type(data.hairColor) == "table" then
            SetPedHairColor(ped, data.hairColor[1] or 0, data.hairColor[2] or 0)
        end

        if data.eyeColor ~= nil then
            SetPedEyeColor(ped, data.eyeColor)
        end
    end
end

function PlayerAppearanceMenu.GetMenu()
    if menu == nil then
        PlayerAppearanceMenu.CreateMenu()
    end
    return menu
end

return PlayerAppearanceMenu
