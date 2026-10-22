fx_version 'cerulean'
game 'gta5'

author 'Tom Grobbe - Normal / VSX Studio - Re-coded version'
description 'vMenu - VSX Studio Re-coded version of vMenu by Normal - Discord: @6w1.'
version '1.2.02'
repository 'https://github.com/normal88/vMenu-lua'

shared_scripts { 'shared/PermissionsManager.lua' }

client_scripts {
    'utils/MathUtil.lua',

    'client/modules/Locale.lua',
    'locales/*.lua',
    'client/modules/Banner.lua',
    'client/modules/Theme.lua',

    'enums/Icon.lua',
    'enums/Control.lua',
    'items/MenuItem.lua',
    'items/MenuListItem.lua',
    'items/MenuCheckboxItem.lua',
    'items/MenuSliderItem.lua',
    'items/MenuDynamicListItem.lua',
    'Menu.lua',
    'MenuController.lua',

    'client/modules/Notification.lua',
    'client/modules/CommonFunctions.lua',
    'client/modules/ConfigManager.lua',
    'client/modules/StorageManager.lua',
    'client/modules/EventManager.lua',
    'client/modules/FunctionsController.lua',
    'client/modules/Noclip.lua',
    'client/modules/FaceSyncFix.lua',
    'client/CameraManager.lua',
    'client/modules/PedPreview.lua',

    'client/data/ValidWeapon.lua',
    'client/data/VehicleData.lua',
    'client/data/VehicleColors.lua',
    'client/data/PedModels.lua',
    'client/data/PedScenarios.lua',
    'client/data/TattoosData.lua',
    'client/data/BlipInfo.lua',

    'client/menus/PlayerOptions.lua',
    'client/menus/WeaponOptions.lua',
    'client/menus/VehicleSpawner.lua',
    'client/menus/VehicleOptions.lua',
    'client/menus/TimeOptions.lua',
    'client/menus/WeatherOptions.lua',
    'client/menus/PlayerAppearance.lua',
    'client/menus/OnlinePlayers.lua',
    'client/menus/SavedVehicles.lua',
    'client/menus/WeaponLoadouts.lua',
    'client/menus/PersonalVehicle.lua',
    'client/menus/MpPedCustomization.lua',
    'client/menus/Recording.lua',
    'client/menus/VoiceChat.lua',
    'client/menus/BannedPlayers.lua',
    'client/menus/MiscSettings.lua',
    'client/menus/About.lua',

    'client/main.lua',
    'client/modules/ExportsController.lua'
}

server_scripts { 'server/version.lua','server/BanManager.lua','server/main.lua' }

files { 'assets/*' }

escrow_ignore {
    'Menu.lua',
    'MenuController.lua',
    'shared/PermissionsManager.lua',
    'server/main.lua',
    'items/MenuItem.lua',
    'items/MenuCheckboxItem.lua',
    'items/MenuSliderItem.lua',
    'client/modules/Banner.lua',
    'client/modules/Theme.lua',
    'assets/banner.html',
    'assets/banner.png',
    'assets/banner.jpg',
    'assets/banner.gif',
    'items/MenuListItem.lua',
    'items/MenuDynamicListItem.lua',
    'client/modules/Locale.lua',
    'client/modules/PedPreview.lua',
    'client/modules/Notification.lua',
    'client/menus/MiscSettings.lua',
    'client/main.lua',
    'client/menus/About.lua',
    'client/menus/PlayerOptions.lua',
    'client/menus/PlayerAppearance.lua',
    'client/menus/MpPedCustomization.lua',
    'locales/ar.lua',
    'locales/es.lua',
    'locales/pt.lua',
    'locales/de.lua',
    'server/version.lua',
    'permissions.cfg',
}
