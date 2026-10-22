RecordingMenu = {}

local menu = nil

function RecordingMenu.CreateMenu()
    menu = Menu:New("Recording", "Recording Options")
    MenuController:AddMenu(menu)

    local takePhotoBtn = MenuItem:New("Take Photo", "Takes a photo and saves it to the Pause Menu gallery.")
    local openGalleryBtn = MenuItem:New("Open Gallery", "Opens the Pause Menu gallery.")
    local startRecordingBtn = MenuItem:New("Start Recording", "Start a new game recording using GTA V's built in recording.")
    local stopRecordingBtn = MenuItem:New("Stop Recording", "Stop and save your current recording.")
    local rockstarEditorBtn = MenuItem:New("Rockstar Editor", "Open the rockstar editor, note you might want to quit the session first before doing this to prevent some issues.")

    menu:AddMenuItem(takePhotoBtn)
    menu:AddMenuItem(openGalleryBtn)
    menu:AddMenuItem(startRecordingBtn)
    menu:AddMenuItem(stopRecordingBtn)
    menu:AddMenuItem(rockstarEditorBtn)

    menu.OnItemSelect = function(sender, item, index)
        if item == takePhotoBtn then
            Citizen.CreateThread(function()
                TakePhoto()
                Wait(100)
                SavePhotoToGallery()
                Notify.Success("Photo saved to gallery.")
            end)

        elseif item == openGalleryBtn then
            ActivateFrontendMenu(GetHashKey("FE_MENU_VERSION_MP_PAUSE"), false, -1)

        elseif item == startRecordingBtn then
            if IsRecording() then
                Notify.Error("You are already recording a clip, you need to stop recording first before you can start recording again!")
            else
                StartRecording(1)
                Notify.Success("Recording started.")
            end

        elseif item == stopRecordingBtn then
            if not IsRecording() then
                Notify.Error("You are currently NOT recording a clip, you need to start recording first before you can stop and save a clip.")
            else
                StopRecordingAndSaveClip()
                Notify.Success("Recording stopped and saved.")
            end

        elseif item == rockstarEditorBtn then
            local quitSession = ConfigManager.GetSettingsBool(ConfigManager.Setting.vmenu_quit_session_in_rockstar_editor, false)

            if quitSession then
                Citizen.CreateThread(function()
                    DoScreenFadeOut(500)
                    while not IsScreenFadedOut() do
                        Wait(0)
                    end

                    NetworkSessionEnd(true, true)
                    Wait(1000)

                    ActivateRockstarEditor()

                    while IsPauseMenuActive() do
                        Wait(0)
                    end

                    DoScreenFadeIn(500)

                    Notify.Info("You left your previous session before entering the Rockstar Editor. Restart the game to be able to rejoin the server's main session.")
                end)
            else
                ActivateRockstarEditor()
            end
        end
    end

    return menu
end

function RecordingMenu.GetMenu()
    if menu == nil then
        RecordingMenu.CreateMenu()
    end
    return menu
end

return RecordingMenu
