PermissionsManager = {}

PermissionsManager.Permission = {
    Everything = "Everything",
    DontKickMe = "DontKickMe",
    DontBanMe = "DontBanMe",
    NoClip = "NoClip",
    Staff = "Staff",

    OPMenu = "OPMenu",
    OPAll = "OPAll",
    OPTeleport = "OPTeleport",
    OPWaypoint = "OPWaypoint",
    OPSpectate = "OPSpectate",
    OPSendMessage = "OPSendMessage",
    OPIdentifiers = "OPIdentifiers",
    OPSummon = "OPSummon",
    OPKill = "OPKill",
    OPKick = "OPKick",
    OPPermBan = "OPPermBan",
    OPTempBan = "OPTempBan",
    OPUnban = "OPUnban",
    OPViewBannedPlayers = "OPViewBannedPlayers",
    OPSeePrivateMessages = "OPSeePrivateMessages",

    POMenu = "POMenu",
    POAll = "POAll",
    POGod = "POGod",
    POInvisible = "POInvisible",
    POFastRun = "POFastRun",
    POFastSwim = "POFastSwim",
    POSuperjump = "POSuperjump",
    PONoRagdoll = "PONoRagdoll",
    PONeverWanted = "PONeverWanted",
    POSetWanted = "POSetWanted",
    POClearBlood = "POClearBlood",
    POSetBlood = "POSetBlood",
    POIgnored = "POIgnored",
    POStayInVehicle = "POStayInVehicle",
    POMaxHealth = "POMaxHealth",
    POMaxArmor = "POMaxArmor",
    POCleanPlayer = "POCleanPlayer",
    PODryPlayer = "PODryPlayer",
    POWetPlayer = "POWetPlayer",
    POVehicleAutoPilotMenu = "POVehicleAutoPilotMenu",
    POFreeze = "POFreeze",
    POScenarios = "POScenarios",
    POUnlimitedStamina = "POUnlimitedStamina",

    VOMenu = "VOMenu",
    VOAll = "VOAll",
    VOGod = "VOGod",
    VOKeepClean = "VOKeepClean",
    VORepair = "VORepair",
    VOWash = "VOWash",
    VOEngine = "VOEngine",
    VODestroyEngine = "VODestroyEngine",
    VOBikeSeatbelt = "VOBikeSeatbelt",
    VOSpeedLimiter = "VOSpeedLimiter",
    VOChangePlate = "VOChangePlate",
    VOMod = "VOMod",
    VOColors = "VOColors",
    VOLiveries = "VOLiveries",
    VOComponents = "VOComponents",
    VODoors = "VODoors",
    VOWindows = "VOWindows",
    VOFreeze = "VOFreeze",
    VOInvisible = "VOInvisible",
    VOTorqueMultiplier = "VOTorqueMultiplier",
    VOPowerMultiplier = "VOPowerMultiplier",
    VOFlip = "VOFlip",
    VOAlarm = "VOAlarm",
    VOCycleSeats = "VOCycleSeats",
    VOEngineAlwaysOn = "VOEngineAlwaysOn",
    VONoSiren = "VONoSiren",
    VONoHelmet = "VONoHelmet",
    VOLights = "VOLights",
    VOFixOrDestroyTires = "VOFixOrDestroyTires",
    VODelete = "VODelete",
    VOUnderglow = "VOUnderglow",
    VOFlashHighbeamsOnHonk = "VOFlashHighbeamsOnHonk",
    VODisableTurbulence = "VODisableTurbulence",
    VOAnchorBoat = "VOAnchorBoat",
    VOInfiniteFuel = "VOInfiniteFuel",
    VOFlares = "VOFlares",
    VOPlaneBombs = "VOPlaneBombs",
    VOBypassExtraDamage = "VOBypassExtraDamage",

    VSMenu = "VSMenu",
    VSAll = "VSAll",
    VSDisableReplacePrevious = "VSDisableReplacePrevious",
    VSSpawnByName = "VSSpawnByName",
    VSAddon = "VSAddon",
    VSCompacts = "VSCompacts",
    VSSedans = "VSSedans",
    VSSUVs = "VSSUVs",
    VSCoupes = "VSCoupes",
    VSMuscle = "VSMuscle",
    VSSportsClassic = "VSSportsClassic",
    VSSports = "VSSports",
    VSSuper = "VSSuper",
    VSMotorcycles = "VSMotorcycles",
    VSOffRoad = "VSOffRoad",
    VSIndustrial = "VSIndustrial",
    VSUtility = "VSUtility",
    VSVans = "VSVans",
    VSCycles = "VSCycles",
    VSBoats = "VSBoats",
    VSHelicopters = "VSHelicopters",
    VSPlanes = "VSPlanes",
    VSService = "VSService",
    VSEmergency = "VSEmergency",
    VSMilitary = "VSMilitary",
    VSCommercial = "VSCommercial",
    VSTrains = "VSTrains",
    VSOpenWheel = "VSOpenWheel",

    SVMenu = "SVMenu",
    SVAll = "SVAll",
    SVSpawn = "SVSpawn",

    PVMenu = "PVMenu",
    PVAll = "PVAll",
    PVToggleEngine = "PVToggleEngine",
    PVToggleLights = "PVToggleLights",
    PVToggleStance = "PVToggleStance",
    PVKickPassengers = "PVKickPassengers",
    PVLockDoors = "PVLockDoors",
    PVDoors = "PVDoors",
    PVSoundHorn = "PVSoundHorn",
    PVToggleAlarm = "PVToggleAlarm",
    PVAddBlip = "PVAddBlip",
    PVExclusiveDriver = "PVExclusiveDriver",

    PAMenu = "PAMenu",
    PAAll = "PAAll",
    PACustomize = "PACustomize",
    PASpawnSaved = "PASpawnSaved",
    PASpawnNew = "PASpawnNew",
    PAAddonPeds = "PAAddonPeds",

    MPMenu = "MPMenu",
    MPAll = "MPAll",
    MPCustomize = "MPCustomize",
    MPSpawnSaved = "MPSpawnSaved",

    TOMenu = "TOMenu",
    TOAll = "TOAll",
    TOFreezeTime = "TOFreezeTime",
    TOSetTime = "TOSetTime",

    WOMenu = "WOMenu",
    WOAll = "WOAll",
    WODynamic = "WODynamic",
    WOBlackout = "WOBlackout",
    WOVehBlackout = "WOVehBlackout",
    WOSetWeather = "WOSetWeather",
    WORemoveClouds = "WORemoveClouds",
    WORandomizeClouds = "WORandomizeClouds",

    WPMenu = "WPMenu",
    WPAll = "WPAll",
    WPGetAll = "WPGetAll",
    WPRemoveAll = "WPRemoveAll",
    WPUnlimitedAmmo = "WPUnlimitedAmmo",
    WPNoReload = "WPNoReload",
    WPSpawn = "WPSpawn",
    WPSpawnByName = "WPSpawnByName",
    WPSetAllAmmo = "WPSetAllAmmo",

    WPAPPistol = "WPAPPistol",
    WPAdvancedRifle = "WPAdvancedRifle",
    WPAssaultRifle = "WPAssaultRifle",
    WPAssaultRifleMk2 = "WPAssaultRifleMk2",
    WPAssaultSMG = "WPAssaultSMG",
    WPAssaultShotgun = "WPAssaultShotgun",
    WPBZGas = "WPBZGas",
    WPBall = "WPBall",
    WPBat = "WPBat",
    WPBattleAxe = "WPBattleAxe",
    WPBottle = "WPBottle",
    WPBullpupRifle = "WPBullpupRifle",
    WPBullpupRifleMk2 = "WPBullpupRifleMk2",
    WPBullpupShotgun = "WPBullpupShotgun",
    WPCarbineRifle = "WPCarbineRifle",
    WPCarbineRifleMk2 = "WPCarbineRifleMk2",
    WPCombatMG = "WPCombatMG",
    WPCombatMGMk2 = "WPCombatMGMk2",
    WPCombatPDW = "WPCombatPDW",
    WPCombatPistol = "WPCombatPistol",
    WPCompactGrenadeLauncher = "WPCompactGrenadeLauncher",
    WPCompactRifle = "WPCompactRifle",
    WPCrowbar = "WPCrowbar",
    WPDagger = "WPDagger",
    WPDoubleAction = "WPDoubleAction",
    WPDoubleBarrelShotgun = "WPDoubleBarrelShotgun",
    WPFireExtinguisher = "WPFireExtinguisher",
    WPFirework = "WPFirework",
    WPFlare = "WPFlare",
    WPFlareGun = "WPFlareGun",
    WPFlashlight = "WPFlashlight",
    WPGolfClub = "WPGolfClub",
    WPGrenade = "WPGrenade",
    WPGrenadeLauncher = "WPGrenadeLauncher",
    WPGrenadeLauncherSmoke = "WPGrenadeLauncherSmoke",
    WPGusenberg = "WPGusenberg",
    WPHammer = "WPHammer",
    WPHatchet = "WPHatchet",
    WPHeavyPistol = "WPHeavyPistol",
    WPHeavyShotgun = "WPHeavyShotgun",
    WPHeavySniper = "WPHeavySniper",
    WPHeavySniperMk2 = "WPHeavySniperMk2",
    WPHomingLauncher = "WPHomingLauncher",
    WPKnife = "WPKnife",
    WPKnuckleDuster = "WPKnuckleDuster",
    WPMG = "WPMG",
    WPMachete = "WPMachete",
    WPMachinePistol = "WPMachinePistol",
    WPMarksmanPistol = "WPMarksmanPistol",
    WPMarksmanRifle = "WPMarksmanRifle",
    WPMarksmanRifleMk2 = "WPMarksmanRifleMk2",
    WPMicroSMG = "WPMicroSMG",
    WPMiniSMG = "WPMiniSMG",
    WPMinigun = "WPMinigun",
    WPMolotov = "WPMolotov",
    WPMusket = "WPMusket",
    WPNightVision = "WPNightVision",
    WPNightstick = "WPNightstick",
    WPParachute = "WPParachute",
    WPPetrolCan = "WPPetrolCan",
    WPPipeBomb = "WPPipeBomb",
    WPPistol = "WPPistol",
    WPPistol50 = "WPPistol50",
    WPPistolMk2 = "WPPistolMk2",
    WPPoolCue = "WPPoolCue",
    WPProximityMine = "WPProximityMine",
    WPPumpShotgun = "WPPumpShotgun",
    WPPumpShotgunMk2 = "WPPumpShotgunMk2",
    WPRPG = "WPRPG",
    WPRailgun = "WPRailgun",
    WPRevolver = "WPRevolver",
    WPRevolverMk2 = "WPRevolverMk2",
    WPSMG = "WPSMG",
    WPSMGMk2 = "WPSMGMk2",
    WPSNSPistol = "WPSNSPistol",
    WPSNSPistolMk2 = "WPSNSPistolMk2",
    WPSawnOffShotgun = "WPSawnOffShotgun",
    WPSmokeGrenade = "WPSmokeGrenade",
    WPSniperRifle = "WPSniperRifle",
    WPSnowball = "WPSnowball",
    WPSpecialCarbine = "WPSpecialCarbine",
    WPSpecialCarbineMk2 = "WPSpecialCarbineMk2",
    WPStickyBomb = "WPStickyBomb",
    WPStunGun = "WPStunGun",
    WPSweeperShotgun = "WPSweeperShotgun",
    WPSwitchBlade = "WPSwitchBlade",
    WPUnarmed = "WPUnarmed",
    WPVintagePistol = "WPVintagePistol",
    WPWrench = "WPWrench",
    WPPlasmaPistol = "WPPlasmaPistol",
    WPPlasmaCarbine = "WPPlasmaCarbine",
    WPPlasmaMinigun = "WPPlasmaMinigun",
    WPStoneHatchet = "WPStoneHatchet",
    WPCeramicPistol = "WPCeramicPistol",
    WPNavyRevolver = "WPNavyRevolver",
    WPHazardCan = "WPHazardCan",
    WPPericoPistol = "WPPericoPistol",
    WPMilitaryRifle = "WPMilitaryRifle",
    WPCombatShotgun = "WPCombatShotgun",
    WPEMPLauncher = "WPEMPLauncher",
    WPHeavyRifle = "WPHeavyRifle",
    WPFertilizerCan = "WPFertilizerCan",
    WPStunGunMP = "WPStunGunMP",
    WPPrecisionRifle = "WPPrecisionRifle",
    WPTacticalRifle = "WPTacticalRifle",
    WPPistolXM3 = "WPPistolXM3",
    WPCandyCane = "WPCandyCane",
    WPRailgunXM3 = "WPRailgunXM3",
    WPAcidPackage = "WPAcidPackage",
    WPTecPistol = "WPTecPistol",
    WPBattleRifle = "WPBattleRifle",
    WPSnowLauncher = "WPSnowLauncher",
    WPHackingDevice = "WPHackingDevice",
    WPStunRod = "WPStunRod",

    WLMenu = "WLMenu",
    WLAll = "WLAll",
    WLEquip = "WLEquip",
    WLEquipOnRespawn = "WLEquipOnRespawn",

    MSAll = "MSAll",
    MSClearArea = "MSClearArea",
    MSTeleportToWp = "MSTeleportToWp",
    MSTeleportToCoord = "MSTeleportToCoord",
    MSShowCoordinates = "MSShowCoordinates",
    MSShowLocation = "MSShowLocation",
    MSJoinQuitNotifs = "MSJoinQuitNotifs",
    MSDeathNotifs = "MSDeathNotifs",
    MSNightVision = "MSNightVision",
    MSThermalVision = "MSThermalVision",
    MSLocationBlips = "MSLocationBlips",
    MSPlayerBlips = "MSPlayerBlips",
    MSOverheadNames = "MSOverheadNames",
    MSTeleportLocations = "MSTeleportLocations",
    MSTeleportSaveLocation = "MSTeleportSaveLocation",
    MSConnectionMenu = "MSConnectionMenu",
    MSRestoreAppearance = "MSRestoreAppearance",
    MSRestoreWeapons = "MSRestoreWeapons",
    MSDriftMode = "MSDriftMode",
    MSEntitySpawner = "MSEntitySpawner",
    MSDevTools = "MSDevTools",

    VCMenu = "VCMenu",
    VCAll = "VCAll",
    VCEnable = "VCEnable",
    VCShowSpeaker = "VCShowSpeaker",
    VCStaffChannel = "VCStaffChannel",
}

PermissionsManager.Permissions = {}
PermissionsManager.ArePermissionsSetup = false

local noInheritPermissions = {
    [PermissionsManager.Permission.MSOverheadNames] = true,
    [PermissionsManager.Permission.MSPlayerBlips] = true,
    [PermissionsManager.Permission.MSLocationBlips] = true,
    [PermissionsManager.Permission.MSDevTools] = true,
}

local allowedPerms = {}
local parentPermissions = {}

function PermissionsManager.GetPermissionAndParentPermissions(permission)
    if parentPermissions[permission] then
        return parentPermissions[permission]
    end

    local list = { PermissionsManager.Permission.Everything, permission }
    local permStr = permission

    if not permStr or type(permStr) ~= "string" then
        return { PermissionsManager.Permission.Everything }
    end

    if permStr:sub(1, 2):upper() == permStr:sub(1, 2) and not noInheritPermissions[permission] then
        local suffix = permStr:sub(3)
        if suffix ~= "All" and suffix ~= "Menu" then
            local parentPerm = permStr:sub(1, 2) .. "All"
            if PermissionsManager.Permission[parentPerm] then
                table.insert(list, PermissionsManager.Permission[parentPerm])
            end
        end
    end

    parentPermissions[permission] = list
    return list
end

if not IsDuplicityVersion() then

    function PermissionsManager.IsAllowed(permission, checkAnyway)
        checkAnyway = checkAnyway or false

        if not PermissionsManager.ArePermissionsSetup and not checkAnyway then
            return false
        end

        local staffPermissionAllowed = (
            PermissionsManager.Permissions[PermissionsManager.Permission.Staff] == true
        ) or (
            PermissionsManager.Permissions[PermissionsManager.Permission.Everything] == true
        )

        if ConfigManager and ConfigManager.GetSettingsBool and
            ConfigManager.GetSettingsBool(ConfigManager.Setting.vmenu_menu_staff_only) and
            not staffPermissionAllowed then
            return false
        end

        if allowedPerms[permission] ~= nil then
            return allowedPerms[permission]
        end

        local permissionsToCheck = PermissionsManager.GetPermissionAndParentPermissions(permission)

        for _, perm in ipairs(permissionsToCheck) do
            if PermissionsManager.Permissions[perm] == true then
                allowedPerms[permission] = true
                return true
            end
        end

        allowedPerms[permission] = false
        return false
    end

    function PermissionsManager.SetPermissions(permissions)
        PermissionsManager.Permissions = permissions
        PermissionsManager.ArePermissionsSetup = true

        allowedPerms = {}

    end

    RegisterNetEvent("vMenu:SetPermissions", function(permissionsJson)

        local success, permissions = pcall(function()
            return json.decode(permissionsJson)
        end)

        if not success then
            return
        end

        PermissionsManager.SetPermissions(permissions)
    end)
end

if IsDuplicityVersion() then
    local ACE_CATEGORIES = {
        OP = "OnlinePlayers",
        PO = "PlayerOptions",
        VO = "VehicleOptions",
        VS = "VehicleSpawner",
        SV = "SavedVehicles",
        PV = "PersonalVehicle",
        PA = "PlayerAppearance",
        MP = "MpPedCustomization",
        TO = "TimeOptions",
        WO = "WeatherOptions",
        WP = "WeaponOptions",
        WL = "WeaponLoadouts",
        MS = "MiscSettings",
        VC = "VoiceChat",
    }

    local ACE_ALIASES = {
        MP = "MPPedCustomization",
    }

    local function GetAceName(permission, alias)
        local prefix = permission:sub(1, 2)
        local category = alias and ACE_ALIASES[prefix] or ACE_CATEGORIES[prefix]
        if category then
            return "vMenu." .. category .. "." .. permission:sub(3)
        end
        return "vMenu." .. permission
    end

    local permissionAces = nil
    local function GetPermissionAces(permission)
        if not permissionAces then
            permissionAces = {}
            for _, perm in pairs(PermissionsManager.Permission) do
                local entry = { ace = GetAceName(perm) }
                local suffix = perm:sub(3)
                local hasAlias = ACE_ALIASES[perm:sub(1, 2)] ~= nil
                if hasAlias then entry.alias = GetAceName(perm, true) end
                if #perm > 2 and suffix ~= "All" and suffix ~= "Menu" and not noInheritPermissions[perm] then
                    entry.parent = GetAceName(perm:sub(1, 2) .. "All")
                    if hasAlias then entry.aliasParent = GetAceName(perm:sub(1, 2) .. "All", true) end
                end
                permissionAces[perm] = entry
            end
        end
        return permissionAces[permission]
    end

    function PermissionsManager.IsAllowed(permission, source)
        if type(permission) ~= "string" or source == nil or source == "" then
            return false
        end
        source = tostring(source)

        if IsPlayerAceAllowed(source, "vMenu.Everything") then
            return true
        end

        local entry = GetPermissionAces(permission)
        if not entry then
            return IsPlayerAceAllowed(source, GetAceName(permission))
        end
        return IsPlayerAceAllowed(source, entry.ace) or
            (entry.parent ~= nil and IsPlayerAceAllowed(source, entry.parent)) or
            (entry.alias ~= nil and IsPlayerAceAllowed(source, entry.alias)) or
            (entry.aliasParent ~= nil and IsPlayerAceAllowed(source, entry.aliasParent))
    end

    local function ComputePermissions(source)
        local perms = {}
        if IsPlayerAceAllowed(source, "vMenu.Everything") then
            for _, permission in pairs(PermissionsManager.Permission) do
                perms[permission] = true
            end
            return perms
        end

        local results = {}
        local function Ace(name)
            local allowed = results[name]
            if allowed == nil then
                allowed = IsPlayerAceAllowed(source, name)
                results[name] = allowed
            end
            return allowed
        end

        for _, permission in pairs(PermissionsManager.Permission) do
            local entry = GetPermissionAces(permission)
            if (entry.parent and Ace(entry.parent)) or Ace(entry.ace)
                or (entry.alias and Ace(entry.alias)) or (entry.aliasParent and Ace(entry.aliasParent)) then
                perms[permission] = true
            end
        end
        return perms
    end

    local publicPermissions = nil
    local function GetPublicPermissions()
        if publicPermissions then return publicPermissions end
        local P = PermissionsManager.Permission
        local excluded = {
            [P.Everything] = true, [P.OPAll] = true, [P.OPKick] = true, [P.OPKill] = true,
            [P.OPPermBan] = true, [P.OPTempBan] = true, [P.OPUnban] = true, [P.OPIdentifiers] = true,
            [P.OPViewBannedPlayers] = true, [P.MSOverheadNames] = true, [P.MSPlayerBlips] = true,
            [P.MSLocationBlips] = true, [P.MSDevTools] = true,
        }
        publicPermissions = {}
        for _, permission in pairs(P) do
            if not excluded[permission] then
                publicPermissions[permission] = true
            end
        end
        return publicPermissions
    end

    local SEND_COOLDOWN = 2000
    local lastSent = {}

    function PermissionsManager.SetPermissionsForPlayer(source, force)
        local src = tonumber(source)
        if not src or not GetPlayerName(src) then return end

        local now = GetGameTimer()
        if not force and lastSent[src] and now - lastSent[src] < SEND_COOLDOWN then
            return
        end
        lastSent[src] = now

        local perms
        if ConfigManager.GetSettingsBool(ConfigManager.Setting.vmenu_use_permissions) then
            perms = ComputePermissions(tostring(src))
        else
            perms = GetPublicPermissions()
        end

        TriggerClientEvent("vMenu:SetPermissions", src, json.encode(perms))

        TriggerClientEvent("vMenu:SetConfigOptions", src)

        if ConfigManager and ConfigManager.GetTeleportLocationsData then
            TriggerClientEvent("vMenu:UpdateTeleportLocations", src,
                json.encode(ConfigManager.GetTeleportLocationsData()))
        end
    end

    RegisterNetEvent("vMenu:RequestPermissions", function()
        PermissionsManager.SetPermissionsForPlayer(source)
    end)

    AddEventHandler("playerDropped", function()
        lastSent[tonumber(source)] = nil
    end)

    exports("RefreshPlayerPermissions", function(source)
        source = tonumber(source)
        if not source or not GetPlayerName(source) then return false end
        PermissionsManager.SetPermissionsForPlayer(source, true)
        return true
    end)
end

ClientAuth = {}

ClientAuth.Authorized = false
ClientAuth.AuthToken = nil
ClientAuth.AuthTimeout = 30000

if IsDuplicityVersion() then
    ClientAuth.PendingAuthorizations = {}
    ClientAuth.AuthorizedPlayers = {}

    function ClientAuth.GenerateToken()
        local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
        local token = ""
        math.randomseed(GetGameTimer() + math.random(1, 99999))
        for i = 1, 64 do
            local randIndex = math.random(1, #chars)
            token = token .. chars:sub(randIndex, randIndex)
        end
        return token
    end

    function ClientAuth.CreatePendingAuth(playerId)
        local token = ClientAuth.GenerateToken()
        ClientAuth.PendingAuthorizations[tostring(playerId)] = {
            token = token,
            timestamp = GetGameTimer(),
            validated = false
        }
        return token
    end

    function ClientAuth.ValidateToken(playerId, token)
        local playerIdStr = tostring(playerId)
        local pending = ClientAuth.PendingAuthorizations[playerIdStr]

        if not pending then
            return false, "No pending authorization found"
        end

        if GetGameTimer() - pending.timestamp > ClientAuth.AuthTimeout then
            ClientAuth.PendingAuthorizations[playerIdStr] = nil
            return false, "Authorization expired"
        end

        if pending.token ~= token then
            return false, "Invalid token"
        end

        pending.validated = true
        ClientAuth.AuthorizedPlayers[playerIdStr] = true
        ClientAuth.PendingAuthorizations[playerIdStr] = nil

        return true, "Authorization successful"
    end

    function ClientAuth.IsPlayerAuthorized(playerId)
        return ClientAuth.AuthorizedPlayers[tostring(playerId)] == true
    end

    function ClientAuth.RemovePlayerAuth(playerId)
        local playerIdStr = tostring(playerId)
        ClientAuth.AuthorizedPlayers[playerIdStr] = nil
        ClientAuth.PendingAuthorizations[playerIdStr] = nil
    end

    RegisterNetEvent("vMenu:RequestClientAuth", function()
        local source = source
        local token = ClientAuth.CreatePendingAuth(source)
        TriggerClientEvent("vMenu:ClientAuthGranted", source, token)
    end)

    RegisterNetEvent("vMenu:ConfirmClientAuth", function(token)
        local source = source
        local success, message = ClientAuth.ValidateToken(source, token)

        if success then
            TriggerClientEvent("vMenu:ClientAuthConfirmed", source, true)
        else
            TriggerClientEvent("vMenu:ClientAuthConfirmed", source, false, message)
        end
    end)

    AddEventHandler("playerDropped", function(reason)
        local source = source
        ClientAuth.RemovePlayerAuth(source)
    end)

else
    ClientAuth.AuthorizationAttempted = false
    ClientAuth.AuthorizationPending = false

    function ClientAuth.RequestAuthorization()
        if ClientAuth.AuthorizationAttempted then
            return false
        end

        ClientAuth.AuthorizationAttempted = true
        ClientAuth.AuthorizationPending = true
        TriggerServerEvent("vMenu:RequestClientAuth")

        return true
    end

    function ClientAuth.IsAuthorized()
        return ClientAuth.Authorized == true and ClientAuth.AuthToken ~= nil
    end

    RegisterNetEvent("vMenu:ClientAuthGranted", function(token)
        if not token or token == "" then
            ClientAuth.AuthorizationPending = false
            return
        end

        ClientAuth.AuthToken = token
        TriggerServerEvent("vMenu:ConfirmClientAuth", token)
    end)

    RegisterNetEvent("vMenu:ClientAuthConfirmed", function(success, message)
        ClientAuth.AuthorizationPending = false

        if success then
            ClientAuth.Authorized = true
        else
            ClientAuth.Authorized = false
            ClientAuth.AuthToken = nil
        end
    end)

    function ClientAuth.WaitForAuthorization(timeout)
        timeout = timeout or ClientAuth.AuthTimeout
        local startTime = GetGameTimer()

        while ClientAuth.AuthorizationPending do
            Wait(100)

            if GetGameTimer() - startTime > timeout then
                ClientAuth.AuthorizationPending = false
                return false
            end
        end

        return ClientAuth.Authorized
    end

end

return PermissionsManager
