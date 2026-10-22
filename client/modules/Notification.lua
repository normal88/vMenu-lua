Notify = {}
Subtitle = {}
HelpMessage = {}
ErrorMessage = {}

CommonErrors = {
    NoVehicle = "NoVehicle",
    NeedToBeTheDriver = "NeedToBeTheDriver",
    UnknownError = "UnknownError",
    NotAllowed = "NotAllowed",
    InvalidModel = "InvalidModel",
    InvalidInput = "InvalidInput",
    InvalidSaveName = "InvalidSaveName",
    SaveNameAlreadyExists = "SaveNameAlreadyExists",
    CouldNotLoadSave = "CouldNotLoadSave",
    CouldNotLoad = "CouldNotLoad",
    PlayerNotFound = "PlayerNotFound",
    PedNotFound = "PedNotFound",
    WalkingStyleNotForMale = "WalkingStyleNotForMale",
    WalkingStyleNotForFemale = "WalkingStyleNotForFemale",
    RightAlignedNotSupported = "RightAlignedNotSupported",
}

local function StringToArray(str)
    str = Locale.ForScaleform(str)
    local result = {}
    local maxLength = 99

    local i = 1
    while i <= #str do
        local j = math.min(i + maxLength - 1, #str)
        while j < #str and j > i and str:byte(j + 1) >= 0x80 and str:byte(j + 1) < 0xC0 do
            j = j - 1
        end
        table.insert(result, string.sub(str, i, j))
        i = j + 1
    end

    return result
end

function ErrorMessage.Get(errorType, placeholderValue)
    local placeholder = placeholderValue and (" " .. placeholderValue) or ""
    local message = ""

    if errorType == CommonErrors.NeedToBeTheDriver then
        message = "You need to be the driver of this vehicle."
    elseif errorType == CommonErrors.NoVehicle then
        message = "You need to be inside a vehicle" .. placeholder .. "."
    elseif errorType == CommonErrors.NotAllowed then
        message = "You are not allowed to" .. placeholder .. ", sorry."
    elseif errorType == CommonErrors.InvalidModel then
        message = "This model~r~" .. placeholder .. " ~s~could not be found, are you sure it's valid?"
    elseif errorType == CommonErrors.InvalidInput then
        message = "The input~r~" .. placeholder .. " ~s~is invalid or you cancelled the action, please try again."
    elseif errorType == CommonErrors.InvalidSaveName then
        message = "Saving failed because the provided save name~r~" .. placeholder .. " ~s~is invalid."
    elseif errorType == CommonErrors.SaveNameAlreadyExists then
        message = "Saving failed because the provided save name~r~" .. placeholder .. " ~s~already exists."
    elseif errorType == CommonErrors.CouldNotLoadSave then
        message = "Loading of~r~" .. placeholder .. " ~s~failed! Is the saves file corrupt?"
    elseif errorType == CommonErrors.CouldNotLoad then
        message = "Could not load~r~" .. placeholder .. "~s~, sorry!"
    elseif errorType == CommonErrors.PedNotFound then
        message = "The specified ped could not be found." .. placeholder
    elseif errorType == CommonErrors.PlayerNotFound then
        message = "The specified player could not be found." .. placeholder
    elseif errorType == CommonErrors.WalkingStyleNotForMale then
        message = "This walking style is not available for male peds." .. placeholder
    elseif errorType == CommonErrors.WalkingStyleNotForFemale then
        message = "This walking style is not available for female peds." .. placeholder
    elseif errorType == CommonErrors.RightAlignedNotSupported then
        message = "Right aligned menus are not supported for ultra wide aspect ratios." .. placeholder
    else
        message = "An unknown error occurred, sorry!" .. placeholder
    end

    return message
end

function Notify.Custom(message, blink, saveToBrief)
    if blink == nil then blink = true end
    if saveToBrief == nil then saveToBrief = true end

    SetNotificationTextEntry("CELL_EMAIL_BCON")
    for _, str in ipairs(StringToArray(message)) do
        AddTextComponentSubstringPlayerName(str)
    end
    DrawNotification(blink, saveToBrief)
end

function Notify.Alert(message, blink, saveToBrief, placeholderValue)
    if type(message) == "string" and CommonErrors[message] then
        message = ErrorMessage.Get(message, placeholderValue)
    end

    Notify.Custom("~y~~h~" .. Locale.Translate("Alert") .. "~h~~s~: " .. Locale.Translate(message), blink, saveToBrief)
end

function Notify.Error(message, blink, saveToBrief, placeholderValue)
    if type(message) == "string" and CommonErrors[message] then
        message = ErrorMessage.Get(message, placeholderValue)
    end

    Notify.Custom("~r~~h~" .. Locale.Translate("Error") .. "~h~~s~: " .. Locale.Translate(message), blink, saveToBrief)
end

function Notify.Info(message, blink, saveToBrief)
    Notify.Custom("~b~~h~" .. Locale.Translate("Info") .. "~h~~s~: " .. Locale.Translate(message), blink, saveToBrief)
end

function Notify.Success(message, blink, saveToBrief)
    Notify.Custom("~g~~h~" .. Locale.Translate("Success") .. "~h~~s~: " .. Locale.Translate(message), blink, saveToBrief)
end

function Notify.CustomImage(textureDict, textureName, message, title, subtitle, saveToBrief, iconType)
    iconType = iconType or 0

    SetNotificationTextEntry("CELL_EMAIL_BCON")
    for _, str in ipairs(StringToArray(message)) do
        AddTextComponentSubstringPlayerName(str)
    end
    SetNotificationMessage(textureName, textureDict, false, iconType, title, subtitle)
    DrawNotification(false, saveToBrief)
end

function Subtitle.Custom(message, duration, drawImmediately)
    duration = duration or 2500
    if drawImmediately == nil then drawImmediately = true end

    BeginTextCommandPrint("CELL_EMAIL_BCON")
    for _, str in ipairs(StringToArray(message)) do
        AddTextComponentSubstringPlayerName(str)
    end
    EndTextCommandPrint(duration, drawImmediately)
end

function Subtitle.Alert(message, duration, drawImmediately, prefix)
    local msg = prefix and ("~y~" .. prefix .. " ~s~" .. message) or ("~y~" .. message)
    Subtitle.Custom(msg, duration, drawImmediately)
end

function Subtitle.Error(message, duration, drawImmediately, prefix)
    local msg = prefix and ("~r~" .. prefix .. " ~s~" .. message) or ("~r~" .. message)
    Subtitle.Custom(msg, duration, drawImmediately)
end

function Subtitle.Info(message, duration, drawImmediately, prefix)
    local msg = prefix and ("~b~" .. prefix .. " ~s~" .. message) or ("~b~" .. message)
    Subtitle.Custom(msg, duration, drawImmediately)
end

function Subtitle.Success(message, duration, drawImmediately, prefix)
    local msg = prefix and ("~g~" .. prefix .. " ~s~" .. message) or ("~g~" .. message)
    Subtitle.Custom(msg, duration, drawImmediately)
end

function HelpMessage.Custom(message, duration, sound)
    duration = duration or 6000
    if sound == nil then sound = true end

    local array = StringToArray(message)
    if IsHelpMessageBeingDisplayed() then
        ClearAllHelpMessages()
    end
    BeginTextCommandDisplayHelp("CELL_EMAIL_BCON")
    for _, str in ipairs(array) do
        AddTextComponentSubstringPlayerName(str)
    end
    EndTextCommandDisplayHelp(0, false, sound, duration)
end

HelpMessage.Label = {
    EXIT_INTERIOR_HELP_MESSAGE = "EXIT_INTERIOR_HELP_MESSAGE"
}

local helpLabels = {
    [HelpMessage.Label.EXIT_INTERIOR_HELP_MESSAGE] = "Press ~INPUT_CONTEXT~ to exit the building."
}

function HelpMessage.CustomLooped(label)
    if GetLabelText(label) == "NULL" then
        local labelText = helpLabels[label] or "Help text"
        AddTextEntry(label, labelText)
    end
    DisplayHelpTextThisFrame(label, true)
end

return {
    Notify = Notify,
    Subtitle = Subtitle,
    HelpMessage = HelpMessage,
    ErrorMessage = ErrorMessage,
    CommonErrors = CommonErrors
}
