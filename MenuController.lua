(function()
    MenuController = {}

    MenuController.Menus = {}
    MenuController.VisibleMenus = {}
    MenuController.MenuButtons = {}
    MenuController.MainMenu = nil
    MenuController._texture_dict = "commonmenu"
    MenuController._header_texture = "interaction_bgd"

    MenuController.DisableMenuButtons = false
    MenuController.NavigateMenuUsingArrows = true
    MenuController.EnableManualGCs = true
    MenuController.DontOpenAnyMenu = false
    MenuController.PreventExitingMenu = false
    MenuController.DisableBackButton = false
    MenuController.MenuToggleKey = Control.InteractionMenu
    MenuController.EnableMenuToggleKeyOnController = true
    MenuController.SetDrawOrder = true

    local _menuAlignment = "right"
    local _assetsLoaded = false
    local _manualTimerForGC = GetGameTimer()

    MenuController.OffsetX = 0.0
    MenuController.OffsetY = 0.0
    local OFFSET_KVP = "vmenu_menu_offset"
    local _offsets = { left = { 0.0, 0.0 }, right = { 0.0, 0.0 } }
    local _dragHeld = false
    local _dragging = nil

    do
        local raw = GetResourceKvpString(OFFSET_KVP)
        local ok, data = pcall(json.decode, raw or "")
        if ok and type(data) == "table" then
            for _, side in ipairs({ "left", "right" }) do
                if type(data[side]) == "table" then
                    _offsets[side] = { tonumber(data[side][1]) or 0.0, tonumber(data[side][2]) or 0.0 }
                end
            end
        end
    end

    local function ApplySavedOffset()
        local offset = _offsets[_menuAlignment] or { 0.0, 0.0 }
        MenuController.OffsetX, MenuController.OffsetY = offset[1], offset[2]
    end
    ApplySavedOffset()

    RegisterCommand("+vmenu_drag", function() _dragHeld = true end, false)
    RegisterCommand("-vmenu_drag", function() _dragHeld = false end, false)
    RegisterKeyMapping("+vmenu_drag", "vMenu Move Menu (hold, then drag the banner)", "keyboard", "LMENU")

    local _enterKeyPressed = false
    RegisterCommand("vMenu:internal:EnterSelect", function()
        _enterKeyPressed = true
    end, false)
    RegisterKeyMapping("vMenu:internal:EnterSelect", "vMenu Select (Enter)", "keyboard", "return")

    local HOLD_DELAY = 400
    local REPEAT_RATE = 120

    local _inputState = {
        up = { pressed = false, holdTime = 0, lastRepeat = 0 },
        down = { pressed = false, holdTime = 0, lastRepeat = 0 },
        left = { pressed = false, holdTime = 0, lastRepeat = 0 },
        right = { pressed = false, holdTime = 0, lastRepeat = 0 }
    }

    local menuTextureAssets = {
        "commonmenu",
        "commonmenutu",
        "mpleaderboard",
        "mphud",
        "mpshopsale",
        "mpinventory",
        "mprankbadge",
        "mpcarhud",
        "mpcarhud2",
        "shared"
    }

    local function GetAspectRatio()
        return GetScreenAspectRatio(false)
    end

    MenuController.ScreenWidth = 1080.0 * GetAspectRatio()
    MenuController.ScreenHeight = 1080.0

    function MenuController:GetMenuAlignment()
        return _menuAlignment
    end

    function MenuController:SetMenuAlignment(alignment)
        local aspectRatio = GetAspectRatio()

        if aspectRatio < 1.888888888888889 then
            _menuAlignment = alignment
        else
            _menuAlignment = "left"
        end
        ApplySavedOffset()
    end

    local function Clamp(value, min, max)
        return math.max(min, math.min(max, value))
    end

    local function ClampOffset(x, y)
        local margin = (1.0 - GetSafeZoneSize()) / 2.0
        local menuWidth = Menu.WIDTH / MenuController.ScreenWidth
        if _menuAlignment == "left" then
            x = Clamp(x, -margin, 1.0 - margin - menuWidth)
        else
            x = Clamp(x, menuWidth - 1.0 + margin, margin)
        end
        y = Clamp(y, -margin, 0.85 - margin)
        return x, y
    end

    local function IsOverHeader(mouseX, mouseY)
        local margin = (1.0 - GetSafeZoneSize()) / 2.0
        local menuWidth = Menu.WIDTH / MenuController.ScreenWidth
        local left
        if _menuAlignment == "left" then
            left = margin + MenuController.OffsetX
        else
            left = 1.0 - margin - menuWidth + MenuController.OffsetX
        end
        local top = margin + MenuController.OffsetY
        local height = (Menu.HEADER_HEIGHT + Menu.SUBTITLE_BAR_HEIGHT) / MenuController.ScreenHeight
        return mouseX >= left and mouseX <= left + menuWidth and mouseY >= top and mouseY <= top + height
    end

    local function FinishDrag()
        _dragging = nil
        _offsets[_menuAlignment] = { MenuController.OffsetX, MenuController.OffsetY }
        SetResourceKvp(OFFSET_KVP, json.encode(_offsets))
    end

    function MenuController:IsDragKeyHeld()
        return _dragHeld
    end

    function MenuController:ResetPosition()
        _dragging = nil
        MenuController.OffsetX, MenuController.OffsetY = 0.0, 0.0
        FinishDrag()
    end

    local _buttonsScaleform = nil
    local _buttonsKey = nil

    local DRAG_KEY_BUTTON = ("~INPUT_%X~"):format((GetHashKey("+vmenu_drag") | 0x80000000) & 0xFFFFFFFF)

    local function AddButtonSlot(slot, button, text)
        BeginScaleformMovieMethod(_buttonsScaleform, "SET_DATA_SLOT")
        ScaleformMovieMethodAddParamInt(slot)
        ScaleformMovieMethodAddParamTextureNameString(button)
        BeginTextCommandScaleformString("STRING")
        AddTextComponentSubstringPlayerName(Locale.ForScaleform(text))
        EndTextCommandScaleformString()
        EndScaleformMovieMethod()
    end

    function MenuController:DrawInstructionalButtons()
        local currentMenu = self:GetCurrentMenu()
        if not currentMenu or not currentMenu.EnableInstructionalButtons or IsHudHidden() or IsPauseMenuActive() then
            return
        end
        if Noclip and Noclip.IsNoclipActive and Noclip.IsNoclipActive() then
            return
        end

        if not _buttonsScaleform or not HasScaleformMovieLoaded(_buttonsScaleform) then
            _buttonsScaleform = RequestScaleformMovie("INSTRUCTIONAL_BUTTONS")
            return
        end

        local previewing = PedPreview and PedPreview.IsShowing() or false
        local key = table.concat({ tostring(_dragHeld), tostring(previewing), Locale.GetLanguage() }, "|")
        if key ~= _buttonsKey then
            _buttonsKey = key
            BeginScaleformMovieMethod(_buttonsScaleform, "CLEAR_ALL")
            EndScaleformMovieMethod()

            local slot = 0
            local function Add(button, text)
                AddButtonSlot(slot, button, text)
                slot = slot + 1
            end

            Add("~INPUT_FRONTEND_ACCEPT~", "Select")
            Add("~INPUT_FRONTEND_CANCEL~", "Back")
            if _dragHeld then
                Add("~INPUT_ATTACK~", "Drag the banner")
            else
                Add(DRAG_KEY_BUTTON, "Move Menu")
            end
            if previewing then
                Add("~INPUT_CONTEXT~", "Rotate Right")
                Add("~INPUT_COVER~", "Rotate Left")
            end

            BeginScaleformMovieMethod(_buttonsScaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
            ScaleformMovieMethodAddParamInt(0)
            EndScaleformMovieMethod()
        end

        DrawScaleformMovieFullscreen(_buttonsScaleform, 255, 255, 255, 255, 0)
    end

    function MenuController:ProcessDrag()
        if not _dragHeld or IsPauseMenuActive() then
            if _dragging then FinishDrag() end
            return
        end

        SetMouseCursorActiveThisFrame()
        DisableControlAction(0, 1, true)
        DisableControlAction(0, 2, true)
        DisableControlAction(0, 24, true)
        DisableControlAction(0, 25, true)
        DisableControlAction(0, 142, true)
        DisableControlAction(0, 106, true)

        local mouseX = GetDisabledControlNormal(0, 239)
        local mouseY = GetDisabledControlNormal(0, 240)

        if _dragging then
            if IsDisabledControlPressed(0, 24) then
                MenuController.OffsetX, MenuController.OffsetY = ClampOffset(
                    _dragging.offsetX + (mouseX - _dragging.mouseX),
                    _dragging.offsetY + (mouseY - _dragging.mouseY))
                SetMouseCursorSprite(4)
            else
                FinishDrag()
            end
        else
            local over = IsOverHeader(mouseX, mouseY)
            SetMouseCursorSprite(over and 3 or 1)
            if over and IsDisabledControlJustPressed(0, 24) then
                _dragging = {
                    mouseX = mouseX, mouseY = mouseY,
                    offsetX = MenuController.OffsetX, offsetY = MenuController.OffsetY,
                }
            end
        end
    end

    function MenuController:AddMenu(menu)
        if not self:ContainsMenu(menu) then
            table.insert(self.Menus, menu)

            if not self.MainMenu then
                self.MainMenu = menu
            end
        end
    end

    function MenuController:ContainsMenu(menu)
        for _, m in ipairs(self.Menus) do
            if m == menu then
                return true
            end
        end
        return false
    end

    function MenuController:AddVisibleMenu(menu)
        if not self.VisibleMenus[menu] then
            self.VisibleMenus[menu] = true
        end
    end

    function MenuController:RemoveVisibleMenu(menu)
        self.VisibleMenus[menu] = nil
    end

    function MenuController:AddSubmenu(parent, child)
        if not self:ContainsMenu(child) then
            self:AddMenu(child)
        end
        child.ParentMenu = parent
    end

    function MenuController:BindMenuItem(parentMenu, childMenu, menuItem)
        self:AddSubmenu(parentMenu, childMenu)
        self.MenuButtons[menuItem] = childMenu
    end

    function MenuController:GetCurrentMenu()
        for menu, _ in pairs(self.VisibleMenus) do
            return menu
        end
        return nil
    end

    function MenuController:IsAnyMenuOpen()
        for _, _ in pairs(self.VisibleMenus) do
            return true
        end
        return false
    end

    function MenuController:AreMenuButtonsEnabled()
        return self:IsAnyMenuOpen() and
            not IsPauseMenuActive() and
            IsScreenFadedIn() and
            not IsPlayerSwitchInProgress() and
            not self.DisableMenuButtons and
            not IsEntityDead(PlayerPedId())
    end

    function MenuController:LoadAssets()
        if _assetsLoaded then
            return
        end

        for _, asset in ipairs(menuTextureAssets) do
            if not HasStreamedTextureDictLoaded(asset) then
                RequestStreamedTextureDict(asset, false)
            end
        end

        Citizen.CreateThread(function()
            local allLoaded = false
            while not allLoaded do
                allLoaded = true
                for _, asset in ipairs(menuTextureAssets) do
                    if not HasStreamedTextureDictLoaded(asset) then
                        allLoaded = false
                        break
                    end
                end
                if not allLoaded then
                    Citizen.Wait(0)
                end
            end
            _assetsLoaded = true
        end)
    end

    function MenuController:UnloadAssets()
        for _, asset in ipairs(menuTextureAssets) do
            if HasStreamedTextureDictLoaded(asset) then
                SetStreamedTextureDictAsNoLongerNeeded(asset)
            end
        end
        _assetsLoaded = false
    end

    function MenuController:DisableControls()
        if not self:IsAnyMenuOpen() then
            return
        end

        local currentMenu = self:GetCurrentMenu()
        if not currentMenu then
            return
        end

        if IsEntityDead(PlayerPedId()) then
            for openMenu, _ in pairs(self.VisibleMenus) do
                openMenu:CloseMenu()
            end
            return
        end

        DisableControlAction(0, Control.FrontendPauseAlternate, true)

        if not IsControlPressed(0, Control.SelectWeapon) then
            DisableControlAction(0, Control.SelectNextWeapon, true)
            DisableControlAction(0, Control.SelectPrevWeapon, true)
            DisableControlAction(24, Control.SelectNextWeapon, true)
            DisableControlAction(24, Control.SelectPrevWeapon, true)
            DisableControlAction(0, 16, true)
            DisableControlAction(0, 17, true)
            DisableControlAction(0, 37, true)
        end
        HideHudComponentThisFrame(19)

        DisableControlAction(0, 332, true)
        DisableControlAction(0, 333, true)
        DisableControlAction(0, Control.VehicleNextRadio, true)
        DisableControlAction(0, Control.VehicleRadioWheel, true)
        DisableControlAction(0, Control.VehiclePrevRadio, true)

        DisableControlAction(0, Control.Phone, true)
        DisableControlAction(0, Control.PhoneCancel, true)
        DisableControlAction(0, Control.PhoneDown, true)
        DisableControlAction(0, Control.PhoneLeft, true)
        DisableControlAction(0, Control.PhoneRight, true)

        DisableControlAction(0, Control.Attack, true)
        DisableControlAction(0, Control.Attack2, true)
        DisableControlAction(0, Control.MeleeAttack1, true)
        DisableControlAction(0, Control.MeleeAttack2, true)
        DisableControlAction(0, Control.MeleeAttackAlternate, true)
        DisableControlAction(0, Control.MeleeAttackHeavy, true)
        DisableControlAction(0, Control.MeleeAttackLight, true)
        DisableControlAction(0, Control.VehicleAttack, true)
        DisableControlAction(0, Control.VehicleAttack2, true)
        DisableControlAction(0, Control.VehicleFlyAttack, true)
        DisableControlAction(0, Control.VehiclePassengerAttack, true)
        DisableControlAction(0, Control.Aim, true)
        DisableControlAction(0, Control.VehicleAim, true)

        if IsPedInAnyVehicle(PlayerPedId(), false) then
            DisableControlAction(0, Control.VehicleSelectNextWeapon, true)
            DisableControlAction(0, Control.VehicleSelectPrevWeapon, true)
            DisableControlAction(0, Control.VehicleCinCam, true)
        end
    end

    function MenuController:ProcessMenus()
        if not self:IsAnyMenuOpen() or not _assetsLoaded then
            return
        end

        local currentMenu = self:GetCurrentMenu()
        if currentMenu then
            currentMenu:Draw()
        end
    end

    function MenuController:ProcessMainButtons()
        if not self:AreMenuButtonsEnabled() then
            return
        end

        local currentMenu = self:GetCurrentMenu()
        if not currentMenu then
            return
        end

        DisableControlAction(0, Control.FrontendAccept, true)

        local enterPressed = _enterKeyPressed
        _enterKeyPressed = false

        local nativeEnterPressed = IsDisabledControlJustPressed(0, Control.FrontendAccept)
        local mouseLeftClick    = not _dragHeld and IsDisabledControlJustPressed(0, 24)
        if enterPressed or nativeEnterPressed or mouseLeftClick or Control.IsJustReleased(Control.VehicleMouseControlOverride) then
            if currentMenu:Size() > 0 then
                currentMenu:SelectItem()
            end
        elseif not self.DisableBackButton and Control.IsJustReleased(Control.PhoneCancel) then
            Citizen.Wait(0)
            currentMenu:GoBack()
        end
    end

    function MenuController:ProcessDirectionalButtons()
        if not self:AreMenuButtonsEnabled() then
            return
        end

        local currentMenu = self:GetCurrentMenu()
        if not currentMenu then
            return
        end

        local currentTime = GetGameTimer()

        local function processDirection(isPressed, state, action)
            if isPressed then
                if not state.pressed then
                    state.pressed = true
                    state.holdTime = currentTime
                    state.lastRepeat = currentTime
                    action()
                else
                    local holdDuration = currentTime - state.holdTime
                    if holdDuration >= HOLD_DELAY then
                        local timeSinceLastRepeat = currentTime - state.lastRepeat
                        if timeSinceLastRepeat >= REPEAT_RATE then
                            state.lastRepeat = currentTime
                            action()
                        end
                    end
                end
            else
                state.pressed = false
                state.holdTime = 0
                state.lastRepeat = 0
            end
        end

        processDirection(self:IsUpPressed(), _inputState.up, function()
            currentMenu:GoUp()
        end)

        processDirection(self:IsDownPressed(), _inputState.down, function()
            currentMenu:GoDown()
        end)

        processDirection(Control.IsPressed(Control.FrontendLeft), _inputState.left, function()
            currentMenu:GoLeft()
        end)

        processDirection(Control.IsPressed(Control.FrontendRight), _inputState.right, function()
            currentMenu:GoRight()
        end)
    end

    function MenuController:IsUpPressed()
        if not self:AreMenuButtonsEnabled() then
            return false
        end

        if not IsPedInAnyVehicle(PlayerPedId(), false) then
            if IsControlPressed(0, Control.SelectWeapon) then
                if IsControlPressed(0, Control.SelectNextWeapon) or IsControlPressed(0, Control.SelectPrevWeapon) then
                    return false
                end
            end
        end

        return Control.IsPressed(Control.FrontendUp) or Control.IsPressed(Control.PhoneScrollBackward)
    end

    function MenuController:IsDownPressed()
        if not self:AreMenuButtonsEnabled() then
            return false
        end

        if not IsPedInAnyVehicle(PlayerPedId(), false) then
            if IsControlPressed(0, Control.SelectWeapon) then
                if IsControlPressed(0, Control.SelectNextWeapon) or IsControlPressed(0, Control.SelectPrevWeapon) then
                    return false
                end
            end
        end

        return Control.IsPressed(Control.FrontendDown) or Control.IsPressed(Control.PhoneScrollForward)
    end

    function MenuController:ProcessMouseInput()
        if not self:AreMenuButtonsEnabled() then return end

        local currentMenu = self:GetCurrentMenu()
        if not currentMenu then return end

        if not self.DisableBackButton and not _dragHeld and IsDisabledControlJustReleased(0, 25) then
            Citizen.Wait(0)
            currentMenu:GoBack()
        end
    end

    function MenuController:ProcessToggleMenuButton()
        if IsPauseMenuActive() or not IsScreenFadedIn() or IsPlayerSwitchInProgress() or IsEntityDead(PlayerPedId()) or self.DisableMenuButtons then
            return
        end

        if self:IsAnyMenuOpen() then
        else
            if Control.IsJustReleased(self.MenuToggleKey) then
                if self.MainMenu and not self.DontOpenAnyMenu then
                    self.MainMenu:OpenMenu()
                end
            end
        end
    end

    Citizen.CreateThread(function()
        MenuController:LoadAssets()

        while true do
            local isMenuOpen = MenuController:IsAnyMenuOpen()

            if isMenuOpen then
                MenuController.ScreenWidth = 1080.0 * GetAspectRatio()

                MenuController:DisableControls()

                MenuController:ProcessDrag()
                MenuController:ProcessMenus()
                MenuController:DrawInstructionalButtons()
                MenuController:ProcessMainButtons()
                MenuController:ProcessDirectionalButtons()
                MenuController:ProcessMouseInput()

                if MenuController.EnableManualGCs then
                    if GetGameTimer() - _manualTimerForGC > 30000 then
                        collectgarbage()
                        _manualTimerForGC = GetGameTimer()
                    end
                end

                Citizen.Wait(0)
            else
                Citizen.Wait(100)

                if MenuController.EnableManualGCs then
                    if GetGameTimer() - _manualTimerForGC > 30000 then
                        collectgarbage()
                        _manualTimerForGC = GetGameTimer()
                    end
                end
            end
        end
    end)

    return MenuController
end)()
