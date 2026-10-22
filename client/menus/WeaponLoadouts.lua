WeaponLoadoutsMenu = {}

local menu = nil
local savedLoadoutsMenu = nil
local manageLoadoutMenu = nil

WeaponLoadoutsMenu.WeaponLoadoutsSetLoadoutOnRespawn = false
local selectedLoadoutName = ""

local KVP_PREFIX = "vmenu_string_saved_weapon_loadout_"
local KVP_DEFAULT_LOADOUT = "vmenu_string_default_weapon_loadout"

local weaponComponentTypes = {
    "COMPONENT_AT_PI_SUPP",
    "COMPONENT_AT_AR_SUPP",
    "COMPONENT_AT_AR_SUPP_02",
    "COMPONENT_AT_SR_SUPP",
    "COMPONENT_AT_SR_SUPP_03",
    "COMPONENT_AT_SCOPE_SMALL",
    "COMPONENT_AT_SCOPE_SMALL_02",
    "COMPONENT_AT_SCOPE_MEDIUM",
    "COMPONENT_AT_SCOPE_MEDIUM_MK2",
    "COMPONENT_AT_SCOPE_LARGE",
    "COMPONENT_AT_SCOPE_LARGE_FIXED_ZOOM",
    "COMPONENT_AT_SCOPE_LARGE_MK2",
    "COMPONENT_AT_SCOPE_MACRO",
    "COMPONENT_AT_SCOPE_MACRO_02",
    "COMPONENT_AT_SCOPE_MACRO_MK2",
    "COMPONENT_AT_SCOPE_MAX",
    "COMPONENT_AT_SCOPE_NV",
    "COMPONENT_AT_SCOPE_THERMAL",
    "COMPONENT_AT_AR_AFGRIP",
    "COMPONENT_AT_AR_AFGRIP_02",
    "COMPONENT_AT_AR_FLSH",
    "COMPONENT_AT_PI_FLSH",
    "COMPONENT_PISTOL_CLIP_02",
    "COMPONENT_COMBATPISTOL_CLIP_02",
    "COMPONENT_APPISTOL_CLIP_02",
    "COMPONENT_MICROSMG_CLIP_02",
    "COMPONENT_SMG_CLIP_02",
    "COMPONENT_ASSAULTRIFLE_CLIP_02",
    "COMPONENT_CARBINERIFLE_CLIP_02",
    "COMPONENT_ADVANCEDRIFLE_CLIP_02",
    "COMPONENT_MG_CLIP_02",
    "COMPONENT_COMBATMG_CLIP_02",
    "COMPONENT_ASSAULTSHOTGUN_CLIP_02",
    "COMPONENT_SNIPERRIFLE_CLIP_02",
    "COMPONENT_HEAVYSNIPER_CLIP_02",
    "COMPONENT_ASSAULTRIFLE_CLIP_03",
    "COMPONENT_CARBINERIFLE_CLIP_03",
    "COMPONENT_MG_CLIP_03",
    "COMPONENT_COMBATMG_CLIP_03",
    "COMPONENT_AT_AR_BARREL_01",
    "COMPONENT_AT_AR_BARREL_02",
    "COMPONENT_AT_SR_BARREL_01",
    "COMPONENT_AT_SR_BARREL_02",
    "COMPONENT_AT_MUZZLE_01",
    "COMPONENT_AT_MUZZLE_02",
    "COMPONENT_AT_MUZZLE_03",
    "COMPONENT_AT_MUZZLE_04",
    "COMPONENT_AT_MUZZLE_05",
    "COMPONENT_AT_MUZZLE_06",
    "COMPONENT_AT_MUZZLE_07",
    "COMPONENT_AT_MUZZLE_08",
    "COMPONENT_AT_MUZZLE_09",
}

local function GetSavedWeapons()
    local handle = StartFindKvp(KVP_PREFIX)
    local saves = {}

    while true do
        local kvp = FindKvp(handle)
        if not kvp or kvp == "" then
            break
        end

        local data = GetResourceKvpString(kvp)
        if data and data ~= "" then
            local success, loadout = pcall(function()
                return json.decode(data)
            end)
            if success and loadout then
                local loadoutName = kvp:sub(#KVP_PREFIX + 1)
                saves[loadoutName] = loadout
            end
        end
    end

    EndFindKvp(handle)
    return saves
end

local function RefreshSavedWeaponsMenu()
    if not savedLoadoutsMenu then return end

    savedLoadoutsMenu:ClearMenuItems()

    local savedWeapons = GetSavedWeapons()
    local sortedNames = {}

    for name, _ in pairs(savedWeapons) do
        table.insert(sortedNames, name)
    end

    table.sort(sortedNames, function(a, b)
        return a:lower() < b:lower()
    end)

    if #sortedNames == 0 then
        local noSavesBtn = MenuItem:New("No Saved Loadouts", "Save a loadout to see it here.")
        noSavesBtn.Enabled = false
        savedLoadoutsMenu:AddMenuItem(noSavesBtn)
    else
        for _, name in ipairs(sortedNames) do
            local loadout = savedWeapons[name]
            local weaponCount = #loadout
            local btn = MenuItem:New(name, "Click to manage this loadout.")
            btn.Label = "→→→"
            btn.ItemData = { name = name, loadout = loadout }
            savedLoadoutsMenu:AddMenuItem(btn)
            MenuController:BindMenuItem(savedLoadoutsMenu, manageLoadoutMenu, btn)
        end
    end
end

local function SaveWeaponLoadout(saveName)
    local ped = PlayerPedId()
    local weapons = {}

    if ValidWeapon and ValidWeapon.WeaponList then
        for _, weaponData in ipairs(ValidWeapon.WeaponList) do
            local weaponHash = GetHashKey(weaponData.Name)

            if HasPedGotWeapon(ped, weaponHash, false) then
                local weapon = {
                    Name = weaponData.Name,
                    Hash = weaponHash,
                    Tint = GetPedWeaponTintIndex(ped, weaponHash),
                    Ammo = GetAmmoInPedWeapon(ped, weaponHash),
                    Components = {}
                }

                for _, compName in ipairs(weaponComponentTypes) do
                    local compHash = GetHashKey(compName)
                    if HasPedGotWeaponComponent(ped, weaponHash, compHash) then
                        table.insert(weapon.Components, {
                            Name = compName,
                            Hash = compHash
                        })
                    end
                end

                table.insert(weapons, weapon)
            end
        end
    end

    if #weapons == 0 then
        return false
    end

    local jsonData = json.encode(weapons)
    SetResourceKvp(KVP_PREFIX .. saveName, jsonData)
    return true
end

local function SpawnWeaponLoadout(loadoutName, clearWeapons, notify)
    local data = GetResourceKvpString(KVP_PREFIX .. loadoutName)
    if not data or data == "" then
        if notify then
            Notify.Error("Loadout not found.")
        end
        return false
    end

    local success, weapons = pcall(function()
        return json.decode(data)
    end)

    if not success or not weapons then
        if notify then
            Notify.Error("Failed to load loadout data.")
        end
        return false
    end

    local ped = PlayerPedId()

    if clearWeapons then
        RemoveAllPedWeapons(ped, true)
    end

    local weaponsGiven = 0

    for _, weapon in ipairs(weapons) do
        local weaponHash = weapon.Hash or GetHashKey(weapon.Name)

        GiveWeaponToPed(ped, weaponHash, weapon.Ammo or 250, false, false)

        Wait(10)

        if weapon.Components then
            for _, comp in ipairs(weapon.Components) do
                local compHash = comp.Hash or GetHashKey(comp.Name)
                if DoesWeaponTakeWeaponComponent(weaponHash, compHash) then
                    GiveWeaponComponentToPed(ped, weaponHash, compHash)
                end
            end
        end

        if weapon.Tint then
            SetPedWeaponTintIndex(ped, weaponHash, weapon.Tint)
        end

        weaponsGiven = weaponsGiven + 1
    end

    SetCurrentPedWeapon(ped, GetHashKey("weapon_unarmed"), true)

    if notify then
        Notify.Success("Equipped ~g~" .. loadoutName .. "~s~ with " .. weaponsGiven .. " weapon(s).")
    end

    return true
end

function WeaponLoadoutsMenu.CreateMenu()
    menu = Menu:New("Weapon Loadouts", "Weapon Loadouts Management")
    MenuController:AddMenu(menu)

    savedLoadoutsMenu = Menu:New("Saved Loadouts", "Saved Weapon Loadouts List")
    manageLoadoutMenu = Menu:New("Manage Loadout", "Manage Saved Weapon Loadout")

    MenuController:AddMenu(savedLoadoutsMenu)
    MenuController:AddMenu(manageLoadoutMenu)

    local saveLoadoutBtn = MenuItem:New("Save Loadout", "Save your current weapons into a new loadout slot.")
    local savedLoadoutsBtn = MenuItem:New("Manage Loadouts", "Manage saved weapon loadouts.")
    savedLoadoutsBtn.Label = "→→→"

    local savedSetting = GetResourceKvpInt("vmenu_weapon_loadout_on_respawn")
    WeaponLoadoutsMenu.WeaponLoadoutsSetLoadoutOnRespawn = savedSetting == 1

    local enableDefaultLoadoutCheckbox = MenuCheckboxItem:New("Restore Default Loadout On Respawn",
        "If you've set a loadout as default loadout, then your loadout will be equipped automatically whenever you (re)spawn.",
        WeaponLoadoutsMenu.WeaponLoadoutsSetLoadoutOnRespawn)

    menu:AddMenuItem(saveLoadoutBtn)
    menu:AddMenuItem(savedLoadoutsBtn)
    MenuController:BindMenuItem(menu, savedLoadoutsMenu, savedLoadoutsBtn)

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.WLEquipOnRespawn) then
        menu:AddMenuItem(enableDefaultLoadoutCheckbox)
    end

    local spawnLoadoutBtn = MenuItem:New("Equip Loadout",
        "Spawn this saved weapons loadout. This will remove all your current weapons and replace them with this saved slot.")
    local renameLoadoutBtn = MenuItem:New("Rename Loadout", "Rename this saved loadout.")
    local cloneLoadoutBtn = MenuItem:New("Clone Loadout", "Clones this saved loadout to a new slot.")
    local setDefaultLoadoutBtn = MenuItem:New("Set As Default Loadout",
        "Set this loadout to be your default loadout for whenever you (re)spawn. This will override the 'Restore Weapons' option inside the Misc Settings menu.")
    local replaceLoadoutBtn = MenuItem:New("~r~Replace Loadout",
        "~r~This replaces this saved slot with the weapons that you currently have in your inventory. This action can not be undone!")
    local deleteLoadoutBtn = MenuItem:New("~r~Delete Loadout",
        "~r~This will delete this saved loadout. This action can not be undone!")

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.WLEquip) then
        manageLoadoutMenu:AddMenuItem(spawnLoadoutBtn)
    end

    manageLoadoutMenu:AddMenuItem(renameLoadoutBtn)
    manageLoadoutMenu:AddMenuItem(cloneLoadoutBtn)
    manageLoadoutMenu:AddMenuItem(setDefaultLoadoutBtn)
    manageLoadoutMenu:AddMenuItem(replaceLoadoutBtn)
    manageLoadoutMenu:AddMenuItem(deleteLoadoutBtn)

    menu.OnCheckboxChange = function(sender, item, index, checked)
        if item == enableDefaultLoadoutCheckbox then
            WeaponLoadoutsMenu.WeaponLoadoutsSetLoadoutOnRespawn = checked
            SetResourceKvpInt("vmenu_weapon_loadout_on_respawn", checked and 1 or 0)
        end
    end

    menu.OnItemSelect = function(sender, item, index)
        if item == saveLoadoutBtn then
            DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 30)
            while UpdateOnscreenKeyboard() == 0 do
                Wait(0)
            end
            if GetOnscreenKeyboardResult() then
                local name = GetOnscreenKeyboardResult()
                if name and name ~= "" then
                    local existingData = GetResourceKvpString(KVP_PREFIX .. name)
                    if existingData and existingData ~= "" then
                        Notify.Error("A loadout with that name already exists.")
                    else
                        if SaveWeaponLoadout(name) then
                            Notify.Success("Your weapons have been saved as ~g~" .. name .. "~s~.")
                            RefreshSavedWeaponsMenu()
                        else
                            Notify.Error("You don't have any weapons to save.")
                        end
                    end
                else
                    Notify.Error("Invalid save name.")
                end
            end
        end
    end

    savedLoadoutsMenu.OnMenuOpen = function(sender)
        RefreshSavedWeaponsMenu()
    end

    savedLoadoutsMenu.OnItemSelect = function(sender, item, index)
        if item.ItemData then
            selectedLoadoutName = item.ItemData.name
            manageLoadoutMenu.MenuSubtitle =selectedLoadoutName
        end
    end

    manageLoadoutMenu.OnItemSelect = function(sender, item, index)
        if selectedLoadoutName == "" then
            Notify.Error("No loadout selected.")
            return
        end

        if item == spawnLoadoutBtn then
            SpawnWeaponLoadout(selectedLoadoutName, true, true)

        elseif item == renameLoadoutBtn then
            DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", selectedLoadoutName, "", "", "", 30)
            while UpdateOnscreenKeyboard() == 0 do
                Wait(0)
            end
            if GetOnscreenKeyboardResult() then
                local newName = GetOnscreenKeyboardResult()
                if newName and newName ~= "" and newName ~= selectedLoadoutName then
                    local existingData = GetResourceKvpString(KVP_PREFIX .. newName)
                    if existingData and existingData ~= "" then
                        Notify.Error("A loadout with that name already exists.")
                    else
                        local oldData = GetResourceKvpString(KVP_PREFIX .. selectedLoadoutName)
                        if oldData and oldData ~= "" then
                            SetResourceKvp(KVP_PREFIX .. newName, oldData)

                            local defaultLoadout = GetResourceKvpString(KVP_DEFAULT_LOADOUT)
                            if defaultLoadout == selectedLoadoutName then
                                SetResourceKvp(KVP_DEFAULT_LOADOUT, newName)
                            end

                            DeleteResourceKvp(KVP_PREFIX .. selectedLoadoutName)

                            selectedLoadoutName = newName
                            manageLoadoutMenu.MenuSubtitle =newName
                            Notify.Success("Loadout renamed to ~g~" .. newName .. "~s~.")
                            RefreshSavedWeaponsMenu()
                        end
                    end
                end
            end

        elseif item == cloneLoadoutBtn then
            DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", selectedLoadoutName .. " (Copy)", "", "", "", 30)
            while UpdateOnscreenKeyboard() == 0 do
                Wait(0)
            end
            if GetOnscreenKeyboardResult() then
                local newName = GetOnscreenKeyboardResult()
                if newName and newName ~= "" then
                    local existingData = GetResourceKvpString(KVP_PREFIX .. newName)
                    if existingData and existingData ~= "" then
                        Notify.Error("A loadout with that name already exists.")
                    else
                        local sourceData = GetResourceKvpString(KVP_PREFIX .. selectedLoadoutName)
                        if sourceData and sourceData ~= "" then
                            SetResourceKvp(KVP_PREFIX .. newName, sourceData)
                            Notify.Success("Loadout cloned as ~g~" .. newName .. "~s~.")
                            RefreshSavedWeaponsMenu()
                        end
                    end
                end
            end

        elseif item == setDefaultLoadoutBtn then
            SetResourceKvp(KVP_DEFAULT_LOADOUT, selectedLoadoutName)
            Notify.Success("~g~" .. selectedLoadoutName .. "~s~ is now your default loadout.")

        elseif item == replaceLoadoutBtn then
            if item.Label == "Are you sure?" then
                item.Label = ""
                if SaveWeaponLoadout(selectedLoadoutName) then
                    Notify.Success("Loadout has been replaced with your current weapons.")
                else
                    Notify.Error("You don't have any weapons to save.")
                end
            else
                item.Label = "Are you sure?"
            end

        elseif item == deleteLoadoutBtn then
            if item.Label == "Are you sure?" then
                item.Label = ""

                local defaultLoadout = GetResourceKvpString(KVP_DEFAULT_LOADOUT)
                if defaultLoadout == selectedLoadoutName then
                    DeleteResourceKvp(KVP_DEFAULT_LOADOUT)
                end

                DeleteResourceKvp(KVP_PREFIX .. selectedLoadoutName)
                Notify.Success("Loadout ~r~" .. selectedLoadoutName .. "~s~ has been deleted.")
                manageLoadoutMenu:GoBack()
                RefreshSavedWeaponsMenu()
            else
                item.Label = "Are you sure?"
            end
        end
    end

    manageLoadoutMenu.OnIndexChange = function(sender, oldItem, newItem, oldIndex, newIndex)
        replaceLoadoutBtn.Label = ""
        deleteLoadoutBtn.Label = ""
    end

    manageLoadoutMenu.OnMenuOpen = function(sender)
        replaceLoadoutBtn.Label = ""
        deleteLoadoutBtn.Label = ""
    end

    return menu
end

function WeaponLoadoutsMenu.GetMenu()
    if menu == nil then
        WeaponLoadoutsMenu.CreateMenu()
    end
    return menu
end

function WeaponLoadoutsMenu.SpawnWeaponLoadoutAsync(loadoutName, clearWeapons, notify)
    if clearWeapons == nil then clearWeapons = true end
    if notify == nil then notify = true end
    return SpawnWeaponLoadout(loadoutName, clearWeapons, notify)
end

function WeaponLoadoutsMenu.GetSavedWeapons()
    return GetSavedWeapons()
end

local function RestoreDefaultLoadoutOnRespawn()
    if not WeaponLoadoutsMenu.WeaponLoadoutsSetLoadoutOnRespawn then
        return
    end

    local defaultLoadout = GetResourceKvpString(KVP_DEFAULT_LOADOUT)
    if not defaultLoadout or defaultLoadout == "" then
        return
    end

    Wait(1000)

    SpawnWeaponLoadout(defaultLoadout, true, false)
end

AddEventHandler("playerSpawned", function()
    RestoreDefaultLoadoutOnRespawn()
end)

return WeaponLoadoutsMenu
