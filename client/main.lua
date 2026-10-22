local clientAuthorized = false
local authorizationComplete = false

Citizen.CreateThread(function()
    Wait(500)

    if not ClientAuth then
        return
    end

    ClientAuth.RequestAuthorization()

    local authorized = ClientAuth.WaitForAuthorization(30000)

    if not authorized then
        authorizationComplete = true
        return
    end

    clientAuthorized = true
    authorizationComplete = true
end)

local function IsClientAuthorized()
    return clientAuthorized == true and ClientAuth and ClientAuth.IsAuthorized()
end

local mainMenu = nil
local playerSubmenu = nil
local vehicleSubmenu = nil
local worldSubmenu = nil

local menuToggleKey = "M"
local noclipKey = "F2"
local menuEnabled = true
local permissionsSetupComplete = false
local configOptionsSetupComplete = false

GetKeyMappingId = (function()
    local id = ConfigManager.GetSettingsString(ConfigManager.Setting.vmenu_keymapping_id, "default")
    if not id or id == "" then
        id = "default"
    end
    return id
end)

InitializeKeymappings = (function()
    local keyMappingId = GetKeyMappingId()

    local customMenuKey = ConfigManager.GetSettingsString(ConfigManager.Setting.vmenu_menu_toggle_key, "M")
    local customNoclipKey = ConfigManager.GetSettingsString(ConfigManager.Setting.vmenu_noclip_toggle_key, "F2")

    if customMenuKey and customMenuKey ~= "" and customMenuKey:len() > 0 and not tonumber(customMenuKey) then
        menuToggleKey = customMenuKey
    end

    if customNoclipKey and customNoclipKey ~= "" and customNoclipKey:len() > 0 and not tonumber(customNoclipKey) then
        noclipKey = customNoclipKey
    end

    local lastToggleTime = 0
    local toggleDebounceMs = 200

    RegisterCommand("vMenu:" .. keyMappingId .. ":MenuToggle", function()
        if vMenuDisabled then return end

        local currentTime = GetGameTimer()
        if currentTime - lastToggleTime < toggleDebounceMs then
            return
        end
        lastToggleTime = currentTime

        if not PermissionsManager.ArePermissionsSetup then
            return
        end

        local staffOnly = ConfigManager.GetSettingsBool(ConfigManager.Setting.vmenu_menu_staff_only)
        if staffOnly then
            local hasStaffAccess = PermissionsManager.IsAllowed(PermissionsManager.Permission.Staff) or
                PermissionsManager.IsAllowed(PermissionsManager.Permission.Everything)
            if not hasStaffAccess then
                return
            end
        end

        local targetMenu = mainMenu or MenuController.MainMenu

        if menuEnabled and targetMenu then
            if MenuController:IsAnyMenuOpen() then
                for openMenu, _ in pairs(MenuController.VisibleMenus) do
                    openMenu:CloseMenu()
                end
            else
                targetMenu:OpenMenu()
            end
        end
    end, false)

    RegisterCommand("vMenu:" .. keyMappingId .. ":NoClip", function()
        if vMenuDisabled then return end
        if PermissionsManager.IsAllowed(PermissionsManager.Permission.NoClip) then
            Noclip.Toggle()
        end
    end, false)

    RegisterKeyMapping("vMenu:" .. keyMappingId .. ":MenuToggle", "vMenu Toggle Button", "keyboard", menuToggleKey)
    RegisterKeyMapping("vMenu:" .. keyMappingId .. ":MenuToggle", "vMenu Toggle Button Controller",
        "pad_digitalbuttonany", "start_index")
    RegisterKeyMapping("vMenu:" .. keyMappingId .. ":NoClip", "vMenu NoClip Toggle Button", "keyboard", noclipKey)

end)

CreateMainMenu = (function()
    for openMenu, _ in pairs(MenuController.VisibleMenus) do
        openMenu._visible = false
    end

    MenuController.Menus = {}
    MenuController.VisibleMenus = {}
    MenuController.MainMenu = nil
    mainMenu = Menu:New("vMenu", "Main Menu")
    MenuController:AddMenu(mainMenu)
    MenuController.MainMenu = mainMenu

    playerSubmenu = Menu:New("Player Related Options", "Player options submenu")
    MenuController:AddMenu(playerSubmenu)

    vehicleSubmenu = Menu:New("Vehicle Related Options", "Vehicle options submenu")
    MenuController:AddMenu(vehicleSubmenu)

    worldSubmenu = Menu:New("World Related Options", "World options submenu")
    MenuController:AddMenu(worldSubmenu)

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.OPMenu) then
        local onlinePlayersMenu = OnlinePlayersMenu.GetMenu()
        local onlinePlayersBtn = MenuItem:New("Online Players", "All currently connected players.")
        onlinePlayersBtn.Label = "→→→"
        mainMenu:AddMenuItem(onlinePlayersBtn)
        MenuController:BindMenuItem(mainMenu, onlinePlayersMenu, onlinePlayersBtn)
    end

    local playerSubmenuBtn = MenuItem:New("Player Related Options", "Player options and customization")
    playerSubmenuBtn.Label = "→→→"
    mainMenu:AddMenuItem(playerSubmenuBtn)
    MenuController:BindMenuItem(mainMenu, playerSubmenu, playerSubmenuBtn)

    local vehicleSubmenuBtn = MenuItem:New("Vehicle Related Options", "Vehicle spawning and options")
    vehicleSubmenuBtn.Label = "→→→"
    mainMenu:AddMenuItem(vehicleSubmenuBtn)
    MenuController:BindMenuItem(mainMenu, vehicleSubmenu, vehicleSubmenuBtn)

    local worldSubmenuBtn = MenuItem:New("World Related Options", "Time and weather options")
    worldSubmenuBtn.Label = "→→→"
    mainMenu:AddMenuItem(worldSubmenuBtn)
    MenuController:BindMenuItem(mainMenu, worldSubmenu, worldSubmenuBtn)

    local recordingMenu = RecordingMenu.GetMenu()
    local recordingBtn = MenuItem:New("Recording Options", "In-game recording options.")
    recordingBtn.Label = "→→→"
    mainMenu:AddMenuItem(recordingBtn)
    MenuController:BindMenuItem(mainMenu, recordingMenu, recordingBtn)

    local miscSettingsMenu = MiscSettingsMenu.GetMenu()
    local miscSettingsBtn = MenuItem:New("Misc Settings", "Miscellaneous settings and options.")
    miscSettingsBtn.Label = "→→→"
    mainMenu:AddMenuItem(miscSettingsBtn)
    MenuController:BindMenuItem(mainMenu, miscSettingsMenu, miscSettingsBtn)

    local aboutMenu = AboutMenu.GetMenu()
    local aboutBtn = MenuItem:New("About vMenu", "Information about vMenu.")
    aboutBtn.Label = "→→→"
    mainMenu:AddMenuItem(aboutBtn)
    MenuController:BindMenuItem(mainMenu, aboutMenu, aboutBtn)

    local languageList = MenuListItem:New("Language", Locale.GetLanguageNames(), Locale.GetLanguageIndex(),
        "Change the language of vMenu. Saved automatically.")
    mainMenu:AddMenuItem(languageList)
    mainMenu.OnListIndexChange = function(sender, item, oldIndex, newIndex, itemIndex)
        if item == languageList then
            local lang = Locale.Languages[newIndex]
            if lang then
                Locale.SetLanguage(lang.code)
            end
        end
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.POMenu) then
        local playerOptionsMenu = PlayerOptionsMenu.GetMenu()
        local playerOptionsBtn = MenuItem:New("Player Options", "Player related options like god mode, stamina, etc.")
        playerOptionsBtn.Label = "→→→"
        playerSubmenu:AddMenuItem(playerOptionsBtn)
        MenuController:BindMenuItem(playerSubmenu, playerOptionsMenu, playerOptionsBtn)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.PAMenu) then
        local playerAppearanceMenu = PlayerAppearanceMenu.GetMenu()
        local playerAppearanceBtn = MenuItem:New("Player Appearance",
            "Change your player model, customize ped appearance, and manage saved peds.")
        playerAppearanceBtn.RightIcon = Icon.MALE
        playerSubmenu:AddMenuItem(playerAppearanceBtn)
        MenuController:BindMenuItem(playerSubmenu, playerAppearanceMenu, playerAppearanceBtn)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.MPMenu) then
        local mpPedCustomizationMenu = MpPedCustomizationMenu.GetMenu()
        local mpPedCustomizationBtn = MenuItem:New("MP Ped Customization",
            "Detailed character creator for FreeMode peds.")
        mpPedCustomizationBtn.Label = "→→→"
        playerSubmenu:AddMenuItem(mpPedCustomizationBtn)
        MenuController:BindMenuItem(playerSubmenu, mpPedCustomizationMenu, mpPedCustomizationBtn)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.WPMenu) then
        local weaponOptionsMenu = WeaponOptionsMenu.GetMenu()
        local weaponOptionsBtn = MenuItem:New("Weapon Options",
            "Weapon related options like unlimited ammo, spawning weapons, etc.")
        weaponOptionsBtn.RightIcon = Icon.GUN
        playerSubmenu:AddMenuItem(weaponOptionsBtn)
        MenuController:BindMenuItem(playerSubmenu, weaponOptionsMenu, weaponOptionsBtn)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.WLMenu) then
        local weaponLoadoutsMenu = WeaponLoadoutsMenu.GetMenu()
        local weaponLoadoutsBtn = MenuItem:New("Weapon Loadouts", "Save and manage your weapon loadouts.")
        weaponLoadoutsBtn.Label = "→→→"
        playerSubmenu:AddMenuItem(weaponLoadoutsBtn)
        MenuController:BindMenuItem(playerSubmenu, weaponLoadoutsMenu, weaponLoadoutsBtn)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.VOMenu) then
        local vehicleOptionsMenu = VehicleOptionsMenu.GetMenu()
        local vehicleOptionsBtn = MenuItem:New("Vehicle Options", "Vehicle related options like god mode, repair, etc.")
        vehicleOptionsBtn.Label = "→→→"
        vehicleSubmenu:AddMenuItem(vehicleOptionsBtn)
        MenuController:BindMenuItem(vehicleSubmenu, vehicleOptionsMenu, vehicleOptionsBtn)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.VSMenu) then
        local vehicleSpawnerMenu = VehicleSpawnerMenu.GetMenu()
        local vehicleSpawnerBtn = MenuItem:New("Vehicle Spawner", "Spawn vehicles by name or category.")
        vehicleSpawnerBtn.Label = "→→→"
        vehicleSubmenu:AddMenuItem(vehicleSpawnerBtn)
        MenuController:BindMenuItem(vehicleSubmenu, vehicleSpawnerMenu, vehicleSpawnerBtn)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.SVMenu) then
        local savedVehiclesMenu = SavedVehiclesMenu.GetMenu()
        local savedVehiclesBtn = MenuItem:New("Saved Vehicles", "Save and manage your favorite vehicles.")
        savedVehiclesBtn.Label = "→→→"
        vehicleSubmenu:AddMenuItem(savedVehiclesBtn)
        MenuController:BindMenuItem(vehicleSubmenu, savedVehiclesMenu, savedVehiclesBtn)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.PVMenu) then
        local personalVehicleMenu = PersonalVehicleMenu.GetMenu()
        local personalVehicleBtn = MenuItem:New("Personal Vehicle",
            "Set a vehicle as your personal vehicle and control it remotely.")
        personalVehicleBtn.Label = "→→→"
        vehicleSubmenu:AddMenuItem(personalVehicleBtn)
        MenuController:BindMenuItem(vehicleSubmenu, personalVehicleMenu, personalVehicleBtn)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.TOMenu) then
        local timeOptionsMenu = TimeOptionsMenu.GetMenu()
        local timeOptionsBtn = MenuItem:New("Time Options", "Change and freeze the time.")
        timeOptionsBtn.Label = "→→→"
        worldSubmenu:AddMenuItem(timeOptionsBtn)
        MenuController:BindMenuItem(worldSubmenu, timeOptionsMenu, timeOptionsBtn)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.WOMenu) then
        local weatherOptionsMenu = WeatherOptionsMenu.GetMenu()
        local weatherOptionsBtn = MenuItem:New("Weather Options", "Change and freeze the weather.")
        weatherOptionsBtn.Label = "→→→"
        worldSubmenu:AddMenuItem(weatherOptionsBtn)
        MenuController:BindMenuItem(worldSubmenu, weatherOptionsMenu, weatherOptionsBtn)
    end

end)

local function RequestPermissions()

    TriggerServerEvent("vMenu:RequestPermissions")

end

RegisterNetEvent("vMenu:SetConfigOptions", function()
    configOptionsSetupComplete = true

end)

local function Initialize()

    InitializeKeymappings()

    RequestPermissions()

end

Citizen.CreateThread(function()
    Wait(3000)
    while not PermissionsManager.ArePermissionsSetup do
        Wait(100)
    end
    permissionsSetupComplete = true
    if PlayerOptionsMenu and PlayerOptionsMenu.LoadSettings then
        PlayerOptionsMenu.LoadSettings()
    end
    CreateMainMenu()
end)

RegisterNetEvent("vMenu:SetPermissions")
AddEventHandler("vMenu:SetPermissions", function()
    if permissionsSetupComplete then
        SetTimeout(200, function()
            CreateMainMenu()
            if PlayerOptionsMenu and PlayerOptionsMenu.EnforcePermissions then
                PlayerOptionsMenu.EnforcePermissions()
            end
            if MiscSettingsMenu and MiscSettingsMenu.EnforcePermissions then
                MiscSettingsMenu.EnforcePermissions()
            end
        end)
    end
end)

CreateThread(function()
    Wait(3000)
    Initialize()
end)
