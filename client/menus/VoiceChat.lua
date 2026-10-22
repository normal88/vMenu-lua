VoiceChatMenu = {}

local menu = nil

VoiceChatMenu.EnableVoicechat = true
VoiceChatMenu.ShowCurrentSpeaker = true
VoiceChatMenu.ShowVoiceStatus = true
VoiceChatMenu.CurrentProximity = 20.0
VoiceChatMenu.CurrentChannel = "Channel 1 (Default)"

local proximityValues = { 5.0, 10.0, 15.0, 20.0, 100.0, 300.0, 1000.0, 2000.0, 0.0 }

local channelNames = {
    "Channel 1 (Default)",
    "Channel 2",
    "Channel 3",
    "Channel 4"
}

local function ConvertToMetric(input)
    local val = "0m"

    if input == 0 then
        val = "global"
    elseif input < 1.0 then
        val = string.format("%.0fcm", input * 100)
    elseif input < 1000 then
        val = string.format("%.0fm", input)
    else
        val = string.format("%.1fkm", input / 1000)
    end

    return val
end

function VoiceChatMenu.CreateMenu()
    local playerName = GetPlayerName(PlayerId())
    menu = Menu:New(playerName, "Voice Chat Settings")
    MenuController:AddMenu(menu)

    local voiceChatEnabled = MenuCheckboxItem:New("Enable Voice Chat", "Enable or disable voice chat.", VoiceChatMenu.EnableVoicechat)
    local showCurrentSpeaker = MenuCheckboxItem:New("Show Current Speaker", "Shows who is currently talking.", VoiceChatMenu.ShowCurrentSpeaker)
    local showVoiceStatus = MenuCheckboxItem:New("Show Microphone Status", "Shows whether your microphone is open or muted.", VoiceChatMenu.ShowVoiceStatus)
    local voiceChatProximity = MenuItem:New("Voice Chat Proximity (" .. ConvertToMetric(VoiceChatMenu.CurrentProximity) .. ")", "Set the voice chat receiving proximity in meters. Set to 0 for global.")

    local channels = {}
    for i, v in ipairs(channelNames) do
        table.insert(channels, v)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.VCStaffChannel) then
        table.insert(channels, "Staff Channel")
    end

    local currentChannelIndex = 0
    for i, channelName in ipairs(channels) do
        if channelName == VoiceChatMenu.CurrentChannel then
            currentChannelIndex = i - 1
            break
        end
    end

    local voiceChatChannel = MenuListItem:New("Voice Chat Channel", channels, currentChannelIndex, "Set the voice chat channel.")

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.VCEnable) then
        menu:AddMenuItem(voiceChatEnabled)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.VCShowSpeaker) then
        menu:AddMenuItem(showCurrentSpeaker)
        menu:AddMenuItem(showVoiceStatus)
    end

    if PermissionsManager.IsAllowed(PermissionsManager.Permission.VCEnable) then
        menu:AddMenuItem(voiceChatProximity)
        menu:AddMenuItem(voiceChatChannel)
    end

    menu.OnCheckboxChange = function(sender, item, index, checked)
        if item == voiceChatEnabled then
            VoiceChatMenu.EnableVoicechat = checked
            NetworkSetTalkerProximity(VoiceChatMenu.CurrentProximity)
            Notify.Custom("Voice chat is now " .. (checked and "~g~enabled~s~" or "~r~disabled~s~") .. ".")

        elseif item == showCurrentSpeaker then
            VoiceChatMenu.ShowCurrentSpeaker = checked
            Notify.Custom("Show current speaker is now " .. (checked and "~g~enabled~s~" or "~r~disabled~s~") .. ".")

        elseif item == showVoiceStatus then
            VoiceChatMenu.ShowVoiceStatus = checked
            Notify.Custom("Show microphone status is now " .. (checked and "~g~enabled~s~" or "~r~disabled~s~") .. ".")
        end
    end

    menu.OnListIndexChange = function(sender, item, oldIndex, newIndex, itemIndex)
        if item == voiceChatChannel then
            VoiceChatMenu.CurrentChannel = channels[newIndex + 1]
            NetworkSetVoiceChannel(newIndex)
            Notify.Custom("New voice chat channel set to: ~b~" .. channels[newIndex + 1] .. "~s~.")
        end
    end

    menu.OnItemSelect = function(sender, item, index)
        if item == voiceChatProximity then
            DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 6)
            while UpdateOnscreenKeyboard() == 0 do
                Wait(0)
            end

            if GetOnscreenKeyboardResult() then
                local input = GetOnscreenKeyboardResult()
                local proximity = tonumber(input)

                if proximity and proximity >= 0 then
                    VoiceChatMenu.CurrentProximity = proximity
                    NetworkSetTalkerProximity(proximity)

                    voiceChatProximity.Text = "Voice Chat Proximity (" .. ConvertToMetric(proximity) .. ")"

                    Notify.Custom("New voice chat proximity set to: ~b~" .. ConvertToMetric(proximity) .. "~s~.")
                else
                    Notify.Error("Invalid proximity value. Please enter a number.")
                end
            end
        end
    end

    return menu
end

function VoiceChatMenu.GetMenu()
    if menu == nil then
        VoiceChatMenu.CreateMenu()
    end
    return menu
end

return VoiceChatMenu
