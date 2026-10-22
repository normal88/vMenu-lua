WeatherOptionsMenu = {}

local menu = nil

WeatherOptionsMenu.DynamicWeatherEnabled = true
WeatherOptionsMenu.IsBlackoutEnabled = false
WeatherOptionsMenu.IsVehicleBlackoutEnabled = false
WeatherOptionsMenu.SnowEnabled = false
WeatherOptionsMenu.CurrentWeather = "CLEAR"
WeatherOptionsMenu.WeatherChangeTime = 45

local weatherTypes = {
    { name = "Extra Sunny", value = "EXTRASUNNY", description = "Set the weather to ~y~extra sunny~s~!" },
    { name = "Clear",       value = "CLEAR",      description = "Set the weather to ~y~clear~s~!" },
    { name = "Neutral",     value = "NEUTRAL",    description = "Set the weather to ~y~neutral~s~!" },
    { name = "Smog",        value = "SMOG",       description = "Set the weather to ~y~smog~s~!" },
    { name = "Foggy",       value = "FOGGY",      description = "Set the weather to ~y~foggy~s~!" },
    { name = "Cloudy",      value = "CLOUDS",     description = "Set the weather to ~y~cloudy~s~!" },
    { name = "Overcast",    value = "OVERCAST",   description = "Set the weather to ~y~overcast~s~!" },
    { name = "Clearing",    value = "CLEARING",   description = "Set the weather to ~y~clearing~s~!" },
    { name = "Rainy",       value = "RAIN",       description = "Set the weather to ~y~rain~s~!" },
    { name = "Thunder",     value = "THUNDER",    description = "Set the weather to ~y~thunder~s~!" },
    { name = "Blizzard",    value = "BLIZZARD",   description = "Set the weather to ~y~blizzard~s~!" },
    { name = "Snow",        value = "SNOW",       description = "Set the weather to ~y~snow~s~!" },
    { name = "Light Snow",  value = "SNOWLIGHT",  description = "Set the weather to ~y~light snow~s~!" },
    { name = "X-MAS Snow",  value = "XMAS",       description = "Set the weather to ~y~x-mas~s~!" },
    { name = "Halloween",   value = "HALLOWEEN",  description = "Set the weather to ~y~halloween~s~!" },
}

local dynamicWeatherCheckbox = nil
local blackoutCheckbox = nil
local vehicleBlackoutCheckbox = nil
local snowEnabledCheckbox = nil
local removeCloudsBtn = nil
local randomizeCloudsBtn = nil

function WeatherOptionsMenu.CreateMenu()
    menu = Menu:New("Weather Options", "Weather Related Options")
    MenuController:AddMenu(menu)

    dynamicWeatherCheckbox = MenuCheckboxItem:New("Toggle Dynamic Weather",
        "Enable or disable dynamic weather changes.", WeatherOptionsMenu.DynamicWeatherEnabled)

    blackoutCheckbox = MenuCheckboxItem:New("Toggle Blackout",
        "This disables or enables all lights across the map.", WeatherOptionsMenu.IsBlackoutEnabled)

    vehicleBlackoutCheckbox = MenuCheckboxItem:New("Toggle Vehicle Lights Blackout",
        "This disables or enables all vehicle lights across the map.", WeatherOptionsMenu.IsVehicleBlackoutEnabled)

    snowEnabledCheckbox = MenuCheckboxItem:New("Enable Snow Effects",
        "This will force snow to appear on the ground and enable snow particle effects for peds and vehicles. Combine with X-MAS or Light Snow weather for best results.",
        WeatherOptionsMenu.SnowEnabled)

    removeCloudsBtn = MenuItem:New("Remove All Clouds", "Remove all clouds from the sky!")

    randomizeCloudsBtn = MenuItem:New("Randomize Clouds", "Add random clouds to the sky!")

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.WODynamic) then
        menu:AddMenuItem(dynamicWeatherCheckbox)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.WOBlackout) then
        menu:AddMenuItem(blackoutCheckbox)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.WOVehBlackout) then
        menu:AddMenuItem(vehicleBlackoutCheckbox)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.WOSetWeather) then
        menu:AddMenuItem(snowEnabledCheckbox)

        for _, weather in ipairs(weatherTypes) do
            local weatherBtn = MenuItem:New(weather.name, weather.description)
            weatherBtn.ItemData = weather.value
            menu:AddMenuItem(weatherBtn)
        end
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.WORandomizeClouds) then
        menu:AddMenuItem(randomizeCloudsBtn)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.WORemoveClouds) then
        menu:AddMenuItem(removeCloudsBtn)
    end

    menu.OnItemSelect = function(sender, item, index)
        if item == removeCloudsBtn then
            WeatherOptionsMenu.ModifyClouds(true)
            Notify.Success("All clouds have been removed.")
        elseif item == randomizeCloudsBtn then
            WeatherOptionsMenu.ModifyClouds(false)
            Notify.Success("Clouds have been randomized.")
        elseif item.ItemData then
            local weatherType = item.ItemData
            Notify.Custom("The weather will be changed to ~y~" .. item.Text .. "~s~. This will take " ..
                WeatherOptionsMenu.WeatherChangeTime .. " seconds.")
            WeatherOptionsMenu.UpdateWeather(weatherType)
        end
    end

    menu.OnCheckboxChange = function(sender, item, index, checked)
        if item == dynamicWeatherCheckbox then
            WeatherOptionsMenu.DynamicWeatherEnabled = checked
            Notify.Custom("Dynamic weather changes are now " ..
                (checked and "~g~enabled~s~" or "~r~disabled~s~") .. ".")
            TriggerServerEvent("vMenu:UpdateServerWeather", WeatherOptionsMenu.CurrentWeather,
                checked, WeatherOptionsMenu.SnowEnabled)

        elseif item == blackoutCheckbox then
            WeatherOptionsMenu.IsBlackoutEnabled = checked
            Notify.Custom("Blackout mode is now " ..
                (checked and "~g~enabled~s~" or "~r~disabled~s~") .. ".")
            TriggerServerEvent("vMenu:UpdateServerBlackout", checked)

        elseif item == vehicleBlackoutCheckbox then
            WeatherOptionsMenu.IsVehicleBlackoutEnabled = checked
            Notify.Custom("Vehicle light blackout mode is now " ..
                (checked and "~g~enabled~s~" or "~r~disabled~s~") .. ".")
            TriggerServerEvent("vMenu:UpdateServerVehicleBlackout", checked)

        elseif item == snowEnabledCheckbox then
            local currentWeather = WeatherOptionsMenu.CurrentWeather
            if currentWeather == "XMAS" or currentWeather == "SNOWLIGHT" or
                currentWeather == "SNOW" or currentWeather == "BLIZZARD" then
                Notify.Custom("Snow effects cannot be disabled when weather is ~y~" .. currentWeather .. "~s~.")
                item.Checked = true
                return
            end

            WeatherOptionsMenu.SnowEnabled = checked
            Notify.Custom("Snow effects will now be forced " ..
                (checked and "~g~enabled~s~" or "~r~disabled~s~") .. ".")
            TriggerServerEvent("vMenu:UpdateServerWeather", WeatherOptionsMenu.CurrentWeather,
                WeatherOptionsMenu.DynamicWeatherEnabled, checked)
        end
    end

    return menu
end

function WeatherOptionsMenu.GetMenu()
    if menu == nil then
        WeatherOptionsMenu.CreateMenu()
    end
    return menu
end

function WeatherOptionsMenu.UpdateWeather(weatherType)
    WeatherOptionsMenu.CurrentWeather = weatherType

    ClearOverrideWeather()
    ClearWeatherTypePersist()
    SetWeatherTypeOvertimePersist(weatherType, WeatherOptionsMenu.WeatherChangeTime + 0.0)

    local isSnowWeather = weatherType == "XMAS" or weatherType == "SNOWLIGHT" or
        weatherType == "SNOW" or weatherType == "BLIZZARD"

    if isSnowWeather then
        WeatherOptionsMenu.SnowEnabled = true
        if snowEnabledCheckbox then
            snowEnabledCheckbox.Checked = true
        end
    end

    local sendDynamic = WeatherOptionsMenu.DynamicWeatherEnabled
    local sendSnow = WeatherOptionsMenu.SnowEnabled

    if type(sendDynamic) ~= "boolean" then
        sendDynamic = true
        WeatherOptionsMenu.DynamicWeatherEnabled = true
    end
    if type(sendSnow) ~= "boolean" then
        sendSnow = isSnowWeather
        WeatherOptionsMenu.SnowEnabled = isSnowWeather
    end

    TriggerServerEvent("vMenu:UpdateServerWeather", weatherType, sendDynamic, sendSnow)
end

function WeatherOptionsMenu.ModifyClouds(remove)
    if remove then
        ClearCloudHat()
        SetCloudHatOpacity(0.0)
    else
        local cloudTypes = {
            "Altostratus", "Cirrus", "Cirrocumulus", "Clear 01", "Cloudy 01",
            "Contrails", "Horizon", "HorizonBand1", "HorizonBand2", "HorizonBand3",
            "Horsey", "Nimbus", "PUFFS", "Rain", "SHOWER", "Snowy 01", "Stormy 01",
            "Stratoscumulus", "Stripey", "Wispy"
        }
        local randomCloud = cloudTypes[math.random(1, #cloudTypes)]
        LoadCloudHat(randomCloud, 1.5)
        SetCloudHatOpacity(1.0)
    end
end

Citizen.CreateThread((function()
    local lastBlackout = nil
    local lastVehicleBlackout = nil
    local lastSnowEnabled = nil
    local lastDynamicDisabled = nil
    local lastWeather = nil

    while true do
        local sleep = 1000

        local isBlackout = WeatherOptionsMenu.IsBlackoutEnabled
        local isVehicleBlackout = WeatherOptionsMenu.IsVehicleBlackoutEnabled
        local isSnowEnabled = WeatherOptionsMenu.SnowEnabled
        local isDynamicDisabled = not WeatherOptionsMenu.DynamicWeatherEnabled
        local weather = WeatherOptionsMenu.CurrentWeather

        if isSnowEnabled or isDynamicDisabled then
            sleep = 0
        end

        if lastBlackout ~= isBlackout then
            if isBlackout then
                SetArtificialLightsState(true)
                SetArtificialLightsStateAffectsVehicles(false)
            else
                SetArtificialLightsState(false)
            end
            lastBlackout = isBlackout
        end

        if lastVehicleBlackout ~= isVehicleBlackout then
            SetArtificialLightsStateAffectsVehicles(isVehicleBlackout)
            lastVehicleBlackout = isVehicleBlackout
        end

        if lastSnowEnabled ~= isSnowEnabled then
            if isSnowEnabled then
                ForceSnowPass(true)
                SetForceVehicleTrails(true)
                SetForcePedFootstepsTracks(true)
            else
                ForceSnowPass(false)
                SetForceVehicleTrails(false)
                SetForcePedFootstepsTracks(false)
            end
            lastSnowEnabled = isSnowEnabled
        end

        if isDynamicDisabled then
            if lastDynamicDisabled ~= true or lastWeather ~= weather then
                SetWeatherTypePersist(weather)
                SetWeatherTypeNow(weather)
                SetWeatherTypeNowPersist(weather)
                lastWeather = weather
            end
        end
        lastDynamicDisabled = isDynamicDisabled

        Citizen.Wait(sleep)
    end
end))

RegisterNetEvent("vMenu:SyncWeather", function(weather, dynamicEnabled, snowEnabled, blackout, vehicleBlackout)
    local validWeather = weather
    if type(weather) ~= "string" then
        validWeather = WeatherOptionsMenu.CurrentWeather or "CLEAR"
    end

    local validDynamic = dynamicEnabled
    if type(dynamicEnabled) ~= "boolean" then
        validDynamic = WeatherOptionsMenu.DynamicWeatherEnabled
        if type(validDynamic) ~= "boolean" then
            validDynamic = true
        end
    end

    local validSnow = snowEnabled
    if type(snowEnabled) ~= "boolean" then
        validSnow = WeatherOptionsMenu.SnowEnabled
        if type(validSnow) ~= "boolean" then
            validSnow = false
        end
    end

    local validBlackout = blackout
    if type(blackout) ~= "boolean" then
        validBlackout = WeatherOptionsMenu.IsBlackoutEnabled
        if type(validBlackout) ~= "boolean" then
            validBlackout = false
        end
    end

    local validVehicleBlackout = vehicleBlackout
    if type(vehicleBlackout) ~= "boolean" then
        validVehicleBlackout = WeatherOptionsMenu.IsVehicleBlackoutEnabled
        if type(validVehicleBlackout) ~= "boolean" then
            validVehicleBlackout = false
        end
    end

    WeatherOptionsMenu.CurrentWeather = validWeather
    WeatherOptionsMenu.DynamicWeatherEnabled = validDynamic
    WeatherOptionsMenu.SnowEnabled = validSnow
    WeatherOptionsMenu.IsBlackoutEnabled = validBlackout
    WeatherOptionsMenu.IsVehicleBlackoutEnabled = validVehicleBlackout
    hasReceivedWeatherSync = true

    if dynamicWeatherCheckbox then
        dynamicWeatherCheckbox.Checked = validDynamic
    end
    if snowEnabledCheckbox then
        snowEnabledCheckbox.Checked = validSnow
    end
    if blackoutCheckbox then
        blackoutCheckbox.Checked = validBlackout
    end
    if vehicleBlackoutCheckbox then
        vehicleBlackoutCheckbox.Checked = validVehicleBlackout
    end

    if type(validWeather) == "string" and validWeather ~= "" then
        ClearOverrideWeather()
        ClearWeatherTypePersist()
        SetWeatherTypePersist(validWeather)
        SetWeatherTypeNow(validWeather)
        SetWeatherTypeNowPersist(validWeather)
    end
end)

local hasReceivedWeatherSync = false

Citizen.CreateThread((function()
    while not NetworkIsPlayerActive(PlayerId()) do
        Citizen.Wait(100)
    end

    Citizen.Wait(2000)

    for attempt = 1, 3 do
        if hasReceivedWeatherSync then
            break
        end
        TriggerServerEvent("vMenu:RequestWeatherSync")
        Citizen.Wait(5000)
    end
end))

return WeatherOptionsMenu
