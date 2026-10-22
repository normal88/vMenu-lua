MiscSettingsMenu = {}

local menu = nil
local teleportOptionsMenu = nil
local keybindSettingsMenu = nil
local connectionOptionsMenu = nil
local developerToolsMenu = nil

MiscSettingsMenu.RightAlignMenu = true
MiscSettingsMenu.DisablePrivateMessages = false
MiscSettingsMenu.DisableControllerSupport = false
MiscSettingsMenu.ShowSpeedoKmh = false
MiscSettingsMenu.ShowSpeedoMph = false
MiscSettingsMenu.ShowLocation = false
MiscSettingsMenu.ShowCoordinates = false
MiscSettingsMenu.DrawTimeOnScreen = false
MiscSettingsMenu.HideHud = false
MiscSettingsMenu.HideRadar = false
MiscSettingsMenu.JoinQuitNotifications = false
MiscSettingsMenu.DeathNotifications = false
MiscSettingsMenu.NightVision = false
MiscSettingsMenu.ThermalVision = false
MiscSettingsMenu.ShowLocationBlips = false
MiscSettingsMenu.ShowPlayerBlips = false
MiscSettingsMenu.ShowOverheadNames = false
MiscSettingsMenu.RespawnDefaultCharacter = false
MiscSettingsMenu.RestorePlayerAppearance = false
MiscSettingsMenu.RestorePlayerWeapons = false
MiscSettingsMenu.LockCameraX = false
MiscSettingsMenu.LockCameraY = false
MiscSettingsMenu.MPPedPreviews = true

MiscSettingsMenu.ShowVehicleDimensions = false
MiscSettingsMenu.ShowPedDimensions = false
MiscSettingsMenu.ShowPropDimensions = false
MiscSettingsMenu.ShowEntityHandles = false
MiscSettingsMenu.ShowEntityModels = false
MiscSettingsMenu.ShowEntityNetOwners = false
MiscSettingsMenu.TimecycleEnabled = false
MiscSettingsMenu.TimecycleModifierIndex = 0
MiscSettingsMenu.TimecycleStrength = 1.0
MiscSettingsMenu.DimensionsRange = 50.0

MiscSettingsMenu.KbTpToWaypoint = false
MiscSettingsMenu.KbDriftMode = false
MiscSettingsMenu.KbRecordKeys = true
MiscSettingsMenu.KbRadarKeys = true
MiscSettingsMenu.KbPointKeys = true

MiscSettingsMenu.TeleportLocations = {}

local timecycleModifiers = {
    "AmbientPUSH",
    "AP1_01_B_IntRefRange",
    "AP1_01_C_NoFog",
    "Bank_HLWD",
    "Barry1_Stoned",
    "BarryFadeOut",
    "baseTONEMAPPING",
    "BeastIntro01",
    "BeastIntro02",
    "BeastLaunch01",
    "BeastLaunch02",
    "BikerFilter",
    "BikerForm01",
    "BikerFormFlash",
    "Bikers",
    "BikersSPLASH",
    "blackNwhite",
    "BlackOut",
    "BleepYellow01",
    "BleepYellow02",
    "Bloom",
    "BloomLight",
    "BloomMid",
    "buggy_shack",
    "buildingTOP",
    "BulletTimeDark",
    "BulletTimeLight",
    "CAMERA_BW",
    "CAMERA_secuirity",
    "CAMERA_secuirity_FUZZ",
    "canyon_mission",
    "carMOD_underpass",
    "carpark",
    "carpark_dt1_02",
    "carpark_dt1_03",
    "Carpark_MP_exit",
    "cashdepot",
    "cashdepotEMERGENCY",
    "cBank_back",
    "cBank_front",
    "ch2_tunnel_whitelight",
    "CH3_06_water",
    "CHOP",
    "cinema",
    "cinema_001",
    "cops",
    "CopsSPLASH",
    "crane_cam",
    "crane_cam_cinematic",
    "CrossLine01",
    "CrossLine02",
    "CS1_railwayB_tunnel",
    "CS3_rail_tunnel",
    "CUSTOM_streetlight",
    "damage",
    "DeadlineNeon01",
    "default",
    "DefaultColorCode",
    "DONT_overide_sunpos",
    "Dont_tazeme_bro",
    "dont_tazeme_bro_b",
    "downtown_FIB_cascades_opt",
    "DrivingFocusDark",
    "DrivingFocusLight",
    "DRUG_2_drive",
    "Drug_deadman",
    "Drug_deadman_blend",
    "drug_drive_blend01",
    "drug_drive_blend02",
    "drug_flying_01",
    "drug_flying_02",
    "drug_flying_base",
    "DRUG_gas_huffin",
    "drug_wobbly",
    "Drunk",
    "dying",
    "eatra_bouncelight_beach",
    "epsilion",
    "exile1_exit",
    "exile1_plane",
    "ExplosionJosh",
    "EXT_FULLAmbientmult_art",
    "ext_int_extlight_large",
    "EXTRA_bouncelight",
    "eyeINtheSKY",
    "Facebook_NEW",
    "facebook_serveroom",
    "FIB_5",
    "FIB_6",
    "FIB_A",
    "FIB_B",
    "FIB_interview",
    "FIB_interview_optimise",
    "FinaleBank",
    "FinaleBankexit",
    "FinaleBankMid",
    "fireDEPT",
    "FORdoron_delete",
    "Forest",
    "fp_vig_black",
    "fp_vig_blue",
    "fp_vig_brown",
    "fp_vig_gray",
    "fp_vig_green",
    "fp_vig_red",
    "FrankilinsHOUSEhills",
    "frankilnsAUNTS_new",
    "frankilnsAUNTS_SUNdir",
    "FRANKLIN",
    "FranklinColorCode",
    "FranklinColorCodeBasic",
    "FranklinColorCodeBright",
    "FullAmbientmult_interior",
    "gallery_refmod",
    "garage",
    "gen_bank",
    "glasses_black",
    "Glasses_BlackOut",
    "glasses_blue",
    "glasses_brown",
    "glasses_Darkblue",
    "glasses_green",
    "glasses_orange",
    "glasses_pink",
    "glasses_purple",
    "glasses_red",
    "glasses_Scuba",
    "glasses_VISOR",
    "glasses_yellow",
    "gorge_reflection_gpu",
    "gorge_reflectionoffset",
    "gorge_reflectionoffset2",
    "graveyard_shootout",
    "gunclub",
    "gunclubrange",
    "gunshop",
    "gunstore",
    "half_direct",
    "hangar_lightsmod",
    "Hanger_INTmods",
    "heathaze",
    "heist_boat",
    "heist_boat_engineRoom",
    "heist_boat_norain",
    "helicamfirst",
    "heliGunCam",
    "Hicksbar",
    "HicksbarNEW",
    "hillstunnel",
    "Hint_cam",
    "hitped",
    "hud_def_blur",
    "hud_def_blur_switch",
    "hud_def_colorgrade",
    "hud_def_desat_cold",
    "hud_def_desat_cold_kill",
    "hud_def_desat_Franklin",
    "hud_def_desat_Michael",
    "hud_def_desat_Neutral",
    "hud_def_desat_switch",
    "hud_def_desat_Trevor",
    "hud_def_desatcrunch",
    "hud_def_flash",
    "hud_def_focus",
    "hud_def_Franklin",
    "hud_def_lensdistortion",
    "hud_def_lensdistortion_subtle",
    "hud_def_Michael",
    "hud_def_Trevor",
    "id1_11_tunnel",
    "ImpExp_Interior_01",
    "impexp_interior_01_lift",
    "IMpExt_Interior_02",
    "IMpExt_Interior_02_stair_cage",
    "InchOrange01",
    "InchOrange02",
    "InchPickup01",
    "InchPickup02",
    "InchPurple01",
    "InchPurple02",
    "int_amb_mult_large",
    "int_Barber1",
    "int_carmod_small",
    "int_carrier_control",
    "int_carrier_control_2",
    "int_carrier_hanger",
    "int_carrier_rear",
    "int_carrier_stair",
    "int_carshowroom",
    "int_chopshop",
    "int_clean_extlight_large",
    "int_clean_extlight_none",
    "int_clean_extlight_small",
    "int_ClothesHi",
    "int_clotheslow_large",
    "int_cluckinfactory_none",
    "int_cluckinfactory_small",
    "int_ControlTower_none",
    "int_ControlTower_small",
    "int_dockcontrol_small",
    "int_extlght_sm_cntrst",
    "int_extlight_large",
    "int_extlight_large_fog",
    "int_extlight_none",
    "int_extlight_none_dark",
    "int_extlight_none_dark_fog",
    "int_extlight_none_fog",
    "int_extlight_small",
    "int_extlight_small_clipped",
    "int_extlight_small_fog",
    "int_Farmhouse_none",
    "int_Farmhouse_small",
    "int_FranklinAunt_small",
    "INT_FullAmbientmult",
    "INT_FULLAmbientmult_art",
    "INT_FULLAmbientmult_both",
    "INT_garage",
    "int_GasStation",
    "int_hanger_none",
    "int_hanger_small",
    "int_Hospital2_DM",
    "int_Hospital_Blue",
    "int_Hospital_BlueB",
    "int_hospital_dark",
    "int_Hospital_DM",
    "int_hospital_small",
    "int_lesters",
    "int_Lost_none",
    "int_Lost_small",
    "INT_mall",
    "int_methlab_small",
    "int_motelroom",
    "INT_NO_fogALPHA",
    "INT_NoAmbientmult",
    "INT_NoAmbientmult_art",
    "INT_NoAmbientmult_both",
    "INT_NOdirectLight",
    "INT_nowaterREF",
    "int_office_Lobby",
    "int_office_LobbyHall",
    "INT_posh_hairdresser",
    "INT_smshop",
    "INT_smshop_indoor_bloom",
    "INT_smshop_inMOD",
    "INT_smshop_outdoor_bloom",
    "INT_streetlighting",
    "int_tattoo",
    "int_tattoo_B",
    "INT_trailer_cinema",
    "int_tunnel_none_dark",
    "interior_WATER_lighting",
    "introblue",
    "jewel_gas",
    "jewel_optim",
    "jewelry_entrance",
    "jewelry_entrance_INT",
    "jewelry_entrance_INT_fog",
    "Kifflom",
    "KT_underpass",
    "lab_none",
    "lab_none_dark",
    "lab_none_dark_fog",
    "lab_none_dark_OVR",
    "lab_none_exit",
    "lab_none_exit_OVR",
    "LectroDark",
    "LectroLight",
    "li",
    "LifeInvaderLOD",
    "lightning",
    "lightning_cloud",
    "lightning_strong",
    "lightning_weak",
    "LightPollutionHills",
    "lightpolution",
    "LIGHTSreduceFALLOFF",
    "LODmult_global_reduce",
    "LODmult_global_reduce_NOHD",
    "LODmult_HD_orphan_LOD_reduce",
    "LODmult_HD_orphan_reduce",
    "LODmult_LOD_reduce",
    "LODmult_SLOD1_reduce",
    "LODmult_SLOD2_reduce",
    "LODmult_SLOD3_reduce",
    "lodscaler",
    "LostTimeDark",
    "LostTimeFlash",
    "LostTimeLight",
    "maxlodscaler",
    "metro",
    "METRO_platform",
    "METRO_Tunnels",
    "METRO_Tunnels_entrance",
    "MichaelColorCode",
    "MichaelColorCodeBasic",
    "MichaelColorCodeBright",
    "MichaelsDarkroom",
    "MichaelsDirectional",
    "MichaelsNODirectional",
    "micheal",
    "micheals_lightsOFF",
    "michealspliff",
    "michealspliff_blend",
    "michealspliff_blend02",
    "militarybase_nightlight",
    "mineshaft",
    "morebloom",
    "morgue_dark",
    "morgue_dark_ovr",
    "Mp_apart_mid",
    "mp_bkr_int01_garage",
    "mp_bkr_int01_small_rooms",
    "mp_bkr_int01_transition",
    "mp_bkr_int02_garage",
    "mp_bkr_int02_hangout",
    "mp_bkr_int02_small_rooms",
    "mp_bkr_ware01",
    "mp_bkr_ware02_dry",
    "mp_bkr_ware02_standard",
    "mp_bkr_ware02_upgrade",
    "mp_bkr_ware03_basic",
    "mp_bkr_ware03_upgrade",
    "mp_bkr_ware04",
    "mp_bkr_ware05",
    "MP_Bull_tost",
    "MP_Bull_tost_blend",
    "MP_corona_heist",
    "MP_corona_heist_blend",
    "MP_corona_heist_BW",
    "MP_corona_heist_BW_night",
    "MP_corona_heist_DOF",
    "MP_corona_heist_night",
    "MP_corona_heist_night_blend",
    "MP_corona_selection",
    "MP_corona_switch",
    "MP_corona_tournament",
    "MP_corona_tournament_DOF",
    "MP_death_grade",
    "MP_death_grade_blend01",
    "MP_death_grade_blend02",
    "MP_deathfail_night",
    "mp_exec_office_01",
    "mp_exec_office_02",
    "mp_exec_office_03",
    "mp_exec_office_03_blue",
    "mp_exec_office_03C",
    "mp_exec_office_04",
    "mp_exec_office_05",
    "mp_exec_office_06",
    "mp_exec_warehouse_01",
    "MP_Garage_L",
    "MP_H_01_Bathroom",
    "MP_H_01_Bedroom",
    "MP_H_01_New",
    "MP_H_01_New_Bathroom",
    "MP_H_01_New_Bedroom",
    "MP_H_01_New_Study",
    "MP_H_01_Study",
    "MP_H_02",
    "MP_H_04",
    "mp_h_05",
    "MP_H_06",
    "mp_h_07",
    "mp_h_08",
    "MP_heli_cam",
    "mp_imx_intwaremed",
    "mp_imx_intwaremed_office",
    "mp_imx_mod_int_01",
    "MP_intro_logo",
    "MP_job_end_night",
    "MP_job_load",
    "MP_job_load_01",
    "MP_job_load_02",
    "MP_job_lose",
    "MP_job_preload",
    "MP_job_preload_blend",
    "MP_job_preload_night",
    "MP_job_win",
    "MP_Killstreak",
    "MP_Killstreak_blend",
    "mp_lad_day",
    "mp_lad_judgment",
    "mp_lad_night",
    "MP_Loser",
    "MP_Loser_blend",
    "MP_lowgarage",
    "MP_MedGarage",
    "MP_Powerplay",
    "MP_Powerplay_blend",
    "MP_race_finish",
    "MP_select",
    "Mp_Stilts",
    "Mp_Stilts2",
    "Mp_Stilts2_bath",
    "Mp_Stilts_gym",
    "Mp_Stilts_gym2",
    "MP_Studio_Lo",
    "MPApart_H_01",
    "MPApart_H_01_gym",
    "MPApartHigh",
    "MPApartHigh_palnning",
    "mugShot",
    "mugShot_lineup",
    "Multipayer_spectatorCam",
    "multiplayer_ped_fight",
    "nervousRON_fog",
    "NeutralColorCode",
    "NeutralColorCodeBasic",
    "NeutralColorCodeBright",
    "NeutralColorCodeLight",
    "NEW_abattoir",
    "new_bank",
    "NEW_jewel",
    "NEW_jewel_EXIT",
    "NEW_lesters",
    "new_MP_Garage_L",
    "NEW_ornate_bank",
    "NEW_ornate_bank_entrance",
    "NEW_ornate_bank_office",
    "NEW_ornate_bank_safe",
    "New_sewers",
    "NEW_shrinksOffice",
    "NEW_station_unfinished",
    "new_stripper_changing",
    "NEW_trevorstrailer",
    "NEW_tunnels",
    "NEW_tunnels_ditch",
    "new_tunnels_entrance",
    "NEW_tunnels_hole",
    "NEW_yellowtunnels",
    "NewMicheal",
    "NewMicheal_night",
    "NewMicheal_upstairs",
    "NewMichealgirly",
    "NewMichealstoilet",
    "NewMichealupstairs",
    "nextgen",
    "NG_blackout",
    "NG_deathfail_BW_base",
    "NG_deathfail_BW_blend01",
    "NG_deathfail_BW_blend02",
    "NG_filmic01",
    "NG_filmic02",
    "NG_filmic03",
    "NG_filmic04",
    "NG_filmic05",
    "NG_filmic06",
    "NG_filmic07",
    "NG_filmic08",
    "NG_filmic09",
    "NG_filmic10",
    "NG_filmic11",
    "NG_filmic12",
    "NG_filmic13",
    "NG_filmic14",
    "NG_filmic15",
    "NG_filmic16",
    "NG_filmic17",
    "NG_filmic18",
    "NG_filmic19",
    "NG_filmic20",
    "NG_filmic21",
    "NG_filmic22",
    "NG_filmic23",
    "NG_filmic24",
    "NG_filmic25",
    "NG_filmnoir_BW01",
    "NG_filmnoir_BW02",
    "NG_first",
    "nightvision",
    "NO_coronas",
    "NO_fog_alpha",
    "NO_streetAmbient",
    "NO_weather",
    "NoAmbientmult",
    "NoAmbientmult_interior",
    "NOdirectLight",
    "NoPedLight",
    "NOrain",
    "overwater",
    "Paleto",
    "paleto_nightlight",
    "paleto_opt",
    "PennedInDark",
    "PennedInLight",
    "PERSHING_water_reflect",
    "phone_cam",
    "phone_cam1",
    "phone_cam10",
    "phone_cam11",
    "phone_cam12",
    "phone_cam13",
    "phone_cam2",
    "phone_cam3",
    "phone_cam3_REMOVED",
    "phone_cam4",
    "phone_cam5",
    "phone_cam6",
    "phone_cam7",
    "phone_cam8",
    "phone_cam8_REMOVED",
    "phone_cam9",
    "plane_inside_mode",
    "player_transition",
    "player_transition_no_scanlines",
    "player_transition_scanlines",
    "PlayerSwitchNeutralFlash",
    "PlayerSwitchPulse",
    "plaza_carpark",
    "PoliceStation",
    "PoliceStationDark",
    "polluted",
    "poolsidewaterreflection2",
    "PORT_heist_underwater",
    "powerplant_nightlight",
    "powerstation",
    "PPFilter",
    "PPGreen01",
    "PPGreen02",
    "PPOrange01",
    "PPOrange02",
    "PPPink01",
    "PPPink02",
    "PPPurple01",
    "PPPurple02",
    "prison_nightlight",
    "projector",
    "prologue",
    "prologue_ending_fog",
    "prologue_ext_art_amb",
    "prologue_reflection_opt",
    "prologue_shootout",
    "Prologue_shootout_opt",
    "pulse",
    "RaceTurboDark",
    "RaceTurboFlash",
    "RaceTurboLight",
    "ranch",
    "REDMIST",
    "REDMIST_blend",
    "ReduceDrawDistance",
    "ReduceDrawDistanceMAP",
    "ReduceDrawDistanceMission",
    "reducelightingcost",
    "ReduceSSAO",
    "reducewaterREF",
    "refit",
    "reflection_correct_ambient",
    "RemoteSniper",
    "resvoire_reflection",
    "rply_brightness",
    "rply_brightness_neg",
    "rply_contrast",
    "rply_contrast_neg",
    "rply_motionblur",
    "rply_saturation",
    "rply_saturation_neg",
    "rply_vignette",
    "rply_vignette_neg",
    "SALTONSEA",
    "sandyshore_nightlight",
    "SAWMILL",
    "scanline_cam",
    "scanline_cam_cheap",
    "scope_zoom_in",
    "scope_zoom_out",
    "secret_camera",
    "services_nightlight",
    "shades_pink",
    "shades_yellow",
    "SheriffStation",
    "ship_explosion_underwater",
    "ship_lighting",
    "Shop247",
    "Shop247_none",
    "sleeping",
    "Sniper",
    "SP1_03_drawDistance",
    "spectator1",
    "spectator10",
    "spectator2",
    "spectator3",
    "spectator4",
    "spectator5",
    "spectator6",
    "spectator7",
    "spectator8",
    "spectator9",
    "StadLobby",
    "stc_coroners",
    "stc_deviant_bedroom",
    "stc_deviant_lounge",
    "stc_franklinsHouse",
    "stc_trevors",
    "stoned",
    "stoned_aliens",
    "stoned_cutscene",
    "stoned_monkeys",
    "StreetLighting",
    "StreetLightingJunction",
    "StreetLightingtraffic",
    "STRIP_changing",
    "STRIP_nofog",
    "STRIP_office",
    "STRIP_stage",
    "StuntFastDark",
    "StuntFastLight",
    "StuntSlowDark",
    "StuntSlowLight",
    "subBASE_water_ref",
    "sunglasses",
    "superDARK",
    "switch_cam_1",
    "switch_cam_2",
    "telescope",
    "TinyGreen01",
    "TinyGreen02",
    "TinyPink01",
    "TinyPink02",
    "TinyRacerMoBlur",
    "torpedo",
    "traffic_skycam",
    "trailer_explosion_optimise",
    "TREVOR",
    "TrevorColorCode",
    "TrevorColorCodeBasic",
    "TrevorColorCodeBright",
    "Trevors_room",
    "trevorspliff",
    "trevorspliff_blend",
    "trevorspliff_blend02",
    "Tunnel",
    "tunnel_entrance",
    "tunnel_entrance_INT",
    "TUNNEL_green",
    "Tunnel_green1",
    "TUNNEL_green_ext",
    "tunnel_id1_11",
    "TUNNEL_orange",
    "TUNNEL_orange_exterior",
    "TUNNEL_white",
    "TUNNEL_yellow",
    "TUNNEL_yellow_ext",
    "ufo",
    "ufo_deathray",
    "underwater",
    "underwater_deep",
    "underwater_deep_clear",
    "v_abattoir",
    "V_Abattoir_Cold",
    "v_bahama",
    "v_cashdepot",
    "V_CIA_Facility",
    "v_dark",
    "V_FIB_IT3",
    "V_FIB_IT3_alt",
    "V_FIB_IT3_alt5",
    "V_FIB_stairs",
    "v_foundry",
    "v_janitor",
    "v_jewel2",
    "v_metro",
    "V_Metro2",
    "V_Metro_station",
    "v_michael",
    "v_michael_lounge",
    "V_Office_smoke",
    "V_Office_smoke_ext",
    "V_Office_smoke_Fire",
    "v_recycle",
    "V_recycle_dark",
    "V_recycle_light",
    "V_recycle_mainroom",
    "v_rockclub",
    "V_Solomons",
    "v_strip3",
    "V_strip_nofog",
    "V_strip_office",
    "v_strpchangerm",
    "v_sweat",
    "v_sweat_entrance",
    "v_sweat_NoDirLight",
    "v_torture",
    "Vagos",
    "vagos_extlight_small",
    "VAGOS_new_garage",
    "VAGOS_new_hangout",
    "VagosSPLASH",
    "VC_tunnel_entrance",
    "vehicle_subint",
    "venice_canal_tunnel",
    "vespucci_garage",
    "VolticBlur",
    "VolticFlash",
    "VolticGold",
    "WAREHOUSE",
    "WATER _lab_cooling",
    "WATER_CH2_06_01_03",
    "WATER_CH2_06_02",
    "WATER_CH2_06_04",
    "WATER_cove",
    "WATER_hills",
    "WATER_ID2_21",
    "WATER_lab",
    "WATER_militaryPOOP",
    "WATER_muddy",
    "WATER_port",
    "WATER_REF_malibu",
    "WATER_refmap_high",
    "WATER_refmap_hollywoodlake",
    "WATER_refmap_low",
    "WATER_refmap_med",
    "WATER_refmap_off",
    "WATER_refmap_poolside",
    "WATER_refmap_silverlake",
    "WATER_refmap_venice",
    "WATER_refmap_verylow",
    "WATER_resevoir",
    "WATER_RichmanStuntJump",
    "WATER_river",
    "WATER_salton",
    "WATER_salton_bottom",
    "WATER_shore",
    "WATER_silty",
    "WATER_silverlake",
    "whitenightlighting",
    "WhiteOut",
    "winning_room",
    "yacht_DLC",
    "yell_tunnel_nodirect"
}

function MiscSettingsMenu.CreateMenu()
    menu = Menu:New("Misc Settings", "Miscellaneous Settings")
    MenuController:AddMenu(menu)

    teleportOptionsMenu = Menu:New("Misc Settings", "Teleport Options")
    keybindSettingsMenu = Menu:New("Misc Settings", "Keybind Settings")
    connectionOptionsMenu = Menu:New("Misc Settings", "Connection Options")
    developerToolsMenu = Menu:New("Misc Settings", "Developer Tools")

    MenuController:AddMenu(developerToolsMenu)
    MenuController:AddMenu(teleportOptionsMenu)
    MenuController:AddMenu(keybindSettingsMenu)
    MenuController:AddMenu(connectionOptionsMenu)

    local themeList = MenuListItem:New("Theme", Theme.GetNames(), Theme.GetIndex(),
        "Change the look of the menu. Saved automatically.")
    local resetMenuPositionBtn = MenuItem:New("Reset Menu Position",
        "Move the menu back to its default corner. To move the menu, hold Left Alt and drag the banner with the mouse.")
    local rightAlignMenuCheckbox = MenuCheckboxItem:New("Right Align Menu",
        "If you want vMenu to appear on the left side of your screen, disable this option.",
        MiscSettingsMenu.RightAlignMenu)
    local disablePmsCheckbox = MenuCheckboxItem:New("Disable Private Messages",
        "Prevent others from sending you a private message via the Online Players menu.",
        MiscSettingsMenu.DisablePrivateMessages)
    local disableControllerCheckbox = MenuCheckboxItem:New("Disable Controller Support",
        "This disables the controller menu toggle key. This does NOT disable the navigation buttons.",
        MiscSettingsMenu.DisableControllerSupport)
    local speedKmhCheckbox = MenuCheckboxItem:New("Show Speed KM/H",
        "Show a speedometer on your screen indicating your speed in KM/h.", MiscSettingsMenu.ShowSpeedoKmh)
    local speedMphCheckbox = MenuCheckboxItem:New("Show Speed MPH",
        "Show a speedometer on your screen indicating your speed in MPH.", MiscSettingsMenu.ShowSpeedoMph)

    local teleportOptionsBtn = MenuItem:New("Teleport Options", "Various teleport options.")
    teleportOptionsBtn.Label = "→→→"
    local keybindSettingsBtn = MenuItem:New("Keybind Settings", "Enable or disable keybinds for some options.")
    keybindSettingsBtn.Label = "→→→"
    local connectionOptionsBtn = MenuItem:New("Connection Options", "Server connection/game quit options.")
    connectionOptionsBtn.Label = "→→→"
    local developerToolsBtn = MenuItem:New("Developer Tools", "Various development/debug tools.")
    developerToolsBtn.Label = "→→→"

    local showLocationCheckbox = MenuCheckboxItem:New("Location Display",
        "Shows your current location and heading, as well as the nearest cross road. ~r~Warning: This feature can take up to -4.6 FPS when running at 60 Hz.",
        MiscSettingsMenu.ShowLocation)
    local drawTimeCheckbox = MenuCheckboxItem:New("Show Time On Screen", "Shows you the current time on screen.",
        MiscSettingsMenu.DrawTimeOnScreen)
    local joinQuitNotifsCheckbox = MenuCheckboxItem:New("Join / Quit Notifications",
        "Receive notifications when someone joins or leaves the server.", MiscSettingsMenu.JoinQuitNotifications)
    local deathNotifsCheckbox = MenuCheckboxItem:New("Death Notifications",
        "Receive notifications when someone dies or gets killed.", MiscSettingsMenu.DeathNotifications)
    local nightVisionCheckbox = MenuCheckboxItem:New("Toggle Night Vision", "Enable or disable night vision.",
        MiscSettingsMenu.NightVision)
    local thermalVisionCheckbox = MenuCheckboxItem:New("Toggle Thermal Vision", "Enable or disable thermal vision.",
        MiscSettingsMenu.ThermalVision)
    local locationBlipsCheckbox = MenuCheckboxItem:New("Location Blips",
        "Shows blips on the map for some common locations.", MiscSettingsMenu.ShowLocationBlips)
    local playerBlipsCheckbox = MenuCheckboxItem:New("Show Player Blips",
        "Shows blips on the map for all players. ~y~Note for when the server is using OneSync Infinity: this won't work for players that are too far away.",
        MiscSettingsMenu.ShowPlayerBlips)
    local playerNamesCheckbox = MenuCheckboxItem:New("Show Player Names", "Enables or disables player overhead names.",
        MiscSettingsMenu.ShowOverheadNames)
    local respawnDefaultCheckbox = MenuCheckboxItem:New("Respawn As Default MP Character",
        "If you enable this, then you will (re)spawn as your default saved MP character. To set your default character, go to one of your saved MP Characters and click the 'Set As Default Character' button.",
        MiscSettingsMenu.RespawnDefaultCharacter)
    local restoreAppearanceCheckbox = MenuCheckboxItem:New("Restore Player Appearance",
        "Restore your player's skin whenever you respawn after being dead. Re-joining a server will not restore your previous skin.",
        MiscSettingsMenu.RestorePlayerAppearance)
    local restoreWeaponsCheckbox = MenuCheckboxItem:New("Restore Player Weapons",
        "Restore your weapons whenever you respawn after being dead. Re-joining a server will not restore your previous weapons.",
        MiscSettingsMenu.RestorePlayerWeapons)
    local hideRadarCheckbox = MenuCheckboxItem:New("Hide Radar", "Hide the radar/minimap.", MiscSettingsMenu.HideRadar)
    local hideHudCheckbox = MenuCheckboxItem:New("Hide HUD", "Hide all HUD elements.", MiscSettingsMenu.HideHud)
    local lockCamXCheckbox = MenuCheckboxItem:New("Lock Camera Horizontal Rotation",
        "Locks your camera horizontal rotation. Could be useful in helicopters.", MiscSettingsMenu.LockCameraX)
    local lockCamYCheckbox = MenuCheckboxItem:New("Lock Camera Vertical Rotation",
        "Locks your camera vertical rotation. Could be useful in helicopters.", MiscSettingsMenu.LockCameraY)
    local mpPedPreviewCheckbox = MenuCheckboxItem:New("3D Ped Preview",
        "Shows your saved peds and saved MP characters beside the menu while browsing them. Hold Q / E to rotate the preview.",
        MiscSettingsMenu.MPPedPreviews)
    local saveSettingsBtn = MenuItem:New("Save Personal Settings",
        "Save your current settings. All saving is done on the client side.")
    saveSettingsBtn.RightIcon = Icon.TICK

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.MSDevTools) or
        PermissionsManager.IsAllowed(PermissionsManager.Permission.MSClearArea) or
        PermissionsManager.IsAllowed(PermissionsManager.Permission.MSShowCoordinates) or
        PermissionsManager.IsAllowed(PermissionsManager.Permission.MSEntitySpawner) then
        menu:AddMenuItem(developerToolsBtn)
        MenuController:BindMenuItem(menu, developerToolsMenu, developerToolsBtn)
    end

    menu:AddMenuItem(themeList)
    menu:AddMenuItem(rightAlignMenuCheckbox)
    menu:AddMenuItem(resetMenuPositionBtn)
    menu:AddMenuItem(disablePmsCheckbox)
    menu:AddMenuItem(disableControllerCheckbox)
    menu:AddMenuItem(speedKmhCheckbox)
    menu:AddMenuItem(speedMphCheckbox)
    menu:AddMenuItem(keybindSettingsBtn)

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.MSTeleportToWp) or
        PermissionsManager.IsAllowed(PermissionsManager.Permission.MSTeleportLocations) or
        PermissionsManager.IsAllowed(PermissionsManager.Permission.MSTeleportToCoord) then
        menu:AddMenuItem(teleportOptionsBtn)
        MenuController:BindMenuItem(menu, teleportOptionsMenu, teleportOptionsBtn)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.MSConnectionMenu) then
        menu:AddMenuItem(connectionOptionsBtn)
        MenuController:BindMenuItem(menu, connectionOptionsMenu, connectionOptionsBtn)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.MSShowLocation) then
        menu:AddMenuItem(showLocationCheckbox)
    end
    menu:AddMenuItem(drawTimeCheckbox)

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.MSJoinQuitNotifs) then
        menu:AddMenuItem(joinQuitNotifsCheckbox)
    end
    if PermissionsManager.IsAllowed(PermissionsManager.Permission.MSDeathNotifs) then
        menu:AddMenuItem(deathNotifsCheckbox)
    end
    if PermissionsManager.IsAllowed(PermissionsManager.Permission.MSNightVision) then
        menu:AddMenuItem(nightVisionCheckbox)
    end
    if PermissionsManager.IsAllowed(PermissionsManager.Permission.MSThermalVision) then
        menu:AddMenuItem(thermalVisionCheckbox)
    end
    if PermissionsManager.IsAllowed(PermissionsManager.Permission.MSLocationBlips) then
        menu:AddMenuItem(locationBlipsCheckbox)
    end
    if PermissionsManager.IsAllowed(PermissionsManager.Permission.MSPlayerBlips) then
        menu:AddMenuItem(playerBlipsCheckbox)
    end
    if PermissionsManager.IsAllowed(PermissionsManager.Permission.MSOverheadNames) then
        menu:AddMenuItem(playerNamesCheckbox)
    end

    menu:AddMenuItem(respawnDefaultCheckbox)

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.MSRestoreAppearance) then
        menu:AddMenuItem(restoreAppearanceCheckbox)
    end
    if PermissionsManager.IsAllowed(PermissionsManager.Permission.MSRestoreWeapons) then
        menu:AddMenuItem(restoreWeaponsCheckbox)
    end

    menu:AddMenuItem(hideRadarCheckbox)
    menu:AddMenuItem(hideHudCheckbox)
    menu:AddMenuItem(lockCamXCheckbox)
    menu:AddMenuItem(lockCamYCheckbox)
    menu:AddMenuItem(mpPedPreviewCheckbox)
    menu:AddMenuItem(saveSettingsBtn)

    MenuController:BindMenuItem(menu, keybindSettingsMenu, keybindSettingsBtn)

    local tpToWaypointBtn = MenuItem:New("Teleport To Waypoint", "Teleport to the waypoint on your map.")
    local tpToCoordsBtn = MenuItem:New("Teleport To Coords",
        "Enter x, y, z coordinates and you will be teleported to that location.")
    local teleportLocationsBtn = MenuItem:New("Teleport Locations",
        "Teleport to pre-configured locations, added by the server owner.")
    teleportLocationsBtn.Label = "→→→"
    local saveLocationBtn = MenuItem:New("Save Teleport Location",
        "Adds your current location to the teleport locations menu and saves it on the server.")

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.MSTeleportToWp) then
        teleportOptionsMenu:AddMenuItem(tpToWaypointBtn)
    end
    if PermissionsManager.IsAllowed(PermissionsManager.Permission.MSTeleportToCoord) then
        teleportOptionsMenu:AddMenuItem(tpToCoordsBtn)
    end
    if PermissionsManager.IsAllowed(PermissionsManager.Permission.MSTeleportLocations) then
        teleportOptionsMenu:AddMenuItem(teleportLocationsBtn)
    end
    if PermissionsManager.IsAllowed(PermissionsManager.Permission.MSTeleportSaveLocation) then
        teleportOptionsMenu:AddMenuItem(saveLocationBtn)
    end

    local kbTpToWaypointCheckbox = MenuCheckboxItem:New("Teleport To Waypoint",
        "Teleport to your waypoint when pressing the keybind. By default, this keybind is set to ~r~F7~s~.",
        MiscSettingsMenu.KbTpToWaypoint)
    local kbDriftModeCheckbox = MenuCheckboxItem:New("Drift Mode",
        "Makes your vehicle have almost no traction while holding left shift on keyboard, or X on controller.",
        MiscSettingsMenu.KbDriftMode)
    local kbRecordKeysCheckbox = MenuCheckboxItem:New("Recording Controls",
        "Enables or disables the recording (gameplay recording for the Rockstar editor) hotkeys on both keyboard and controller.",
        MiscSettingsMenu.KbRecordKeys)
    local kbRadarKeysCheckbox = MenuCheckboxItem:New("Minimap Controls",
        "Press the Multiplayer Info (Z on keyboard, down arrow on controller) key to switch between expanded radar and normal radar.",
        MiscSettingsMenu.KbRadarKeys)
    local kbPointKeysCheckbox = MenuCheckboxItem:New("Finger Point Controls",
        "Enables the finger point toggle key. The default QWERTY keyboard mapping for this is 'B', or for controller quickly double tap the right analog stick.",
        MiscSettingsMenu.KbPointKeys)
    local kbBackBtn = MenuItem:New("Back", "Go back to the previous menu.")

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.MSTeleportToWp) then
        keybindSettingsMenu:AddMenuItem(kbTpToWaypointCheckbox)
    end
    if PermissionsManager.IsAllowed(PermissionsManager.Permission.MSDriftMode) then
        keybindSettingsMenu:AddMenuItem(kbDriftModeCheckbox)
    end
    keybindSettingsMenu:AddMenuItem(kbRecordKeysCheckbox)
    keybindSettingsMenu:AddMenuItem(kbRadarKeysCheckbox)
    keybindSettingsMenu:AddMenuItem(kbPointKeysCheckbox)
    keybindSettingsMenu:AddMenuItem(kbBackBtn)

    local quitSessionBtn = MenuItem:New("Quit Session",
        "Leaves you connected to the server, but quits the network session. ~r~Cannot be used when you are the host.")
    local rejoinSessionBtn = MenuItem:New("Re-join Session",
        "This may not work in all cases, but you can try to use this if you want to re-join the previous session after clicking 'Quit Session'.")
    local quitGameBtn = MenuItem:New("Quit Game", "Exits the game after 5 seconds.")
    local disconnectBtn = MenuItem:New("Disconnect From Server",
        "Disconnects you from the server and returns you to the serverlist. ~r~This feature is not recommended, quit the game completely instead.")

    connectionOptionsMenu:AddMenuItem(quitSessionBtn)
    connectionOptionsMenu:AddMenuItem(rejoinSessionBtn)
    connectionOptionsMenu:AddMenuItem(quitGameBtn)
    connectionOptionsMenu:AddMenuItem(disconnectBtn)

    local clearAreaBtn = MenuItem:New("Clear Area",
        "Clears the area around your player (100 meters). Damage, dirt, peds, props, vehicles, etc. Everything gets cleaned up.")
    local showCoordsCheckbox = MenuCheckboxItem:New("Show Coordinates",
        "Show your current coordinates at the top of your screen.", MiscSettingsMenu.ShowCoordinates)
    local vehDimensionsCheckbox = MenuCheckboxItem:New("Show Vehicle Dimensions",
        "Draws the model outlines for every vehicle that's currently close to you.",
        MiscSettingsMenu.ShowVehicleDimensions)
    local pedDimensionsCheckbox = MenuCheckboxItem:New("Show Ped Dimensions",
        "Draws the model outlines for every ped that's currently close to you.", MiscSettingsMenu.ShowPedDimensions)
    local propDimensionsCheckbox = MenuCheckboxItem:New("Show Prop Dimensions",
        "Draws the model outlines for every prop that's currently close to you.", MiscSettingsMenu.ShowPropDimensions)
    local showEntityHandlesCheckbox = MenuCheckboxItem:New("Show Entity Handles",
        "Draws the entity handles for all close entities.", MiscSettingsMenu.ShowEntityHandles)
    local showEntityModelsCheckbox = MenuCheckboxItem:New("Show Entity Models",
        "Draws the entity models for all close entities.", MiscSettingsMenu.ShowEntityModels)
    local showEntityNetOwnersCheckbox = MenuCheckboxItem:New("Show Network Owners",
        "Draws the entity network owner for all close entities.", MiscSettingsMenu.ShowEntityNetOwners)

    local dimensionRangeList = {}
    for i = 1, 20 do
        table.insert(dimensionRangeList, tostring(i * 10) .. "m")
    end
    local dimensionsRangeSlider = MenuListItem:New("Show Dimensions Radius",
        dimensionRangeList, 5, "Set the entity model/handle/dimension draw range.")

    local timecycleList = {}
    for i, tc in ipairs(timecycleModifiers) do
        table.insert(timecycleList, tc .. " (" .. i .. "/" .. #timecycleModifiers .. ")")
    end
    local timecycleListItem = MenuListItem:New("Timecycle Modifier",
        timecycleList, 1, "Select a timecycle modifier and enable the checkbox below.")
    local enableTimecycleCheckbox = MenuCheckboxItem:New("Enable Timecycle Modifier",
        "Enable or disable the timecycle modifier from the list above.", MiscSettingsMenu.TimecycleEnabled)
    local timecycleStrengthList = {}
    for i = 0, 20 do
        table.insert(timecycleStrengthList, tostring(i * 5) .. "%")
    end
    local timecycleStrengthSlider = MenuListItem:New("Timecycle Modifier Strength",
        timecycleStrengthList, 20, "Set the timecycle modifier intensity.")

    local entitySpawnerBtn = MenuItem:New("Entity Spawner",
        "Spawn and move entities. Enter a model name to spawn.")

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.MSClearArea) then
        developerToolsMenu:AddMenuItem(clearAreaBtn)
    end
    if PermissionsManager.IsAllowed(PermissionsManager.Permission.MSShowCoordinates) then
        developerToolsMenu:AddMenuItem(showCoordsCheckbox)
    end
    if PermissionsManager.IsAllowed(PermissionsManager.Permission.MSDevTools) then
        developerToolsMenu:AddMenuItem(vehDimensionsCheckbox)
        developerToolsMenu:AddMenuItem(pedDimensionsCheckbox)
        developerToolsMenu:AddMenuItem(propDimensionsCheckbox)
        developerToolsMenu:AddMenuItem(showEntityHandlesCheckbox)
        developerToolsMenu:AddMenuItem(showEntityModelsCheckbox)
        developerToolsMenu:AddMenuItem(showEntityNetOwnersCheckbox)
        developerToolsMenu:AddMenuItem(dimensionsRangeSlider)
    end

    developerToolsMenu:AddMenuItem(timecycleListItem)
    developerToolsMenu:AddMenuItem(enableTimecycleCheckbox)
    developerToolsMenu:AddMenuItem(timecycleStrengthSlider)

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.MSEntitySpawner) then
        developerToolsMenu:AddMenuItem(entitySpawnerBtn)
    end

    menu.OnCheckboxChange = function(sender, item, index, checked)
        if item == rightAlignMenuCheckbox then
            MiscSettingsMenu.RightAlignMenu = checked
            MenuController:SetMenuAlignment(checked and "right" or "left")
            Notify.Custom("Menu alignment changed to " ..
                (checked and "~y~right~s~" or "~y~left~s~") .. ". ~c~Edit positions in Menu.lua")
        elseif item == disablePmsCheckbox then
            MiscSettingsMenu.DisablePrivateMessages = checked
            Notify.Custom("Private messages " .. (checked and "~r~disabled~s~" or "~g~enabled~s~") .. ".")
        elseif item == disableControllerCheckbox then
            MiscSettingsMenu.DisableControllerSupport = checked
            Notify.Custom("Controller support " .. (checked and "~r~disabled~s~" or "~g~enabled~s~") .. ".")
        elseif item == speedKmhCheckbox then
            MiscSettingsMenu.ShowSpeedoKmh = checked
            Notify.Custom("Speedometer (KM/H) " .. (checked and "~g~enabled~s~" or "~r~disabled~s~") .. ".")
        elseif item == speedMphCheckbox then
            MiscSettingsMenu.ShowSpeedoMph = checked
            Notify.Custom("Speedometer (MPH) " .. (checked and "~g~enabled~s~" or "~r~disabled~s~") .. ".")
        elseif item == showLocationCheckbox then
            MiscSettingsMenu.ShowLocation = checked
            Notify.Custom("Location display " .. (checked and "~g~enabled~s~" or "~r~disabled~s~") .. ".")
        elseif item == drawTimeCheckbox then
            MiscSettingsMenu.DrawTimeOnScreen = checked
            Notify.Custom("Time display " .. (checked and "~g~enabled~s~" or "~r~disabled~s~") .. ".")
        elseif item == joinQuitNotifsCheckbox then
            MiscSettingsMenu.JoinQuitNotifications = checked
            Notify.Custom("Join/Quit notifications " .. (checked and "~g~enabled~s~" or "~r~disabled~s~") .. ".")
        elseif item == deathNotifsCheckbox then
            MiscSettingsMenu.DeathNotifications = checked
            Notify.Custom("Death notifications " .. (checked and "~g~enabled~s~" or "~r~disabled~s~") .. ".")
        elseif item == nightVisionCheckbox then
            MiscSettingsMenu.NightVision = checked
            SetNightvision(checked)
        elseif item == thermalVisionCheckbox then
            MiscSettingsMenu.ThermalVision = checked
            SetSeethrough(checked)
        elseif item == locationBlipsCheckbox then
            MiscSettingsMenu.ShowLocationBlips = checked
            MiscSettingsMenu.ToggleLocationBlips(checked)
            Notify.Custom("Location blips " .. (checked and "~g~enabled~s~" or "~r~disabled~s~") .. ".")
        elseif item == playerBlipsCheckbox then
            MiscSettingsMenu.ShowPlayerBlips = checked
            Notify.Custom("Player blips " .. (checked and "~g~enabled~s~" or "~r~disabled~s~") .. ".")
        elseif item == playerNamesCheckbox then
            MiscSettingsMenu.ShowOverheadNames = checked
            Notify.Custom("Player names " .. (checked and "~g~enabled~s~" or "~r~disabled~s~") .. ".")
        elseif item == respawnDefaultCheckbox then
            MiscSettingsMenu.RespawnDefaultCharacter = checked
            Notify.Custom("Respawn as default MP character " .. (checked and "~g~enabled~s~" or "~r~disabled~s~") .. ".")
        elseif item == restoreAppearanceCheckbox then
            MiscSettingsMenu.RestorePlayerAppearance = checked
            Notify.Custom("Restore appearance on respawn " .. (checked and "~g~enabled~s~" or "~r~disabled~s~") .. ".")
        elseif item == restoreWeaponsCheckbox then
            MiscSettingsMenu.RestorePlayerWeapons = checked
            Notify.Custom("Restore weapons on respawn " .. (checked and "~g~enabled~s~" or "~r~disabled~s~") .. ".")
        elseif item == hideRadarCheckbox then
            MiscSettingsMenu.HideRadar = checked
            if checked then
                DisplayRadar(false)
            else
                DisplayRadar(true)
            end
        elseif item == hideHudCheckbox then
            MiscSettingsMenu.HideHud = checked
            DisplayHud(not checked)
        elseif item == lockCamXCheckbox then
            MiscSettingsMenu.LockCameraX = checked
        elseif item == lockCamYCheckbox then
            MiscSettingsMenu.LockCameraY = checked
        elseif item == mpPedPreviewCheckbox then
            MiscSettingsMenu.MPPedPreviews = checked
            Notify.Custom("3D Ped Preview " .. (checked and "~g~enabled~s~" or "~r~disabled~s~") .. ".")
        end
    end

    menu.OnItemSelect = function(sender, item, index)
        if item == saveSettingsBtn then
            MiscSettingsMenu.SaveSettings()
            PlayerOptionsMenu.SaveSettings()
            VehicleOptionsMenu.SaveSettings()
            Notify.Success("Settings saved!")
        elseif item == resetMenuPositionBtn then
            MenuController:ResetPosition()
            Notify.Success("Menu position reset.")
        end
    end

    menu.OnListIndexChange = function(sender, item, oldIndex, newIndex, itemIndex)
        if item == themeList then
            local theme = Theme.Themes[newIndex]
            if theme then
                Theme.Set(theme.code)
            end
        end
    end

    teleportOptionsMenu.OnItemSelect = function(sender, item, index)
        if item == tpToWaypointBtn then
            MiscSettingsMenu.TeleportToWaypoint()
        elseif item == tpToCoordsBtn then
            MiscSettingsMenu.TeleportToCoords()
        elseif item == saveLocationBtn then
            MiscSettingsMenu.SaveTeleportLocation()
        end
    end

    keybindSettingsMenu.OnCheckboxChange = function(sender, item, index, checked)
        if item == kbTpToWaypointCheckbox then
            MiscSettingsMenu.KbTpToWaypoint = checked
        elseif item == kbDriftModeCheckbox then
            MiscSettingsMenu.KbDriftMode = checked
        elseif item == kbRecordKeysCheckbox then
            MiscSettingsMenu.KbRecordKeys = checked
        elseif item == kbRadarKeysCheckbox then
            MiscSettingsMenu.KbRadarKeys = checked
        elseif item == kbPointKeysCheckbox then
            MiscSettingsMenu.KbPointKeys = checked
        end
    end

    keybindSettingsMenu.OnItemSelect = function(sender, item, index)
        if item == kbBackBtn then
            keybindSettingsMenu:GoBack()
        end
    end

    connectionOptionsMenu.OnItemSelect = function(sender, item, index)
        if item == quitSessionBtn then
            if NetworkIsSessionActive() then
                if NetworkIsHost() then
                    Notify.Error("Sorry, you cannot leave the session when you are the host.")
                else
                    NetworkSessionEnd(true, true)
                    Notify.Info("You have left the session.")
                end
            else
                Notify.Error("You are currently not in any session.")
            end
        elseif item == rejoinSessionBtn then
            if NetworkIsSessionActive() then
                Notify.Error("You are already connected to a session.")
            else
                Notify.Info("Attempting to re-join the session.")
                NetworkSessionHost(-1, 32, false)
            end
        elseif item == quitGameBtn then
            Notify.Alert("The game will exit in 5 seconds.")
            Citizen.Wait(5000)
            ForceSocialClubUpdate()
        elseif item == disconnectBtn then
            Notify.Alert("Disconnecting from server...")
            Citizen.Wait(1000)
            TriggerServerEvent("vMenu:DisconnectPlayer")
        end
    end

    developerToolsMenu.OnCheckboxChange = function(sender, item, index, checked)
        if item == showCoordsCheckbox then
            MiscSettingsMenu.ShowCoordinates = checked
        elseif item == vehDimensionsCheckbox then
            MiscSettingsMenu.ShowVehicleDimensions = checked
        elseif item == pedDimensionsCheckbox then
            MiscSettingsMenu.ShowPedDimensions = checked
        elseif item == propDimensionsCheckbox then
            MiscSettingsMenu.ShowPropDimensions = checked
        elseif item == showEntityHandlesCheckbox then
            MiscSettingsMenu.ShowEntityHandles = checked
        elseif item == showEntityModelsCheckbox then
            MiscSettingsMenu.ShowEntityModels = checked
        elseif item == showEntityNetOwnersCheckbox then
            MiscSettingsMenu.ShowEntityNetOwners = checked
        elseif item == enableTimecycleCheckbox then
            MiscSettingsMenu.TimecycleEnabled = checked
            ClearTimecycleModifier()
            if checked then
                local tcIndex = timecycleListItem.ListIndex
                SetTimecycleModifier(timecycleModifiers[tcIndex])
                local strength = (timecycleStrengthSlider.ListIndex - 1) / 20.0
                SetTimecycleModifierStrength(strength)
            end
        end
    end

    developerToolsMenu.OnListIndexChange = function(sender, item, oldIndex, newIndex, itemIndex)
        if item == timecycleListItem then
            MiscSettingsMenu.TimecycleModifierIndex = newIndex
            if MiscSettingsMenu.TimecycleEnabled then
                ClearTimecycleModifier()
                SetTimecycleModifier(timecycleModifiers[newIndex])
                local strength = (timecycleStrengthSlider.ListIndex - 1) / 20.0
                SetTimecycleModifierStrength(strength)
            end
        elseif item == timecycleStrengthSlider then
            local strength = (newIndex - 1) / 20.0
            MiscSettingsMenu.TimecycleStrength = strength
            if MiscSettingsMenu.TimecycleEnabled then
                SetTimecycleModifierStrength(strength)
            end
        elseif item == dimensionsRangeSlider then
            MiscSettingsMenu.DimensionsRange = newIndex * 10.0
        end
    end

    developerToolsMenu.OnItemSelect = function(sender, item, index)
        if item == clearAreaBtn then
            MiscSettingsMenu.ClearArea()
        elseif item == entitySpawnerBtn then
            MiscSettingsMenu.SpawnEntity()
        end
    end

    return menu
end

function MiscSettingsMenu.GetMenu()
    if menu == nil then
        MiscSettingsMenu.CreateMenu()
    end
    return menu
end

function MiscSettingsMenu.TeleportToWaypoint()
    local ped = PlayerPedId()
    local waypoint = GetFirstBlipInfoId(8)

    if DoesBlipExist(waypoint) then
        local coords = GetBlipInfoIdCoord(waypoint)
        local groundZ = 0.0

        for height = 1, 1000 do
            local found, z = GetGroundZFor_3dCoord(coords.x, coords.y, height + 0.0, false)
            if found then
                groundZ = z
                break
            end
        end

        SetEntityCoords(ped, coords.x, coords.y, groundZ + 1.0, false, false, false, true)
        Notify.Success("Teleported to waypoint.")
        TriggerServerEvent("vMenu:LogTeleport", "Waypoint", coords.x, coords.y, groundZ + 1.0)
    else
        Notify.Error("No waypoint set on the map.")
    end
end

function MiscSettingsMenu.TeleportToCoords()
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 30)
    while UpdateOnscreenKeyboard() == 0 do
        Wait(0)
    end

    if GetOnscreenKeyboardResult() then
        local xStr = GetOnscreenKeyboardResult()
        local x = tonumber(xStr)

        if not x then
            Notify.Error("Invalid X coordinate.")
            return
        end

        DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 30)
        while UpdateOnscreenKeyboard() == 0 do
            Wait(0)
        end

        if GetOnscreenKeyboardResult() then
            local yStr = GetOnscreenKeyboardResult()
            local y = tonumber(yStr)

            if not y then
                Notify.Error("Invalid Y coordinate.")
                return
            end

            DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 30)
            while UpdateOnscreenKeyboard() == 0 do
                Wait(0)
            end

            if GetOnscreenKeyboardResult() then
                local zStr = GetOnscreenKeyboardResult()
                local z = tonumber(zStr)

                if not z then
                    Notify.Error("Invalid Z coordinate.")
                    return
                end

                local ped = PlayerPedId()
                SetEntityCoords(ped, x, y, z, false, false, false, true)
                Notify.Success(string.format("Teleported to: %.2f, %.2f, %.2f", x, y, z))
                TriggerServerEvent("vMenu:LogTeleport", "Coordinates", x, y, z)
            end
        end
    end
end

function MiscSettingsMenu.SaveTeleportLocation()
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "New Location", "", "", "", 30)
    while UpdateOnscreenKeyboard() == 0 do
        Wait(0)
    end

    if GetOnscreenKeyboardResult() then
        local name = GetOnscreenKeyboardResult()
        if name and name ~= "" then
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            local heading = GetEntityHeading(ped)

            TriggerServerEvent("vMenu:SaveTeleportLocation", name, coords.x, coords.y, coords.z, heading)
            Notify.Success("Location saved: ~y~" .. name)
        else
            Notify.Error("Invalid location name.")
        end
    end
end

function MiscSettingsMenu.ClearArea()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)

    ClearAreaOfEverything(coords.x, coords.y, coords.z, 100.0, false, false, false, false)
    Notify.Success("Area cleared!")
end

function MiscSettingsMenu.SpawnEntity()
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 50)
    while UpdateOnscreenKeyboard() == 0 do
        Wait(0)
    end

    if GetOnscreenKeyboardResult() then
        local modelName = GetOnscreenKeyboardResult()
        if modelName and modelName ~= "" then
            local modelHash = GetHashKey(modelName)

            if not IsModelValid(modelHash) then
                Notify.Error("Invalid model name: " .. modelName)
                return
            end

            RequestModel(modelHash)
            local loadStart = GetGameTimer()
            while not HasModelLoaded(modelHash) do
                if GetGameTimer() - loadStart > 5000 then
                    Notify.Error("Model load timeout!")
                    return
                end
                Wait(0)
            end

            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            local heading = GetEntityHeading(ped)
            local forward = GetEntityForwardVector(ped)
            local spawnPos = coords + forward * 3.0

            local entity = nil
            if IsModelAPed(modelHash) then
                entity = CreatePed(4, modelHash, spawnPos.x, spawnPos.y, spawnPos.z, heading, true, false)
            elseif IsModelAVehicle(modelHash) then
                entity = CreateVehicle(modelHash, spawnPos.x, spawnPos.y, spawnPos.z, heading, true, false)
            else
                entity = CreateObject(modelHash, spawnPos.x, spawnPos.y, spawnPos.z, true, true, false)
            end

            if entity and entity ~= 0 then
                SetEntityAsMissionEntity(entity, true, true)
                PlaceObjectOnGroundProperly(entity)
                Notify.Success("Entity spawned: ~y~" .. modelName)
            else
                Notify.Error("Failed to spawn entity.")
            end

            SetModelAsNoLongerNeeded(modelHash)
        else
            Notify.Error("Invalid model name.")
        end
    end
end

function MiscSettingsMenu.ToggleLocationBlips(enabled)
end

function MiscSettingsMenu.EnforcePermissions()
    local P     = PermissionsManager.Permission
    local dirty = false

    if MiscSettingsMenu.ShowLocationBlips and not PermissionsManager.IsAllowed(P.MSLocationBlips) then
        MiscSettingsMenu.ShowLocationBlips = false
        MiscSettingsMenu.ToggleLocationBlips(false)
        dirty = true
    end

    if MiscSettingsMenu.ShowPlayerBlips and not PermissionsManager.IsAllowed(P.MSPlayerBlips) then
        MiscSettingsMenu.ShowPlayerBlips = false
        dirty = true
    end

    if dirty then
        MiscSettingsMenu.SaveSettings()
    end
end

function MiscSettingsMenu.SaveSettings()
    local settings = {
        RightAlignMenu = MiscSettingsMenu.RightAlignMenu,
        DisablePrivateMessages = MiscSettingsMenu.DisablePrivateMessages,
        DisableControllerSupport = MiscSettingsMenu.DisableControllerSupport,
        ShowSpeedoKmh = MiscSettingsMenu.ShowSpeedoKmh,
        ShowSpeedoMph = MiscSettingsMenu.ShowSpeedoMph,
        ShowLocation = MiscSettingsMenu.ShowLocation,
        ShowCoordinates = MiscSettingsMenu.ShowCoordinates,
        DrawTimeOnScreen = MiscSettingsMenu.DrawTimeOnScreen,
        HideHud = MiscSettingsMenu.HideHud,
        HideRadar = MiscSettingsMenu.HideRadar,
        NightVision = MiscSettingsMenu.NightVision,
        ThermalVision = MiscSettingsMenu.ThermalVision,
        JoinQuitNotifications = MiscSettingsMenu.JoinQuitNotifications,
        DeathNotifications = MiscSettingsMenu.DeathNotifications,
        ShowLocationBlips = MiscSettingsMenu.ShowLocationBlips,
        LockCameraX = MiscSettingsMenu.LockCameraX,
        LockCameraY = MiscSettingsMenu.LockCameraY,
        RespawnDefaultCharacter = MiscSettingsMenu.RespawnDefaultCharacter,
        RestorePlayerAppearance = MiscSettingsMenu.RestorePlayerAppearance,
        RestorePlayerWeapons = MiscSettingsMenu.RestorePlayerWeapons,
        MPPedPreviews = MiscSettingsMenu.MPPedPreviews,
        KbTpToWaypoint = MiscSettingsMenu.KbTpToWaypoint,
        KbDriftMode = MiscSettingsMenu.KbDriftMode,
        KbRecordKeys = MiscSettingsMenu.KbRecordKeys,
        KbRadarKeys = MiscSettingsMenu.KbRadarKeys,
        KbPointKeys = MiscSettingsMenu.KbPointKeys,
        ShowVehicleDimensions = MiscSettingsMenu.ShowVehicleDimensions,
        ShowPedDimensions = MiscSettingsMenu.ShowPedDimensions,
        ShowPropDimensions = MiscSettingsMenu.ShowPropDimensions,
        ShowEntityHandles = MiscSettingsMenu.ShowEntityHandles,
        ShowEntityModels = MiscSettingsMenu.ShowEntityModels,
        ShowEntityNetOwners = MiscSettingsMenu.ShowEntityNetOwners,
        TimecycleEnabled = MiscSettingsMenu.TimecycleEnabled,
        TimecycleModifierIndex = MiscSettingsMenu.TimecycleModifierIndex,
        TimecycleStrength = MiscSettingsMenu.TimecycleStrength,
        DimensionsRange = MiscSettingsMenu.DimensionsRange,
        NoclipSpeed = Noclip.GetSpeed(),
        NoclipFollowCam = Noclip.GetFollowCam()
    }

    SetResourceKvp("vmenu_misc_settings", json.encode(settings))
end

function MiscSettingsMenu.LoadSettings()
    local data = GetResourceKvpString("vmenu_misc_settings")
    if data and data ~= "" then
        local settings = json.decode(data)
        if settings then
            for key, value in pairs(settings) do
                if MiscSettingsMenu[key] ~= nil
                    and key ~= "ShowPlayerBlips"
                    and key ~= "ShowOverheadNames" then
                    MiscSettingsMenu[key] = value
                end
            end
            MiscSettingsMenu.ShowPlayerBlips = false
            MiscSettingsMenu.ShowOverheadNames = false
            if settings.NoclipSpeed ~= nil then
                Noclip.SetSpeed(settings.NoclipSpeed)
            end
            if settings.NoclipFollowCam ~= nil then
                Noclip.SetFollowCam(settings.NoclipFollowCam)
            end
        end
    end
end

GetZoneName = (function()
    local pos = GetEntityCoords(PlayerPedId())
    return GetNameOfZone(pos.x, pos.y, pos.z)
end)

GetStreetName = (function()
    local pos = GetEntityCoords(PlayerPedId())
    local streetHash, crossingHash = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local streetName = GetStreetNameFromHashKey(streetHash)
    local crossingName = GetStreetNameFromHashKey(crossingHash)

    if crossingName and crossingName ~= "" then
        return streetName .. " / " .. crossingName
    end
    return streetName
end)

DrawScreenText = (function(x, y, text)
    SetTextFont(4)
    SetTextScale(0.4, 0.4)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end)

Citizen.CreateThread((function()
    MiscSettingsMenu.LoadSettings()
    VehicleOptionsMenu.LoadSettings()

    if MiscSettingsMenu.RightAlignMenu then
        MenuController:SetMenuAlignment("right")
    else
        MenuController:SetMenuAlignment("left")
    end

    if MiscSettingsMenu.NightVision then
        SetNightvision(true)
    end
    if MiscSettingsMenu.ThermalVision then
        SetSeethrough(true)
    end

    if MiscSettingsMenu.HideRadar then
        DisplayRadar(false)
    end

    if MiscSettingsMenu.HideHud then
        DisplayHud(false)
    end

    if MiscSettingsMenu.TimecycleEnabled then
        local idx = MiscSettingsMenu.TimecycleModifierIndex
        if timecycleModifiers[idx] then
            SetTimecycleModifier(timecycleModifiers[idx])
            SetTimecycleModifierStrength(MiscSettingsMenu.TimecycleStrength)
        end
    end

    while true do
        local sleep = 500
        local yOffset = 0.0
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)

        local showLocation = MiscSettingsMenu.ShowLocation
        local showCoords = MiscSettingsMenu.ShowCoordinates
        local showTime = MiscSettingsMenu.DrawTimeOnScreen
        local showSpeedKmh = MiscSettingsMenu.ShowSpeedoKmh
        local showSpeedMph = MiscSettingsMenu.ShowSpeedoMph
        local showOverheadNames = MiscSettingsMenu.ShowOverheadNames
        local showPlayerBlips = MiscSettingsMenu.ShowPlayerBlips

        if showLocation or showCoords or showTime or showSpeedKmh or showSpeedMph or showOverheadNames then
            sleep = 0
        end

        if showLocation then
            local zoneName = GetZoneName()
            local streetName = GetStreetName()
            local heading = math.floor(GetEntityHeading(ped))
            DrawScreenText(0.5, 0.02 + yOffset,
                "~y~" .. streetName .. "~s~ | ~b~" .. zoneName .. "~s~ | ~g~" .. heading .. "°")
            yOffset = yOffset + 0.025
        end

        if showCoords then
            DrawScreenText(0.5, 0.02 + yOffset,
                string.format("X: ~y~%.2f~s~ | Y: ~y~%.2f~s~ | Z: ~y~%.2f", pos.x, pos.y, pos.z))
            yOffset = yOffset + 0.025
        end

        if showTime then
            local hour = GetClockHours()
            local minute = GetClockMinutes()
            DrawScreenText(0.5, 0.02 + yOffset, string.format("~c~%02d:%02d", hour, minute))
            yOffset = yOffset + 0.025
        end

        if (showSpeedKmh or showSpeedMph) and IsPedInAnyVehicle(ped, false) then
            local vehicle = GetVehiclePedIsIn(ped, false)
            local speed = GetEntitySpeed(vehicle)

            if showSpeedKmh then
                local kmh = math.floor(speed * 3.6)
                DrawScreenText(0.5, 0.02 + yOffset, "~b~" .. kmh .. " KM/H")
                yOffset = yOffset + 0.025
            end

            if showSpeedMph then
                local mph = math.floor(speed * 2.236936)
                DrawScreenText(0.5, 0.02 + yOffset, "~b~" .. mph .. " MPH")
                yOffset = yOffset + 0.025
            end
        end

        if showOverheadNames then
            for _, player in ipairs(GetActivePlayers()) do
                if player ~= PlayerId() then
                    local targetPed = GetPlayerPed(player)
                    if DoesEntityExist(targetPed) then
                        local playerCoords = GetEntityCoords(targetPed)
                        local distance = #(pos - playerCoords)
                        if distance < 50.0 then
                            local playerName = GetPlayerName(player)
                            DrawText3D(playerCoords.x, playerCoords.y, playerCoords.z + 1.0, playerName)
                        end
                    end
                end
            end
        end

        if MiscSettingsMenu.LockCameraX then
            DisableControlAction(0, 1, true)
        end
        if MiscSettingsMenu.LockCameraY then
            DisableControlAction(0, 2, true)
        end

        if MiscSettingsMenu.HideHud then
            HideHudAndRadarThisFrame()
        end

        if MiscSettingsMenu.HideRadar and not MiscSettingsMenu.HideHud then
            HideMinimapExteriorMapThisFrame()
        end

        Citizen.Wait(sleep)
    end
end))

DrawText3D = (function(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end)

return MiscSettingsMenu
