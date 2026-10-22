TimeOptionsMenu = {}

local menu = nil
local freezeTimeToggle = nil

function TimeOptionsMenu.CreateMenu()
    menu = Menu:New("Time Options", "Time Related Options")
    MenuController:AddMenu(menu)

    freezeTimeToggle = MenuItem:New("Freeze/Unfreeze Time", "Enable or disable time freezing.")

    local earlyMorningBtn = MenuItem:New("Early Morning", "Set the time to 06:00.")
    earlyMorningBtn.Label = "06:00"

    local morningBtn = MenuItem:New("Morning", "Set the time to 09:00.")
    morningBtn.Label = "09:00"

    local noonBtn = MenuItem:New("Noon", "Set the time to 12:00.")
    noonBtn.Label = "12:00"

    local earlyAfternoonBtn = MenuItem:New("Early Afternoon", "Set the time to 15:00.")
    earlyAfternoonBtn.Label = "15:00"

    local afternoonBtn = MenuItem:New("Afternoon", "Set the time to 18:00.")
    afternoonBtn.Label = "18:00"

    local eveningBtn = MenuItem:New("Evening", "Set the time to 21:00.")
    eveningBtn.Label = "21:00"

    local midnightBtn = MenuItem:New("Midnight", "Set the time to 00:00.")
    midnightBtn.Label = "00:00"

    local nightBtn = MenuItem:New("Night", "Set the time to 03:00.")
    nightBtn.Label = "03:00"

    local hours = {}
    for i = 0, 23 do
        if i < 10 then
            table.insert(hours, "0" .. i)
        else
            table.insert(hours, tostring(i))
        end
    end

    local minutes = {}
    for i = 0, 59 do
        if i < 10 then
            table.insert(minutes, "0" .. i)
        else
            table.insert(minutes, tostring(i))
        end
    end

    local manualHour = MenuListItem:New("Set Custom Hour", hours, 1, "Set a custom hour and press enter to apply.")
    local manualMinute = MenuListItem:New("Set Custom Minute", minutes, 1,
        "Set a custom minute and press enter to apply.")

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.TOFreezeTime) then
        menu:AddMenuItem(freezeTimeToggle)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.TOSetTime) then
        menu:AddMenuItem(earlyMorningBtn)
        menu:AddMenuItem(morningBtn)
        menu:AddMenuItem(noonBtn)
        menu:AddMenuItem(earlyAfternoonBtn)
        menu:AddMenuItem(afternoonBtn)
        menu:AddMenuItem(eveningBtn)
        menu:AddMenuItem(midnightBtn)
        menu:AddMenuItem(nightBtn)
        menu:AddMenuItem(manualHour)
        menu:AddMenuItem(manualMinute)
    end

    menu.OnItemSelect = function(sender, item, index)
        if item == freezeTimeToggle then
            local newFrozen = not TimeOptionsMenu.IsServerTimeFrozen()
            TriggerServerEvent("vMenu:FreezeServerTime", newFrozen)
            Notify.Info("Time will now " .. (newFrozen and "~o~freeze" or "~y~continue") .. "~s~.")
        else
            local newHour = nil

            if item == earlyMorningBtn then
                newHour = 6
            elseif item == morningBtn then
                newHour = 9
            elseif item == noonBtn then
                newHour = 12
            elseif item == earlyAfternoonBtn then
                newHour = 15
            elseif item == afternoonBtn then
                newHour = 18
            elseif item == eveningBtn then
                newHour = 21
            elseif item == midnightBtn then
                newHour = 0
            elseif item == nightBtn then
                newHour = 3
            end

            if newHour ~= nil then
                TriggerServerEvent("vMenu:UpdateServerTime", newHour, 0)
                local hourStr = newHour < 10 and ("0" .. newHour) or tostring(newHour)
                Notify.Info("Time set to ~y~" .. hourStr .. "~s~:~y~00~s~.")
            end
        end
    end

    menu.OnListItemSelect = function(sender, item, listIndex, itemIndex)
        local newHour = TimeOptionsMenu.GetServerHours()
        local newMinute = TimeOptionsMenu.GetServerMinutes()

        if item == manualHour then
            newHour = listIndex - 1
        elseif item == manualMinute then
            newMinute = listIndex - 1
        end

        TriggerServerEvent("vMenu:UpdateServerTime", newHour, newMinute)

        local hourStr = newHour < 10 and ("0" .. newHour) or tostring(newHour)
        local minStr = newMinute < 10 and ("0" .. newMinute) or tostring(newMinute)
        Notify.Info("Time set to ~y~" .. hourStr .. "~s~:~y~" .. minStr .. "~s~.")
    end

    return menu
end

function TimeOptionsMenu.GetMenu()
    if menu == nil then
        TimeOptionsMenu.CreateMenu()
    end
    return menu
end

local serverHours = 12
local serverMinutes = 0
local serverTimeFrozen = false
local hasReceivedTimeSync = false

function TimeOptionsMenu.GetServerHours()
    return serverHours
end

function TimeOptionsMenu.GetServerMinutes()
    return serverMinutes
end

function TimeOptionsMenu.IsServerTimeFrozen()
    return serverTimeFrozen
end

RegisterNetEvent("vMenu:SyncTime", function(hours, minutes, frozen)
    serverHours = hours
    serverMinutes = minutes
    serverTimeFrozen = frozen
    hasReceivedTimeSync = true
    NetworkOverrideClockTime(serverHours, serverMinutes, 0)
end)

Citizen.CreateThread((function()
    while not NetworkIsPlayerActive(PlayerId()) do
        Citizen.Wait(100)
    end

    TriggerServerEvent("vMenu:RequestTimeSync")
end))

Citizen.CreateThread((function()
    while true do
        if hasReceivedTimeSync then
            if serverTimeFrozen then
                NetworkOverrideClockTime(serverHours, serverMinutes, 0)
                Citizen.Wait(0)
            else
                NetworkOverrideClockTime(serverHours, serverMinutes, 0)
                Citizen.Wait(2000)
            end
        else
            Citizen.Wait(500)
        end
    end
end))

return TimeOptionsMenu
