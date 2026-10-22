WeaponOptionsMenu = {}

local menu = nil

WeaponOptionsMenu.UnlimitedAmmo = false
WeaponOptionsMenu.NoReload = false
WeaponOptionsMenu.UnlimitedParachutes = false
WeaponOptionsMenu.AutoEquipChute = false

local handgunsMenu = nil
local riflesMenu = nil
local shotgunsMenu = nil
local smgsMenu = nil
local throwablesMenu = nil
local meleeMenu = nil
local heavyMenu = nil
local snipersMenu = nil
local parachuteMenu = nil

local weaponTints = {
    "Normal",
    "Green",
    "Gold",
    "Pink",
    "Army",
    "LSPD",
    "Orange",
    "Platinum"
}

local weaponTintsMk2 = {
    "Classic Black",
    "Classic Gray",
    "Classic Two-Tone",
    "Classic White",
    "Classic Beige",
    "Classic Green",
    "Classic Blue",
    "Classic Earth",
    "Classic Brown & Black",
    "Red Contrast",
    "Blue Contrast",
    "Yellow Contrast",
    "Orange Contrast",
    "Bold Pink",
    "Bold Purple & Yellow",
    "Bold Orange",
    "Bold Green & Purple",
    "Bold Red Features",
    "Bold Green Features",
    "Bold Cyan Features",
    "Bold Yellow Features",
    "Bold Red & White",
    "Bold Blue & White",
    "Metallic Gold",
    "Metallic Platinum",
    "Metallic Gray & Lilac",
    "Metallic Purple & Lime",
    "Metallic Red",
    "Metallic Green",
    "Metallic Blue",
    "Metallic White & Aqua",
    "Metallic Red & Yellow"
}

local weaponCategories = {
    {
        name = "Handguns",
        weapons = {
            { name = "WEAPON_PISTOL",         label = "Pistol" },
            { name = "WEAPON_COMBATPISTOL",   label = "Combat Pistol" },
            { name = "WEAPON_APPISTOL",       label = "AP Pistol" },
            { name = "WEAPON_PISTOL50",       label = "Pistol .50" },
            { name = "WEAPON_SNSPISTOL",      label = "SNS Pistol" },
            { name = "WEAPON_HEAVYPISTOL",    label = "Heavy Pistol" },
            { name = "WEAPON_VINTAGEPISTOL",  label = "Vintage Pistol" },
            { name = "WEAPON_MARKSMANPISTOL", label = "Marksman Pistol" },
            { name = "WEAPON_REVOLVER",       label = "Heavy Revolver" },
            { name = "WEAPON_DOUBLEACTION",   label = "Double Action Revolver" },
            { name = "WEAPON_PISTOL_MK2",     label = "Pistol Mk II" },
            { name = "WEAPON_SNSPISTOL_MK2",  label = "SNS Pistol Mk II" },
            { name = "WEAPON_REVOLVER_MK2",   label = "Heavy Revolver Mk II" },
            { name = "WEAPON_CERAMICPISTOL",  label = "Ceramic Pistol" },
            { name = "WEAPON_NAVYREVOLVER",   label = "Navy Revolver" },
            { name = "WEAPON_GADGETPISTOL",   label = "Perico Pistol" },
            { name = "WEAPON_STUNGUN",        label = "Stun Gun" },
            { name = "WEAPON_FLAREGUN",       label = "Flare Gun" },
            { name = "WEAPON_RAYPISTOL",      label = "Up-n-Atomizer" },
        }
    },
    {
        name = "Assault Rifles",
        weapons = {
            { name = "WEAPON_ASSAULTRIFLE",       label = "Assault Rifle" },
            { name = "WEAPON_CARBINERIFLE",       label = "Carbine Rifle" },
            { name = "WEAPON_ADVANCEDRIFLE",      label = "Advanced Rifle" },
            { name = "WEAPON_SPECIALCARBINE",     label = "Special Carbine" },
            { name = "WEAPON_BULLPUPRIFLE",       label = "Bullpup Rifle" },
            { name = "WEAPON_COMPACTRIFLE",       label = "Compact Rifle" },
            { name = "WEAPON_ASSAULTRIFLE_MK2",   label = "Assault Rifle Mk II" },
            { name = "WEAPON_CARBINERIFLE_MK2",   label = "Carbine Rifle Mk II" },
            { name = "WEAPON_SPECIALCARBINE_MK2", label = "Special Carbine Mk II" },
            { name = "WEAPON_BULLPUPRIFLE_MK2",   label = "Bullpup Rifle Mk II" },
            { name = "WEAPON_MILITARYRIFLE",      label = "Military Rifle" },
            { name = "WEAPON_HEAVYRIFLE",         label = "Heavy Rifle" },
            { name = "WEAPON_TACTICALRIFLE",      label = "Service Carbine" },
        }
    },
    {
        name = "Shotguns",
        weapons = {
            { name = "WEAPON_PUMPSHOTGUN",     label = "Pump Shotgun" },
            { name = "WEAPON_SAWNOFFSHOTGUN",  label = "Sawed-Off Shotgun" },
            { name = "WEAPON_ASSAULTSHOTGUN",  label = "Assault Shotgun" },
            { name = "WEAPON_BULLPUPSHOTGUN",  label = "Bullpup Shotgun" },
            { name = "WEAPON_MUSKET",          label = "Musket" },
            { name = "WEAPON_HEAVYSHOTGUN",    label = "Heavy Shotgun" },
            { name = "WEAPON_DBSHOTGUN",       label = "Double Barrel Shotgun" },
            { name = "WEAPON_AUTOSHOTGUN",     label = "Sweeper Shotgun" },
            { name = "WEAPON_PUMPSHOTGUN_MK2", label = "Pump Shotgun Mk II" },
            { name = "WEAPON_COMBATSHOTGUN",   label = "Combat Shotgun" },
        }
    },
    {
        name = "Sub-/Light Machine Guns",
        weapons = {
            { name = "WEAPON_MICROSMG",      label = "Micro SMG" },
            { name = "WEAPON_SMG",           label = "SMG" },
            { name = "WEAPON_ASSAULTSMG",    label = "Assault SMG" },
            { name = "WEAPON_COMBATPDW",     label = "Combat PDW" },
            { name = "WEAPON_MACHINEPISTOL", label = "Machine Pistol" },
            { name = "WEAPON_MINISMG",       label = "Mini SMG" },
            { name = "WEAPON_SMG_MK2",       label = "SMG Mk II" },
            { name = "WEAPON_MG",            label = "MG" },
            { name = "WEAPON_COMBATMG",      label = "Combat MG" },
            { name = "WEAPON_COMBATMG_MK2",  label = "Combat MG Mk II" },
            { name = "WEAPON_GUSENBERG",     label = "Gusenberg Sweeper" },
            { name = "WEAPON_RAYCARBINE",    label = "Unholy Hellbringer" },
        }
    },
    {
        name = "Sniper Rifles",
        weapons = {
            { name = "WEAPON_SNIPERRIFLE",       label = "Sniper Rifle" },
            { name = "WEAPON_HEAVYSNIPER",       label = "Heavy Sniper" },
            { name = "WEAPON_MARKSMANRIFLE",     label = "Marksman Rifle" },
            { name = "WEAPON_HEAVYSNIPER_MK2",   label = "Heavy Sniper Mk II" },
            { name = "WEAPON_MARKSMANRIFLE_MK2", label = "Marksman Rifle Mk II" },
            { name = "WEAPON_PRECISIONRIFLE",    label = "Precision Rifle" },
        }
    },
    {
        name = "Heavy Weapons",
        weapons = {
            { name = "WEAPON_RPG",                   label = "RPG" },
            { name = "WEAPON_GRENADELAUNCHER",       label = "Grenade Launcher" },
            { name = "WEAPON_GRENADELAUNCHER_SMOKE", label = "Smoke Grenade Launcher" },
            { name = "WEAPON_MINIGUN",               label = "Minigun" },
            { name = "WEAPON_FIREWORK",              label = "Firework Launcher" },
            { name = "WEAPON_RAILGUN",               label = "Railgun" },
            { name = "WEAPON_HOMINGLAUNCHER",        label = "Homing Launcher" },
            { name = "WEAPON_COMPACTLAUNCHER",       label = "Compact Grenade Launcher" },
            { name = "WEAPON_RAYMINIGUN",            label = "Widowmaker" },
            { name = "WEAPON_EMPLAUNCHER",           label = "Compact EMP Launcher" },
        }
    },
    {
        name = "Throwables",
        weapons = {
            { name = "WEAPON_GRENADE",      label = "Grenade" },
            { name = "WEAPON_STICKYBOMB",   label = "Sticky Bomb" },
            { name = "WEAPON_PROXMINE",     label = "Proximity Mine" },
            { name = "WEAPON_BZGAS",        label = "BZ Gas" },
            { name = "WEAPON_MOLOTOV",      label = "Molotov Cocktail" },
            { name = "WEAPON_SMOKEGRENADE", label = "Tear Gas" },
            { name = "WEAPON_PIPEBOMB",     label = "Pipe Bomb" },
            { name = "WEAPON_FLARE",        label = "Flare" },
            { name = "WEAPON_BALL",         label = "Baseball" },
            { name = "WEAPON_SNOWBALL",     label = "Snowball" },
        }
    },
    {
        name = "Melee",
        weapons = {
            { name = "WEAPON_KNIFE",         label = "Knife" },
            { name = "WEAPON_NIGHTSTICK",    label = "Nightstick" },
            { name = "WEAPON_HAMMER",        label = "Hammer" },
            { name = "WEAPON_BAT",           label = "Baseball Bat" },
            { name = "WEAPON_CROWBAR",       label = "Crowbar" },
            { name = "WEAPON_GOLFCLUB",      label = "Golf Club" },
            { name = "WEAPON_BOTTLE",        label = "Broken Bottle" },
            { name = "WEAPON_DAGGER",        label = "Antique Cavalry Dagger" },
            { name = "WEAPON_HATCHET",       label = "Hatchet" },
            { name = "WEAPON_KNUCKLE",       label = "Knuckle Dusters" },
            { name = "WEAPON_MACHETE",       label = "Machete" },
            { name = "WEAPON_FLASHLIGHT",    label = "Flashlight" },
            { name = "WEAPON_SWITCHBLADE",   label = "Switchblade" },
            { name = "WEAPON_POOLCUE",       label = "Pool Cue" },
            { name = "WEAPON_WRENCH",        label = "Pipe Wrench" },
            { name = "WEAPON_BATTLEAXE",     label = "Battle Axe" },
            { name = "WEAPON_STONE_HATCHET", label = "Stone Hatchet" },
        }
    }
}

local weaponPermMap = {
    WEAPON_PISTOL = "WPPistol", WEAPON_COMBATPISTOL = "WPCombatPistol",
    WEAPON_APPISTOL = "WPAPPistol", WEAPON_PISTOL50 = "WPPistol50",
    WEAPON_SNSPISTOL = "WPSNSPistol", WEAPON_HEAVYPISTOL = "WPHeavyPistol",
    WEAPON_VINTAGEPISTOL = "WPVintagePistol", WEAPON_MARKSMANPISTOL = "WPMarksmanPistol",
    WEAPON_REVOLVER = "WPRevolver", WEAPON_DOUBLEACTION = "WPDoubleAction",
    WEAPON_PISTOL_MK2 = "WPPistolMk2", WEAPON_SNSPISTOL_MK2 = "WPSNSPistolMk2",
    WEAPON_REVOLVER_MK2 = "WPRevolverMk2", WEAPON_CERAMICPISTOL = "WPCeramicPistol",
    WEAPON_NAVYREVOLVER = "WPNavyRevolver", WEAPON_GADGETPISTOL = "WPPericoPistol",
    WEAPON_STUNGUN = "WPStunGun", WEAPON_FLAREGUN = "WPFlareGun",
    WEAPON_RAYPISTOL = "WPPlasmaPistol",

    WEAPON_ASSAULTRIFLE = "WPAssaultRifle", WEAPON_CARBINERIFLE = "WPCarbineRifle",
    WEAPON_ADVANCEDRIFLE = "WPAdvancedRifle", WEAPON_SPECIALCARBINE = "WPSpecialCarbine",
    WEAPON_BULLPUPRIFLE = "WPBullpupRifle", WEAPON_COMPACTRIFLE = "WPCompactRifle",
    WEAPON_ASSAULTRIFLE_MK2 = "WPAssaultRifleMk2", WEAPON_CARBINERIFLE_MK2 = "WPCarbineRifleMk2",
    WEAPON_SPECIALCARBINE_MK2 = "WPSpecialCarbineMk2", WEAPON_BULLPUPRIFLE_MK2 = "WPBullpupRifleMk2",
    WEAPON_MILITARYRIFLE = "WPMilitaryRifle", WEAPON_HEAVYRIFLE = "WPHeavyRifle",
    WEAPON_TACTICALRIFLE = "WPTacticalRifle",

    WEAPON_PUMPSHOTGUN = "WPPumpShotgun", WEAPON_SAWNOFFSHOTGUN = "WPSawnOffShotgun",
    WEAPON_ASSAULTSHOTGUN = "WPAssaultShotgun", WEAPON_BULLPUPSHOTGUN = "WPBullpupShotgun",
    WEAPON_MUSKET = "WPMusket", WEAPON_HEAVYSHOTGUN = "WPHeavyShotgun",
    WEAPON_DBSHOTGUN = "WPDoubleBarrelShotgun", WEAPON_AUTOSHOTGUN = "WPSweeperShotgun",
    WEAPON_PUMPSHOTGUN_MK2 = "WPPumpShotgunMk2", WEAPON_COMBATSHOTGUN = "WPCombatShotgun",

    WEAPON_MICROSMG = "WPMicroSMG", WEAPON_SMG = "WPSMG",
    WEAPON_ASSAULTSMG = "WPAssaultSMG", WEAPON_COMBATPDW = "WPCombatPDW",
    WEAPON_MACHINEPISTOL = "WPMachinePistol", WEAPON_MINISMG = "WPMiniSMG",
    WEAPON_SMG_MK2 = "WPSMGMk2", WEAPON_MG = "WPMG",
    WEAPON_COMBATMG = "WPCombatMG", WEAPON_COMBATMG_MK2 = "WPCombatMGMk2",
    WEAPON_GUSENBERG = "WPGusenberg", WEAPON_RAYCARBINE = "WPPlasmaCarbine",

    WEAPON_SNIPERRIFLE = "WPSniperRifle", WEAPON_HEAVYSNIPER = "WPHeavySniper",
    WEAPON_MARKSMANRIFLE = "WPMarksmanRifle", WEAPON_HEAVYSNIPER_MK2 = "WPHeavySniperMk2",
    WEAPON_MARKSMANRIFLE_MK2 = "WPMarksmanRifleMk2", WEAPON_PRECISIONRIFLE = "WPPrecisionRifle",

    WEAPON_RPG = "WPRPG", WEAPON_GRENADELAUNCHER = "WPGrenadeLauncher",
    WEAPON_GRENADELAUNCHER_SMOKE = "WPGrenadeLauncherSmoke", WEAPON_MINIGUN = "WPMinigun",
    WEAPON_FIREWORK = "WPFirework", WEAPON_RAILGUN = "WPRailgun",
    WEAPON_HOMINGLAUNCHER = "WPHomingLauncher", WEAPON_COMPACTLAUNCHER = "WPCompactGrenadeLauncher",
    WEAPON_RAYMINIGUN = "WPPlasmaMinigun", WEAPON_EMPLAUNCHER = "WPEMPLauncher",

    WEAPON_GRENADE = "WPGrenade", WEAPON_STICKYBOMB = "WPStickyBomb",
    WEAPON_PROXMINE = "WPProximityMine", WEAPON_BZGAS = "WPBZGas",
    WEAPON_MOLOTOV = "WPMolotov", WEAPON_SMOKEGRENADE = "WPSmokeGrenade",
    WEAPON_PIPEBOMB = "WPPipeBomb", WEAPON_FLARE = "WPFlare",
    WEAPON_BALL = "WPBall", WEAPON_SNOWBALL = "WPSnowball",

    WEAPON_KNIFE = "WPKnife", WEAPON_NIGHTSTICK = "WPNightstick",
    WEAPON_HAMMER = "WPHammer", WEAPON_BAT = "WPBat",
    WEAPON_CROWBAR = "WPCrowbar", WEAPON_GOLFCLUB = "WPGolfClub",
    WEAPON_BOTTLE = "WPBottle", WEAPON_DAGGER = "WPDagger",
    WEAPON_HATCHET = "WPHatchet", WEAPON_KNUCKLE = "WPKnuckleDuster",
    WEAPON_MACHETE = "WPMachete", WEAPON_FLASHLIGHT = "WPFlashlight",
    WEAPON_SWITCHBLADE = "WPSwitchBlade", WEAPON_POOLCUE = "WPPoolCue",
    WEAPON_WRENCH = "WPWrench", WEAPON_BATTLEAXE = "WPBattleAxe",
    WEAPON_STONE_HATCHET = "WPStoneHatchet",
}

local function IsWeaponAllowed(weaponName)
    local permKey = weaponPermMap[weaponName] or "WPSpawn"
    local perm = PermissionsManager.Permission[permKey]
    if not perm then return false end
    return PermissionsManager.IsAllowed(perm)
end

local parachuteTints = {
    GetLabelText("PM_TINT0"),
    GetLabelText("PM_TINT1"),
    GetLabelText("PM_TINT2"),
    GetLabelText("PM_TINT3"),
    GetLabelText("PM_TINT4"),
    GetLabelText("PM_TINT5"),
    GetLabelText("PM_TINT6"),
    GetLabelText("PM_TINT7"),
}

local smokeColors = {
    { name = "White",  r = 255, g = 255, b = 255 },
    { name = "Red",    r = 255, g = 0,   b = 0 },
    { name = "Orange", r = 255, g = 165, b = 0 },
    { name = "Yellow", r = 255, g = 255, b = 0 },
    { name = "Blue",   r = 0,   g = 0,   b = 255 },
    { name = "Black",  r = 20,  g = 20,  b = 20 },
}

local weaponComponentMap = {
    ["WEAPON_PISTOL"] = {
        { hash = "COMPONENT_PISTOL_CLIP_02",   label = "Extended Clip" },
        { hash = "COMPONENT_AT_PI_FLSH",        label = "Flashlight" },
        { hash = "COMPONENT_AT_PI_SUPP_02",     label = "Suppressor" },
        { hash = "COMPONENT_AT_PI_RAIL",        label = "Laser Sight" },
    },
    ["WEAPON_COMBATPISTOL"] = {
        { hash = "COMPONENT_COMBATPISTOL_CLIP_02", label = "Extended Clip" },
        { hash = "COMPONENT_AT_PI_FLSH",            label = "Flashlight" },
        { hash = "COMPONENT_AT_PI_SUPP",            label = "Suppressor" },
    },
    ["WEAPON_APPISTOL"] = {
        { hash = "COMPONENT_APPISTOL_CLIP_02", label = "Extended Clip" },
        { hash = "COMPONENT_AT_PI_FLSH",        label = "Flashlight" },
        { hash = "COMPONENT_AT_PI_SUPP",        label = "Suppressor" },
    },
    ["WEAPON_PISTOL50"] = {
        { hash = "COMPONENT_PISTOL50_CLIP_02", label = "Extended Clip" },
        { hash = "COMPONENT_AT_PI_FLSH",        label = "Flashlight" },
        { hash = "COMPONENT_AT_PI_SUPP_02",     label = "Suppressor" },
    },
    ["WEAPON_SNSPISTOL"] = {
        { hash = "COMPONENT_SNSPISTOL_CLIP_02", label = "Extended Clip" },
    },
    ["WEAPON_HEAVYPISTOL"] = {
        { hash = "COMPONENT_HEAVYPISTOL_CLIP_02", label = "Extended Clip" },
        { hash = "COMPONENT_AT_PI_FLSH",           label = "Flashlight" },
        { hash = "COMPONENT_AT_PI_SUPP",           label = "Suppressor" },
    },
    ["WEAPON_VINTAGEPISTOL"] = {
        { hash = "COMPONENT_VINTAGEPISTOL_CLIP_02", label = "Extended Clip" },
        { hash = "COMPONENT_AT_PI_FLSH",             label = "Flashlight" },
        { hash = "COMPONENT_AT_PI_SUPP",             label = "Suppressor" },
    },
    ["WEAPON_MARKSMANPISTOL"] = {
        { hash = "COMPONENT_MARKSMANPISTOL_CLIP_02", label = "Extended Clip" },
    },
    ["WEAPON_PISTOL_MK2"] = {
        { hash = "COMPONENT_PISTOL_MK2_CLIP_02",   label = "Extended Clip" },
        { hash = "COMPONENT_PISTOL_MK2_CLIP_FMJ",  label = "FMJ Rounds" },
        { hash = "COMPONENT_AT_PI_FLSH_02",         label = "Flashlight" },
        { hash = "COMPONENT_PISTOL_MK2_SCOPE_01",  label = "Holographic Sight" },
        { hash = "COMPONENT_AT_PI_SUPP_02",         label = "Suppressor" },
        { hash = "COMPONENT_PISTOL_MK2_BARREL_01", label = "Default Barrel" },
        { hash = "COMPONENT_PISTOL_MK2_BARREL_02", label = "Heavy Barrel" },
        { hash = "COMPONENT_PISTOL_MK2_SLIDE",     label = "Slide" },
        { hash = "COMPONENT_PISTOL_MK2_MUZZLE_01", label = "Muzzle Brake 1" },
        { hash = "COMPONENT_PISTOL_MK2_MUZZLE_02", label = "Muzzle Brake 2" },
        { hash = "COMPONENT_PISTOL_MK2_MUZZLE_03", label = "Muzzle Brake 3" },
        { hash = "COMPONENT_PISTOL_MK2_MUZZLE_04", label = "Muzzle Brake 4" },
        { hash = "COMPONENT_PISTOL_MK2_MUZZLE_05", label = "Muzzle Brake 5" },
        { hash = "COMPONENT_PISTOL_MK2_MUZZLE_06", label = "Muzzle Brake 6" },
        { hash = "COMPONENT_PISTOL_MK2_MUZZLE_07", label = "Muzzle Brake 7" },
        { hash = "COMPONENT_PISTOL_MK2_MUZZLE_08", label = "Muzzle Brake 8" },
        { hash = "COMPONENT_PISTOL_MK2_MUZZLE_09", label = "Muzzle Brake 9" },
    },
    ["WEAPON_SNSPISTOL_MK2"] = {
        { hash = "COMPONENT_SNSPISTOL_MK2_CLIP_02",   label = "Extended Clip" },
        { hash = "COMPONENT_SNSPISTOL_MK2_CLIP_FMJ",  label = "FMJ Rounds" },
        { hash = "COMPONENT_SNSPISTOL_MK2_BARREL_01", label = "Default Barrel" },
        { hash = "COMPONENT_SNSPISTOL_MK2_BARREL_02", label = "Heavy Barrel" },
    },
    ["WEAPON_REVOLVER_MK2"] = {
        { hash = "COMPONENT_REVOLVER_MK2_CLIP_FMJ",  label = "FMJ Rounds" },
        { hash = "COMPONENT_REVOLVER_MK2_BARREL_01", label = "Default Barrel" },
        { hash = "COMPONENT_REVOLVER_MK2_BARREL_02", label = "Heavy Barrel" },
        { hash = "COMPONENT_REVOLVER_MK2_SCOPE_01",  label = "Scope" },
    },
    ["WEAPON_MICROSMG"] = {
        { hash = "COMPONENT_MICROSMG_CLIP_02",  label = "Extended Clip" },
        { hash = "COMPONENT_AT_PI_FLSH",         label = "Flashlight" },
        { hash = "COMPONENT_AT_SCOPE_MACRO",     label = "Scope" },
        { hash = "COMPONENT_AT_AR_SUPP_02",      label = "Suppressor" },
    },
    ["WEAPON_SMG"] = {
        { hash = "COMPONENT_SMG_CLIP_02",    label = "Extended Clip" },
        { hash = "COMPONENT_AT_PI_FLSH",      label = "Flashlight" },
        { hash = "COMPONENT_AT_SCOPE_MACRO",  label = "Scope" },
        { hash = "COMPONENT_AT_PI_SUPP",      label = "Suppressor" },
    },
    ["WEAPON_ASSAULTSMG"] = {
        { hash = "COMPONENT_ASSAULTSMG_CLIP_02", label = "Extended Clip" },
        { hash = "COMPONENT_AT_PI_FLSH",          label = "Flashlight" },
        { hash = "COMPONENT_AT_SCOPE_MACRO",      label = "Scope" },
        { hash = "COMPONENT_AT_AR_SUPP",          label = "Suppressor" },
    },
    ["WEAPON_COMBATPDW"] = {
        { hash = "COMPONENT_COMBATPDW_CLIP_02", label = "Extended Clip" },
        { hash = "COMPONENT_COMBATPDW_CLIP_03", label = "Drum Magazine" },
    },
    ["WEAPON_MACHINEPISTOL"] = {
        { hash = "COMPONENT_MACHINEPISTOL_CLIP_02", label = "Extended Clip" },
        { hash = "COMPONENT_MACHINEPISTOL_CLIP_03", label = "Drum Magazine" },
        { hash = "COMPONENT_AT_PI_SUPP",             label = "Suppressor" },
    },
    ["WEAPON_MINISMG"] = {
        { hash = "COMPONENT_MINISMG_CLIP_02", label = "Extended Clip" },
    },
    ["WEAPON_SMG_MK2"] = {
        { hash = "COMPONENT_SMG_MK2_CLIP_02",  label = "Extended Clip" },
        { hash = "COMPONENT_SMG_MK2_CLIP_FMJ", label = "FMJ Rounds" },
        { hash = "COMPONENT_AT_PI_FLSH_02",     label = "Flashlight" },
        { hash = "COMPONENT_SMG_MK2_SCOPE_01", label = "Scope" },
        { hash = "COMPONENT_SMG_MK2_SCOPE_02", label = "Large Scope" },
        { hash = "COMPONENT_AT_PI_SUPP_02",     label = "Suppressor" },
    },
    ["WEAPON_MG"] = {
        { hash = "COMPONENT_MG_CLIP_02",         label = "Extended Clip" },
        { hash = "COMPONENT_MG_CLIP_03",         label = "Drum Magazine" },
        { hash = "COMPONENT_AT_SCOPE_SMALL_02",  label = "Scope" },
    },
    ["WEAPON_COMBATMG"] = {
        { hash = "COMPONENT_COMBATMG_CLIP_02",  label = "Extended Clip" },
        { hash = "COMPONENT_COMBATMG_CLIP_03",  label = "Drum Magazine" },
        { hash = "COMPONENT_AT_AR_AFGRIP",       label = "Grip" },
        { hash = "COMPONENT_AT_SCOPE_MEDIUM",    label = "Scope" },
    },
    ["WEAPON_COMBATMG_MK2"] = {
        { hash = "COMPONENT_COMBATMG_MK2_CLIP_02",  label = "Extended Clip" },
        { hash = "COMPONENT_COMBATMG_MK2_CLIP_FMJ", label = "FMJ Rounds" },
        { hash = "COMPONENT_COMBATMG_MK2_SCOPE_01", label = "Scope" },
        { hash = "COMPONENT_COMBATMG_MK2_SCOPE_02", label = "Large Scope" },
    },
    ["WEAPON_GUSENBERG"] = {
        { hash = "COMPONENT_GUSENBERG_CLIP_02", label = "Drum Magazine" },
    },
    ["WEAPON_ASSAULTRIFLE"] = {
        { hash = "COMPONENT_ASSAULTRIFLE_CLIP_02", label = "Extended Clip" },
        { hash = "COMPONENT_ASSAULTRIFLE_CLIP_03", label = "Drum Magazine" },
        { hash = "COMPONENT_AT_AR_AFGRIP",          label = "Grip" },
        { hash = "COMPONENT_AT_AR_FLSH",            label = "Flashlight" },
        { hash = "COMPONENT_AT_SCOPE_MACRO",        label = "Scope" },
        { hash = "COMPONENT_AT_AR_SUPP_02",         label = "Suppressor" },
    },
    ["WEAPON_CARBINERIFLE"] = {
        { hash = "COMPONENT_CARBINERIFLE_CLIP_02", label = "Extended Clip" },
        { hash = "COMPONENT_CARBINERIFLE_CLIP_03", label = "Drum Magazine" },
        { hash = "COMPONENT_AT_AR_AFGRIP",          label = "Grip" },
        { hash = "COMPONENT_AT_AR_FLSH",            label = "Flashlight" },
        { hash = "COMPONENT_AT_SCOPE_MEDIUM",       label = "Scope" },
        { hash = "COMPONENT_AT_AR_SUPP",            label = "Suppressor" },
    },
    ["WEAPON_ADVANCEDRIFLE"] = {
        { hash = "COMPONENT_ADVANCEDRIFLE_CLIP_02", label = "Extended Clip" },
        { hash = "COMPONENT_AT_AR_FLSH",             label = "Flashlight" },
        { hash = "COMPONENT_AT_SCOPE_SMALL",         label = "Scope" },
        { hash = "COMPONENT_AT_AR_SUPP",             label = "Suppressor" },
    },
    ["WEAPON_SPECIALCARBINE"] = {
        { hash = "COMPONENT_SPECIALCARBINE_CLIP_02", label = "Extended Clip" },
        { hash = "COMPONENT_SPECIALCARBINE_CLIP_03", label = "Drum Magazine" },
        { hash = "COMPONENT_AT_AR_AFGRIP",            label = "Grip" },
        { hash = "COMPONENT_AT_AR_FLSH",              label = "Flashlight" },
        { hash = "COMPONENT_AT_SCOPE_MEDIUM",         label = "Scope" },
        { hash = "COMPONENT_AT_AR_SUPP_02",           label = "Suppressor" },
    },
    ["WEAPON_BULLPUPRIFLE"] = {
        { hash = "COMPONENT_BULLPUPRIFLE_CLIP_02", label = "Extended Clip" },
        { hash = "COMPONENT_AT_AR_AFGRIP_02",       label = "Grip" },
        { hash = "COMPONENT_AT_AR_FLSH",            label = "Flashlight" },
        { hash = "COMPONENT_AT_SCOPE_SMALL",        label = "Scope" },
        { hash = "COMPONENT_AT_AR_SUPP",            label = "Suppressor" },
    },
    ["WEAPON_COMPACTRIFLE"] = {
        { hash = "COMPONENT_COMPACTRIFLE_CLIP_02", label = "Extended Clip" },
        { hash = "COMPONENT_COMPACTRIFLE_CLIP_03", label = "Drum Magazine" },
    },
    ["WEAPON_ASSAULTRIFLE_MK2"] = {
        { hash = "COMPONENT_ASSAULTRIFLE_MK2_CLIP_02",  label = "Extended Clip" },
        { hash = "COMPONENT_ASSAULTRIFLE_MK2_CLIP_FMJ", label = "FMJ Rounds" },
        { hash = "COMPONENT_AT_AR_AFGRIP_02",            label = "Grip" },
        { hash = "COMPONENT_AT_AR_FLSH",                 label = "Flashlight" },
        { hash = "COMPONENT_ASSAULTRIFLE_MK2_SCOPE_01", label = "Holographic Sight" },
        { hash = "COMPONENT_ASSAULTRIFLE_MK2_SCOPE_02", label = "Scope" },
        { hash = "COMPONENT_AT_AR_SUPP_02",              label = "Suppressor" },
        { hash = "COMPONENT_AT_AR_BARREL_01",            label = "Default Barrel" },
        { hash = "COMPONENT_AT_AR_BARREL_02",            label = "Heavy Barrel" },
        { hash = "COMPONENT_AT_MUZZLE_01",               label = "Muzzle Brake 1" },
        { hash = "COMPONENT_AT_MUZZLE_02",               label = "Muzzle Brake 2" },
        { hash = "COMPONENT_AT_MUZZLE_03",               label = "Muzzle Brake 3" },
        { hash = "COMPONENT_AT_MUZZLE_04",               label = "Muzzle Brake 4" },
        { hash = "COMPONENT_AT_MUZZLE_05",               label = "Muzzle Brake 5" },
        { hash = "COMPONENT_AT_MUZZLE_06",               label = "Muzzle Brake 6" },
        { hash = "COMPONENT_AT_MUZZLE_07",               label = "Muzzle Brake 7" },
        { hash = "COMPONENT_AT_MUZZLE_08",               label = "Muzzle Brake 8" },
        { hash = "COMPONENT_AT_MUZZLE_09",               label = "Muzzle Brake 9" },
    },
    ["WEAPON_CARBINERIFLE_MK2"] = {
        { hash = "COMPONENT_CARBINERIFLE_MK2_CLIP_02",  label = "Extended Clip" },
        { hash = "COMPONENT_CARBINERIFLE_MK2_CLIP_FMJ", label = "FMJ Rounds" },
        { hash = "COMPONENT_AT_AR_AFGRIP_02",            label = "Grip" },
        { hash = "COMPONENT_AT_AR_FLSH",                 label = "Flashlight" },
        { hash = "COMPONENT_CARBINERIFLE_MK2_SCOPE_01", label = "Holographic Sight" },
        { hash = "COMPONENT_CARBINERIFLE_MK2_SCOPE_02", label = "Scope" },
        { hash = "COMPONENT_AT_AR_SUPP",                 label = "Suppressor" },
        { hash = "COMPONENT_AT_AR_BARREL_01",            label = "Default Barrel" },
        { hash = "COMPONENT_AT_AR_BARREL_02",            label = "Heavy Barrel" },
        { hash = "COMPONENT_AT_MUZZLE_01",               label = "Muzzle Brake 1" },
        { hash = "COMPONENT_AT_MUZZLE_02",               label = "Muzzle Brake 2" },
        { hash = "COMPONENT_AT_MUZZLE_03",               label = "Muzzle Brake 3" },
        { hash = "COMPONENT_AT_MUZZLE_04",               label = "Muzzle Brake 4" },
        { hash = "COMPONENT_AT_MUZZLE_05",               label = "Muzzle Brake 5" },
        { hash = "COMPONENT_AT_MUZZLE_06",               label = "Muzzle Brake 6" },
        { hash = "COMPONENT_AT_MUZZLE_07",               label = "Muzzle Brake 7" },
        { hash = "COMPONENT_AT_MUZZLE_08",               label = "Muzzle Brake 8" },
        { hash = "COMPONENT_AT_MUZZLE_09",               label = "Muzzle Brake 9" },
    },
    ["WEAPON_SPECIALCARBINE_MK2"] = {
        { hash = "COMPONENT_SPECIALCARBINE_MK2_CLIP_02",  label = "Extended Clip" },
        { hash = "COMPONENT_SPECIALCARBINE_MK2_CLIP_FMJ", label = "FMJ Rounds" },
        { hash = "COMPONENT_AT_AR_AFGRIP_02",              label = "Grip" },
        { hash = "COMPONENT_AT_AR_FLSH",                   label = "Flashlight" },
        { hash = "COMPONENT_SPECIALCARBINE_MK2_SCOPE_01", label = "Holographic Sight" },
        { hash = "COMPONENT_SPECIALCARBINE_MK2_SCOPE_02", label = "Scope" },
        { hash = "COMPONENT_AT_AR_SUPP_02",                label = "Suppressor" },
        { hash = "COMPONENT_AT_AR_BARREL_01",              label = "Default Barrel" },
        { hash = "COMPONENT_AT_AR_BARREL_02",              label = "Heavy Barrel" },
        { hash = "COMPONENT_AT_MUZZLE_01",                 label = "Muzzle Brake 1" },
        { hash = "COMPONENT_AT_MUZZLE_02",                 label = "Muzzle Brake 2" },
        { hash = "COMPONENT_AT_MUZZLE_03",                 label = "Muzzle Brake 3" },
        { hash = "COMPONENT_AT_MUZZLE_04",                 label = "Muzzle Brake 4" },
        { hash = "COMPONENT_AT_MUZZLE_05",                 label = "Muzzle Brake 5" },
        { hash = "COMPONENT_AT_MUZZLE_06",                 label = "Muzzle Brake 6" },
        { hash = "COMPONENT_AT_MUZZLE_07",                 label = "Muzzle Brake 7" },
        { hash = "COMPONENT_AT_MUZZLE_08",                 label = "Muzzle Brake 8" },
        { hash = "COMPONENT_AT_MUZZLE_09",                 label = "Muzzle Brake 9" },
    },
    ["WEAPON_BULLPUPRIFLE_MK2"] = {
        { hash = "COMPONENT_BULLPUPRIFLE_MK2_CLIP_02",  label = "Extended Clip" },
        { hash = "COMPONENT_BULLPUPRIFLE_MK2_CLIP_FMJ", label = "FMJ Rounds" },
        { hash = "COMPONENT_AT_AR_AFGRIP_02",            label = "Grip" },
        { hash = "COMPONENT_AT_AR_FLSH",                 label = "Flashlight" },
        { hash = "COMPONENT_BULLPUPRIFLE_MK2_SCOPE_01", label = "Holographic Sight" },
        { hash = "COMPONENT_BULLPUPRIFLE_MK2_SCOPE_02", label = "Scope" },
        { hash = "COMPONENT_AT_AR_SUPP_02",              label = "Suppressor" },
        { hash = "COMPONENT_AT_AR_BARREL_01",            label = "Default Barrel" },
        { hash = "COMPONENT_AT_AR_BARREL_02",            label = "Heavy Barrel" },
        { hash = "COMPONENT_AT_MUZZLE_01",               label = "Muzzle Brake 1" },
        { hash = "COMPONENT_AT_MUZZLE_02",               label = "Muzzle Brake 2" },
        { hash = "COMPONENT_AT_MUZZLE_03",               label = "Muzzle Brake 3" },
        { hash = "COMPONENT_AT_MUZZLE_04",               label = "Muzzle Brake 4" },
        { hash = "COMPONENT_AT_MUZZLE_05",               label = "Muzzle Brake 5" },
        { hash = "COMPONENT_AT_MUZZLE_06",               label = "Muzzle Brake 6" },
        { hash = "COMPONENT_AT_MUZZLE_07",               label = "Muzzle Brake 7" },
        { hash = "COMPONENT_AT_MUZZLE_08",               label = "Muzzle Brake 8" },
        { hash = "COMPONENT_AT_MUZZLE_09",               label = "Muzzle Brake 9" },
    },
    ["WEAPON_PUMPSHOTGUN"] = {
        { hash = "COMPONENT_AT_AR_FLSH",   label = "Flashlight" },
        { hash = "COMPONENT_AT_PI_SUPP",   label = "Suppressor" },
    },
    ["WEAPON_ASSAULTSHOTGUN"] = {
        { hash = "COMPONENT_ASSAULTSHOTGUN_CLIP_02", label = "Extended Clip" },
        { hash = "COMPONENT_AT_AR_AFGRIP",            label = "Grip" },
        { hash = "COMPONENT_AT_AR_FLSH",              label = "Flashlight" },
        { hash = "COMPONENT_AT_AR_SUPP",              label = "Suppressor" },
    },
    ["WEAPON_BULLPUPSHOTGUN"] = {
        { hash = "COMPONENT_AT_AR_AFGRIP_02", label = "Grip" },
        { hash = "COMPONENT_AT_AR_FLSH",       label = "Flashlight" },
        { hash = "COMPONENT_AT_AR_SUPP_02",    label = "Suppressor" },
    },
    ["WEAPON_HEAVYSHOTGUN"] = {
        { hash = "COMPONENT_HEAVYSHOTGUN_CLIP_02", label = "Extended Clip" },
        { hash = "COMPONENT_HEAVYSHOTGUN_CLIP_03", label = "Drum Magazine" },
        { hash = "COMPONENT_AT_AR_AFGRIP",          label = "Grip" },
        { hash = "COMPONENT_AT_AR_FLSH",            label = "Flashlight" },
        { hash = "COMPONENT_AT_AR_SUPP_02",         label = "Suppressor" },
    },
    ["WEAPON_PUMPSHOTGUN_MK2"] = {
        { hash = "COMPONENT_PUMPSHOTGUN_MK2_CLIP_02",   label = "Extended Clip" },
        { hash = "COMPONENT_AT_AR_FLSH",                 label = "Flashlight" },
        { hash = "COMPONENT_PUMPSHOTGUN_MK2_SCOPE_01",  label = "Scope" },
        { hash = "COMPONENT_PUMPSHOTGUN_MK2_MUZZLE_01", label = "Muzzle Brake 1" },
        { hash = "COMPONENT_PUMPSHOTGUN_MK2_MUZZLE_02", label = "Muzzle Brake 2" },
        { hash = "COMPONENT_PUMPSHOTGUN_MK2_MUZZLE_03", label = "Muzzle Brake 3" },
        { hash = "COMPONENT_PUMPSHOTGUN_MK2_MUZZLE_04", label = "Muzzle Brake 4" },
        { hash = "COMPONENT_PUMPSHOTGUN_MK2_MUZZLE_05", label = "Muzzle Brake 5" },
        { hash = "COMPONENT_PUMPSHOTGUN_MK2_MUZZLE_06", label = "Muzzle Brake 6" },
        { hash = "COMPONENT_PUMPSHOTGUN_MK2_MUZZLE_07", label = "Muzzle Brake 7" },
        { hash = "COMPONENT_PUMPSHOTGUN_MK2_MUZZLE_08", label = "Muzzle Brake 8" },
        { hash = "COMPONENT_PUMPSHOTGUN_MK2_MUZZLE_09", label = "Muzzle Brake 9" },
    },
    ["WEAPON_SNIPERRIFLE"] = {
        { hash = "COMPONENT_SNIPERRIFLE_CLIP_02",  label = "Extended Clip" },
        { hash = "COMPONENT_AT_AR_FLSH",            label = "Flashlight" },
        { hash = "COMPONENT_AT_SCOPE_MAX",          label = "Advanced Scope" },
        { hash = "COMPONENT_AT_SR_SUPP_03",         label = "Suppressor" },
    },
    ["WEAPON_HEAVYSNIPER"] = {
        { hash = "COMPONENT_HEAVYSNIPER_CLIP_02", label = "Extended Clip" },
        { hash = "COMPONENT_AT_SCOPE_MAX",         label = "Advanced Scope" },
    },
    ["WEAPON_MARKSMANRIFLE"] = {
        { hash = "COMPONENT_MARKSMANRIFLE_CLIP_02",        label = "Extended Clip" },
        { hash = "COMPONENT_AT_AR_AFGRIP",                  label = "Grip" },
        { hash = "COMPONENT_AT_PI_FLSH",                    label = "Flashlight" },
        { hash = "COMPONENT_AT_SCOPE_LARGE_FIXED_ZOOM",    label = "Scope" },
        { hash = "COMPONENT_AT_AR_SUPP",                    label = "Suppressor" },
    },
    ["WEAPON_HEAVYSNIPER_MK2"] = {
        { hash = "COMPONENT_HEAVYSNIPER_MK2_CLIP_FMJ",    label = "FMJ Rounds" },
        { hash = "COMPONENT_HEAVYSNIPER_MK2_SCOPE_01",    label = "Scope" },
        { hash = "COMPONENT_HEAVYSNIPER_MK2_SCOPE_02",    label = "Night Vision Scope" },
        { hash = "COMPONENT_HEAVYSNIPER_MK2_SCOPE_03",    label = "Thermal Scope" },
        { hash = "COMPONENT_HEAVYSNIPER_MK2_SCOPE_04",    label = "Advanced Scope" },
        { hash = "COMPONENT_HEAVYSNIPER_MK2_BARREL_01",   label = "Default Barrel" },
        { hash = "COMPONENT_HEAVYSNIPER_MK2_BARREL_02",   label = "Heavy Barrel" },
        { hash = "COMPONENT_HEAVYSNIPER_MK2_MUZZLE_01",   label = "Muzzle Brake 1" },
        { hash = "COMPONENT_HEAVYSNIPER_MK2_MUZZLE_02",   label = "Muzzle Brake 2" },
        { hash = "COMPONENT_HEAVYSNIPER_MK2_MUZZLE_03",   label = "Muzzle Brake 3" },
        { hash = "COMPONENT_HEAVYSNIPER_MK2_MUZZLE_04",   label = "Muzzle Brake 4" },
        { hash = "COMPONENT_HEAVYSNIPER_MK2_MUZZLE_05",   label = "Muzzle Brake 5" },
        { hash = "COMPONENT_HEAVYSNIPER_MK2_MUZZLE_06",   label = "Muzzle Brake 6" },
        { hash = "COMPONENT_HEAVYSNIPER_MK2_MUZZLE_07",   label = "Muzzle Brake 7" },
        { hash = "COMPONENT_HEAVYSNIPER_MK2_MUZZLE_08",   label = "Muzzle Brake 8" },
        { hash = "COMPONENT_HEAVYSNIPER_MK2_MUZZLE_09",   label = "Muzzle Brake 9" },
    },
    ["WEAPON_MARKSMANRIFLE_MK2"] = {
        { hash = "COMPONENT_MARKSMANRIFLE_MK2_CLIP_02",  label = "Extended Clip" },
        { hash = "COMPONENT_MARKSMANRIFLE_MK2_CLIP_FMJ", label = "FMJ Rounds" },
        { hash = "COMPONENT_AT_AR_AFGRIP_02",             label = "Grip" },
        { hash = "COMPONENT_AT_PI_FLSH_02",               label = "Flashlight" },
        { hash = "COMPONENT_MARKSMANRIFLE_MK2_SCOPE_01", label = "Scope" },
        { hash = "COMPONENT_MARKSMANRIFLE_MK2_SCOPE_02", label = "Night Vision Scope" },
        { hash = "COMPONENT_AT_AR_SUPP_02",               label = "Suppressor" },
        { hash = "COMPONENT_AT_SR_BARREL_01",             label = "Default Barrel" },
        { hash = "COMPONENT_AT_SR_BARREL_02",             label = "Heavy Barrel" },
        { hash = "COMPONENT_AT_MUZZLE_01",                label = "Muzzle Brake 1" },
        { hash = "COMPONENT_AT_MUZZLE_02",                label = "Muzzle Brake 2" },
        { hash = "COMPONENT_AT_MUZZLE_03",                label = "Muzzle Brake 3" },
        { hash = "COMPONENT_AT_MUZZLE_04",                label = "Muzzle Brake 4" },
        { hash = "COMPONENT_AT_MUZZLE_05",                label = "Muzzle Brake 5" },
        { hash = "COMPONENT_AT_MUZZLE_06",                label = "Muzzle Brake 6" },
        { hash = "COMPONENT_AT_MUZZLE_07",                label = "Muzzle Brake 7" },
        { hash = "COMPONENT_AT_MUZZLE_08",                label = "Muzzle Brake 8" },
        { hash = "COMPONENT_AT_MUZZLE_09",                label = "Muzzle Brake 9" },
    },
    ["WEAPON_KNUCKLE"] = {
        { hash = "COMPONENT_KNUCKLE_VARMOD_BASE",    label = "Base" },
        { hash = "COMPONENT_KNUCKLE_VARMOD_PIMP",    label = "Gold" },
        { hash = "COMPONENT_KNUCKLE_VARMOD_BALLAS",  label = "Ballas" },
        { hash = "COMPONENT_KNUCKLE_VARMOD_DOLLAR",  label = "Dollar Sign" },
        { hash = "COMPONENT_KNUCKLE_VARMOD_DIAMOND", label = "Diamond" },
        { hash = "COMPONENT_KNUCKLE_VARMOD_HATE",    label = "Hate" },
        { hash = "COMPONENT_KNUCKLE_VARMOD_LOVE",    label = "Love" },
        { hash = "COMPONENT_KNUCKLE_VARMOD_PLAYER",  label = "Player" },
        { hash = "COMPONENT_KNUCKLE_VARMOD_KING",    label = "King" },
        { hash = "COMPONENT_KNUCKLE_VARMOD_VAGOS",   label = "Vagos" },
    },
}

CreateWeaponMenu = (function(weaponData)
    local weaponHash = GetHashKey(weaponData.name)
    local weaponMenu = Menu:New("Weapon Options", weaponData.label)
    MenuController:AddMenu(weaponMenu)

    local getRemoveBtn = MenuItem:New("Equip/Remove Weapon", "Add or remove this weapon to/from your inventory.")

    local fillAmmoBtn = MenuItem:New("Re-fill Ammo", "Get max ammo for this weapon.")

    local isMk2 = weaponData.name:find("MK2") or weaponData.name:find("_MK2")
    local tintList = isMk2 and weaponTintsMk2 or weaponTints
    local tintItem = MenuListItem:New("Tints", tintList, 1, "Select a tint for your weapon.")

    weaponMenu:AddMenuItem(getRemoveBtn)
    weaponMenu:AddMenuItem(fillAmmoBtn)
    weaponMenu:AddMenuItem(tintItem)

    local componentItems = {}
    local components = weaponComponentMap[weaponData.name] or {}

    if #components > 0 then
        local spacer = MenuItem:New("~ Components ~", "")
        spacer.Enabled = false
        weaponMenu:AddMenuItem(spacer)

        for _, comp in ipairs(components) do
            local compHash = GetHashKey(comp.hash)
            local checkbox = MenuCheckboxItem:New(comp.label, "Add or remove this weapon component.", false)
            table.insert(componentItems, { hash = compHash, item = checkbox })
            weaponMenu:AddMenuItem(checkbox)
        end
    end

    weaponMenu.OnMenuOpen = function(m)
        local ped = PlayerPedId()
        if HasPedGotWeapon(ped, weaponHash, false) then
            for _, comp in ipairs(componentItems) do
                comp.item.Checked = HasPedGotWeaponComponent(ped, weaponHash, comp.hash)
            end
            local currentTint = GetPedWeaponTintIndex(ped, weaponHash)
            tintItem.Index = currentTint + 1
        end
    end

    weaponMenu.OnItemSelect = function(sender, item, index)
        local ped = PlayerPedId()

        if item == getRemoveBtn then
            if HasPedGotWeapon(ped, weaponHash, false) then
                RemoveWeaponFromPed(ped, weaponHash)
                Notify.Custom("Weapon removed.")
            else
                local ammo = 255
                local success, maxAmmo = GetMaxAmmo(ped, weaponHash, ammo)
                GiveWeaponToPed(ped, weaponHash, success and maxAmmo or 255, false, true)
                Notify.Custom("Weapon added.")
                TriggerServerEvent("vMenu:LogWeaponSpawn", item.Text or "Unknown")
            end
        elseif item == fillAmmoBtn then
            if HasPedGotWeapon(ped, weaponHash, false) then
                local ammo = 900
                local success, maxAmmo = GetMaxAmmo(ped, weaponHash, ammo)
                SetPedAmmo(ped, weaponHash, success and maxAmmo or 900)
                Notify.Success("Ammo refilled.")
            else
                Notify.Error("You need to get the weapon first!")
            end
        end
    end

    weaponMenu.OnCheckboxChange = function(sender, item, index, checked)
        local ped = PlayerPedId()
        if not HasPedGotWeapon(ped, weaponHash, false) then
            Notify.Error("You need to get the weapon first!")
            item.Checked = false
            return
        end
        for _, comp in ipairs(componentItems) do
            if item == comp.item then
                if checked then
                    GiveWeaponComponentToPed(ped, weaponHash, comp.hash)
                else
                    RemoveWeaponComponentFromPed(ped, weaponHash, comp.hash)
                end
                return
            end
        end
    end

    weaponMenu.OnListIndexChange = function(sender, item, oldIndex, newIndex, itemIndex)
        if item == tintItem then
            local ped = PlayerPedId()
            if HasPedGotWeapon(ped, weaponHash, false) then
                SetPedWeaponTintIndex(ped, weaponHash, newIndex - 1)
            else
                Notify.Error("You need to get the weapon first!")
            end
        end
    end

    return weaponMenu
end)

function WeaponOptionsMenu.CreateMenu()
    menu = Menu:New("Weapon Options", "Weapon Related Options")
    MenuController:AddMenu(menu)

    local getAllWeaponsBtn = MenuItem:New("Get All Weapons", "Get all weapons with full ammo.")
    local removeAllWeaponsBtn = MenuItem:New("Remove All Weapons", "Removes all weapons in your inventory.")
    local unlimitedAmmoCheckbox = MenuCheckboxItem:New("Unlimited Ammo", "Unlimited ammunition supply.",
        WeaponOptionsMenu.UnlimitedAmmo)
    local noReloadCheckbox = MenuCheckboxItem:New("No Reload", "Never reload.", WeaponOptionsMenu.NoReload)
    local setAmmoBtn = MenuItem:New("Set All Ammo Count", "Set the amount of ammo in all your weapons.")
    local refillMaxAmmoBtn = MenuItem:New("Refill All Ammo", "Give all your weapons max ammo.")
    local spawnByNameBtn = MenuItem:New("Spawn Weapon By Name", "Enter a weapon model name to spawn.")

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.WPGetAll) then
        menu:AddMenuItem(getAllWeaponsBtn)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.WPRemoveAll) then
        menu:AddMenuItem(removeAllWeaponsBtn)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.WPUnlimitedAmmo) then
        menu:AddMenuItem(unlimitedAmmoCheckbox)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.WPNoReload) then
        menu:AddMenuItem(noReloadCheckbox)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.WPSetAllAmmo) then
        menu:AddMenuItem(setAmmoBtn)
        menu:AddMenuItem(refillMaxAmmoBtn)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.WPSpawnByName) then
        menu:AddMenuItem(spawnByNameBtn)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.WPParachute) then
        parachuteMenu = Menu:New("Parachute Options", "Parachute Options")
        MenuController:AddMenu(parachuteMenu)

        local parachuteBtn = MenuItem:New("Parachute Options", "All parachute related options can be changed here.")
        parachuteBtn.Label = "→→→"
        menu:AddMenuItem(parachuteBtn)
        MenuController:BindMenuItem(menu, parachuteMenu, parachuteBtn)

        local togglePrimaryBtn = MenuItem:New("Toggle Primary Parachute", "Equip or remove the primary parachute.")
        local toggleReserveBtn = MenuItem:New("Enable Reserve Parachute",
            "Enables the reserve parachute. Only works if you enabled the primary parachute first.")
        local autoEquipCheckbox = MenuCheckboxItem:New("Auto Equip Parachutes",
            "Automatically equip a parachute when entering planes/helicopters.", WeaponOptionsMenu.AutoEquipChute)
        local unlimitedParachutesCheckbox = MenuCheckboxItem:New("Unlimited Parachutes",
            "Enable unlimited parachutes and reserve parachutes.", WeaponOptionsMenu.UnlimitedParachutes)

        local smokeColorNames = {}
        for _, color in ipairs(smokeColors) do
            table.insert(smokeColorNames, color.name)
        end
        local smokeColorList = MenuListItem:New("Smoke Trail Color", smokeColorNames, 1,
            "Choose a smoke trail color for your parachute.")

        local primaryChuteList = MenuListItem:New("Primary Chute Style", parachuteTints, 1,
            "Select a style for your primary parachute.")
        local reserveChuteList = MenuListItem:New("Reserve Chute Style", parachuteTints, 1,
            "Select a style for your reserve parachute.")

        parachuteMenu:AddMenuItem(togglePrimaryBtn)
        parachuteMenu:AddMenuItem(toggleReserveBtn)
        parachuteMenu:AddMenuItem(autoEquipCheckbox)
        parachuteMenu:AddMenuItem(unlimitedParachutesCheckbox)
        parachuteMenu:AddMenuItem(smokeColorList)
        parachuteMenu:AddMenuItem(primaryChuteList)
        parachuteMenu:AddMenuItem(reserveChuteList)

        parachuteMenu.OnItemSelect = function(sender, item, index)
            local ped = PlayerPedId()
            local parachuteHash = GetHashKey("gadget_parachute")

            if item == togglePrimaryBtn then
                if HasPedGotWeapon(ped, parachuteHash, false) then
                    RemoveWeaponFromPed(ped, parachuteHash)
                    Notify.Custom("Primary parachute removed.")
                else
                    GiveWeaponToPed(ped, parachuteHash, 1, false, false)
                    Notify.Custom("Primary parachute added.")
                end
            elseif item == toggleReserveBtn then
                SetPlayerHasReserveParachute(PlayerId())
                Notify.Custom("Reserve parachute has been added.")
            end
        end

        parachuteMenu.OnCheckboxChange = function(sender, item, index, checked)
            if item == unlimitedParachutesCheckbox then
                WeaponOptionsMenu.UnlimitedParachutes = checked
                Notify.Custom("Unlimited parachutes " .. (checked and "~g~enabled" or "~r~disabled") .. ".")
            elseif item == autoEquipCheckbox then
                WeaponOptionsMenu.AutoEquipChute = checked
                Notify.Custom("Auto equip parachutes " .. (checked and "~g~enabled" or "~r~disabled") .. ".")
            end
        end

        parachuteMenu.OnListItemSelect = function(sender, item, listIndex, itemIndex)
            local player = PlayerId()
            if item == smokeColorList then
                local color = smokeColors[listIndex]
                SetPlayerParachuteSmokeTrailColor(player, color.r, color.g, color.b)
                SetPlayerCanLeaveParachuteSmokeTrail(player, listIndex > 1)
                Notify.Custom("Smoke trail color set to ~y~" .. color.name .. "~s~.")
            end
        end

        parachuteMenu.OnListIndexChange = function(sender, item, oldIndex, newIndex, itemIndex)
            local player = PlayerId()
            if item == primaryChuteList then
                SetPlayerParachuteTintIndex(player, newIndex - 1)
            elseif item == reserveChuteList then
                SetPlayerReserveParachuteTintIndex(player, newIndex - 1)
            end
        end
    end

    local spacer = MenuItem:New("↓ Weapon Categories ↓", "")
    spacer.Enabled = false
    menu:AddMenuItem(spacer)

    for _, category in ipairs(weaponCategories) do
        local categoryMenu = Menu:New("Weapons", category.name)
        MenuController:AddMenu(categoryMenu)

        local categoryBtn = MenuItem:New(category.name, "Open the " .. category.name .. " weapon category.")
        categoryBtn.Label = "→→→"
        menu:AddMenuItem(categoryBtn)
        MenuController:BindMenuItem(menu, categoryMenu, categoryBtn)

        for _, weapon in ipairs(category.weapons) do
            local weaponHash = GetHashKey(weapon.name)

            if IsWeaponValid(weaponHash) and IsWeaponAllowed(weapon.name) then
                local weaponMenu = CreateWeaponMenu(weapon)
                local weaponBtn = MenuItem:New(weapon.label, "Open options for ~y~" .. weapon.label .. "~s~.")
                weaponBtn.Label = "→→→"
                categoryMenu:AddMenuItem(weaponBtn)
                MenuController:BindMenuItem(categoryMenu, weaponMenu, weaponBtn)
            end
        end
    end

    menu.OnCheckboxChange = function(sender, item, index, checked)
        if item == unlimitedAmmoCheckbox then
            WeaponOptionsMenu.UnlimitedAmmo = checked
            Notify.Custom("Unlimited ammo is now " .. (checked and "~g~enabled~s~" or "~r~disabled~s~") .. ".")

        elseif item == noReloadCheckbox then
            WeaponOptionsMenu.NoReload = checked
            Notify.Custom("No reload is now " .. (checked and "~g~enabled~s~" or "~r~disabled~s~") .. ".")
        end
    end

    menu.OnItemSelect = function(sender, item, index)
        local ped = PlayerPedId()

        if item == getAllWeaponsBtn then
            for _, category in ipairs(weaponCategories) do
                for _, weapon in ipairs(category.weapons) do
                    local weaponHash = GetHashKey(weapon.name)
                    if IsWeaponValid(weaponHash) and IsWeaponAllowed(weapon.name) then
                        GiveWeaponToPed(ped, weaponHash, 250, false, false)

                        local maxAmmo = 0
                        local success, ammo = GetMaxAmmo(ped, weaponHash, maxAmmo)
                        if success then
                            SetPedAmmo(ped, weaponHash, ammo)
                        end
                    end
                end
            end
            SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
            Notify.Success("All weapons added.")
            TriggerServerEvent("vMenu:LogAllWeapons")

        elseif item == removeAllWeaponsBtn then
            RemoveAllPedWeapons(ped, true)
            Notify.Success("All weapons removed.")

        elseif item == setAmmoBtn then
            DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "250", "", "", "", 5)
            while UpdateOnscreenKeyboard() == 0 do
                Wait(0)
            end
            if GetOnscreenKeyboardResult() then
                local ammoCount = tonumber(GetOnscreenKeyboardResult())
                if ammoCount and ammoCount >= 0 then
                    for _, category in ipairs(weaponCategories) do
                        for _, weapon in ipairs(category.weapons) do
                            local weaponHash = GetHashKey(weapon.name)
                            if HasPedGotWeapon(ped, weaponHash, false) then
                                SetPedAmmo(ped, weaponHash, ammoCount)
                            end
                        end
                    end
                    Notify.Success("All weapons ammo set to ~o~" .. ammoCount .. "~s~.")
                else
                    Notify.Error("Invalid ammo count.")
                end
            end

        elseif item == refillMaxAmmoBtn then
            local refillCount = 0
            for _, category in ipairs(weaponCategories) do
                for _, weapon in ipairs(category.weapons) do
                    local weaponHash = GetHashKey(weapon.name)
                    if HasPedGotWeapon(ped, weaponHash, false) then
                        local maxAmmoInClip = GetMaxAmmoInClip(ped, weaponHash, false)
                        SetAmmoInClip(ped, weaponHash, maxAmmoInClip)

                        local maxAmmo = 0
                        local success, ammo = GetMaxAmmo(ped, weaponHash, maxAmmo)
                        if success then
                            SetPedAmmo(ped, weaponHash, ammo)
                            refillCount = refillCount + 1
                        end
                    end
                end
            end
            if refillCount > 0 then
                Notify.Success("Refilled ammo for " .. refillCount .. " weapon(s).")
            else
                Notify.Alert("You don't have any weapons to refill.")
            end

        elseif item == spawnByNameBtn then
            DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 60)
            while UpdateOnscreenKeyboard() == 0 do
                Wait(0)
            end
            if GetOnscreenKeyboardResult() then
                local weaponName = GetOnscreenKeyboardResult()
                if weaponName and weaponName ~= "" then
                    local weaponHash = GetHashKey(weaponName)
                    if not IsWeaponValid(weaponHash) then
                        weaponHash = GetHashKey("WEAPON_" .. weaponName)
                    end

                    if IsWeaponValid(weaponHash) then
                        GiveWeaponToPed(ped, weaponHash, 250, false, true)

                        local maxAmmo = 0
                        local success, ammo = GetMaxAmmo(ped, weaponHash, maxAmmo)
                        if success then
                            SetPedAmmo(ped, weaponHash, ammo)
                        end

                        Notify.Success("Weapon spawned: ~g~" .. weaponName)
                        TriggerServerEvent("vMenu:LogWeaponSpawn", weaponName)
                    else
                        Notify.Error("Invalid weapon name: ~r~" .. weaponName)
                    end
                end
            end
        end
    end

    return menu
end

function WeaponOptionsMenu.GetMenu()
    if menu == nil then
        WeaponOptionsMenu.CreateMenu()
    end
    return menu
end

Citizen.CreateThread((function()
    local hadInfiniteAmmo = false

    while true do
        local sleep = 1000
        local ped = PlayerPedId()
        local player = PlayerId()

        local unlimitedAmmo = WeaponOptionsMenu.UnlimitedAmmo
            and PermissionsManager.IsAllowed(PermissionsManager.Permission.WPUnlimitedAmmo)

        local noReload = WeaponOptionsMenu.NoReload
            and PermissionsManager.IsAllowed(PermissionsManager.Permission.WPNoReload)

        local unlimitedParachutes = WeaponOptionsMenu.UnlimitedParachutes
            and PermissionsManager.IsAllowed(PermissionsManager.Permission.WPParachute)

        local autoEquipChute = WeaponOptionsMenu.AutoEquipChute
            and PermissionsManager.IsAllowed(PermissionsManager.Permission.WPParachute)

        if unlimitedAmmo or noReload or unlimitedParachutes or autoEquipChute then
            sleep = 0
        end

        if unlimitedAmmo then
            if not hadInfiniteAmmo then
                SetPedInfiniteAmmoClip(ped, true)
                hadInfiniteAmmo = true
            end
        elseif hadInfiniteAmmo then
            SetPedInfiniteAmmoClip(ped, false)
            hadInfiniteAmmo = false
        end

        if noReload then
            local currentWeapon = GetSelectedPedWeapon(ped)
            if currentWeapon ~= GetHashKey("WEAPON_UNARMED") then
                local maxAmmoInClip = GetMaxAmmoInClip(ped, currentWeapon, true)
                SetAmmoInClip(ped, currentWeapon, maxAmmoInClip)
            end
        end

        if unlimitedParachutes then
            local parachuteHash = GetHashKey("gadget_parachute")
            if not HasPedGotWeapon(ped, parachuteHash, false) then
                if not IsPedInAnyVehicle(ped, false) then
                    GiveWeaponToPed(ped, parachuteHash, 1, false, false)
                    SetPlayerHasReserveParachute(player)
                end
            end
        end

        if autoEquipChute then
            local vehicle = GetVehiclePedIsIn(ped, false)
            if vehicle and vehicle ~= 0 then
                local vehicleClass = GetVehicleClass(vehicle)
                if vehicleClass == 15 or vehicleClass == 16 then
                    local parachuteHash = GetHashKey("gadget_parachute")
                    if not HasPedGotWeapon(ped, parachuteHash, false) then
                        GiveWeaponToPed(ped, parachuteHash, 1, false, false)
                        SetPlayerHasReserveParachute(player)
                    end
                end
            end
        end

        Citizen.Wait(sleep)
    end
end))

return WeaponOptionsMenu
